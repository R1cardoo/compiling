app: test1.l test1.y
	lex test1.l
	yacc test1.y
	gcc y.tab.c -ll -ly
