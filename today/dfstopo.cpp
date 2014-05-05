#include <cstdio>
#include <iostream>
#include <fstream>
#include <algorithm>
#include <vector>
#include <queue>
#define MAX 501
using namespace std;

int INDEG[MAX], node, edge;

vector<int> TOPOLOGICAL_SORT(int [][MAX]);

int main(int argc, char *argv[])
{
    int i;
	ifstream fin(argv[1]);
    int adjMatrix[MAX][MAX];
    for(i=0; i<MAX; i++)
        for(int j=0; j<MAX; j++) {
            adjMatrix[i][j] = 0;
            INDEG[i] = 0;
        }
    int M, N;
    fin >> node >> edge;
    for(int e=1; e<=edge; e++) {
        fin >> M >> N;
        adjMatrix[M][N] = 1;
        INDEG[N]++;
    }
    vector<int> orderedList = TOPOLOGICAL_SORT(adjMatrix);
	char vname[MAX][20];
	for(i=0; i<node;i++){
		fin>>vname[i];
	}
    for(i=0; i<orderedList.size(); i++) {
        cout << vname[orderedList[i]-1] << ",";
    }
	cout<<endl;
    return 0;
}

vector<int> TOPOLOGICAL_SORT(int S[][MAX]) {

    queue<int> Q;

    for(int n=1; n<=node; n++) {
        if(INDEG[n] == 0) Q.push(n);
    }

    vector<int> topoList;

    while( !Q.empty()) {
        int N = Q.front(); Q.pop();
        topoList.push_back(N);
        for(int M=1; M<=node; M++) {
            if(S[N][M] == 1) {
                INDEG[M]--;
                if(INDEG[M] == 0) {
                    Q.push(M);
                }
            }
        }
    }
    return topoList;
}
