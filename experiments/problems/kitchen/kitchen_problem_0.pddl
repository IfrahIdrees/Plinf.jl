(define (problem kitchen) (:domain kitchen)
  (:objects
    hand_1 - hand
    faucet_1 - faucet
    kettle_1 - kettle
    cup_1 - cup
    tea_box_1 - tea_box
    coffee_box_1 - coffee_box
  )
  (:init 
    (dirty hand_1)
    (dry hand_1)
	(eq hand_1 hand_1)
	(eq faucet_1 faucet_1)
	(eq kettle_1 kettle_1)
	(eq cup_1 cup_1)
	(eq tea_box_1 tea_box_1)
	(eq coffee_box_1 coffee_box_1)
  )
  (:goal(and (switch_kettle kettle_1) (has_water_kettle kettle_1)))
)