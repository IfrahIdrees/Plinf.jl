(and (dry hand_1) (not(dirty hand_1)))
(and (has_tea cup_1) (not(has_water kettle_1)) (not(water_hot kettle_1)))
(and (has_coffee cup_1) (not(has_water kettle_1)) (not(water_hot kettle_1)))

#trying
(and (has_water ?x) (not(has_water ?y)) (not(water_hot ?y)))
(and (has_water_cup ?x) (not(has_water_kettle ?y)) (not(water_hot ?y)))
(and (has_water_cup cup_1) (not(has_water_kettle kettle_1)) (not(water_hot kettle_1)))
(and (has_water_cup cup_1) (has_tea cup_1))
(and (has_water_cup cup_1) (has_tea cup_1) (not(switch_kettle kettle_1)))



##second time

(and (not(has_water_cup cup_1)) (has_water_kettle kettle_1) (water_hot kettle_1) (not(switch_kettle kettle_1)))
(and (not (water_hot kettle_1))) water not hot after switch on

#worked:
(and (dry hand_1))
(and (has_water_cup cup_1) (has_tea cup_1))

#second time
(and (water_hot kettle_1) (has_tea cup_1))
(and (not(has_water_cup cup_1)) (has_water_kettle kettle_1) (water_hot kettle_1))
(and (not(has_water_cup cup_1)) (not (water_hot kettle_1)) (not(switch_kettle kettle_1)))
(and (not(switch_kettle kettle_1)) (not(water_hot kettle_1)) (has_water_kettle kettle_1))
(and (not(switch_kettle kettle_1)) (not(water_hot kettle_1)) (not(has_water_kettle kettle_1)))


switch_on (and (switch_kettle kettle_1)(water_hot kettle_1)(has_water_kettle kettle_1))