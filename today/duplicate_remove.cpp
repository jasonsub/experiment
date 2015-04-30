#include<iostream>
#include<vector>
#include<algorithm>
using namespace std;

int main()
{
	int a;
	vector<int> array;
	vector<int>::const_iterator i;
	while(cin>>a)
	{
		if(find(array.begin(), array.end(), a) != array.end())
			continue;
		else
			array.push_back(a);
	}
	sort(array.begin(), array.end());
	for(i = array.begin(); i != array.end(); i++)
		cout<<*i<<" ";
	cout<<endl;
	return 0;
}