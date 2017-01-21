%{
#include <stdio.h>
int line_num = 1;
char str[1024];
int str_len = 0;
%}

%x COMMENTBLOCK
%x SINGLESTRINGLITERAL
%x TRIPLESTRINGLITERAL
NEWLINE \n
WHITESPACE [\t\n\r ]
DIGIT    [0-9]
IDENT [_a-zA-Z][_a-zA-Z0-9]*
SINGLELINECOMMENT \/\/.*

CLASS class
DEF def
EXTENDS extends
IF if
ELIF elif
ELSE else
WHILE while
RETURN return

STRING String
INTEGER Integer
OBJ Obj
BOOLEAN Boolean
TRUE true
FALSE false
AND and
OR or
NOT not
NOTHING Nothing
NONE none

ASSIGNMENT "="

PLUS "+"
MINUS "-"
TIMES "*"
DIVIDE "/"
EQUALS "=="
ATMOST "<="
LESS "<"
ATLEAST ">="
MORE ">"

LCBRACE "{"
RCBRACE "}"
LBRACE "("
RBRACE ")"
COMMA ","
SEMICOLON ";"
PERIOD "."
COLON ":"

%%
{SINGLELINECOMMENT}     {
           printf( "%d  %s \"%s\"\n", line_num, "COMMENT", "");
           }

\/\*       {BEGIN(COMMENTBLOCK);}
<COMMENTBLOCK>\*\/     {
            printf( "%d  %s \"%s\"\n", line_num, "BLOCKCOMMENT", "");
            BEGIN(INITIAL);
            }
\"\"\"     {str_len = 0; BEGIN(TRIPLESTRINGLITERAL);}
<TRIPLESTRINGLITERAL>\"\"\"           {
            str[str_len] = '\0';
            printf( "%d  %s \"%s\"\n", line_num, "TRIPLESTRINGLITERAL", str);
            BEGIN(INITIAL);
            }
<TRIPLESTRINGLITERAL>.|\n            {
                                     str[str_len] = yytext[0];
                                     str_len++;
                                     }
\"         {str_len= 0; BEGIN(SINGLESTRINGLITERAL);}
<SINGLESTRINGLITERAL>\\\"            {
                                      str[str_len++] = '\\';
                                      str[str_len++] = '\"';
                                     }
<SINGLESTRINGLITERAL>\"         {
                                str[str_len] = '\0';
                                printf( "%d  %s \"%s\"\n", line_num, "SINGLESTRINGLITERAL", str);
                                BEGIN(INITIAL);
                                }
<SINGLESTRINGLITERAL>[^\"]           {
                                     str[str_len] = yytext[0];
                                     str_len++;
                                     }

<INITIAL,COMMENTBLOCK,TRIPLESTRINGLITERAL>{NEWLINE}      { ++line_num;}

{WHITESPACE}  {;}

0|[1-9]{DIGIT}*    {
            printf( "%d  %s \"%s\"\n", line_num, "INT_LIT", yytext);
            }

{DIGIT}*"."{DIGIT}+      {
            printf( "%d  %s \"%s\"\n", line_num, "FLOAT_LIT", yytext);
            }

{CLASS}|{DEF}|{EXTENDS}|{IF}|{ELIF}|{ELSE}|{WHILE}|{RETURN}            {
            printf( "%d  %s \"%s\"\n", line_num, "KEYWORD", yytext);
            }

{STRING}|{INTEGER}|{OBJ}|{BOOLEAN}|{TRUE}|{FALSE}|{AND}|{OR}|{NOT}|{NOTHING}|{NONE}|{IDENT}  {
            printf( "%d  %s \"%s\"\n", line_num, "IDENT", yytext);
            }
{PLUS}|{MINUS}|{TIMES}|{DIVIDE}|{EQUALS}|{ATMOST}|{LESS}|{ATLEAST}|{MORE}|{LCBRACE}|{RCBRACE}|{LBRACE}|{RBRACE}|{COMMA}|{SEMICOLON}|{PERIOD}|{COLON}   {
            printf( "%d  %s \"%s\"\n", line_num, yytext, yytext);
            }
{ASSIGNMENT}  {
            printf( "%d  %s \"%s\"\n", line_num, yytext, yytext);
            }
.           {
           printf( "%d  Unrecognized character: %s\n", line_num, yytext );
           }
%%

main(int argc, char **argv )
    {
    ++argv, --argc;  /* skip over program name */
    if ( argc > 0 )
            yyin = fopen( argv[0], "r" );
    else
            yyin = stdin;

    yylex();
    }
