module IMP
	
	syntax BExp ::= Bool
				| BExp "&&" BExp [seqstrict]
				> BExp "||" BExp [seqstrict]
				| "(" BExp ")" [bracket]
				| BExp BExp [left]

	syntax AExp ::= Int
				| AExp "+" AExp [strict]
				| AExp "-" AExp [strict]
				> AExp "*" AExp [strict]
				> AExp "/" AExp [strict]
				| "(" AExp ")" [bracket]
				| AExp AExp [left]

	syntax Exp ::= Value | AExp

	syntax Block ::= "Skip" 
					| Id "=" Exp [binder, strict(2)] 
					| "if" "(" BExp ")" "{" Block "}" "else" "{" Block "}" [strict(1)]
					| Block ";" Block 

	syntax Value ::= Int | Bool

	syntax IDs ::= List{Id,","}

	syntax Stmt ::= "var" IDs "=" Value ";"
					| Block
					| Stmt Stmt [left]
	
	
	syntax Pgm ::= Stmt

	syntax KResult ::= Value

	configuration
		<env>
			<k color="yellow"> $PGM:Pgm </k>
			<store color="blue"> .Map </store>
		</env>

	rule S1:Stmt S2:Stmt => S1 ~> S2 [structural]

	rule B1:Block ; B2:Block => B1 ~> B2 [structural]

	rule Skip => .K

	rule if (true) { B:Block } else { _ } => B

	rule if (false) { _ } else { B:Block } => B

	rule <k> var (X:Id,Xs:IDs) = V:Value ; => var Xs = V ; ... </k>
		<store> Rho:Map => Rho X |-> V </store>

	rule var .IDs = _:Value ; => .K [structural]

	rule <k> I:Id = V:Value => .K ... </k>
		<store> Rho:Map I |-> _ => Rho I |-> V </store>

	rule Exp1:Int + Exp2:Int => Exp1 +Int Exp2
	rule Exp1:Int - Exp2:Int => Exp1 -Int Exp2
	rule Exp1:Int * Exp2:Int => Exp1 *Int Exp2
	rule Exp1:Int / Exp2:Int => Exp1 /Int Exp2 requires Exp2 =/=Int 0

	rule B1:BExp && B2:BExp => B2 when B1 ==K true
	rule B1:BExp && B2:BExp => false when B1 ==K false
	rule B1:BExp || B2:BExp => true when B1 ==K true 
	rule B1:BExp || B2:BExp => B2 when B1 ==K false

endmodule		