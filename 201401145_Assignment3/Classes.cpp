#include <bits/stdc++.h>
#include "ClassDefs.h"

using namespace std;

ofstream out("XML_vistor.txt");
int tabs_needed = 0;
const int tab_width = 4;
#define TBS printTabs()
/* Usefull Functions */

string getOperation(string opr){
	if(opr.compare("+") == 0){
		return string("Addition");
	}
	else if (opr.compare("-")){
		return string("Subtraction");
	}
	else if(opr.compare("*")){
		return string("Multiplication");
	}
	else if (opr.compare("/")){
		return string("Division");
	}
	else if (opr.compare("%")){
		return string("Modulus");
	}
}

void printTabs(){
	for(int i = 0; i < tabs_needed; i++){
		for(int j = 0; j < tab_width; j++)
			out << " ";
	}
}
/* Constructors */
Var::Var(string declType, string name, unsigned int length){
	this->declType = declType;
	this->name = name;
	this->length = length;
}

Var::Var(string declType, string name){
	this->declType = declType;
	this->name = name;
}

Decl::Decl(string dataType, class Var* var){
	this->dataType = dataType;
	this->var = var;
	this->var->setDataType(dataType);
}

Decls::Decls(){
	this->cnt = 0;
}
Location::Location(string var, string location_type, class Expr* expr){
	this->var = var;
	this->location_type = location_type;
	this->expr = expr;
	this->etype = exprType::location;
}

Location::Location(string var,string location_type){
	this->var = var;
	this->location_type = location_type;
	this->etype = exprType::location;
}

intLiteral::intLiteral(int value){
	this->value = value;
	this->ltype = literalType::Int;
}

boolLiteral::boolLiteral(string value){
	this->value = value;
	this->ltype = literalType::Bool;
}

BinExpr::BinExpr(class Expr* lhs,string opr,class Expr* rhs){
	this->lhs = lhs;
	this->rhs = rhs;
	this->opr = opr;
	this->etype = exprType::binary;
}

EnclExpr::EnclExpr(class Expr* expr){
	this->expr = expr;
	this->etype = exprType::enclExpr;
}

Assignment::Assignment(class Location* loc,class Expr* expr){
	this->loc = loc;
	this->expr = expr;	
}

Stmts::Stmts(){
	this->cnt = 0;
}

Prog::Prog(class Decls* decls,class Stmts* stmts){
	this->decls = decls;
	this->stmts = stmts;
}

/* Methods */

void Var::setDataType(string datatype){
	this->dataType = datatype;
}

class Var* Decl::getVar(){
	return var;
}

void Decls::push_back(class Decl* var){
	decl_list.push_back(var);
	cnt++;
}

void Stmts::push_back(class Stmt* stmt){
	stmts.push_back(stmt);
}

string BinExpr::toString(){
	return lhs->toString() + opr + rhs->toString();
}

string EnclExpr::toString(){
	return "(" + expr->toString() + ")";
}
string Location::toString(){
	if(location_type.compare("Number") == 0){
		return var;
	}
	else{
		return var+ "[" + expr->toString() + "]";
	}
}

int intLiteral::getValue(){
	return value;
}

string intLiteral::toString(){
	return to_string(value);
}

string boolLiteral::toString(){
	return value;
}

string Location::getVar(){
	return var;
}

bool Location::is_array(){
	return location_type.compare("Array") == 0;
}

class Expr* Location::getExpr(){
	return expr;
}

/* Traversals */

void Decls::traverse(){
	TBS;
	out << "<declarations count=\"" << cnt << "\">\n";
	tabs_needed++;
	for (int i = 0; i < decl_list.size(); i++){
		decl_list[i]->traverse();
	}
	tabs_needed--;
	TBS;
	out << "</declarations>\n";

}

void Decl::traverse(){
	var->traverse();
}

void Var::traverse(){
	TBS;
	out << declType << endl;
	TBS;
	out << "<declaration name=\"" << name << "\" type=\"" << dataType << "\" ";
	if(declType.compare("Array") == 0){
		out << "size=\"" << length << "\" ";
	}
	out << "/>\n";
}

void Stmts::traverse(){
	TBS;
	out << "<statements count=\"" << cnt << "\">\n";
	tabs_needed++;
	for(int i = 0; i < stmts.size(); i++){
		stmts[i]->traverse();
	}
	tabs_needed--;
	TBS;
	out << "</statements>\n";
}

void Assignment::traverse(){
	TBS;
	out << "<assignment>\n";
	tabs_needed++;
	TBS;
	out << "<LHS name =\"" << loc->getVar() << "\">\n";
	if(loc->is_array()){
		tabs_needed++;
		loc->getExpr()->traverse();
		tabs_needed--;
	}
	TBS;
	out << "</LHS>\n";
	TBS;
	out << "<RHS>\n";
	tabs_needed++;
	expr->traverse();
	tabs_needed--;
	TBS;
	out << "</RHS>\n";
	tabs_needed--;
	TBS;
	out << "</assignment>\n";
}

void Location::traverse(){
	TBS;
	out << "<identifier name=\"" << var << "\"";
	if(is_array()){
		out << ">\n";
		tabs_needed++;
		expr->traverse();
		tabs_needed--;
		TBS;
		out << "</identifier>\n";
	}
	else{
		out << " />\n";
	}
}

void intLiteral::traverse(){
	TBS;
	out << "<integer value=\"" << value << "\" />\n";
}

void boolLiteral::traverse(){
	TBS;
	out << "<boolean value=\"" << value << "\" />\n";
}

void EnclExpr::traverse(){
	TBS;
	out << "(";
	expr->traverse();
	out << ")\n";
}

void BinExpr::traverse(){
	TBS;
	out << "<binary_expression type=\"" << getOperation(opr) <<"\">\n";
	tabs_needed++;
	lhs->traverse();
	rhs->traverse();
	tabs_needed--;
	TBS;
	out << "</binary_expression>\n";
}

void Prog::traverse(){
	TBS;
	out << "<program>\n";
	tabs_needed++;
	decls->traverse();
	stmts->traverse();
	tabs_needed--;
	TBS;
	out << "</program>\n";
}