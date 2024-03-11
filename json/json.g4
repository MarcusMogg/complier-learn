grammar json;

prog: stat+ EOF;
// parser
stat:
	expr NEWLINE # expression
	//| ID '=' expr NEWLINE 
	| NEWLINE # blank;
expr:
	expr op = ('*' | '/') expr		# muldiv
	| expr op = ('+' | '-') expr	# addsub
	| INT							# int
	| ID							# id
	| ID '=' expr					# assign
	| '(' expr ')'					# parens;