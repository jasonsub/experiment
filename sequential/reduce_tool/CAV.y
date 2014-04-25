/***************************************************************************

  FileName    [OGBC.y]

  PackageName [MVD: Multi-Variable Division]

  Synopsis    [Syntax analyzer for EQN format.]

  Author      [Jinpeng Lv]
******************************************************************************/
%{
#include "alphaPoly.h"
#include<cstdio>
#include<cstdlib>
#include<iostream>
#include<sstream>
#include<map>
#include<list>
#include<set>
#include<vector>
#include<string>
#include<cstring>
#include<fstream>
#include<cassert>
#include<algorithm>
#include<ctime>
using namespace std;

/*************Definition of Flex&Bison**********/
extern int cavlineno;
extern FILE *cavin;
extern FILE *cavout;
int caverror(const char *s);
extern int cavlex();

double diffms(0.0);
static clock_t end;
static clock_t begin;
/**********************************************/
/**********************************************/
typedef struct monomial_
{
	set<unsigned int> monList;
	AlphaPoly* coef;
} monomial;
static monomial tempmon;

static list<monomial> glopoly;
static list<monomial> specpoly;

static vector< list<monomial> > ideal;

static unsigned long int lastExp;

static map<string, unsigned int> VID;   // mapping:  variable -> ID
static map<unsigned int,string> DIV;   // mapping:  ID --> variable  
static unsigned int ind=2;				//ID index. "0" is not supposed to occur in any monomial.

static map<string, unsigned int>::iterator mapit;

static string minpolyString = "";
static string tmpMinpoly = "";

static void HandleMiter(string out1, string out2);

static void HandleMinpoly(string& str, char* var, unsigned long int exp);

static void HandlePoly(list<monomial>& tempoly);

static int CompareSet(set<unsigned int> &set1,set<unsigned int> &set2);

/*sorting monomials when inserting into polynomial*/
static void insertmon(monomial & tempmon, bool delCoef);
/*merge sort of two sorted polys*/
void mergesort(list<monomial>& specpoly,list<monomial>& tempoly);
/*insertion order, insert tempmon into poly*/
static void insertmon2poly(list<monomial>& poly, monomial & mon);
/* copies monList and coef in "from" over to "to". "from" remains unchanged.*/
static void copyMonomial(monomial* to, monomial& from);
/* multiplies "original" by "mult" and stores in "original". "mult remains unchanged */
static void multiplyMonomial(monomial* original, monomial& mult);


/***  kernel function***/
/*multivariate polynomial reduction*/
static void reduce(list<monomial> & specpoly,vector< list<monomial> > &ideal );
static void HandleVar(char * var);

static void clear();

/**********aux functions*******/
static void printmap();
static void printmonomial(monomial & toprint);
static void printpoly(list<monomial> &toprint);
static void printideal(vector< list<monomial> > &toprint);

static int digione; //the corresponding index of number 1.

%}

/* variable returned by lex */
%union
{
  char* id;
  unsigned long int exp;
  bool parentheses;
};

/* definition of token */

%token <id> VARIABLE
%token <exp> EXP
//%token <parentheses> PARENTHESES

%left '+' 
%left '*' 
%left '^' 


%type <id> poly polys var gmonomial minvar groupStart group
%type <exp> exponent
//%type <parentheses> paren

%%
statements:statement	{reduce(specpoly,ideal);clear();}
	| statements statement {reduce(specpoly,ideal);clear();}
	;
statement:
	vardelc ';' minpoly ';' specPoly ';' polys ';'
	;
	
vardelc: var {VID[$1]=ind;DIV[ind]=$1;if(strcmp($1,"1")==0) digione=ind;++ind;  free($1);}
	| vardelc ',' var  {VID[$3]=ind;DIV[ind]=$3;if(strcmp($3,"1")==0) digione=ind;++ind;  free($3);}
	;

minpoly: minvar {AlphaPoly::setMinpoly(minpolyString); tempmon.coef = new AlphaPoly((long unsigned int)0);}
	;

minvar: var			   {HandleMinpoly(minpolyString,$1,lastExp); free($1);}
	|	minvar '+' var {minpolyString += "+"; HandleMinpoly(minpolyString,$3,lastExp); free($3);}
	;

specPoly:  poly {specpoly=glopoly;glopoly.clear();}
	;
	

miterpoly:  var '+' var {HandleMiter($1,$3);free($1);free($3);}
	;
	
polys:poly					{HandlePoly(glopoly);glopoly.clear();}
	| polys ',' poly		{HandlePoly(glopoly);glopoly.clear();}
	 ;
	 
poly:	gmonomial		{insertmon(tempmon, true);tempmon.monList.clear();tempmon.coef = new AlphaPoly((unsigned long int)0);}//left var of equation
	|	poly '+' gmonomial   {insertmon(tempmon, true);tempmon.monList.clear();tempmon.coef = new AlphaPoly((unsigned long int)0);}
//	|   paren poly paren {cout<<"Got open and close around ";printpoly(glopoly);cout<<endl;exit(0);}
	;	
	
gmonomial: var 						{HandleVar($1);free($1);}
	|   group '*' var				{HandleVar($3);free($3);}
	|	gmonomial '*' var			{HandleVar($3);free($3);}
	;

group: groupStart ')' {AlphaPoly tmp = AlphaPoly(tmpMinpoly); tempmon.coef->mult(&tmp); }
	;

groupStart: '(' var 	 { tmpMinpoly=""; HandleMinpoly(tmpMinpoly, $2, lastExp); free($2);}
	| groupStart '+' var { tmpMinpoly+="+";HandleMinpoly(tmpMinpoly,$3,lastExp); free($3);}
	;
	

var: VARIABLE 
	{
		$$ =strdup($1); lastExp=1;
	}
	| var exponent {$$ =strdup($1); lastExp=$2;}
	;

exponent: EXP {;};

//paren: PARENTHESES { $$? cout<<"parenthesis opened"<<endl : cout<<"parenthesis closed";};

%%

int caverror(const char *s)
{
cout<<"ERROR:line "<<cavlineno<<": "<<s<<"\n";
return 1;
}

void cavmain(char *filename)
{
	cavin=fopen(filename,"r");
	if(!cavin)
	{
		cout<<"Fail to locate file: "<<filename<<endl;
		return;
	}
	cavparse();
	fclose(cavin);
	//printideal(ideal);
	//cout<<"Total verification time is: "<<diffms<<" ms."<<endl;
	//cout<<"specpoly:"<<endl;
	//printpoly(specpoly);
	//cout<<"ideal:"<<endl;
	//printideal(ideal);
	
	//cout<<"reduction:"<<endl;
	
	
	//reduce(specpoly,ideal);
	
}

void HandleVar(char * var)
{
	if( strcmp(var,"X") == 0 )
	{
		AlphaPoly tmp(lastExp);
		tempmon.coef->mult(&tmp);
		return;
	}

	if( strcmp(var,"1") == 0 )
	{
		// tempmon.coef already contains one
		return;
	}

	if(VID.find(var)!=VID.end()) 
		tempmon.monList.insert(VID[var]);
	else
	{
		cout<<var<<" undefined\n";
		exit(1);
	}
}


void HandleMinpoly(string& str, char* var, unsigned long int exp)
{
	stringstream ss;
	if( exp == 0 )
	{
		cout<<"Invalid minpoly exponent 0"<<endl;
		exit(1);
	}

	if( strcmp(var,"X") == 0 )
	{
		str += "X";
		if(exp!=1)
		{
			ss<<exp;
			str+="^"+ss.str();
		}
	}
	else 
	{
		if( strcmp(var,"1") == 0 )
		{
			str += "1";
		}
		else
		{
			cout<<"Invalid minpoly variable "<<var<<endl;
			exit(1);
		}
	}
}


// Ideal does not have to be in ring order
// But the program will parse a bit faster if it is
void HandlePoly(list<monomial>& tempoly)
{
	//cout<<"Adding: ";
	//printpoly(tempoly);
	int ret;
	vector<list<monomial> >::iterator it;
	if( ideal.size() == 0 )
	{
		ideal.push_back(tempoly);
		return;
	}

	it = ideal.end();
	do
	{
		it--;
		ret = CompareSet(it->front().monList,tempoly.front().monList);
		//cout<<"ret"<<endl;
		if( ret < 0 )
		{
			if( it+1 == ideal.end() )
				ideal.push_back(tempoly);
			else
				ideal.insert(it+1,tempoly);
			return;
		}
		//cout<<"After if1"<<endl;
		if( ret == 0 )
		{
			/*cout<<"WARNING:"<<endl;
			printpoly(*it);
			printpoly(tempoly);
			cout<<"Contain the same monomials!"<<endl;*/
			if( it+1 == ideal.end() )
				ideal.push_back(tempoly);
			else
				ideal.insert(it+1,tempoly);
			return;
		}
		//cout<<"After if2"<<endl;
	}
	while(it != ideal.begin());
	//cout<<"Outside"<<endl;
	ideal.insert(it,tempoly);
}

void HandleMiter(string out1,  string out2)
{
	// tempmon will already have a valid coef of exp 0 by this point

	tempmon.monList.insert(VID[out1]);
	specpoly.push_back(tempmon);
	tempmon.monList.clear();
	tempmon.monList.insert(VID[out2]);
	tempmon.coef = new AlphaPoly((long unsigned int)0);
	specpoly.push_back(tempmon);
	tempmon.monList.clear();
	tempmon.coef = new AlphaPoly((long unsigned int)0);
}

//1 if set1> set2, example: <5,2,3> > <2,3,4>
//0 if set1=set2
//-1 if set1<set2
int CompareSet(set<unsigned int> &set1,set<unsigned int> &set2)
{
	set<unsigned int>::iterator it1;
	set<unsigned int>::iterator it2;
	
	for(it1=set1.begin(),it2=set2.begin();((it1!=set1.end()) && (it2!=set2.end()));++it1,++it2)
	if((*it1)>(*it2)) return 1;
	else if((*it1)<(*it2)) return -1;
	
	if(set1.size()>set2.size())
	return -1;
	else if(set1.size()<set2.size())
	return 1;
	else return 0;
}


/*sorting monomials when inserting into polynomial*/
// delCoef == true deletes tempmon.coef if not used by glopoly
void insertmon(monomial & tempmon, bool delCoef)
{
	if(tempmon.monList.size() == 0)
	{
		glopoly.push_back(tempmon);
		return;
	}
	set<unsigned int>::iterator monit=tempmon.monList.end();
		--monit;
//	if ( (*monit==digione) && (tempmon.monList.size()>1) )//handle the case: a*b*1
//		tempmon.monList.erase(monit);
	if(glopoly.size()==0 )
	{
		glopoly.push_back(tempmon);
	}
	else
	{
		//sorting first
		list<monomial>::iterator it; //about 5 times faster than reverse iterator.
		it=glopoly.end();
		int temp;
		--it;
	//cout<<"it=";printmonomial(*it);cout<<endl;
		while(it!=glopoly.begin())
		{
			temp=CompareSet(tempmon.monList,it->monList);//cout<<"compare result is: "<<temp<<endl;
			if( temp==1)//temp > it
			{
				glopoly.insert(++it,tempmon);
		//		cout<<"insert: ";printmonomial(tempmon);//cout<<" into: ";printpoly(glopoly);
				return;
			}
			else if(temp==-1)
			--it;
			else if (temp==0) //same, add or delete
			{
				it->coef->add(tempmon.coef);
				if( it->coef->isZero() )
				{
					delete it->coef;
					glopoly.erase(it);
				}
				if( delCoef )
					delete tempmon.coef;
		//		cout<<"insert: ";printmonomial(tempmon);cout<<" into: ";printpoly(glopoly);
				return;
			}
			
		}
	
		temp=CompareSet(tempmon.monList,it->monList);//cout<<"compare result is: "<<temp<<endl;
		if( temp==1)//temp > it
		{
			glopoly.insert(++it,tempmon);
		}
		else if(temp==-1)
			glopoly.push_front(tempmon);
		else if (temp==0) //same, add or delete
		{
			it->coef->add(tempmon.coef);
			if( it->coef->isZero() )
			{
				delete it->coef;
				glopoly.erase(it);
			}
			if( delCoef )
				delete tempmon.coef;
		}
	}
	//cout<<"insert: ";printmonomial(tempmon);cout<<" into: ";printpoly(glopoly);
}



/* copies monList and coef in "from" over to "to". "from" remains unchanged */
static void copyMonomial(monomial* to, monomial& from)
{
	to->monList = from.monList;
	to->coef = new AlphaPoly(from.coef);
}



/* multiplies "original" by "mult" and stores in "original". "mult remains unchanged 
 * Time critical function. Make sure it is optimized
 */
static void multiplyMonomial(monomial* original, monomial& mult)
{
	pair<set<unsigned int>::iterator, bool> ret;
	set<unsigned int>::iterator it;
	for( it = mult.monList.begin(); it != mult.monList.end(); it++ )
	{
		ret = original->monList.insert(*it);
		if( !(ret.second) ) // element already existed 
		{
			cout<<"Warning: Exponents not yet handled. Possible overlap detected for ";
			printmonomial(*original);
			cout<<" and ";
			printmonomial(mult);
			cout<<endl;
		}
	}

	if( !mult.coef->isOne() )
		original->coef->mult(mult.coef);
}



/* If div divides spec, creates result newmon (including new allocated AlphaPoly) and returns true
 * Otherwise returns false (no AlphaPoly allocated for newmon in this case)
 * Time critical function. Make sure it is optimized
 */
static bool tryMonDiv(monomial* newmon, monomial& spec, monomial& div )
{
	set<unsigned int>::iterator it1;
	set<unsigned int>::iterator it2;

	newmon->monList.clear();
	if( div.monList.size() > spec.monList.size() )
		return false;

	/*cout<<"Spec is ";
	printmonomial(spec);
	cout<<" and div is ";
	printmonomial(div);
	cout<<endl;*/
	
	for(it1=spec.monList.begin(),it2=div.monList.begin(); it1!=spec.monList.end() && it2!=div.monList.end(); it1++ )
	{
		if((*it1)>(*it2))
			return false;

		if((*it1)<(*it2))
			newmon->monList.insert(*it1);
		else
			it2++;
	}

	if( it2 != div.monList.end() )
		return false;

	while( it1!=spec.monList.end() )
	{
		newmon->monList.insert(*it1);
		it1++;
	}

	// If got here, monomials are divisible
    // Create AlphaPoly coefficient of spec/div = spec*inverse(div)
	if( div.coef->isOne() )
	{
		newmon->coef = new AlphaPoly(spec.coef);
	}
	else
	{
		if( div.coef->equals(spec.coef) )
		{
			newmon->coef = new AlphaPoly((unsigned long int) 0);
		}
		else
		{
			newmon->coef = div.coef->getInverse(); // Make sure this function is optimized!
			newmon->coef->mult(spec.coef);
		}
	}

	/*cout<<"Divided: ";
	printmonomial(*newmon);
	cout<<endl;*/

	return true;
}



/*
Purpose: r = specpoly / ideal 
specpoly is a given polynomial (or called specification polynomial)
ideal is a set of polynomials containing f1,f2,f3,...fn
------------------------------------------------------------
Basic procedure is:
1: get the leading monomials of specpoly, example: f=ab+ac+bc+d; lms(f)=ab+ac, not just "ab"!!! Differnt from traditional method.
2: get the leading monomial of f_i, because the property of circuit, leading monomial of f_i can only be single variable 
3: if the 1st variable of lms(f)== lm(f_i), then it implies divisiable. 
	Example: specpoly=ab+ac+bc+d, f1=a+c+d*e, 
			lms(specpoly)=ab+ac; lm(f1)=a; 1st var of lms(specpoy) is a==lm(f1), so dividable.
4: update specpoly: specpoly=specpoly-lms(specpoly)+(f_i-lm(f_i))*lms(specpoly)/lm(f_i)
5: go step 1 until all f_i are handled.
------------------------------------------------------------
The critical and most time-consuming step is Step 4, of which, there are 2 critical sub-steps:
1: (f_i-lm(f_i))*	lms(specpoly)/lm(f_i) 
2: addition between "specpoly-lms(specpoly)" and "(f_i-lm(f_i))*lms(specpoly)/lm(f1)"
The above step 1 takes about 90% running time and Step 2 only takes 10%.
So basically the problem now is how to efficiently compute polynomial multiplication?
Some attributes of these polynomials:
1) the two polynomials are sorted
2) In most time, one polynomial can be much longer the other one.
*/
//dd

double diffms1(0.0);
clock_t mbegin,mend;

double diffms2(0.0);
clock_t abegin,aend;

double diffms3(0.0);
clock_t fbegin,fend;

double diffms4(0.0);
clock_t t1begin,t1end;

double diffms5(0.0);
void reduce(list<monomial> & specpoly,vector< list<monomial> > &ideal )
{
  //mbegin = clock();

	int start = 0;
	monomial newMon;

	//tryMonDiv(&newMon, specpoly.front(), ideal[start].front());
	while(start<ideal.size() && specpoly.size() > 0 )
	{
		// If can be divided
		if( tryMonDiv(&newMon, specpoly.front(), ideal[start].front()) )
		{
		#ifdef DEBUG
			printpoly(specpoly);
			cout<<"IS DIVIDED BY"<<endl;
			printpoly(ideal[start]);
                #endif
			//cout<<"monom result ";
			//printmonomial(newMon);
			//cout<<endl;
		
			delete specpoly.front().coef;
			specpoly.pop_front();
			list<monomial>::iterator it;
			it = ideal[start].begin();
			it++; //skip lm(f). i.e now f-lm(f)
			// Multiply every monomial in (f-lm(f)) by newmon
			// Then, add it to the current specPoly
			for( it; it != ideal[start].end(); it++ )
			{
				monomial tmpMon;
			 	copyMonomial(&tmpMon, *it);
				multiplyMonomial(&tmpMon, newMon);
				insertmon2poly(specpoly,tmpMon);
			}
		#ifdef DEBUG
			cout<<"RESULT"<<endl;
			printpoly(specpoly);
			cout<<endl;
		#endif

			delete newMon.coef;
		}
		else
		{
		  /*#ifdef DEBUG
			printpoly(ideal[start]);
			cout<<"DOES NOT DIVIDE"<<endl;
			printpoly(specpoly);
			cout<<endl;
		  #endif*/
			start++;
		}
	}
	//printideal(ideal);

	//mend = std::clock();

	cout<<"FINAL RESULT: ";
	printpoly(specpoly);
	//cout<<"Reduce took "<<(mend-mbegin)/ (double)(CLOCKS_PER_SEC / 1000) << " ms"<<endl; 
}


/*insertion order, insert tempmon into poly
 * when inserting, from end to begin
 * tempmon no longer owns its coef after insert
 * */
void insertmon2poly(list<monomial>& tempoly, monomial & tempmon)
{
		//fbegin=clock();
		//sorting first

		// Lack of this constitutes a bug in Jinpeng's code!
		if( tempoly.size() == 0 )
		{
			tempoly.push_back(tempmon);
			return;
		}

		list<monomial>::iterator it; //about 5 times faster than reverse iterator.
		it=tempoly.end();
		int temp;
		--it;

		while(it!=tempoly.begin())
		{
			temp=CompareSet(tempmon.monList,it->monList);
			if( temp==1)//temp > it
			{
				tempoly.insert(++it,tempmon);
				//fend=clock();
				//diffms3+=((fend-fbegin)*1000);
				
				return;
			}
			else if(temp==-1)
			--it;
			else if (temp==0) //same, add then maybe delete
			{
				it->coef->add(tempmon.coef);
				if( it->coef->isZero() )
				{
					delete it->coef;
					tempoly.erase(it);
				}
				delete tempmon.coef;
				
				//fend=clock();
				//diffms3+=((fend-fbegin)*1000);
				
				return;
			}
			
		}
		temp=CompareSet(tempmon.monList,it->monList);
		if( temp==1)//temp > it
		{
			tempoly.insert(++it,tempmon);
		}
		else if(temp==-1)
			tempoly.push_front(tempmon);
		else if (temp==0) //same, delete
		{
			it->coef->add(tempmon.coef);
			if( it->coef->isZero() )
			{
				delete it->coef;
				tempoly.erase(it);
			}
			delete tempmon.coef;
		}
		//fend=clock();
		//diffms3+=((fend-fbegin)*1000);	
		
}

/*merge sort of two sorted polys*/
void mergesort(list<monomial>& specpoly, list<monomial>& tempoly)
{
		/*
		 * addition between "specpoly-lms(specpoly)" and "(f_i-lm(f_i))*lms(specpoly)/lm(f1)"
		 * "specpoly-lms(specpoly)" is stored in specpoly which has been sorted
		 * "(f_i-lm(f_i))*lms(specpoly)/lm(f1)" is stored in tempoly which has been sorted
		 * Implemented as a merge sort
		 */
		
		list<monomial>::iterator tempit;
		list<monomial>::iterator specit;
		list<monomial>::iterator pre_specit;
		int res;
		
		tempit=tempoly.begin();
		specit=specpoly.begin();
			
		while( (tempit!=tempoly.end()) || (specit!=specpoly.end()) )
		{/*since specpoly is usually much longer than tempoly, we choose a different version of merge sort. different from CLRS book.*/
			if( (tempit!=tempoly.end()) && (specit!=specpoly.end()) )
			{	
				res=CompareSet(tempit->monList, specit->monList);
				if( res==1)//temp > spec
				{
					//newspecpoly.push_back(*specit);
					//cout<<"temp>spec: ";printpoly(newspecpoly);
					++specit;
				}
				else if(res==-1) //temp < spec
				{
					specpoly.insert(specit,*tempit);
					//newspecpoly.push_back(*tempit);
					//cout<<"temp<spec: ";printpoly(newspecpoly);
					++tempit;
				}
				else if (res==0) //temp =spec, add or delete
				{
						//cout<<"temp=spec: ";printpoly(newspecpoly);
						specit->coef->add(tempit->coef);
						++tempit;
						if( specit->coef->isZero() )
						{
							pre_specit=specit;
							++specit;
						
							specpoly.erase(pre_specit);
						}
						//if( (tempit==tempoly.end()) && (specit==specpoly.end()))
						//{
							//specpoly.clear();
							//specpoly.insert(specpoly.end(),newspecpoly.begin(),newspecpoly.end());
						//	break;
						//}
					}
				}
				else if(tempit==tempoly.end())//most possible case
				{
					//specpoly.erase(specpoly.begin(),specit);
					//specpoly.insert(specit,newspecpoly.begin(),newspecpoly.end());
					break;
				}
				else if(specit==specpoly.end())//less possible
				{
					//specpoly.clear();
					//specpoly.insert(specpoly.end(),tempit,tempoly.end());
					specpoly.splice(specpoly.end(),tempoly,tempit,tempoly.end());
					//specpoly.insert(specpoly.end(),tempit,tempoly.end());
					break;
				}
				
			}
					
}

/*clear global variables*/
void clear()
{	//begin=clock();
	tempmon.monList.clear();
	glopoly.clear();
	specpoly.clear();
	ideal.clear();
	VID.clear();
	ind=2;		
//	end=clock();
	//double diffms2=((end-begin)*1000)/CLOCKS_PER_SEC;	
//	cout<<"clear takes "<<diffms2<<" ms"<<endl;
}
/********************************************/

void printmonomial(monomial & toprint)
{
	if(toprint.monList.size()==0)
	{
		cout<<toprint.coef->toString()<<endl;
		return;
	}

	if( !toprint.coef->isOne() )
		cout<<"("<<toprint.coef->toString()<<")*";

	set<unsigned int>::iterator it;
	set<unsigned int>::iterator endit;

	endit=--toprint.monList.end();
	for(it=toprint.monList.begin();it!=endit;++it)
	{
		cout<<DIV[*it]<<"*";
	}

	cout<<DIV[*it];
	
}

void printpoly(list<monomial> &toprint)
{
	if(toprint.size()==0)
	{
		cout<<"0"<<endl;
		return;
	}
	list<monomial>::iterator it;
	list<monomial>::iterator endit;
	endit=--toprint.end();
	for(it=toprint.begin();it!=endit;++it)
	{
		printmonomial(*it);
		cout<<"+";
	}
	printmonomial(*it);
	cout<<endl;
}

void printideal(vector< list<monomial> > &toprint)
{
	if(toprint.size()==0)
	{
		cout<<"0"<<endl;
		return;
	}	
	vector< list<monomial> >::iterator it;
	for(it=toprint.begin();it!=toprint.end();++it)
	{
		printpoly(*it);
		cout<<endl;
	}
}

void printmap()
{
	map<string, unsigned int>::iterator it;
	for(it=VID.begin();it!=VID.end();++it)
	cout<<it->first<<"-->"<<it->second<<endl;
}

