#!/bin/sh

lex expr.l
yacc -d expr.y
gcc -I. lex.yy.c y.tab.c -ll
