(define (domain transport-strips)
(:requirements :typing :equality :action-costs)

(:types location fuellevel locatable - object 
	package truck - locatable
)

(:predicates 
(connected ?l1 ?l2 - location)
(at ?o - locatable ?l - location)
(stag_at ?p - package ?l - location)
(in ?p - package ?t - truck)
(fuel ?t - truck ?level - fuellevel)
(fuelcost ?level - fuellevel ?l1 ?l2 - location)
(sum ?a ?b ?c - fuellevel)
)

(:functions 
(total-cost) - number)

(:action LOAD
:parameters
(?p - package
?t - truck
?l - location
?l2 - location)
:precondition
(and (at ?t ?l) (at ?p ?l)(stag_at ?p ?l2)(not (= ?l ?l2)))
:effect
(and (not (at ?p ?l)) (in ?p ?t) (increase (total-cost) 1))
)

(:action UNLOAD
:parameters
(?p - package
?t - truck
?l - location)
:precondition
(and (at ?t ?l) (in ?p ?t)(stag_at ?p ?l))
:effect
(and (at ?p ?l)(not (stag_at ?p ?l))(not (in ?p ?t)) (increase (total-cost) 1))
)

(:action DRIVE
:parameters
(?t - truck
?l1 - location
?l2 - location
?fuelpost - fuellevel
?fueldelta - fuellevel
?fuelpre - fuellevel)
:precondition
(and 
(connected ?l1 ?l2)
(fuelcost ?fueldelta ?l1 ?l2)
(fuel ?t ?fuelpre)
(sum ?fuelpost ?fueldelta ?fuelpre)
(at ?t ?l1)
)
:effect
(and (not (at ?t ?l1)) 
     (at ?t ?l2) 
     (not (fuel ?t ?fuelpre)) 
     (fuel ?t ?fuelpost)
     (increase (total-cost) 1))
)

)


