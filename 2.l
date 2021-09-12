%{
#include <stdio.h>
#include <stdlib.h>

#define COLOR_RED "\033[1;31m"
#define COLOR_RESET "\033[0m"

void yyerror(char *);
FILE *yyin;
int yylval;
int linenum = 1;

enum {
  RESERVED_IF=128,
  RESERVED_WHILE,
  RESERVED_DECVAR,
  RESERVED_ENDDEC,
  RESERVED_INTEGER,
  RESERVED_FLOAT,
  RESERVED_WRITE,
  ID,
  INT_CONSTANT,
  REAL_CONSTANT,
  STRING,
  OP_SUM,
  OP_SUB,
  OP_MULT,
  OP_DIV,
  OP_ASSIGN,
  OP_AND,
  OP_OR,
  OP_NOT,
  OP_EQ,
  OP_LT,
  OP_LE,
  OP_GT,
  OP_GE,
  OP_NE,
  PARENTHESIS_OPEN,
  PARENTHESIS_CLOSE,
  BRACES_OPEN,
  BRACES_CLOSE,
  COMMA,
  SEMICOLON,
  COLON
};

typedef int t_token;
%}

%option noyywrap
%option yylineno

natural_digit [1-9]
digit (0|{natural_digit})
uppercase_letter [A-Z]
lowercase_letter [a-z]
letter ({uppercase_letter}|{lowercase_letter})

id {letter}(_?({letter}|{digit}))*

int_constant ({digit}|{natural_digit}{digit}*)
real_constant {digit}+\.{digit}+

string \".*?\"

reserved_if (IF|if|If)
reserved_while (WHILE|while|While)
reserved_decvar (DECVAR|decvar|Decvar)
reserved_enddec (ENDDEC|enddec|Enddec)
reserved_integer (INTEGER|integer|Integer)
reserved_float (FLOAT|float|Float)
reserved_write (WRITE|write|Write)

op_sum "+"
op_sub "-"
op_mult "*"
op_div "/"
op_assign "="

op_and (AND|"&&")
op_or (OR|"||")
op_not (NOT|!)
op_eq "=="
op_lt "<"
op_gt ">"
op_le "<="
op_ge ">="
op_ne "!="

%%
{reserved_if} {
  printf("RESERVED_IF/%s\n", yytext);
  return RESERVED_IF;
}
{reserved_while} {
  printf("RESERVED_WHILE/%s\n", yytext);
  return RESERVED_WHILE;
}
{reserved_decvar} {
  printf("RESERVED_DECVAR/%s\n", yytext);
  return RESERVED_DECVAR;
}
{reserved_enddec} {
  printf("RESERVED_ENDDEC/%s\n", yytext);
  return RESERVED_ENDDEC;
}
{reserved_integer} {
  printf("RESERVED_INTEGER/%s\n", yytext);
  return RESERVED_INTEGER;
}
{reserved_float} {
  printf("RESERVED_FLOAT/%s\n", yytext);
  return RESERVED_FLOAT;
}
{reserved_write} {
  printf("RESERVED_WRITE/%s\n", yytext);
  return RESERVED_WRITE;
}

{id} {
  printf("ID/%s\n", yytext);
  return ID;
}

{int_constant} {
  yylval = atoi(yytext);
  printf("INT_CONSTANT/%d\n", yylval);
  return INT_CONSTANT;
}
{real_constant} {
  printf("REAL_CONSTANT/%s\n", yytext);
  return REAL_CONSTANT;
}

{string} {
  printf("STRING/%s\n", yytext);
  return STRING;
}

{op_sum} {
  printf("OP_SUM/%s\n", yytext);
  return OP_SUM;
}
{op_sub} {
  printf("OP_SUB/%s\n", yytext);
  return OP_SUB;
}
{op_mult} {
  printf("OP_MULT/%s\n", yytext);
  return OP_MULT;
}
{op_div} {
  printf("OP_DIV/%s\n", yytext);
  return OP_DIV;
}
{op_assign} {
  printf("OP_ASSIGN/%s\n", yytext);
  return OP_ASSIGN;
}

{op_and} {
  printf("OP_AND/%s\n", yytext);
  return OP_AND;
}
{op_or} {
  printf("OP_OR/%s\n", yytext);
  return OP_OR;
}
{op_not} {
  printf("OP_NOT/%s\n", yytext);
  return OP_NOT;
}
{op_eq} {
  printf("OP_EQ/%s\n", yytext);
  return OP_EQ;
}
{op_lt} {
  printf("OP_LT/%s\n", yytext);
  return OP_LT;
}
{op_gt} {
  printf("OP_GT/%s\n", yytext);
  return OP_GT;
}
{op_le} {
  printf("OP_LE/%s\n", yytext);
  return OP_LE;
}
{op_ge} {
  printf("OP_GE/%s\n", yytext);
  return OP_GE;
}
{op_ne} {
  printf("OP_NE/%s\n", yytext);
  return OP_NE;
}

"(" {
  printf("PARENTHESIS_OPEN/%s\n", yytext);
  return PARENTHESIS_OPEN;
}
")" {
  printf("PARENTHESIS_CLOSE/%s\n", yytext);
  return PARENTHESIS_CLOSE;
}
"{" {
  printf("BRACES_OPEN/%s\n", yytext);
  return BRACES_OPEN;
}
"}" {
  printf("BRACES_CLOSE/%s\n", yytext);
  return BRACES_CLOSE;
}
"," {
  printf("COMMA/%s\n", yytext);
  return COMMA;
}
";" {
  printf("SEMICOLON/%s\n", yytext);
  return SEMICOLON;
}
":" {
  printf("COLON/%s\n", yytext);
  return COLON;
}

"\n" {
  ++linenum;
}
"\t"
" "

. {
  char s[] = "Invalid character: ";

  strcat(s, yytext);
  strcat(s, "\n");

  yyerror(s);
}
%%

int main(int argc, char** argv) {
  const char* filename = argv[1];
  FILE* arg_file = fopen(filename, "rt");

  if (arg_file == NULL ) {
    printf("File cannot be opened: %s\n", filename);
    printf("Using standard input\n\n");
  }
  else {
    yyin = arg_file;
  }

  t_token token = yylex();

  while (token) {
    token = yylex();
  }

  return 0;
}

extern int linenum;
void yyerror(char* s) {
  fprintf(stderr, COLOR_RED "\nline %d: %s\n" COLOR_RESET, linenum, s);
  exit(1);
}