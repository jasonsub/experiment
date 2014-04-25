#pragma once

#include <string>
using namespace std;

/* NOTE!! setMinpoly must be called before any other AlphaPoly function.
 */
class AlphaPoly
{
	private:
		/*
		 * An AlphaPoly is a Galois Field element, such as "X^4+X+1", where X is alpha.
         * Each element is stored as a bit list of exponents "exp" in increasing order.
		 * So the first bit of the first byte of exp represents 1, the next bit represents X, etc.
         * For example, "X^4+X+1" would fit in 1 unsigned char as follows: exp[0] = 1'b00010011
         * Larger fields require more bytes, 
		 *  For instance, "X^10+X^6+X+1": exp[1] = 1'b00000100, exp[0] = 1'b01000011
         * exp does not store any exponents K or greater (where K is defined by the minpoly)
         * So for minpoly "X^4+X+1", the element "X^4+X^2" would be stored as "X^2+X+1"
         */
		unsigned char* exp;

	public:

        // MUST BE CALLED FIRST BEFORE ANY OTHER FUNCTION
		// poly is a minimum polynomial string.
		// Term must be X.
		// Highest term must be the first one (k)
		// ex: X^3 + X^2 + 1
		static void setMinpoly(string poly);

        // Returns the size of the field, k
        // ex: if minpoly was set to X^3 + X^2 + 1, returns 3
		static int getK(void);


		// Create alpha poly object from poly string (where X is alpha)
		// i.e. "X^4+X+1"
		AlphaPoly(string poly);

		// Create poly object from exponent
        // i.e AlphaPoly(4) -> "X^4"
		AlphaPoly(unsigned long expon);

		// Create poly object by multiplying or adding two different polys
        // doMult = true - > Multiply one and two
        // doMult = false -> Add one and two
        // one and two are not modified 
		AlphaPoly(AlphaPoly* one, AlphaPoly* two, bool doMult);

		// Create an exact duplicate of the given AlphaPoly
        // copy is not modified
		AlphaPoly(AlphaPoly* copy);

		// Create AlphaPoly element 0
		AlphaPoly(void);

		// Delete AlphaPoly
		~AlphaPoly(void);

		// Multiply this AlphaPoly by other
        // other is not modified
		void mult(AlphaPoly* other);

        // Add other to this AlphaPoly
        // other is not modified
		void add(AlphaPoly* other);

		// Returns exp of this AlphaPoly
        // Should really only be used by internal functions on other AlphaPoly instances
		unsigned char* getInternal(void);

		// Test function which tries to divide this AlphaPoly by divisor
        // Prints out the result to COUT
        // Nothing is actually changed
        // If you want to do a real division, create an inverse and multiply instead
		void tryTheDiv(AlphaPoly* divisor);

		// Creates a string representation of the AlphaPoly where X is alpha
        // ex: "X^4+X+1"
		string toString(void);

        // True if AlphaPoly == 0
        // Usually means this AlphaPoly should be deleted
		bool isZero(void);

        // True if AlphaPoly == 1
		bool isOne(void);

        // True if AlphaPoly is equivalent to other
		bool equals(AlphaPoly* other);

        // Uses Euclid's algorithm to generate an inverse of this AlphaPoly over the current minpoly
		// Allocates and returns a new AlphaPoly instance which must be later deleted.
		AlphaPoly* getInverse(void);

		// Helper function
        // Given the string poly, removes all instances of characters found in chars
        // ex: poly = "X^3 + X + 1", chars = " +",
        //     removeChars(&poly,chars)
        //     poly now "X^3X1"
		static void removeChars(string* poly, string chars);
};



// Some optional functions for basic lp ring implementation
// Was not tested much, verify it works as intended if you want to use it
// Also, the actual implementation could be better as some functions are O(X) time (see below).
// NOTE: Ring variables which start with a capital letter are assumed to be word-level
//       This doesn't actually do anything other than change return values of the isWordLevel function.
//       It was meant to help handle ring variables with exponents, which I never ended up working on.
//       I.e. since "A" is wordlevel, A^k=A. Since "a" is bit-level a^2=a.
class Ring
{
	private:
		Ring(){} // No constructor

	public:
		/* Ring operations
         */

		// Comma delimited string of terms in lp order (spaces ignored)
		static void setRing(string ringList);

		// Get position of the term in the ring. 0 means failure
		// First term is 1, second is 2 and so on
        // O(1) time
		static int getTermPosition(string termName);

		// Get string term name from ring position. Blank means failure
        // O(X) time
		static string getTermName(int position);

        // True if term at given position starts with a capital letter
        // O(X) time
		static bool isWordLevel(int position);
		
        // True if termName starts with a capital letter
        // O(1) time
		static bool isWordLevel(string termName);

        // Prints ring to COUT
        // Should probably return a string instead
		static void printRing(void);
};
