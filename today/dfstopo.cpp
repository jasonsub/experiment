#include <iostream>
#include <fstream>
#include <cstring>
#include <queue>
using namespace std;
const int maxn = 501;
int n, m;
int indegree[maxn], gragh[maxn][maxn], res[maxn];
string vname[maxn];

void topologic() {
	queue <int> q;
	int cnt = 0;
	for (int i = 0; i < n; i++) {
	cout<<indegree[i]<<endl;
		if (indegree[i] == 0){
			q.push(i);
}
}
	while (!q.empty()) {
		int tmp = q.front();
		q.pop();
		res[cnt++] = tmp;
		for (int i = 0; i < n; i++){
			if (gragh[tmp][i] != 0){
				if (--indegree[i] == 0)
					q.push(i);
}
}
	}//while
		cout<<cnt<<endl;
		for (int i = 0; i < n; i++)
//			cout<<vname[res[i]]<<",";
			cout<<res[i]<<",";
		cout<<endl;
}

int main(int argc, char *argv[]) {
		ifstream fin(argv[1]);
		int n,m;
		fin>>n>>m;
		for(int i=0;i<n;i++){
			for(int j=0;j<n;j++){
				gragh[i][j]=0;
}
}
		for(int i=0;i<n;i++){
			indegree[i]=0;
}
		int a, b;
		for (int i = 0; i < m; i++) {
			fin>>a>>b;
			gragh[a-1][b-1] = 1;
			indegree[b-1]++;
		}//for input
		
		for (int i=0;i<n;i++)
		{
			fin>>vname[i];
		}
//for (int i = 0; i < n; i++)
//			cout<<vname[res[i]]<<",";
	//		cout<<vname[i]<<",";
	//	cout<<endl;
	topologic();
	fin.close();
	return 0;
}
