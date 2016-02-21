#include <iostream>
#include <algorithm>
#include <vector>
#include <fstream>
#include <string>
#include <sstream>

//For now only <9999 data recommended
#define MAX_LINE_LENGTH 15

using namespace std;

struct tuple {
    unsigned int idx;
    unsigned int dist;
    unsigned int freq;
};

struct compare {
    bool operator() (tuple const& s1, tuple const& s2) {
        if( s1.dist < s2.dist) return true;
        else if(s1.dist > s2.dist) return false;
        else {
            if( s1.freq > s2.freq ) return true;
            if( s1.freq < s2.freq ) return false;
            return ( s1.idx < s2.idx );
        }
    }
};

int main()
{
    ifstream dist;
    ifstream core;
    ofstream reorder;
    dist.open("tmp.dist");
    core.open("tmp.simp");
    reorder.open("reorder.dat");
    vector<unsigned int> c; // simplified core
    unsigned int tmp;
    while(core>>tmp)
        c.push_back(tmp);
    core.close();
    string s;
    vector<tuple> polys;
    // Read in every line with 3 unsigned int: idx, dist and freq
    while( getline(dist,s) ) {
        if( s.length() <=1 || s[0] == 'c' ) continue;
        istringstream iss(s);
        unsigned int c_idx;
        iss>>c_idx;
        // Check if idx is in simplified core, if so, add to pool
        if(find(c.begin(), c.end(), c_idx) != c.end()) {
            tuple newpoly;
            newpoly.idx = c_idx;
            iss>>newpoly.dist>>newpoly.freq;
            polys.push_back( newpoly );
        }
    }
    dist.close();
    // Sort according to heuristics
    sort(polys.begin(), polys.end(), compare());
    int sz = polys.size();
    cout<<"There are "<<sz<<" polys in the refined core!"<<endl;
    reorder<<"intvec rd = "<<polys[0].idx;
    for(int i = 1; i < sz; i++)
		reorder<<","<<polys[i].idx;
	reorder<<";"<<endl<<endl<<"ideal F = I[rd[1]]";
	for(int i = 1; i < sz; i++)
		reorder<<",I[rd["<<i+1<<"]]";
	reorder<<";"<<endl;
	reorder.close();
	
	return 0;
}