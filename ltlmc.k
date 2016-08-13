require "builtins/model-checker.k"

module LTLMC
	imports LTL-HOOKS
	imports MODEL-CHECKER-HOOKS
	imports BUILTIN-HOOKS

  	syntax Pgm ::= LtlFormula

	syntax Bool ::= "val" "(" Bag "," Id "," Int ")" [function]

  	syntax Prop ::= "eq" "(" Id "," Int ")"

    rule val(<generatedTop>
    	<env>
    		...
    		<memo> ... I |-> Loc ... </memo>
			<store> Loc |-> V </store>
			...
		</env>
    </generatedTop>, I:Id, V:Int) => true
    
    rule B:Bag |=Ltl eq(I:Id, V:Int) => val(B, I, V) [ltl,anywhere]

    // krun example.kcml --ltlmc '<>Ltl eq(x,1)'
    // Eventualmente: <>Ltl
    // Proximo estado: OLtl
    // Em todos os estados: []Ltl
                     

endmodule 