;
; reaction.scm
;
; Simple example of using the graph rewrites to emulate chmical
; reactions. This will search the AtomSpace for anything matching
; the query, and then create a new molecule whenever it finds the
; matching pattern.

(use-modules (opencog) (opencog cheminformatics))
(use-modules (opencog exec))

; This defines an esterification reaction. It is is simple, but
; incomplete, as will become apparent shortly. Patience!
(define esterification
	(BindLink
		; Variable declaration
		(VariableList
			(TypedVariable (Variable "$varH1") (Type 'H))
			(TypedVariable (Variable "$varH2") (Type 'H))
			(TypedVariable (Variable "$varC1") (Type 'C))
			(TypedVariable (Variable "$varC2") (Type 'C))
			(TypedVariable (Variable "$varO1") (Type 'O))
			(TypedVariable (Variable "$varO2") (Type 'O))
			(TypedVariable (Variable "$varO3") (Type 'O))
		)
		; Premise: Functional groups found in some educts
		(AndLink
			; Look for carboxyl group
			(Molecule
				(DB (Variable "$varC1") (Variable "$varO1"))
				(SB (Variable "$varC1") (Variable "$varO2"))
				(SB (Variable "$varO2") (Variable "$varH1"))
			)
			; Look for hydroxyl group
			(Molecule
				(SB (Variable "$varC2") (Variable "$varO3"))
				(SB (Variable "$varO3") (Variable "$varH2"))
			)
		)
		; Clause: Formation of products
		(AndLink
			; Produce ester
			(Molecule
				(DB (Variable "$varC1") (Variable "$varO1"))
				(SB (Variable "$varC1") (Variable "$varO2"))
				(SB (Variable "$varO2") (Variable "$varC2"))
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
)

; A hydroxyl group
(Molecule
	(SB (C "hydroxyl carbon") (O "hydroxyl oxy"))
	(SB (O "hydroxyl oxy") (H "hydroxyl proton"))
)

; Perform the reaction
(cog-execute! esterification)

; ------------------------------------------------
; What's wrong with this example? Two things: The search pattern failed
; to specify the "R" remaining part of the molecules. And the demo
; molecules also don't have the "R" part. Lets fix this ...

