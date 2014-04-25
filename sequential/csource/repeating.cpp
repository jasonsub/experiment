#include <iostream>

using namespace std;

int main(){
  int i,j;
  char *word;
  cout<<"Plz input prefix:";
  cin>>word;
  cout<<"Plz input end No.:";
  cin>>j;
  for(i = 0; i <= j; i++){
    cout<<word<<i<<", ";
  }
  cout<<endl;
  return 0;
}
