#include <bits/stdc++.h>
#include "Classdefs.h"

using namespace std;

ofstream out("XML_vistor.txt");

/* Constructors */
Var:Var(string declType, string name, int length){
	this->declType = declType;
	this->name = name;
	this->length = length;
}

Var:Var(string declType, name){
	this->declType = declType;
	this->name = name;
}

Decl:Decl(string dataType, class Var* var){
	this->dataType = dataType;
	this->var = var;
	this->var->setDataType(dataType);
}

Decls:Decls(){
	this->count = 0;
}
Location:Location(string var, string location_type, class Expr* expr){
	this->var = var;
	this->location_type = location_type;
	this->expr = expr;
	this->etype = exprType::location;
}

Location:Location(string var,string location_type){
	this->var = var;
	this->location_type = location_type;
	this->etype = exprType::location;
}

intLiteral:intLiteral(int value){
	this->value = value;
	this.ltype = literalType::Int;
}

boolLiteral:boolLiteral(string value){
	this->value = value;
	this.ltype = literalType::Bool;
}

BinExpr:BinExpr(class Expr* left,string opr,class Expr* right){
	this->left = left;
	this->right = right;
	this->opr = opr;
	this->etype = exprType::binary;
}

EnclExpr:EnclExpr(class Expr* expr){
	this->expr = expr;
	this.etype = exprType::enclExpr;
}

Assignment:Assignment(class Location* loc,class Expr* expr){
	this->loc = loc;
	this->expr = expr;	
}

Stmts:Stmts(){
	this->count = 0;
}

Prog:Prog(class Decls* decls,class Stmts* stmts){
	this->decls = decls;
	this->stmts = stmts;
}

/* Methods */

void Var:setDataType(string datatype){
	this->dataType = datatype;
}

class Var* Decl::getVar(){
	return var;
}

void Decls:push_back(class Var* var){
	decl_list.push_back(var);
	count++;
}

string BinExpr:BinExpr(){
	return lhs.toString() + opr + rhs.toString();
}

string Location:toString(){
	if(location_type.compare("Number") == 0){
		return var;
	}
	else{
		return var+ "[" + expr->toString + "]";
	}
}

int intLiteral:getValue(){
	return value;
}

string boolLiteral:toString(){
	return value;
}

string Location:getVar(){
	return var;
}

bool Location:is_array(){
	return location_type.compare("Array") == 0;
}

strinf Location:getExpr(){
	return expr;
}

/* Traversals */

void Decls:traverse(){
	out << "<declarations count=\"" << count << "\">\n";
	for (int i = 0; i < decl_list.size(); i++){
		decl_list[i]->traverse();
	}
	out << "</declarations>\n";
}

void Decl:traverse(){
	var->traverse();
}

void Var:traverse(){
	out << declType << endl;
	out << "<declaration name=\"" << name << "\" type=\"" << dataType << "\" ";
	if(declType.compare("Array") == 0){
		out << "size=\"" << length << "\" ";
	}
	out << "/>\n";
}

void Stmts:traverse(){
	out << "<statements count=\"" << count << "\">\n";
	for(int i = 0; i < stms.size(); i++){
		stmts[i]->traverse();
	}
	out << "</statements>\n";
}

void Assignment:traverse(){
	out << "<assignment>\n";
	out << "<LHS name =\"" << loc->getVar() << "\">\n";
	if(loc->is_array)loc->getExpr->traverse();
	out << "</LHS>\n";
	out << "<RHS>\n";
	out << expr->traverse();
	out << "</RHS>\n";
	out << "</assignment>\n";
}

void Location:traverse(){
	out << "<identifier name=\"" << var << "\"";
	if(is_array){
		out << ">";
		expr->traverse();
		out << "</identifier>\n";
	}
	else{
		out << " />\n";
	}
}

void intLiteral:traverse(){
	out << "<integer value=\"" << value << "\" />\n";
}

void boolLiteral:traverse(){
	out << "<boolean value=\"" << value << "\" />" << endl;
}

void BinExpr:traverse(){
	out << out << "<binary_expression type=\"" << getOperation(opr) <<"\">\n";
	left->traverse();
	right->traverse();
	out << "</binary_expression>\n";
}

void Prog:traverse(){
	out << "<program>\n";
	decls.traverse();
	stmts.traverse();
	out << "</program>\n";
}
