- 1.1
	- three mechanisms for combining simple ideas into complex ones:
		- primitive expressions - a language's simplest entities, procedures and data
		  means of combination - procedure composition and construction of compound data
		  means of abstraction - elements named & manipulated
	- environment tracks named entities, provides context for evaluation
	- applicative-order evaluation model
	  1. evaluate subexpressions
	  2. apply operator to operands
	  normal-order evaluation model
	  1. substitute non-primitive expressions
	  2. apply operator to operands
	  special forms have their own evaluation models
	- predicates return/evaluate to true or false
	- procedure parameters are called bound variables, procedures bind their parameters. a free variable is one that is not bound. the expressions for which a binding defines a name is the name's scope. capturing a variable is to use it's name in a binding.
	- block structure is the nesting of definitions. lexical scoping allows internal definitions to use the bound variables of their enclosing procedure as free .