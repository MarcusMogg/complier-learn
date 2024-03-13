lexer grammar cbLex;
Bool: 'bool';
Char: 'char';
Char16: 'char16_t';
Char32: 'char32_t';
Double: 'double';
Int: 'int';
Long: 'long';
Short: 'short';
Signed: 'signed';
Unsigned: 'unsigned';
Void: 'void';
Float: 'float';

Id: [a-zA-Z_][a-zA-Z0-9_]*;

IntegerLiteral: [0-9]+;
fragment IntSuffix: [Uu]? [Ll]?;
fragment Decimal:
	[+\-]? [0-9] IntSuffix
	| [+\-]? [1-9][0-9]* IntSuffix;
fragment Hex: '0' [xX][0-9a-fA-F]+ IntSuffix;

WhiteSpace: [ \t\r\n]+ -> skip;
Newline: '\r'? '\n' -> skip;
LineComment: '//' ~[\r\n]* -> skip;
BlockComment: '/*' .*? '*/' -> skip;

StingLiteral: '"' SChar* '"';
fragment SChar: ~[\n\r\\"] | '\\' [0-7][0-7][0-7] | '\\' .;

CharLiteral: '\'' CChar '\'';
fragment CChar: ~[\n\r\\'] | '\\' [0-7][0-7][0-7] | '\\' .;