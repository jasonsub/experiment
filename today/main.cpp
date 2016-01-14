#include "alphaPoly.h"
#include<vector>
#include<list>
#include<string>
#include<sstream>
#include<map>
#include<set>
#include<fstream>
#include<algorithm>
#include<iostream>
using namespace std;

extern void cavmain(char *filename);
extern double diffms;
int main (int argc, char* argv[]) 
{
	if(argc!=2)
	{
		cout<<"Usage: "<<argv[0]<<" input.alg"<<endl;
		return 1;
	}

	clock_t t;
	t= clock();

	cavmain(argv[1]);

	t = clock() - t;
	
	/*AlphaPoly::setMinpoly("X^8+X^4+X^3+X+1");
	AlphaPoly one = AlphaPoly("X^6+X^4+X+1");

	one.getInverse();*/
	
	cout<<"Total reduction time is: "<<((t*1000)/CLOCKS_PER_SEC)<<" ms."<<endl;

	return 0;
}

