grammar csv;

file: header row* NEWLINE?;

header: field (',' field)+;
row: NEWLINE field (',' field)+;

field: TEXT | STRING |; // allow empty

NEWLINE: '\r'? '\n';
TEXT: ~[,\n\r"]+;
STRING: '"' ('""' | ~'"')* '"';