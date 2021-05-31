%{
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>
int num,a,b;
int lines=0;
int chars=0;
int words=0;
char *fr;
char *be;
double result,re,r;
double conv(int i,char*str);
FILE* output;
%}
cha [ \t\r\f\v]+
IDN ([A-Za-z][A-Za-z0-9]*([_.][A-Za-z0-9][A-Za-z0-9]*))|([A-Za-z][A-Za-z0-9]*)
REA8 [0][1-7][0-7]*[.][1-7][0-7]*
REA16 [0](x)[a-f0-9][a-f0-9]*[.][a-f0-9][a-f0-9]*
REA10 ([0]|[1-9][0-9]*)[.][0-9][0-9]*
INT8 [0][0-7]*
INT16 [0](x)[a-f0-9]*
INT10 [1-9][0-9]*|[0]
%%
\n {chars++;lines++;}
{cha}  {chars+=strlen(yytext);}
if {words++; chars+=2; fprintf(output,"IF\n"); return IF;}
then {words++; chars+=4; fprintf(output,"THEN\n"); return THEN;}
else {words++; chars+=4; fprintf(output,"ELSE\n"); return ELSE;}
while {words++; chars+=5; fprintf(output,"WHILE\n"); return WHILE;}
do {words++; chars+=2; fprintf(output,"DO\n"); return DO;}
"int" {chars++; fprintf(output,"INT:int\n"); return INT;}
"double" {chars++; fprintf(output,"DOUBLE:double\n"); return DOUBLE;}
"+" {chars++; fprintf(output,"PLUS:+\n"); return PLUS;}
"-" {chars++; fprintf(output,"MINUS:-\n"); return MINUS;}
"*" {chars++; fprintf(output,"MULTI:*\n"); return MULTI;}
"/" {chars++; fprintf(output,"RDIV:/\n"); return RDIV;}
">" {chars++; fprintf(output,"GT:>\n"); return GT;}
"<" {chars++; fprintf(output,"LT:<\n"); return LT;}
"=" {chars++; fprintf(output,"EQ:=\n"); return EQ;}
";" {chars++; fprintf(output,"SEMIC ;\n"); return SEMIC;}
"(" {chars++; fprintf(output,"LB:(\n"); return LB;}
")" {chars++; fprintf(output,"RB:)\n"); return RB;}
"{" {chars++; fprintf(output,"LC:{\n"); return LC;}
"}"	{chars++; fprintf(output,"RC:}\n"); return RC;}

{REA10}   {
    words++; 
    chars+=strlen(yytext);
    fprintf(output,"REA10    %f\n",  conv(10,yytext));
    return REALDEC;
}
{REA8}   {
    words++; 
    chars+=strlen(yytext);
    fprintf(output,"REA8    %f\n", conv(8,yytext));
    return REALOCT;
}
{REA16}   {
    words++; 
    chars+=strlen(yytext);
    fprintf(output,"REA16    %f\n", conv(16,yytext));
    return REALOCT;
}
{INT10}   {
    words++; 
    chars+=strlen(yytext);
    sscanf(yytext,"%d",&num);
    fprintf(output,"INT10    %d\n", num);
    return INTDEC;
}
{INT8}   {
    words++; 
    chars+=strlen(yytext);
    sscanf(yytext,"%o",&num);
    fprintf(output,"INT8    %d\n", num);
    return  INTOCT;
}
{INT16}   {
    words++; 
    chars+=strlen(yytext);
    sscanf(yytext,"%x",&num);
    fprintf(output,"INT16    %d\n", num);
    return  INTHEX;
}
{IDN}   {
   words++; 
   chars+=strlen(yytext); 
   fprintf(output,"ID:%s\n",yytext); 
   return ID;
}
. {chars++; fprintf(output,"NOT\n");}
%%


double conv(int i,char*str){
  be=str;
  fr = strsep(&be, ".");
  num=0;
  if(i==16){
  sscanf(fr,"%x",&a);
  result=(double)a;
  r=1.0/16.0;
  re=r;
  while(be[num]!=0){
  if(be[num]=='A'||be[num]=='a'){
      result+=10*re;
  }
  else if(be[num]=='B'||be[num]=='b'){
      result+=11*re;
  }
  else if(be[num]=='C'||be[num]=='c'){
      result+=12*re;
  }
  else if(be[num]=='D'||be[num]=='d'){
      result+=13*re;
  }
  else if(be[num]=='E'||be[num]=='e'){
      result+=14*re;
  }
  else if(be[num]=='F'||be[num]=='f'){
      result+=15*re;
  }
  else{
      result+=(be[num]-'0')*re;
  }
      re*=r;
      num++;
  }
  }
  else if(i==8){
  	  sscanf(fr,"%o",&a);
  result=(double)a;
  r=1.0/8.0;
  re=r;
  while(be[num]!=0){
      result+=(be[num]-'0')*re;
      re*=r;
      num++;
  }
  }
  else{
    sscanf(fr,"%d",&a);
  result=(double)a;
  r=1.0/10.0;
  re=r;
  while(be[num]!=0){
      result+=(be[num]-'0')*re;
      re*=r;
      num++;
  }
  }
  return result;
}

