all: scanner

scanner: lex.yy.c
	gcc lex.yy.c -lfl -o scanner

lex.yy.c: quack.l
	flex quack.l

clean:
	rm lex.yy.c scanner
