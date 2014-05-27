#include <iostream>
#include <cstring>
#include <cmath>
using namespace std;

#define M 99

bool onb(double a, double b)
{
	long sum, diff;
	long power_a = 1;
	long power_b = 1;
	
	while (a>16) { 
		power_a *= (long(pow(2,16))%(2*M+1));
		power_a = power_a%(2*M+1);
		a -= 16;
	}
	power_a *= long(pow(2,a))%(2*M+1);

	while (b>16) { 
		power_b *= (long(pow(2,16))%(2*M+1));
		power_b = power_b%(2*M+1);
		b -= 16;
	}
	power_b *= long(pow(2,b))%(2*M+1);

	sum = power_a + power_b;
	diff = power_a - power_b;
	while(diff < 0)
		diff += 2*M+1;
	sum = sum%(2*M+1);
	diff = diff%(2*M+1);
	if (sum == 1 || sum == (2*M) || diff == 1 || diff == (2*M))
		return 1;
	else return 0;
}

int main()
{
	bool l[M][M];
	int idx[M][2];
	int cnt=0;
	int g_cnt = 0;
	int x;
	double i = 0.0, j = 0.0;
	for(i=0; i<M; i++)
		memset(l[int(i)],0,M);
	for(i=0; i<M; i++){
		idx[int(i)][0] = -1;
		idx[int(i)][1] = -1;
	}
	for(i=0.0; i < M; i=i+1.0){
		cnt = 0;
		for(j = 0.0; j<M; j=j+1.0){
			if(onb(i,j) == 1){
				l[int(i)][int(j)] = 1;
				idx[int(i)][cnt] = int(j);
				cnt++;
				g_cnt++;
			}
		}
	}
/*	for(i=0;i<M;i++){
		for(j=0;j<M;j++)
			cout<<l[int(i)][int(j)]<<" ";
		cout<<endl;
	}
*/
	cout<<"Complexity: "<<g_cnt<<endl;
	for(x=0;x<M;x++)
		cout<<idx[x][0]<<" "<<idx[x][1]<<" ";
	cout<<endl;
	return 0;
}

