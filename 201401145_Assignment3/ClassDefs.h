#include <bits/stdc++.h>

using namespace std;

enum exprType {binary = 1; location = 2; literal = 3; enclExpr = 4;};
enum literalType {Int = 1; Bool = 2;};
union Node{
	int number;
	char* value;
	class Prog* prog;
	class Decls* decls;
	class Decl* decl;
	class Var* var;
	class Stmts* stmts;
	class Stmt* stmt;
	class Expr* expr;
	class Location* location;
	class Literal* literal;
	class intLiteral* int_literal;
	class boolLiteral* bool_literal;

	Node(){
		number = 0;
		string = NULL;
		var = NULL;
		decls = NULL;
		decl = NULL;
		stmts = NULL;
		stmt = NULL;
	}
	~Node(){};
};
typedef union Node YYSTYPE;

/* Classes 
   class Prog;
   class Decls;
   class Decl;
   class Var;
   class Stmts;
   class Stmt;
   class Assignment;
   class Expr;
   class EnclExpr;
   class BinExpr;
   class Location;
   class Literal;
   class intLiteral;
   class boolLiteral;
 */

class Var{
	private:
		string declType;
		string name;
		string dataType;
		unsigned int length;
	public:
		/* Constructors */
		Var(string,string,length);
		Var(string,string);
		/* Methods */
		void setDataType(string);
		void traverse();
};

class Decl{
private:
	string dataType;
	class Var* var;
public:
	Decl(string,class Var*);
	class Var* getVar();
	void traverse();
};

class Decls{
private:
	vector<class Decl*> decl_list;
	int cnt;
public:
	Decls();
	void push_back(class Decl*);
	void traverse();
};

class Expr{
protected:
	exprType etype;
public:
	void setEtype(exprType x){etype = x;}
	exprType getEtype();
	string toString();
	virtual void traverse();
};

class EnclExpr:public Expr{
private:
	class Expr* expr;
public:
	EnclExpr(class Expr*);
	void traverse();
};

class BinExpr:public Expr{
private:
	class Expr* lhs;
	class Expr* rhs;
	string opr;
public:
	BinExpr(class Expr*, string, class Expr*);
	void traverse();
	string toString();
};

class Location:public Expr{
private:
	string var;
	string location_type;
	class Expr* expr;
public:
	Location(string,string,class Expr*);
	Location(string,string);
	void traverse();
	string getVar();
	bool is_array();
	string getExpr();
	string toString();
};

class Literal:public Expr{
protected:
	literalType ltype;
public:
	virtual void traverse();
	virtual int getValue();
	virtual string toString();
};

class intLiteral:public Literal{
private:
	int value;
public:
	intLiteral(int);
	void traverse();
	int getValue();
	string toString();
};

class boolLiteral:public Literal{
private:
	string value;
public:
	boolLiteral(string);
	void traverse();
	string toString();
};

class Stmt{
public:
	virtual void traverse();
};

class Stmts{
private:
	vector<class Stmt*> stmts;
	int cnt;
public:
	Stmts();
	void push_back(class Stmt*);
	void traverse();
};

class Assignment:public Stmt{
private:
	class Location* loc;
	class Expr* expr;
public:
	Assignment(class Location*, class Expr*);
	void traverse();
};

class Prog{
private:
	class Stmts* stmts;
	class Decls* decls;
public:
	Prog(class Decls*,class Stmts*);
	void traverse();
};
