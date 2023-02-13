(define (domain kitchen)
  (:requirements :strips :typing :equality)
;  (:types hand faucet)  
   (:types hand faucet kettle cup tea_box coffee_box)  
;   (:types faucet)  

; predicates are attributes from state.json
(:predicates
(soapy ?x - hand)
(dirty ?x - hand)
(dry ?x - hand)
(switch_faucet ?x - faucet)
 (switch_kettle ?x - kettle)
 (has_water_kettle ?x - kettle)
 (water_hot ?x - kettle)
 (has_tea ?x - cup)
 (has_coffee ?x - cup)
 (has_water_cup ?x - cup)
 (open_tea ?x - tea_box)
 (open_coffee ?x - coffee_box)
)

  (:action use_soap
  :parameters (?x - hand)
  :precondition (and (not (soapy ?x)) (dirty ?x))
  :effect (and(soapy ?x))
  )
; ;   these are from operator.json and method.json

  (:action rinse_hand
      :parameters (?x - hand ?y - faucet)
      :precondition (and (switch_faucet ?y) (soapy ?x) (dirty ?x))
      :effect (and (not(soapy ?x)) (not(dirty ?x)) (not(dry ?x)))
  )

  (:action turn_on_faucet_1
      :parameters (?x - faucet)
      :precondition (and (not (switch_faucet ?x)))
      :effect (and (switch_faucet ?x))
  )

  (:action turn_off_faucet_1
      :parameters (?x - faucet)
      :precondition (and (switch_faucet ?x))
      :effect (and (not (switch_faucet ?x)))
  )

  (:action dry_hand
      :parameters (?x - hand)
      :precondition (and (not(dry ?x)) (not(dirty ?x)))
      :effect (and (dry ?x))
  )

   (:action switch_on_kettle_1
       :parameters (?x - kettle)
       :precondition (and (not(switch_kettle ?x)) (not(water_hot ?x)) (has_water_kettle ?x))
       :effect (and (switch_kettle ?x) (water_hot ?x))
   )

   (:action switch_off_kettle_1
       :parameters (?x - kettle)
       :precondition (and (switch_kettle ?x))
       :effect (and (not (switch_kettle ?x)))
   )

   (:action add_water_kettle_1
       :parameters (?x - kettle)
       :precondition (and (not(has_water_kettle ?x)) (not(switch_kettle ?x)) (not(water_hot ?x)))
       :effect (and (has_water_kettle ?x))
   )

   (:action open_tea_box_1
       :parameters (?x - tea_box)
       :precondition (and (not(ope_tean ?x)))
       :effect (and (open_tea ?x))
   )

   (:action open_coffee_box_1
       :parameters (?x - coffee_box)
       :precondition (and (not(open_coffee ?x)))
       :effect (and (open_coffee ?x))
   )

   (:action add_tea_cup_1
       :parameters (?x - tea_box ?y - cup)
       :precondition (and (open_tea ?x) (not(has_tea ?y)) (not(has_coffee ?y)))
       :effect (and (has_tea ?y) )
   )

   (:action add_coffee_cup_1
       :parameters (?x - coffee_box ?y - cup)
       :precondition (and (open_coffee ?x) (not(has_tea ?y)) (not(has_coffee ?y)))
       :effect (and (has_coffee ?y))
   )

   (:action close_tea_box_1
       :parameters (?x - tea_box)
       :precondition (and (open_tea ?x))
       :effect (and (not(open_tea ?x)))
   )

   (:action close_coffee_box_1
       :parameters (?x - coffee_box)
       :precondition (and (open_coffee ?x))
       :effect (and (not(open_coffee ?x)))
   )

   (:action add_water_cup_1
       :parameters (?x - cup ?y - kettle)
       :precondition (and (not(has_water_cup ?x)) (has_water_kettle ?y) (water_hot ?y) (not(switch_kettle ?y)))
       :effect (and (has_water_cup ?x) (not(has_water_kettle ?y)) (not(water_hot ?y)))
       
   )

  )

;   (:action drink
;      :parameters (?x - cup)
;      :precondition (and (has_water ?x))
;      :effect (and (not(has_coffee ?x)) (not(has_tea ?x)) (not(has_water ?x)))
;  )
  
  
  
  
  
  


  
  
  

