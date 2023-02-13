(define (domain kitchen)
  (:requirements :strips :typing :equality)
  (:types hand faucet kettle cup tea_box coffee_box)  
  ;   types include states/ob_type from state.json so hand, faucet
;   (:predicates (on ?x ?y - block)
; 	       (ontable ?x - block)
; 	       (clear ?x - block)
; 	       (handempty)
; 	       (holding ?x - block)
; 	       )
; predicates are attributes from state.json
(:predicates
(soapy ?x - hand)
(dirty ?x - hand)
(dry ?x - hand)
(switch ?x - faucet)
(switch ?x - kettle)
(has_water ?x - kettle)
(water_hot ?x - kettle)
(has_tea ?x - cup)
(has_coffee ?x - cup)
(has_water ?x - cup)
(open ?x - tea_box)
(open ?x - coffee_box)
)

  (:action use_soap
  :parameters (?x - hand)
  :precondition (and (not(soapy ?x)) (dirty ?x))
  :effect(and(soapy ?x))
  )
;   these are from operator.json and method.json

  (:action rinse_hand
      :parameters (?x - hand ?y - faucet)
      :precondition (and (state ?y) (soapy ?x) (dirty ?x))
      :effect (and (not(soapy ?x)) (not(dirty ?x)) (not(dry ?x)))
  )

  (:action turn_on_faucet_1
      :parameters (?x - faucet)
      :precondition (and (not(state ?x)))
      :effect (and (state ?x))
  )

  (:action turn_off_faucet_1
      :parameters (?x - faucet)
      :precondition (and (state ?x))
      :effect (and (not(state ?x)))
  )

  (:action dry_hand
      :parameters (?x - hand)
      :precondition (and (not(dry ?x)) (not(dirty ?x)))
      :effect (and (dry ?x))
  )

  (:action switch_on_kettle_1
      :parameters (?x - kettle)
      :precondition (and (not(state ?x)) (not(water_hot ?x)) (has_water ?x))
      :effect (and (state ?x) (water_hot ?x))
  )

  (:action switch_off_kettle_1
      :parameters (?x - kettle)
      :precondition (and (state ?x) (water_hot ?x))
      :effect (and (not(state ?x)))
  )

  (:action add_water_kettle_1
      :parameters (?x - kettle)
      :precondition (and (not(has_water ?x)) (not(switch ?x)) (not(water_hot ?x)))
      :effect (and (has_water ?x))
  )

  (:action open_tea_box_1
      :parameters (?x - tea_box)
      :precondition (and (not(open ?x)))
      :effect (and (open ?x))
  )

  (:action open_coffee_box_1
      :parameters (?x - coffee_box)
      :precondition (and (not(open ?x)))
      :effect (and (open ?x))
  )

  (:action add_tea_cup_1
      :parameters (?x - tea_box ?y - cup)
      :precondition (and (open ?x) (not(has_tea ?y)) (not(has_coffee ?y)))
      :effect (and (has_tea ?y))
  )

  (:action add_coffee_cup_1
      :parameters (?x - coffee_box ?y - cup)
      :precondition (and (open ?x) (not(has_tea ?y)) (not(has_coffee ?y)))
      :effect (and (has_coffee ?y))
  )

  (:action close_tea_box_1
      :parameters (?x - tea_box)
      :precondition (and (open ?x))
      :effect (and (not(open ?x)))
  )

  (:action close_coffee_box_1
      :parameters (?x - coffee_box)
      :precondition (and (open ?x))
      :effect (and (not(open ?x)))
  )

  (:action add_water_cup_1
      :parameters (?x - cup ?y - kettle)
      :precondition (and (not(has_water ?x)) (has_water ?y) (water_hot ?y) (not(switch ?y)))
      :effect (and (has_water ?x) (not(has_water ?y)) (not(water_hot ?y)))
  ))

;   (:action drink
;      :parameters (?x - cup)
;      :precondition (and (has_water ?x))
;      :effect (and (not(has_coffee ?x)) (not(has_tea ?x)) (not(has_water ?x)))
;  )
  
  
  
  
  
  


  
  
  

