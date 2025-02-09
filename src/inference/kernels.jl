export pf_replan_move_accept!, pf_replan_move_reweight!
export pf_goal_move_accept!, pf_goal_move_reweight!
export pf_mixed_move_accept!, pf_mixed_move_reweight!

"Error-driven rejuvenation proposal that samples new partial plans."
@gen function replan_move_proposal(trace::Trace, use_obs::Bool=true)
    # Unpack trace
    _, _, world_config = Gen.get_args(trace)
    @unpack domain = world_config
    planner = trace[:init => :agent => :planner]
    world_states = get_retval(trace)
    env_states = [ws.env_state for ws in world_states]
    obs_states = [ws.obs_state for ws in world_states]
    plan_states = [ws.agent_state.plan_state for ws in world_states]
    # Compute time of divergence between hypothesized and observed states
    t_current = length(world_states)
    t_diverge = findfirst(hash.(env_states) .!= hash.(obs_states))
    if (t_diverge == nothing) t_diverge = t_current + 1 end
    # Decide whether to resample partial plans
    t_diff = t_current - t_diverge
    resample_prob = t_diff < 0 ? 0.05 : exp(1)/6 * t_diff * exp(-t_diff/5)
    resample ~ bernoulli(resample_prob)
    if !resample return end
    # Find earliest plan that diverges from observations
    t_plans, _ = get_planning_steps(plan_states, false)
    plan_idx = max(searchsortedfirst(t_plans, t_diverge) - 1, 1)
    # Propose timestep to resample plans from
    n_plans = length(t_plans)
    idx_probs = (n_plans == 1) ? [1.0] :
        [i == plan_idx ? 0.9 : 0.1 / (n_plans-1) for i in 1:n_plans]
    resample_idx ~ categorical(idx_probs)
    t_resamp = t_plans[resample_idx]
    # Propose maximum node budget for first partial plan resampled
    t_diff = t_diverge - t_resamp
    if t_diff <= 0 || !use_obs # Sample node budget from prior
        n_attempts, p_cont = planner.persistence
        max_resource ~ neg_binom(n_attempts, 1-p_cont)
    else
        max_resource_guess = t_diff * length(PDDL.get_actions(domain))
        max_resource ~ geometric(1 / (t_diff+1))
    end
    # Propose partial plans from t_resample to t_current
    proposal_args = [(max_resource,); fill((nothing,), t_current - t_resamp)]
    goal_spec = get_goal(trace[:timestep => t_resamp => :agent => :goal])
    plan_state = t_resamp == 1 ?
        init_plan_state(planner) : plan_states[t_resamp-1]
    obs_states = use_obs ?
        obs_states[t_resamp:t_current] : fill(nothing, t_current-t_resamp+1)
    env_states = env_states[t_resamp:t_current]
    {*} ~ propose_step_range(t_resamp, t_current, plan_state,
                             planner, domain, env_states, goal_spec,
                             obs_states, proposal_args)
    return (t_resamp, t_current)
end

"Trace transform for the replanning move kernel."
@transform replan_move_involution (p_in, q_in) to (p_out, q_out) begin
    resample = @read(q_in[:resample], :discrete)
    @copy(q_in[:resample], q_out[:resample])
    if !resample return end
    t_resamp, t_current = @read(q_in[], :discrete)
    @copy(q_in[:resample_idx], q_out[:resample_idx])
    @copy(p_in[:timestep => t_resamp => :agent => :plan => :max_resource],
          q_out[:max_resource])
    for t in t_resamp:t_current
        addr = :timestep => t => :agent => :plan
        @copy(q_in[addr], p_out[addr])
        @copy(p_in[addr], q_out[addr])
    end
end

"Metropolis-Hastings replanning move kernel."
replan_move_accept(trace::Trace) =
    mh(trace, replan_move_proposal, (), replan_move_involution)

"Move-reweight replanning kernel."
replan_move_reweight(trace::Trace) =
    move_reweight(trace, replan_move_proposal, (true,),
                  replan_move_proposal, (false,), replan_move_involution)

"Apply replanning move-accept kernel to particle filter state."
pf_replan_move_accept!(pf_state::ParticleFilterState; n_iters::Int=1) =
    pf_move_accept!(pf_state, replan_move_accept, (), n_iters)

"Apply replanning move-reweight kernel to particle filter state."
pf_replan_move_reweight!(pf_state::ParticleFilterState; n_iters::Int=1) =
    pf_move_reweight!(pf_state, replan_move_reweight, (), n_iters)

"Heuristic-driven goal rejuvenation proposal that reintroduces likely goals."
@gen function goal_move_proposal(trace::Trace, goals::Vector,
                                 beta::Real=0.1, goal_addr=:goal)
    # Unpack trace
    n_steps, world_init, world_config = Gen.get_args(trace)
    @unpack domain = world_config
    planner = trace[:init => :agent => :planner]
    @unpack heuristic = planner.planner
    world_states = get_retval(trace)
    env_states = [ws.env_state for ws in world_states]
    obs_states = [ws.obs_state for ws in world_states]
    # Compute heuristic distance from current state to each goal
    h_values = [heuristic(domain, env_states[end], g) for g in goals]
    probs = softmax(-beta .* h_values)
    # Propose goals that are closer to the current state
    new_goal_idx = @trace(categorical(probs),
                          :init => :agent => :goal => goal_addr)
    new_goal = Specification(goals[new_goal_idx])
    if new_goal == world_states[1].agent_state.goal_state
        return new_goal end # Don't replan if goal does not change
    # Replan from the start, given new goal
    plan_state = init_plan_state(planner)
    {*} ~ propose_step_range(1, n_steps, plan_state, planner, domain,
                             env_states, new_goal, obs_states,
                             fill(nothing, n_steps))
    return new_goal
end

"Metropolis-Hastings goal move kernel."
goal_move_accept(trace::Trace, goals::Vector, beta::Real=0.1, goal_addr=:goal) =
    mh(trace, goal_move_proposal, (goals, beta, goal_addr))

"Move-reweight goal kernel."
goal_move_reweight(trace::Trace, goals::Vector, beta::Real=0.1, goal_addr=:goal) =
    move_reweight(trace, goal_move_proposal, (goals, beta, goal_addr))

"Apply goal move-accept kernel to particle filter state."
pf_goal_move_accept!(pf_state::ParticleFilterState, goals::Vector;
                     beta::Real=0.1, goal_addr=:goal, n_iters::Int=1) =
    pf_move_accept!(pf_state, goal_move_accept,
                    (goals, beta, goal_addr), n_iters)

"Apply goal move-reweight kernel to particle filter state."
pf_goal_move_reweight!(pf_state::ParticleFilterState, goals::Vector;
                       beta::Real=0.1, goal_addr=:goal, n_iters::Int=1) =
    pf_move_reweight!(pf_state, goal_move_reweight,
                      (goals, beta, goal_addr), n_iters)

"Metropolis-Hastings goal-replan mixture kernel."
mixed_move_accept(trace::Trace, goals::Vector, mix_prob::Real=0.25) =
    bernoulli(mix_prob) ?
        mh(trace, goal_move_proposal, (goals,)) :
        mh(trace, replan_move_proposal, (), replan_move_involution)

"Metropolis-Hastings goal-replan mixture kernel."
mixed_move_reweight(trace::Trace, goals::Vector, mix_prob::Real=0.25) =
    bernoulli(mix_prob) ?
        move_reweight(trace, goal_move_proposal, (goals,)) :
        move_reweight(trace, replan_move_proposal, (true,),
                      replan_move_proposal, (false,), replan_move_involution)

"Apply move-accept goal-replan mixture kernel to particle filter state."
pf_mixed_move_accept!(pf_state::ParticleFilterState, goals::Vector;
                      mix_prob::Real=0.25, n_iters::Int=1) =
    pf_move_accept!(pf_state, mixed_move_accept,
                    (goals, mix_prob), n_iters)

"Apply move-accept goal-replan mixture kernel to particle filter state."
pf_mixed_move_reweight!(pf_state::ParticleFilterState, goals::Vector;
                        mix_prob::Real=0.25, n_iters::Int=1) =
    pf_move_reweight!(pf_state, mixed_move_reweight,
                      (goals, mix_prob), n_iters)
