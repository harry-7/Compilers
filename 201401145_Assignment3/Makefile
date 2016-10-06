TARGET = a.out
CC = g++
CFLAGS = -lfl
all: $(TARGET)
$(TARGET): lex.yy.c Assignment2.tab.c
	$(CC) lex.yy.c Assignment2.tab.c $(CFLAGS)
lex.yy.c: Assignment2.l
	flex Assignment2.l
Assignment2.tab.c: Assignment2.y
	bison -d Assignment2.y
clean:
	rm *.c 
veryclean:
	rm -f *.c Assignment2.tab.h a.out bison_output.txt *.output
