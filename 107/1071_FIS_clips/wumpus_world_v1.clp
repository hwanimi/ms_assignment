; WUMPUS WORLD 
; input : states of wumpus world (n*n caves, breeze, stench)
; output : exist of pit, wumpus at each caves - (n, n) Safe, (n, n) Pit, (n, n) Wumpus ;safe has neither pir nor wumpus 
; 


(deftemplate observations
	(multislot breeze) (multislot stench)); because obervations need to have x,y position, it must define as multislot

(deffacts initial-states
	(xpositions 1 2 3 4)
	(ypositions 1 2 3 4)
	(observations (breeze 2 1))
	(observations (breeze 2 3))
	(observations (breeze 3 2))
	(observations (breeze 3 4))
	(observations (breeze 4 1))
	(observations (breeze 4 3))
	(observations (stench 1 2))
	(observations (stench 1 4))
	(observations (stench 2 3))
)
;(reset)
;(facts)

;;Pit
(defrule Pit-middle
	;(onmap ?x ?y)
	(xpositions $? ?x $?) 
    (ypositions $? ?y $?)
	(observations (breeze =(- ?x 1) ?y))
	(observations (breeze =(+ ?x 1) ?y))
	(observations (breeze ?x =(- ?y 1)))
	(observations (breeze ?x =(+ ?y 1)))
=> (assert(Pit ?x ?y)))
	
	
(defrule Pit-right-side
	(xpositions ?first $? ?last) 
	(xpositions $? ?x $?)
	(ypositions $? ?y $?)

	(and(not(observations (breeze =(+ ?last 1) ?y)))
	(observations (breeze ?last =(- ?y 1)))
	(observations (breeze ?last =(+ ?y 1)))
	(observations (breeze =(- ?last 1) ?y))); 
	
	=>(assert(Pit ?last ?y)))
	
(defrule Pit-left-side
	(xpositions ?first $? ?last) 
	(xpositions $? ?x $?)
	(ypositions $? ?y $?)

	(and(not(observations (breeze =(- ?first 1) ?y)))
	(observations (breeze ?first =(- ?y 1)))
	(observations (breeze ?first =(+ ?y 1)))
	(observations (breeze =(+ ?first 1) ?y))
	); 
	
	=>(assert(Pit ?first ?y)))
	
(defrule Pit-upper-side
	(xpositions ?first $? ?last) 
	(xpositions $? ?x $?)
	(ypositions $? ?y $?)

	(and(not(observations (breeze ?x =(+ ?last 1))))
	(observations (breeze ?x =(- ?last 1)))
	(observations (breeze =(+ ?x 1) ?last))
	(observations (breeze =(- ?x 1) ?last))); 
	
	=>(assert(Pit ?x ?last)))
	
(defrule Pit-lower-side
	(xpositions ?first $? ?last) 
	(xpositions $? ?x $?)
	(ypositions $? ?y $?)

	(and(not(observations (breeze ?x =(- ?first 1))))
	(observations (breeze ?x =(+ ?first 1)))
	(observations (breeze =(+ ?x 1) ?first))
	(observations (breeze =(- ?x 1) ?first))); 
	
	=>(assert(Pit ?x ?first)))	
	
(defrule Pit-edge-1
	(xpositions ?first $? ?last) 

	(and
	(not(observations (breeze ?first =(- ?first 1))))
	(not(observations (breeze =(- ?first 1) ?first)))
	(observations (breeze ?first =(+ ?first 1)))
	(observations (breeze =(+ ?first 1) ?first))
	); 
	
	=>(assert(Pit ?first ?first)))		
(defrule Pit-edge-2
	(xpositions ?first $? ?last) 

	(and
	(not(observations (breeze ?first =(+ ?last 1))))
	(not(observations (breeze =(- ?first 1) ?last)))
	(observations (breeze ?first =(- ?last 1)))
	(observations (breeze =(+ ?first 1) ?last))
	); 
	
	=>(assert(Pit ?first ?last)))

(defrule Pit-edge-3
	(xpositions ?first $? ?last) 

	(and
	(not(observations (breeze ?last =(+ ?last 1))))
	(not(observations (breeze =(+ ?last 1) ?last)))
	(observations (breeze ?last =(- ?last 1)))
	(observations (breeze =(- ?last 1) ?last))
	); 
	
	=>(assert(Pit ?last ?last)))

(defrule Pit-edge-4
	(xpositions ?first $? ?last) 

	(and
	(not(observations (breeze ?last =(+ ?first 1))))
	(not(observations (breeze =(+ ?last 1) ?first)))
	(observations (breeze ?last =(- ?first 1)))
	(observations (breeze =(- ?last 1) ?first))
	); 
	
	=>(assert(Pit ?last ?first)))



;;Wumpus
(defrule W-middle
	;(onmap ?x ?y)
	(xpositions $? ?x $?) 
    (ypositions $? ?y $?)
	(observations (stench =(- ?x 1) ?y))
	(observations (stench =(+ ?x 1) ?y))
	(observations (stench ?x =(- ?y 1)))
	(observations (stench ?x =(+ ?y 1)))
=> (assert(W ?x ?y)))
	
	
(defrule W-right-side
	(xpositions ?first $? ?last) 
	(xpositions $? ?x $?)
	(ypositions $? ?y $?)

	(and(not(observations (stench =(+ ?last 1) ?y)))
	(observations (stench ?last =(- ?y 1)))
	(observations (stench ?last =(+ ?y 1)))
	(observations (stench =(- ?last 1) ?y))); 
	
	=>(assert(W ?last ?y)))
	
(defrule W-left-side
	(xpositions ?first $? ?last) 
	(xpositions $? ?x $?)
	(ypositions $? ?y $?)

	(and(not(observations (stench =(- ?first 1) ?y)))
	(observations (stench ?first =(- ?y 1)))
	(observations (stench ?first =(+ ?y 1)))
	(observations (stench =(+ ?first 1) ?y))
	); 
	
	=>(assert(W ?first ?y)))
	
(defrule W-upper-side
	(xpositions ?first $? ?last) 
	(xpositions $? ?x $?)
	(ypositions $? ?y $?)

	(and(not(observations (stench ?x =(+ ?last 1))))
	(observations (stench ?x =(- ?last 1)))
	(observations (stench =(+ ?x 1) ?last))
	(observations (stench =(- ?x 1) ?last))); 
	
	=>(assert(W ?x ?last)))
	
(defrule W-lower-side
	(xpositions ?first $? ?last) 
	(xpositions $? ?x $?)
	(ypositions $? ?y $?)

	(and(not(observations (stench ?x =(- ?first 1))))
	(observations (stench ?x =(+ ?first 1)))
	(observations (stench =(+ ?x 1) ?first))
	(observations (stench =(- ?x 1) ?first))); 
	
	=>(assert(W ?x ?first)))	
	
(defrule W-edge-1
	(xpositions ?first $? ?last) 

	(and
	(not(observations (stench ?first =(- ?first 1))))
	(not(observations (stench =(- ?first 1) ?first)))
	(observations (stench ?first =(+ ?first 1)))
	(observations (stench =(+ ?first 1) ?first))
	); 
	
	=>(assert(W ?first ?first)))		
(defrule W-edge-2
	(xpositions ?first $? ?last) 

	(and
	(not(observations (stench ?first =(+ ?last 1))))
	(not(observations (stench =(- ?first 1) ?last)))
	(observations (stench ?first =(- ?last 1)))
	(observations (stench =(+ ?first 1) ?last))
	); 
	
	=>(assert(W ?first ?last)))

(defrule W-edge-3
	(xpositions ?first $? ?last) 

	(and
	(not(observations (stench ?last =(+ ?last 1))))
	(not(observations (stench =(+ ?last 1) ?last)))
	(observations (stench ?last =(- ?last 1)))
	(observations (stench =(- ?last 1) ?last))
	); 
	
	=>(assert(W ?last ?last)))

(defrule W-edge-4
	(xpositions ?first $? ?last) 

	(and
	(not(observations (stench ?last =(+ ?first 1))))
	(not(observations (stench =(+ ?last 1) ?first)))
	(observations (stench ?last =(- ?first 1)))
	(observations (stench =(- ?last 1) ?first))
	); 
	
	=>(assert(W ?last ?first)))
	

(defrule result-safe
	(xpositions $? ?x $?)
	(ypositions $? ?y $?)
	(not (Pit ?x ?y))
	(not (W ?x ?y))
	=>
	(printout t "(" ?x "," ?y ")Safe " crlf))

(defrule result-pit
	(Pit ?x ?y)
=> (printout t "(" ?x"," ?y ")Pit " crlf))

(defrule result-W
	(W ?x ?y)
=> (printout t "(" ?x"," ?y ")Wumpus " crlf))




;------
;thought
;(defrule onmap
;   (xpositions $? ?x $?) 
;   (ypositions $? ?y $?)
;=> 
;   (assert (onmap ?x ?y))
;)
;(run)

;(deftemplate neighbor
;	(multislot onmap)(multislot left) (multislot right)(multislot down)(multislot up))

;(defrule neighbor
;	(onmap ?x ?y)
;	=>
;	(assert (neighbor (onmap ?x ?y)(left (- ?x 1) ?y)(right (+ ?x 1)?y)(down ?x (- ?y 1))(up ?x (+ ?y 1)))))
;(run)
;(defrule getpossilblepit
;	(observations (breeze ?x ?y))
;	=>
;	(assert (pit (- ?x 1) ?y)(pit (+ ?x 1)?y)(pit ?x (- ?y 1))(pit ?x (+ ?y 1))))
;	))
	
;(defrule range
;	?f<-(pit ?x ?y)
;	(not(onmap ?x ?y))
;	=>
;	(retract ?f))
;	
;(defrule range
;	(not (xpositions $? ?a $?))
;	?n<-(neighbor (onmap ? ?) (left $? ?a $?) (right $? ?a $?) (down $? ?a $?)(up $? ?a $?))
;	=> (modify ?n



;----
;reference 
;FIG3.
;CLIPS> (assert (numlist 1 2 3))
;==> f-11    (numlist 1 2 3)
;<Fact-11>
;CLIPS> (assert (exception 2 5 6))
;==> f-12    (exception 2 5 6)
;<Fact-12>
;CLIPS> (defrule practice1
;(numlist $? ?x $?)
;(not(exception $? ?x $?))
;=>
;(printout t "passing:"?x crlf))
;CLIPS> (run)
;FIRE    1 practice1: f-11,*
;passing:1
;FIRE    2 practice1: f-11,*
;passing:3

;FIG4.
;CLIPS> (> 2 3)
;FALSE
;CLIPS> (and(> 3 2)(> 5 4))
;TRUE
;CLIPS> (defrule andor
;(test (and (> 3 2)(or( > 7 8)(= 3 (+ 2 1)))))
;=>
;(printout t " i can use test, and, or, and > in CLIPS." crlf))
;CLIPS> (run)
;FIRE    1 andor: *
; i can use test, and, or, and > in CLIPS.
;CLIPS> 
