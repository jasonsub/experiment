# include "stdlib.h"
#include "stdio.h"
# include "time.h"

#define dm 8
int a[dm];
void permutation()
{
 int b;                       //定义一个变量存取随机生成的一个整数
 int j,i=0;          
 srand((unsigned)time(NULL));
 a[0]=rand()%dm+1;
 for(i=1;i<dm;i++)           //循环生成随机数，并存取在数组a[]中。
 {
  srand((unsigned)time(NULL));
  loop:   b=rand()%dm+1;
     for(j=0;j<=i;j++)       //把后一个生成的数和前面的数一一对比，若是有相同的GOTO LOOP再产生。
  {
        if(b==a[j])
        goto loop;
  }
     a[i]=b;
  }
/* for(i=0;i<dm;i++)
 {printf("%d ",a[i]);}
 printf("\n");*/
}

int

int metropolis(int S, int T, int M)
void main()
{
  permutation();
}
