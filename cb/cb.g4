grammar cb;

import cbLex;

prog: importStatements topDefinitions EOF;

importStatements: importStatement*;

importStatement: 'import' name ('.' name)* ';';
name: Id;

topDefinitions: (
		functionDef
		| varDef
		| structDef
		| unionDef
		| typeDef
	)*;

functionDef:
	storage typeRef name '(' paramsDef ')' functionBlock;
paramsDef: typeRef name (',' typeRef name)*? ',...'?;
functionBlock: '{' statements '}';

varDef: storage typeRef name ('=' expr)? ';';

structDef: 'struct' name memberList;
unionDef: 'union' name memberList;

memberList: '{' (varDef)* '}';

typeDef: 'using' Id '=' typeRef ';';

typeRef: typeRefBase ('[' IntegerLiteral ']' | '*')*;
typeRefBase:
	Char
	| Bool
	| Short
	| Int
	| Long
	| Signed
	| (Unsigned (Char | Short | Int | Long))
	| Float
	| Double
	| Void
	| Id;

storage: 'static'?;

statements: statement*;
statement:
	';'
	| expr ';'
	| block
	| ifStatement
	| whileStatement
	| breakStatement
	| returnStatement;

block: '{' statements '}';
ifStatement: 'if' '(' expr ')' statement ('else' statement)?;
whileStatement: 'while' '(' expr ')' statement;

breakStatement: 'break' ';';
returnStatement: 'return' expr? ';';

expr: term '=' expr | expr10;

expr10: expr9 ('?' expr9 ':' expr9)?;
expr9: expr8 ('||' expr8)*;
expr8: expr7 ('&&' expr7)*;
expr7: expr6 (('>' | '<' | '>=' | '<=' | '==' | '!=') expr6)*;
expr6: expr5 ('|' expr5)*;
expr5: expr4 ('^' expr4)*;
expr4: expr3 ('&' expr3)*;
expr3: expr2 (('>>' | '<<') expr2)*;
expr2: expr1 (('+' | '-') expr1)*;
expr1: term (('*' | '/' | '%') term)*;

term: unary;
unary: '*' term | '&' term | postfix;
postfix:
	primary (
		'[' expr ']'
		| '.' name
		| '->' name
		| '(' expr (',' expr)* ')'
	)*;

primary:
	IntegerLiteral
	| CharLiteral
	| StingLiteral
	| Id
	| ('(' expr ')');