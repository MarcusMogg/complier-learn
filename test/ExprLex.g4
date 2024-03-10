lexer grammar ExprLex;

SPACE: [ \t]+ -> skip;
NEWLINE: '\r'? '\n';
INT: [0-9]+;
ID: [a-zA-Z]+;