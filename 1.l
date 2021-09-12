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
  POSTAL_CODE=128,
  PATENT,
  RESERVED_WORD,
  ID_D,
  ID_E,
  OTHER_BASE_CONSTANT,
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
  BINARY_CONSTANT
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

octal_digit [0-7]
octal_constant 0{octal_digit}+
hex_letter [A-F]
hex_digit ({digit}|{hex_letter})
hex_constant 0x{hex_digit}+

postal_code {natural_digit}{digit}{digit}{digit}
patent {uppercase_letter}{uppercase_letter}{digit}{digit}{digit}{uppercase_letter}{uppercase_letter}
comment \/\*.*\*\/
id_d ({letter}|{letter}({letter}|{digit}|_)*({letter}|{digit}))
id_e {letter}(_?({letter}|{digit}))*
other_base_constant ({octal_constant}|{hex_constant})
int_constant ({digit}|{natural_digit}{digit}*)
real_constant {digit}+\.{digit}+
string \".*?\"
reserved_word (IF|WHILE|DECVAR|ENDDEC|INTEGER|FLOAT|WRITE)

op_sum "+"
op_sub "-"
op_mult "*"
op_div "/"
op_assign "="
op_and (AND|\&\&)
op_or (OR|\|\|)
op_not (NOT|!)
op_eq "=="
op_lt "<"
op_gt ">"
op_le "<="
op_ge ">="
op_ne "!="

binary_digit (0|1)
binary_constant 0b{binary_digit}+

%%
{postal_code} {
  printf("POSTAL_CODE/%d\n", atoi(yytext));
  return POSTAL_CODE;
}
{patent} {
  printf("PATENT/%s\n", yytext);
  return PATENT;
}

{comment} /* skip comments */

{reserved_word} {
  printf("RESERVED_WORD/%s\n", yytext);
  return RESERVED_WORD;
}

{id_e} {
  printf("ID_E/%s\n", yytext);
  return ID_E;
}
{id_d} {
  printf("ID_D/%s\n", yytext);
  return ID_D;
}

{other_base_constant} {
  printf("OTHER_BASE_CONSTANT/%s\n", yytext);
  return OTHER_BASE_CONSTANT;
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

{binary_constant} {
  printf("BINARY_CONSTANT/%s\n", yytext);
  return BINARY_CONSTANT;
}

"("
")"
"{"
"}"
","
";"
":"
" "
\"

"\n" {
  ++linenum;
}
"\t"
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