#include "alphaPoly.h"
#include <sstream>
#include <map>
#include <string>
#include <iostream>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <vector>
#include <ctype.h>

using namespace std;

static unsigned int ringSize = 0;
static map<string,int> theRing; 

void Ring::setRing(string ringList)
{
	size_t index;
	size_t lastIndex = 0;
	ringSize = 0;
	theRing.clear();

	// Remove all spaces
	index = ringList.find_first_of(" ");
	while(index != string::npos)
	{
		ringList.erase(index,1);
		index=ringList.find_first_of(" ",index);
	}

	index = ringList.find_first_of(",");
	while(index != string::npos)
	{
		ringSize++;
		theRing[ringList.substr(lastIndex, index-lastIndex)] = ringSize;
		lastIndex=index+1;
		index=ringList.find_first_of(",",lastIndex);
	}
	ringSize++;
	theRing[ringList.substr(lastIndex)] = ringSize;
}

int Ring::getTermPosition(string termName)
{
	return theRing[termName];
}

string Ring::getTermName(int position)
{
	for (map<string,int>::iterator it=theRing.begin(); it!=theRing.end(); ++it)
	{
		if( it->second == position )
			return it->first;
	}
	return "";
}

void Ring::printRing(void)
{
	cout<<"(";
	for(int i = 1; i <= ringSize; i++)
	{
		if( i!=1 )
			cout<<", ";
		cout<<Ring::getTermName(i);
	}
	cout<<")\n";
}



// Word Level if first char is upper case
bool Ring::isWordLevel(string termName)
{
	return (isupper(termName[0]));
}


bool Ring::isWordLevel(int position)
{
	return isWordLevel(getTermName(position));
}



// Start AlphaPoly functions
/* These are the static variables of AlphaPoly.
 * They are set when setting the minpoly
 * K = Size of field extension as in F(2^k) (i.e. word size )
 * NumChars = the size each AlphaPoly's "exp" (see header file "exp" def)
 * lastCharBuffer = number of unused bits in the last byte of "exp"
 * exponents = list of alphapoly terms X^K to X^(2K)
 *             "exp" for these only holds exponents for X^0 to X^(k-1)
 *			   i.e. if minpoly=X^4+X+1, then K=4 and 
 *                  exponent[0] would store "X+1" in exp
 *					exponent[1] would store "X^2+X" (because minpoly*X = X^5+X^2+X)
 */
static int K;
static int NumChars;
static int lastCharBuffer;
static AlphaPoly** exponents;



static void printExp(unsigned char* exp)
{
	stringstream ss;
	bool first = true;
	unsigned char* p = exp+NumChars-1;
	for(int i = NumChars-1; i >= 0; i--, p-- )
	{
		int j = 7;
		if( i == NumChars-1)
		{
			j-=lastCharBuffer;
		}
		for(; j >= 0; j--)
		{
			if( (*p) & (1 << j) )
			{
				int num = i*8+j;
				if( !first )
					ss<<"+";
				else
					first=false;
				if(num == 0)
				{
					ss<<"1";
				}
				else
				{
					ss<<"X";
					if(num!=1)
						ss<<"^"<<num;
				}
			
			}
		}
	}
	cout<<ss.str()<<"\n";
}



// Static helper functions

static string stringFromChar(unsigned char* exp)
{
	stringstream ss;
	bool first = true;
	unsigned char* p = exp+NumChars-1;
	for(int i = NumChars-1; i >= 0; i--, p-- )
	{
		int j = 7;
		if( i == NumChars-1)
		{
			j-=lastCharBuffer;
		}
		for(; j >= 0; j--)
		{
			if( (*p) & (1 << j) )
			{
				int num = i*8+j;
				if( !first )
					ss<<"+";
				else
					first=false;
				if(num == 0)
				{
					ss<<"1";
				}
				else
				{
					ss<<"X";
					if(num!=1)
						ss<<"^"<<num;
				}
			
			}
		}
	}
	return ss.str();

}


static void shift(unsigned char* first, int shift)
{
	while( shift >= 8 )
	{
		for(int i = NumChars-1; i >= 0; i--)
		{
			if( i==0 )
				first[i] = 0;
			else
				first[i] = first[i-1];
		}
		shift -= 8;
	}
	
	if( shift <= 0 )
		return;

	// At this point, shift between 1 and 7 (inclusive)
	for(int i = NumChars-1; i >= 0; i--)
	{
		first[i] = first[i]<<shift;
		if( i != 0 )
		{
			// i=1, shift=1, NumChars=2, lastCharBuffer=7
			for(int j = 0; j < shift; j++)
			{
				if( first[i-1] & 1 << (7-j) )
				{
					first[i] |= 1<<shift-1-j;
				}
				else
				{
					first[i] &= ~(1<<shift-1-j);
				}
			}
		}
		if( i==NumChars-1 )
		{
			// Hack to zero out leading bits
			// ex: if lastCharBuffer=1 then &= 0111 1111
			//     if lastCharBuffer=2 then &= 0011 1111
			first[i] &= ~(((1<<lastCharBuffer)-1)<<(8-lastCharBuffer));
		}
	}
}


// Left shift across multiple chars
// 0000 0011, 0010 0001 shifted by 3 is
// 0001 1001, 0000 1000 
static void shift2(unsigned char* first, int shift, int nChars)
{
	while( shift >= 8 )
	{
		for(int i = nChars-1; i >= 0; i--)
		{
			if( i==0 )
				first[i] = 0;
			else
				first[i] = first[i-1];
		}
		shift -= 8;
	}
	
	if( shift <= 0 )
		return;

	// At this point, shift between 1 and 7 (inclusive)
	for(int i = nChars-1; i >= 0; i--)
	{
		first[i] = first[i]<<shift;
		if( i != 0 )
		{
            // Set leading (shift) bits of first[i-1] to be last bits of first[i]
            // ex: if first[i-1] = 1011 0000 and shift=3
            //     then "first[i] |= 0000 0101"
            // First, "(1<<shift)-1" creates 0000 0111
            // Then, "<<(8-shift)" creates 1110 0000
            // Then  1110 0000 & first[i-1] creates 1010 0000
            // Then >>(8-shift) creates 0000 0101
            first[i] |= (( ((1<<shift)-1) << (8-shift)) & first[i-1]) >> (8-shift);
            /*
			// i=1, shift=1, nChars=2, lastCharBuffer=7
			for(int j = 0; j < shift; j++)
			{
				if( first[i-1] & 1 << (7-j) )
				{
					first[i] |= 1<<(shift-1-j);
				}
				else
				{
					first[i] &= ~(1<<(shift-1-j));
				}
			}*/
		}
/*		if( i==nChars-1 )
		{
			// Hack to zero out leading bits
			// ex: if lastCharBuffer=1 then &= 0111 1111
			//     if lastCharBuffer=2 then &= 0011 1111
			first[i] &= ~(((1<<lastCharBuffer)-1)<<(8-lastCharBuffer));
		}*/
	}
}




// Modifies first
static void addExp(unsigned char* first, unsigned char* second)
{
	for(int i = 0; i < NumChars; i++, first++, second++)
	{
		*first ^= *second;
	}
}

// Modifies first
static void addExp2(unsigned char* first, unsigned char* second, int nChars)
{
	for(int i = 0; i < nChars; i++, first++, second++)
	{
		*first ^= *second;
	}
}


// Modifies first
static void multExpOld(unsigned char* first, unsigned char* second)
{
    //cpy first to temp
	unsigned char temp[NumChars];
	memcpy(temp,first,NumChars);

    //set first to 0
	memset(first,0,NumChars);

    //int shift = 0
	int shifted = 0;

    //vector expon = {}
	std::vector<int> expon;


    //for every bit 0 to end in second
	for(int i=0; i<NumChars; i++)
	{
		for(int j=0; j<8; j++)
		{
			if( i==NumChars-1 && j==8-lastCharBuffer )
				break;

		    //check if one
			if( second[i] & 1<<j )
			{
		        //add temp to first
				addExp(first,temp);
				
		        //for all elements in expon as el
				const int exponSize = expon.size();
				for(int k = 0; k < exponSize; k++)
				{
		            //add Exponent[shift-el] to first
					addExp(first,exponents[shifted-expon[k]]->getInternal());
				}
			}
		    
			//shift++
			shifted++;

		    //if last bit of temp is 1
			if( temp[NumChars-1] & 1<<(7-lastCharBuffer) )
			{
		        // add shift to expon
				expon.push_back(shifted);
			}

		    // shift temp
			shift(temp, 1);
		}
	}
}



static void multExp(unsigned char* first, unsigned char* second)
{
    /*
    unsigned char first2[NumChars];
    memcpy(first2,first,NumChars);
    multExpOLD(first2,second);
    */
    int nChars = NumChars*2;
    unsigned char temp[nChars];
    memset(temp,0,nChars);
    memcpy(temp,first,NumChars);

    unsigned char answer[nChars];
    memset(answer,0,nChars);

/*
    cout<<"Mult ";
    printExp(first,NumChars);
    cout<<"by ";
    printExp(second,NumChars);
    cout<<endl;*/

    //for every bit 0 to end in second
    int shiftNum=0;
    int i=0;
    int j=0;
	for(i=0; i<NumChars; i++)
	{
		for(j=0; j<8; j++)
		{
//			if( i==NumChars-1 && j==8-lastCharBuffer )
//                break;

            if( second[i] & 1<<j )
		    {
                if(shiftNum != 0)
                    shift2(temp,shiftNum,nChars);

                /*cout<<"i="<<i<<" and j="<<j<<endl;
                cout<<"Adding ";
                printExp(temp,nChars);
                cout<<endl;*/

                addExp2(answer,temp,nChars);
                shiftNum=0;
            }
            shiftNum++;
        }
    }
    
    memcpy(first,answer,NumChars);
    // Hack to zero out leading bits
	// ex: if lastCharBuffer=1 then &= 0111 1111
	//     if lastCharBuffer=2 then &= 0011 1111
	first[NumChars-1] &= ~(((1<<lastCharBuffer)-1)<<(8-lastCharBuffer));
    
//    cout<<"OUT. i="<<i<<" j="<<j<<endl;
    int expInd=0;
    i=NumChars-1;
    j=8-lastCharBuffer;
    for(; i<nChars; i++)
    {
        for(; j<8; j++)
        {
            if( answer[i] & 1<<j )
                addExp(first,exponents[expInd]->getInternal());
            expInd++;
        }
        j=0;
    }

    /*
    if(memcmp(first, first2, NumChars) != 0 )
    {
        cout<<"SOMETHIN BORKED"<<endl;
        cout<<"GOOD: ";
        printExp(first2,NumChars);
        cout<<endl<<"BAD: ";
        printExp(first,NumChars);
        cout<<endl;
        exit(0);
    }*/
}


// inputs:  numerator and divisor (remain unchanged)
// outputs: quotient and remainder
static void tryDiv(unsigned char* numerator, unsigned char* divisor,
				   unsigned char* quotient,  unsigned char* remainder)
{
	unsigned char tmpQuotient[NumChars];
	memset(quotient,          0, NumChars);
	memset(tmpQuotient,       0, NumChars);
	memcpy(remainder, numerator, NumChars);

	//cout<<endl<<"DOING DIV: ("<<stringFromChar(numerator)<<")/("<<stringFromChar(divisor)<<")"<<endl;
	do
	{
		int remainBitOffset = -1;
		int divisBitOffset  = -1;

		// Find offset of first '1' in remainder and divisor char arrays
		for(int i = NumChars-1; i >= 0; i-- )
		{
			int j = 7;
			if( i == NumChars-1)
			{
				j-=lastCharBuffer;
			}
			for( ; j>=0; j--)
			{
				if( remainBitOffset == -1 && (remainder[i] & 1<<j))
				{
					remainBitOffset = (i*8) + j;
				}
				if( divisBitOffset == -1 && (divisor[i] & 1<<j))
				{
					divisBitOffset = (i*8) + j;
				}
				if( remainBitOffset >= 0 && divisBitOffset >= 0 )
				{
					break;
				}
			}
			if( remainBitOffset >= 0 && divisBitOffset >= 0 )
			{
				break;
			}
		}

				
		/*cout<<"Remainder: "<<stringFromChar(remainder)
			<<"\nDivisor: "<<stringFromChar(divisor)
			<<"\nremainBitOffset: "<<remainBitOffset
			<<"\ndivisBitOffset: "<<divisBitOffset<<"\n";
		*/
		

		if( divisBitOffset == -1 )
		{
			cout<<"ERROR: CANNOT DIVIDE BY ZERO\n";
			exit(1);
		}

		// If can't divide anymore, break out
		if( divisBitOffset > remainBitOffset )
			break;
		
		int difference = remainBitOffset - divisBitOffset;
		/*
		int offset = difference/8;
		memset(tmpQuotient, 0, NumChars);
		tmpQuotient[offset] |= 1 << difference - (offset*8);
		cout<<"TmpQuotientFirst: "<<stringFromChar(tmpQuotient)<<"\n";
		quotient[offset]    |= 1 << difference - (offset*8);
		multExp(tmpQuotient, divisor);
		*/
		int offset = difference/8;
		//cout<<"difference="<<difference<<" and offset="<<offset<<endl;
		memcpy(tmpQuotient, divisor, NumChars);
		//cout<<"TmpQuotientBefore: "<<stringFromChar(tmpQuotient)<<"\n";
		shift(tmpQuotient, difference);
		//cout<<"TmpQuotientAfter: "<<stringFromChar(tmpQuotient)<<"\n";
		quotient[offset]    |= 1 << difference - (offset*8);
		//cout<<"Quotient now: "<<stringFromChar(quotient)<<endl;

		addExp(remainder, tmpQuotient);
		//cout<<"TmpQuotientSecond: "<<stringFromChar(tmpQuotient)<<"\n";
		//cout<<"New Remainder: "<<stringFromChar(remainder)<<"\n";
	}while( true );
	//cout<<"DIV DONE: ("<<stringFromChar(quotient)<<") R("<<stringFromChar(remainder)<<")"<<endl<<endl;
}



static void printSavedExponents(bool debug)
{		
cout<<"K="<<K<<"\nNumChars="<<NumChars<<"\nlastCharBuffer="<<lastCharBuffer<<"\n";
	for(int i = 0; i <= K; i++)
	{
		if( debug )
		{
			for(int j = 0; j < NumChars; j++ )
			{
				printf("0x%02x\n",exponents[i]->getInternal()[j]);
			}
		}
		cout<<exponents[i]->toString();
		cout<<"\n";
	}
}



void AlphaPoly::removeChars(string* poly, string chars)
{
	int index = poly->find_first_of(chars);
	while(index != string::npos)
	{
		poly->erase(index,1);
		index=poly->find_first_of(chars,index);
	}	
}


void AlphaPoly::tryTheDiv(AlphaPoly* divisor)
{
	unsigned char quotient[NumChars];
	unsigned char remainder[NumChars];
	memset(quotient,  0, NumChars);
	memset(remainder, 0, NumChars); 

	tryDiv(exp, divisor->getInternal(), quotient, remainder);
	cout<<stringFromChar(exp)<<"\nDivided by\n"
		<<stringFromChar(divisor->getInternal())<<"\nQuotient is "
		<<stringFromChar(quotient)<<"\nRemainder is "
		<<stringFromChar(remainder)<<"\n";
}


static bool inverseFinished(unsigned char* check)
{
	for(int i = 0; i < NumChars; i++ )
	{
		if( i == 0 )
		{
			if(  check[i] > 1 )
				return false;
		}
		else
		{
			if( check[i] > 0 )
				return false;
		}
		
	}
	return true;
}



bool AlphaPoly::equals(AlphaPoly* other)
{
	return memcmp(exp,other->getInternal(), K) == 0;
}


/* Perform Euclids Algorithm to find inverse over the minpoly
 * To test an example, go to http://en.wikipedia.org/wiki/Extended_Euclidean_algorithm
 * Set minpoly to X^8+X^4+X^3+X+1, create AlphaPoly X^6+X^4+X+1,
 * uncomment all couts in getInverse, call it
 * and follow along with the example in the wiki page
 */
AlphaPoly* AlphaPoly::getInverse(void)
{
	AlphaPoly* theInverse;

	// Temporarily increase K in order to store full minpoly
	// Very important to set all this back once we're done
	int prevNumChars = NumChars;
	int prevLastCharBuffer = lastCharBuffer;
	K++;
	NumChars = ((K-1)/8)+1; // K=1<->8, NumChars = 1. K=9<->16, NumChars = 2. etc.
	lastCharBuffer = (NumChars*8)-K;

	unsigned char prevRemainder[NumChars];
	unsigned char remainder[NumChars];
	unsigned char nextRemainder[NumChars];
	unsigned char prevAux[NumChars];
	unsigned char aux[NumChars];
	unsigned char nextAux[NumChars];

	memset(prevRemainder, 0,NumChars);
	memset(remainder,     0,NumChars);
	memset(nextRemainder, 0,NumChars);
	memset(prevAux,       0,NumChars);
	memset(aux,           0,NumChars);
	memset(nextAux,       0,NumChars);

	memcpy(prevRemainder,exponents[0]->getInternal(),prevNumChars);
	memcpy(remainder, exp, prevNumChars);
	prevRemainder[NumChars-1] |= 1 << (7-lastCharBuffer);
	aux[0] = 1;

	while( !inverseFinished(remainder) )
	{
		//cout<<"prevRemainder: "<<stringFromChar(prevRemainder)<<endl;
		//cout<<"remainder: "<<stringFromChar(remainder)<<endl;
		//cout<<"prevAux: "<<stringFromChar(prevAux)<<endl;
		//cout<<"aux: "<<stringFromChar(aux)<<endl<<endl;

		tryDiv(prevRemainder, remainder, nextAux, nextRemainder);
		multExp(nextAux,aux);
		addExp(nextAux,prevAux);
		
		memcpy(prevAux, aux,     NumChars);
		memcpy(aux,     nextAux, NumChars);		
		memset(nextAux, 0,       NumChars);
		
		memcpy(prevRemainder, remainder,     NumChars);
		memcpy(remainder,     nextRemainder, NumChars);
		memset(nextRemainder, 0,             NumChars);
	}
	

	K--;
	NumChars = prevNumChars;
	lastCharBuffer = prevLastCharBuffer;

	//cout<<"Inverse of ("<<stringFromChar(exp)<<") is ("<<stringFromChar(aux)<<")"<<endl;
	
	theInverse = new AlphaPoly();
	memcpy(theInverse->getInternal(),aux,NumChars);
	return theInverse;
}

// Constructors

AlphaPoly::AlphaPoly(void)
{
	exp = new unsigned char[NumChars];
	memset(exp,0,NumChars);
}


// Create from poly string
AlphaPoly::AlphaPoly(string poly)
{
	exp = new unsigned char[NumChars];
	memset(exp,0,NumChars);	

	removeChars(&poly," ^");
	
	int previous = -1;
	int index    = -1;	
	do
	{
		
		index = poly.find_first_of("+",index+1);
		int fixed = (index == string::npos)? poly.length() : index;

		// Special Case
		if( fixed - (previous+2) == 0 )
		{
			if( poly[fixed-1] == 'X' )
			{
				exp[0] |= 1 << 1;
			}
			else if( poly[fixed-1] == '1' )
			{
				exp[0] |= 1 << 0;
			}
			else
			{
				cout<<"ERROR PARSING POLY: '"<<poly<<"'\n";
				cout<<"Got '"<<poly[fixed-1]<<"'\n";
				exit(1);
			}
		}
		else
		{
			int num = atoi(poly.substr(previous+2,fixed-(previous+2)).c_str());
			int offset = num/8;
			exp[offset] |= 1 << (num-(offset*8));
		}
		previous = index;
	}while( index != string::npos );
}



// Create from exponent 
AlphaPoly::AlphaPoly(unsigned long expon)
{
	exp = new unsigned char[NumChars];
	memset(exp,0,NumChars);
	if( expon < K )
	{
		int offset = expon/8;
		exp[offset] |= 1 << (expon-(offset*8));
	}
	else if(expon <= 2*K)
	{
		memcpy(exp, exponents[expon-K]->getInternal(), NumChars);
	}
	else
	{
		// Need exponent >2K
		// Start at 2K
		// Keep multiplying by at most 2K
		memcpy(exp, exponents[K]->getInternal(), NumChars);
		unsigned long i = 2*K;
		while( i != expon )
		{
			unsigned long multBy = expon-i > 2*K? 2*K : expon-i;
			if( multBy < K )
			{
				unsigned char multPoly[NumChars];
				memset(multPoly,0,NumChars);
				int offset = multBy/8;
				multPoly[offset] |= 1 << (multBy-(offset*8));
				multExp(exp,multPoly);
			}
			else
			{
				mult(exponents[multBy-K]);
			}
			i += multBy;
		}
	}
}

// Create poly object by multiplying or adding two different polys	
AlphaPoly::AlphaPoly(AlphaPoly* one, AlphaPoly* two, bool doMult)
{
	exp = new unsigned char[NumChars];
	memcpy(exp,one->getInternal(),NumChars);
	if( doMult )
	{
		mult(two);
	}
	else
	{
		add(two);
	}
}

// Create an exact duplicate
AlphaPoly::AlphaPoly(AlphaPoly* copy)
{
	exp = new unsigned char[NumChars];
	memcpy(exp,copy->getInternal(),NumChars);	
}

string AlphaPoly::toString(void)
{
	return stringFromChar(exp);
}



bool AlphaPoly::isZero(void)
{
	for(int i=0; i<NumChars; i++)
	{
		if( exp[i] != 0 )
			return false;
	}
	return true;
}



bool AlphaPoly::isOne(void)
{
	for(int i=0; i<NumChars; i++)
	{
		if( i==0 )
		{
			if( exp[i] != 1 )
				return false;
		}
		else
		{
			if( exp[i] != 0 )
				return false;
		}
	}
	return true;
}



int AlphaPoly::getK(void)
{
	return K;
}



void AlphaPoly::setMinpoly(string poly)
{
	int previous = 0;

	// Remove spaces and ^
	// EX: X^4 + X^2 + X + 1 becomes X4+X2+X+1
	removeChars(&poly," ^");	
	
	int index = poly.find_first_of("+");
	K = atoi(poly.substr(1,index).c_str());
	NumChars = ((K-1)/8)+1; // K=1<->8, NumChars = 1. K=9<->16, NumChars = 2. etc.

	lastCharBuffer = (NumChars*8)-K;
	exponents = new AlphaPoly*[K+1];

	exponents[0] = new AlphaPoly(poly.substr(index+1,poly.length()-index-1));
	AlphaPoly* XMult = new AlphaPoly(1);

	//Fill in K+1 to 2K exponents
	for(int i = 1; i <= K; i++ )
	{
		exponents[i] = new AlphaPoly(exponents[i-1],XMult,true);
	}

	delete XMult;

	//printSavedExponents(false);
}



AlphaPoly::~AlphaPoly()
{
	//printf("DELETING POLY 0x%08x\n",exp);
	delete []exp;
}



unsigned char* AlphaPoly::getInternal(void)
{
	return exp;
}



void AlphaPoly::add(AlphaPoly* other)
{
	addExp(exp, other->getInternal());
}



void AlphaPoly::mult(AlphaPoly* other)
{
	multExp(exp,other->getInternal());
}

