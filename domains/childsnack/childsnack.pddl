;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; The child-snack domain 2013
;;
;; This domain is for planning how to make and serve sandwiches for a group of
;; children in which some are allergic to gluten. There are two actions for
;; making sandwiches from their ingredients. The first one makes a sandwich and
;; the second one makes a sandwich taking into account that all ingredients are
;; gluten-free. There are also actions to put a sandwich on a tray, to move a tray
;; from one place to another and to serve sandwiches.
;; 
;; Problems in this domain define the ingredients to make sandwiches at the initial
;; state. Goals consist of having all kids served with a sandwich to which they
;; are not allergic.
;; 
;; Author: Raquel Fuentetaja and Tomás de la Rosa
;; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(define (domain child-snack)
(:requirements :typing :equality)
(:types child bread_portion content_portion sandwich tray place state - object)
(:constants kitchen - place
            state0 state1 state2 - state
)

(:predicates (at_kitchen_bread ?b - bread_portion)
	     (at_kitchen_content ?c - content_portion)
     	     (at_kitchen_sandwich ?s - sandwich)
     	     (no_gluten_bread ?b - bread_portion)
       	     (no_gluten_content ?c - content_portion)
      	     (ontray ?s - sandwich ?t - tray)
       	     (no_gluten_sandwich ?s - sandwich)
	     (allergic_gluten ?c - child)
     	     (not_allergic_gluten ?c - child)
	     (served ?c - child)
	     (waiting ?c - child ?p - place)
             (at ?t - tray ?p - place)
	     (notexist ?s - sandwich)
             (state_pred ?s - state)
  )

(:action make_sandwich_no_gluten 
	 :parameters (?s - sandwich ?b - bread_portion ?c - content_portion)
	 :precondition (and (at_kitchen_bread ?b)
			    (at_kitchen_content ?c)
			    (no_gluten_bread ?b)
			    (no_gluten_content ?c)
			    (notexist ?s)
                            (state_pred state0))
	 :effect (and
		   (not (at_kitchen_bread ?b))
		   (not (at_kitchen_content ?c))
		   (at_kitchen_sandwich ?s)
		   (no_gluten_sandwich ?s)
                   (not (notexist ?s))
                   (not (state_pred state0))
                   (state_pred state1)
		   ))


(:action make_sandwich
	 :parameters (?s - sandwich ?b - bread_portion ?c - content_portion)
	 :precondition (and (at_kitchen_bread ?b)
			    (at_kitchen_content ?c)
                            (notexist ?s)
                            (not (no_gluten_bread ?b))
			    (not (no_gluten_content ?c))
                            (state_pred state0)
			    )
	 :effect (and
		   (not (at_kitchen_bread ?b))
		   (not (at_kitchen_content ?c))
		   (at_kitchen_sandwich ?s)
                   (not (notexist ?s))
                   (not (state_pred state0))
                   (state_pred state1)
		   ))


(:action put_on_tray
	 :parameters (?s - sandwich ?t - tray)
	 :precondition (and  (at_kitchen_sandwich ?s)
			     (at ?t kitchen)
                             (state_pred state1))
	 :effect (and
		   (not (at_kitchen_sandwich ?s))
		   (ontray ?s ?t)
                   (not (state_pred state1))
                   (state_pred state0)
))


(:action serve_sandwich_no_gluten
 	:parameters (?s - sandwich ?c - child ?t - tray ?p - place)
	:precondition (and
		       (allergic_gluten ?c)
		       (ontray ?s ?t)
		       (waiting ?c ?p)
		       (no_gluten_sandwich ?s)
                       (at ?t ?p)
                       (state_pred state2)
		       )
	:effect (and (not (ontray ?s ?t))
		     (served ?c)))

(:action serve_sandwich
	:parameters (?s - sandwich ?c - child ?t - tray ?p - place)
	:precondition (and (not_allergic_gluten ?c)
	                   (waiting ?c ?p)
			   (ontray ?s ?t)
			   (at ?t ?p)
                           (not (no_gluten_sandwich ?s))
                           (state_pred state2))
	:effect (and (not (ontray ?s ?t))
		     (served ?c)))

(:action move_tray
	 :parameters (?t - tray ?p1 ?p2 - place)
	 :precondition (and (at ?t ?p1)(= ?p1 kitchen)(state_pred state0))
	 :effect (and (not (at ?t ?p1))
		      (at ?t ?p2)
                      (not (state_pred state0))
                      (state_pred state2)
))
			    
(:action move_tray_2
	 :parameters (?t - tray ?p1 ?p2 - place)
	 :precondition (and (at ?t ?p1)(= ?p2 kitchen)(state_pred state2))
	 :effect (and (not (at ?t ?p1))
		      (at ?t ?p2)
                      (not (state_pred state2))
                      (state_pred state0)
))

)
