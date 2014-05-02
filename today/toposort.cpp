#include <iostream>
#include <fstream>
#include <cstring>
//#include <memory>
#include <stack>
using namespace std;

#define MAX_VERTEX_NUM 1300

stack<int> s;

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

bool TopologicalSort(ALGraph G,int *indegree)
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
		cout<<G.vertices[i].data<<"-->";
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
	cout<<"First line: vertex # and edge #";
	fin>>g.vexnum>>g.arcnum;
	for(i=1;i<g.vexnum+1;i++)
		g.vertices[i].data = i;

	int b,e;
	ArcNode *p;
	int *indegree = new int[g.vexnum+1];
	//int *indegree=(int *)malloc(sizeof(int)*(g.vexnum+1));
	memset(indegree,0,sizeof(int)*(g.vexnum+1));
	cout<<"Edge info (start --> end) for each line"<<endl;
	for(i=1;i<g.arcnum+1;i++)
	{
		cout<<"No."<<i<<"edge: ";
		fin>>b>>e;
		p = new ArcNode();
		p->adjvex = e;
		p->nextarc = g.vertices[b].firstarc;
		g.vertices[b].firstarc = p;
		indegree[e]++;
		cout<<endl;
	}
	if(TopologicalSort(g,indegree)) cout<<"No news is good news!"<<endl;
	else cout<<"Error: Loop detected!"<<endl;
	fin.close();
	return 0;
}
