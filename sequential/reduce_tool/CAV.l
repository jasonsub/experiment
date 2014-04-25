/***************************************************************************

  FileName    [eqn2poly.l]

  PackageName [MVD: Multi-Variable Division]

  Synopsis    [Lexical analyzer for EQN format.]

  Author      [Jinpeng Lv]
******************************************************************************/

%{
#include<cstdio>
#include<iostream>
#include<cstring> 
//#include<cstdlib>


#include "parser.hpp"

using  namespace std;
%}


%option noyywrap
%option nodefault
%x C_COMMENT
%x comment

blank  [ \t\r\b\n]
identifier  [A-Za-z_0-9]
exp "^"[0-9]+
brace [\[\]]

%%
"/*"				{BEGIN(C_COMMENT);}
<C_COMMENT>"*/"		{BEGIN(INITIAL);}
<C_COMMENT>.|\n	{}

"//"				{BEGIN(comment);}
<comment>\n			{BEGIN(INITIAL);}
<comment>.			{}

{identifier}+		{	
						cavlval.id=cavtext;
						return VARIABLE;
					}
{exp}				{
						cavlval.exp=atoi(cavtext+1);
				    	return EXP;
					}

				
[\+\^\*\(\)\'\;\=!\,]			{return *cavtext;}

[\n]		{++cavlineno;}

{blank}+		;

. cout<<"Unknown character: line "<<cavlineno<<": "<<cavtext[0]<<"\n";

%%
