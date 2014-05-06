#include <iostream>
#include <fstream>
#include <cstring>
#include <stack>

using namespace std;

#define MAX_VERTEX_NUM 1300

stack<int> s;
int idxcnt = 0;

typedef struct ArcNode{
	int adjvex;
	struct ArcNode *nextarc;
	ArcNode(){nextarc=0;}
//	InfoType *info;
}ArcNode;

typedef struct VNode{
	int data;
	ArcNode *firstarc;
	VNode(){firstarc=0;}
}VNode,AdjList[MAX_VERTEX_NUM];

typedef struct{
	AdjList vertices;
	int vexnum,arcnum;
	int kind;
}ALGraph;

bool TopologicalSort(ALGraph G,int *indegree,string *str)
{
	int i,k;
	for(i=1;i<G.vexnum+1;i++)
	{
		if(!indegree[i]){s.push(i);}
	}
	int count=0;
	ArcNode *p;
	while(!s.empty())
	{
		i = s.top();
		s.pop();
		if(i==0) {continue;}
		int tmp;
		tmp = G.vertices[i].data - 1;
//		if(tmp < 0 || tmp >= G.vexnum) {
//			cout<<"error!!!!!!!!"<<endl;
//			cout<<"error when i = "<<i<<endl;
//		}
//		idx[idxcnt] = tmp;
//		idxcnt++;
		cout<<str[tmp]<<",";
//		cout<<G.vertices[i].data<<"-->";
		count++;
		for(p=G.vertices[i].firstarc;p;p=p->nextarc)
		{
			k = p->adjvex;
			indegree[k]--;
			if(!indegree[k])
			  s.push(k);
		}
	}
	if(count<G.vexnum) return false;
	return true;
}


int main(int argc, char *argv[])
{
	ifstream fin(argv[1]);
	int i;
	ALGraph g;
//	cout<<"First line: vertex # and edge #";
	fin>>g.vexnum>>g.arcnum;
	for(i=1;i<g.vexnum+1;i++)
		g.vertices[i].data = i;

	int b,e;
	ArcNode *p;
	int *indegree = new int[g.vexnum+1];

	memset(indegree,0,sizeof(int)*(g.vexnum+1));
	cout<<"Edge info (start --> end) for each line"<<endl;
	for(i=1;i<g.arcnum+1;i++)
	{
//		cout<<"No."<<i<<"edge: ";
		fin>>b>>e;
		p = new ArcNode();
		p->adjvex = e;
		p->nextarc = g.vertices[b].firstarc;
		g.vertices[b].firstarc = p;
		indegree[e]++;
//		cout<<endl;
	}

	string *vname = new string[g.vexnum+1];
	for(i=0;i<g.vexnum;i++)
	{
		fin>>vname[i];
//		cout<<vname[i]<<" ";
	}
//	cout<<endl;

//	int *idx = new int[g.vexnum+1];
//	memset(idx,0,sizeof(int)*(g.vexnum+1));

	if(TopologicalSort(g,indegree,vname)) 
		cout<<"No news is good news!"<<endl;
	else cout<<"Error: Loop detected!"<<endl;

//	for(i=0;i<g.vexnum;i++){
//		cout<<idx[i]<<" ";
//	}
//	cout<<endl;
	fin.close();
	return 0;
}
