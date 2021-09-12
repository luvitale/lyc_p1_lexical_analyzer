LEX=flex
CC=gcc

all: 1.app 2.app

1.app: lex1.yy.o
	$(CC) -o 1.app lex1.yy.o -lfl

lex1.yy.o: lex1.yy.c
	$(CC) -c lex1.yy.c

lex1.yy.c: 1.l
	$(LEX) -o lex1.yy.c 1.l

2.app: lex2.yy.o
	$(CC) -o 2.app lex2.yy.o -lfl

lex2.yy.o: lex2.yy.c
	$(CC) -c lex2.yy.c

lex2.yy.c: 2.l
	$(LEX) -o lex2.yy.c 2.l

clean:
	rm -f *.yy.c *.yy.o *.app
