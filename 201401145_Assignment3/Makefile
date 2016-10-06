TARGET = a.out
CC = g++
CFLAGS = -lfl
FLAGS=-w -Wno-deprecated -g -std=c++11
all: $(TARGET)
$(TARGET): lex.yy.c Assignment3.tab.c Classes.cpp ClassDefs.h
	$(CC) $(FLAGS) lex.yy.c Assignment3.tab.c Classes.cpp $(CFLAGS)
lex.yy.c: Assignment3.l
	flex Assignment3.l
Assignment3.tab.c: Assignment3.y
	bison -vd Assignment3.y
clean:
	rm *.c 
veryclean:
	rm -f *.c Assignment3.tab.h a.out XML_* *.output
