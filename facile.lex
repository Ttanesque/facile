%{
#include <assert.h>
#include <glib.h>
#include "facile.y.h"

// #define TOK_IF         258
// #define TOK_THEN       259
// #define TOK_ELSE       260
// #define TOK_ELSE_IF    261
// #define TOK_END        262
// #define TOK_ENDIF      263

// #define TOK_WHILE      264
// #define TOK_END_WHILE  265

// #define TOK_CONTINUE   266
// #define TOK_BREAK      267

// #define TOK_SEMI_COLON  268
// #define TOK_AFFECTATION 269

// #define TOK_PRINT      270
// #define TOK_READ       271

// #define TOK_IDENTIFIER 272
// #define TOK_NUMBER     273

// #define TOK_BRACK_OP   274
// #define TOK_BRACK_CL   275

// #define TOK_OPE_ADD    276
// #define TOK_OPE_SUB    277
// #define TOK_OPE_DIV    278
// #define TOK_OPE_MUL    279

// #define TOK_TRUE     280
// #define TOK_FALSE    281

// #define TOK_AND      282
// #define TOK_OR       283
// #define TOK_NOT      284
// #define TOK_SUP      285
// #define TOK_INF      286
// #define TOK_EQUALS   287
// #define TOK_SUPEQUAL 288
// #define TOK_INFEQUAL 289
// #define TOK_COMMENT  290

// #define TOK_DO       291

%}

%option yylineno

%%
if {
    // assert(printf("'if'found\n"));
    return TOK_IF;
}

then {
    // assert(printf("'then'found\n"));
    return TOK_THEN;
}

else {
    // assert(printf("'else'found\n"));
    return TOK_ELSE;
}

elseif {
    // assert(printf("'elseif'found\n"));
    return TOK_ELSE_IF;
}

end {
    // assert(printf("'end'found\n"));
    return TOK_END;
}

endif {
    // assert(printf("'endif'found\n"));
    return TOK_ENDIF;
}

while {
    // assert(printf("'while'found\n"));
    return TOK_WHILE;
}

endwhile {
    // assert(printf("'endwhile'found\n"));
    return TOK_END_WHILE;
}

do {
    // assert(printf("'do'found\n"));
    return TOK_DO;
}

continue {
    // assert(printf("'continue'found\n"));
    return TOK_CONTINUE;
}

break {
    // assert(printf("'break'found\n"));
    return TOK_BREAK;
}

";" {
    // assert(printf("'semicolon'found\n"));
    return TOK_SEMI_COLON;
}

":=" {
    // assert(printf("':='found\n"));
    return TOK_AFFECTATION;
}

print {
    // assert(printf("'print'found\n"));
    return TOK_PRINT;
}

read {
    // assert(printf("'read'found\n"));
    return TOK_READ;
}

true {
    // assert(printf("'true'found\n"));
    return TOK_TRUE;
}

false {
    // assert(printf("'false'found\n"));
    return TOK_FALSE;
}

and {
    // assert(printf("'and'found\n"));
    return TOK_AND;
}

or {
    // assert(printf("'or'found\n"));
    return TOK_OR; 
}

not {
    // assert(printf("'not'found\n"));
    return TOK_NOT; 
}

"(" {
    // assert(printf("'('found\n"));
    return TOK_BRACK_OP;
}

")" {
    // assert(printf("')'found\n"));
    return TOK_BRACK_CL;
}

"+" {
    // assert(printf("'+'found\n"));
    return TOK_OPE_ADD;
}

"-" {
    // assert(printf("'-'found\n"));
    return TOK_OPE_SUB;
}

"/" {
    // assert(printf("'/'found\n"));
    return TOK_OPE_DIV;
}

"*" {
    // assert(printf("'*'found\n"));
    return TOK_OPE_MUL;
}

">=" {
    // assert(printf("'>='found\n"));
    return TOK_SUPEQUAL;
}

"<=" {
    // assert(printf("'<='found\n"));
    return TOK_INFEQUAL;
}

">" {
    // assert(printf("'>'found\n"));
    return TOK_SUP; 
}

"<" {
    // assert(printf("'<'found\n"));
    return TOK_INF;
}

"==" {
    // assert(printf("'=='found\n"));
    return TOK_EQUALS;
}

# {
    // assert(printf("'#'found\n"));
    return TOK_COMMENT;
}

[a-zA-Z][a-zA-Z0-9_]* {
    // assert(printf("'identificateur'found\n"));
    yylval.string = yytext;
    return TOK_IDENTIFIER;
}

[1-9]*[0-9] {
    // assert(printf("'number'found\n"));
    sscanf(yytext, "%lu", &yylval.number);
    return TOK_NUMBER;
}

[ \t\n] ;

. {
    return yytext[0];
}

%%