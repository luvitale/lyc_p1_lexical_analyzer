LEX=flex
CC=gcc

1.app: lex.yy.o
	$(CC) -o 1.app lex.yy.o -lfl

lex.yy.o: lex.yy.c
	$(CC) -c lex.yy.c

lex.yy.c: 1.l
	$(LEX) 1.l
