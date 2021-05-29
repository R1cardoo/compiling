%{
#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>


int chars=0;
int words=0;
int lines=0;
int totchars=0;
int totwords=0;
int totlines=0;
FILE* output;
int intnum(char* yytext,int i);
double realnum(char* yytext,int i);
%}

%option yylineno

ws [ \t\r\f\v]+
letter [a-zA-Z]
digit [0-9]
id {letter}({letter}|{digit})*(([_.])({letter}|{digit})+)?
intdec (0|([1-9]{digit}*))
intoct 0([0-7])+
inthex 0[xX]({digit}|[a-fA-F])+
realdec {intdec}.({digit}+)
realoct {intoct}.([0-7])([0-7])+
realhex {inthex}.({digit}|[a-fA-F])({digit}|[a-fA-F])+
%%
\n {chars++; lines++;}
{ws} {chars+=strlen(yytext);}
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
{id} {words++; chars+=strlen(yytext); fprintf(output,"ID:%s\n",yytext); return ID;}
{intdec} {words++; chars+=strlen(yytext); fprintf(output,"INTDEC:%s\n",yytext); return INTDEC;}
{intoct} {words++; chars+=strlen(yytext); fprintf(output,"INTOCT:%d\n",intnum(yytext,1)); return INTOCT;}
{inthex} {words++; chars+=strlen(yytext); fprintf(output,"INTHEX:%d\n",intnum(yytext,2)); return INTHEX;}
{realdec} {words++; chars+=strlen(yytext); fprintf(output,"REALDEC:%s\n",yytext); return REALDEC;}
{realoct} {words++; chars+=strlen(yytext); fprintf(output,"REALOCT:%f\n",realnum(yytext,1)); return REALOCT;}
{realhex} {words++; chars+=strlen(yytext); fprintf(output,"REALHEX:%f\n",realnum(yytext,2)); return REALHEX;}
. {chars++; fprintf(output,"NOT\n");}
%%

// int main2(int argc, char **argv)
// {
// 	int i;
// 	output=stdout;
// 	if(argc<2){
// 		yylex();
// 		printf("line:%8dwords:%8dchars:%8d\n",lines,words,chars);
// 		return 0;
// 	}
// 	for(i=1;i<argc;i++){
// 		FILE *f=fopen(argv[i],"r");
// 		if(!f){
// 			perror(argv[i]);
// 			return (1);		
// 		}
// 		yyrestart(f);
// 		yylex();
// 		fclose(f);
// 		printf("line:%8dwords:%8dchars:%8d %s\n",lines,words,chars,argv[i]);
// 		totchars+=chars;
// 		totwords+=words;
// 		totlines+=lines;
// 		chars=0;
// 		words=0;
// 		lines=0;
// 	}
// 	if(argc>1){
// 		printf("line:%8dwords:%8dchars:%8d  total\n",totlines,totwords,totchars);
// 	}
// 	return 0;	
// }


int intnum(char* yytext,int i){
	int num=0;
	int j=0;
	int t=0;
	switch(i){
	case 1:
		while(yytext[j]!='\0'){
			num=num*8+yytext[j]-'0';
			j++;		
		}
		break;
	case 2:
		j=2;
		while(yytext[j]!='\0'){
			if(yytext[j]>='0'&&yytext[j]<='9')
			t=yytext[j]-'0';       
			if(yytext[j]>='a'&&yytext[j]<='z')
			t=yytext[j]-'a'+10;
			if(yytext[j]>='A'&&yytext[j]<='Z')
			t=yytext[j]-'A'+10;
			num=num*16+t;
			j++;	
		}
		break;
	}
	
	return num;
}
double realnum(char* yytext,int i){
	double dnum=0;
	int j=0;
	int k=0;
	int t=0;
	while(yytext[k]!='.'&&yytext[k]!='\0'){
		k++;		
	}
	switch(i){
	case 1:
		while(yytext[j]!='\0'){
			if(j<k)	dnum=dnum+(yytext[j]-'0')*pow(8,k-j-1);
			else if(j==k){}
			else  dnum=dnum+(yytext[j]-'0')*pow(8,k-j);
			j++;		
		}
		break;
	case 2:
		j=2;
		while(yytext[j]!='\0'){
			if(j<k){
				if(yytext[j]>='0'&&yytext[j]<='9')
				t=yytext[j]-'0';       
				if(yytext[j]>='a'&&yytext[j]<='z')
				t=yytext[j]-'a'+10;
				if(yytext[j]>='A'&&yytext[j]<='Z')
				t=yytext[j]-'A'+10;
				dnum=dnum+t*pow(16,k-j-1);
			}
			else if(j==k){}
			else{
				if(yytext[j]>='0'&&yytext[j]<='9')
				t=yytext[j]-'0';       
				if(yytext[j]>='a'&&yytext[j]<='z')
				t=yytext[j]-'a'+10;
				if(yytext[j]>='A'&&yytext[j]<='Z')
				t=yytext[j]-'A'+10;
				dnum=dnum+t*pow(16,k-j);
			}
			j++;	
		}
		break;
	}
	
	return dnum;
}
