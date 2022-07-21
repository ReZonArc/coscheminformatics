;
; reaction.scm
;
; Simple example of using the graph rewrites to emulate chmical
; reactions. This will search the AtomSpace for anything matching
; the query, and then create a new molecule whenever it finds the
; matching pattern.
;
; To run this example, start the guile shell in the `examples` directory
; (the directory holding this file!) and then say
;   `(load "reaction.scm")`
; It will print the results.

(use-modules (opencog) (opencog cheminformatics))
(use-modules (opencog exec))

; This defines an esterification reaction.
(define esterification
	(BindLink
		; Variable declaration
		(VariableList

			; Typed variables, specifying specific atoms.
			(TypedVariable (Variable "$varH1") (Type 'H))
			(TypedVariable (Variable "$varH2") (Type 'H))
			(TypedVariable (Variable "$varC1") (Type 'C))
			(TypedVariable (Variable "$varO1") (Type 'O))
			(TypedVariable (Variable "$varO2") (Type 'O))
			(TypedVariable (Variable "$varO3") (Type 'O))

			; Untyped variables that will match to anything
			(Variable "carboxy moiety")
			(Variable "hydroxy moiety")
			(Glob "rest of carboxy")
			(Glob "rest of hydroxy")
		)
		; Premise: Functional groups found in some educts
		(AndLink
			; Look for carboxyl group
			(Molecule
				(DB (Variable "$varC1") (Variable "$varO1"))
				(SB (Variable "$varC1") (Variable "$varO2"))
				(SB (Variable "$varO2") (Variable "$varH1"))
				(SB (Variable "$varC1") (Variable "carboxy moiety"))

				; Globs match one or more bonds.  To match zero,
				; change the lower bound by declaring it lik this:
				; (TypedVariable (Glob "rest of carboxy")
				;     (Interval (Number 0) (Number -1)))
				(Glob "rest of carboxy")
			)

			; The above will happily match `$varO2` and `carboxy moiety`
			; to the same atom. But we don't want that, so demand that
			; they be distinct.
			(Not (Identical (Variable "$varO2") (Variable "carboxy moiety")))

			; Look for hydroxyl group
			(Molecule
				(SB (Variable "$varO3") (Variable "$varH2"))
				(SB (Variable "$varO3") (Variable "hydroxy moiety"))
				(Glob "rest of hydroxy")
			)
		)
		; Clause: Formation of products
		(AndLink
			; Produce ester
			(Molecule
				(DB (Variable "$varC1") (Variable "$varO1"))
				(SB (Variable "$varC1") (Variable "$varO2"))

				(SB (Variable "$varC1") (Variable "carboxy moiety"))
				(Glob "rest of carboxy")

				(SB (Variable "$varO2") (Variable "hydroxy moiety"))
				(Glob "rest of hydroxy")
			)
			; Produce water
			(Molecule
				(SB (Variable "$varO3") (Variable "$varH1"))
				(SB (Variable "$varO3") (Variable "$varH2"))
			)
		)
	)
)

; ------------------------------------------------
; Populate the AtomSpace with some contents.
;
; Carboxyl group
(Molecule
	(DB (C "some carb") (O "oxy one"))
	(SB (C "some carb") (O "oxy two"))
	(SB (O "oxy two") (H "carboxyl proton"))
	(SB (C "some carb") (Fe "Bushehr"))
	; Some nonsense moiety, for pattern matching only.
	(SB (Fe "Bushehr") (Ni "phase II"))
)

; A hydroxyl group
(Molecule
	(SB (O "hydroxyl oxy") (H "hydroxyl proton"))
	; Another nonsense moiety, for pattern matching
	(SB (C "hydroxyl carbon") (O "hydroxyl oxy"))
	(SB (C "hydroxyl carbon") (Zn "Iranian"))
	(SB (Zn "Iranian") (Cu "Uranium"))
)

; Perform the reaction
(display "Here is the result of the reaction:\n")
(cog-execute! esterification)

; ------------------------------------------------
; The end.
; That's all, folks!
