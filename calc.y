%{
void yyerror (char *s);   /*parser is going to call when there is some error */
#include <suryansh.h>
int symbols[52];
int symbolVal(char symbol); /* reads the value of symbol */
void updateSymbolVal(char symbol,int val);  /* updates the value of symbol */
%}

%union {int num; char id;}         /* Yacc definitions */  /* different types my analyzer can return */
%start line /* which production is my starting rule */
%token print	/* print token is present */
%token sum
%token fib
%token exit_command
%token <num> number
%token <id> identifier
%type <num> line exp term 
%type <id> assignment

%%

/* descriptions of expected inputs     corresponding actions (in C) */

line    : assignment ';'		{;}
		| exit_command ';'		{exit(EXIT_SUCCESS);}
		| print exp ';'			{printf("Printing %d\n", $2);}
		| sum exp ';'			{printf("Sum is %d\n",SUM($2));}
		| fib exp ';'			{int c,i=0;for ( c = 1 ; c <= $2 ; c++ )
   {
      printf("Printing Fibonacci series:%d\n", Fibonacci(i));
      i++; 
   }}
		| line assignment ';'	{;}
		| line print exp ';'	{printf("Printing %d\n", $3);}
		| line exit_command ';'	{exit(EXIT_SUCCESS);}
		| line sum exp ';'		{printf("Sum is %d\n",SUM($3));}
		| line fib exp ';'			{int c,i=0;for ( c = 1 ; c <= $3 ; c++ )
   {
      printf("Printing Fibonacci series:%d\n", Fibonacci(i));
      i++; 
   }}
        ;

assignment : identifier '=' exp  {updateSymbolVal($1,$3); }
			;
exp    	: term                  {$$ = $1;}
       	| exp '+' term          {$$ = $1 + $3;}
       	| exp '-' term          {$$ = $1 - $3;}
	| exp '*' term		{$$ = $1 * $3;}
	| exp '/' term		{$$ = $1 / $3;}
	| exp '&' term		{$$ = pow($1,$3);} /*Power */
	| exp '?' 		{$$ = sqrt($1);} /*Square Root */
	| exp '!'		{$$ = fact($1);}
       	;
term   	: number                {$$ = $1;}
		| identifier			{$$ = symbolVal($1);} 
        ;

%%                     /* C code */

int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 

/* returns the value of a given symbol */
int symbolVal(char symbol)
{
	int bucket = computeSymbolIndex(symbol);
	return symbols[bucket];
}

/* updates the value of a given symbol */
void updateSymbolVal(char symbol,int val)
{
	int bucket = computeSymbolIndex(symbol);
	symbols[bucket] = val;
}

/*Function for factorial*/
int fact(int num){
	if(num == 0 || num == 1){ return 1;}
	else {
		return(num * fact(num - 1));
	}
}

/*Sum of n numbers*/
int SUM(int num)
{
     int i,su=0;
     for(i=0;i<=num;i++)
     {
          su = su + i;
      }
      return su;
}

/*Function for fibonacci*/
int Fibonacci(int n)
{
   if ( n == 0 )
      return 0;
   else if ( n == 1 )
      return 1;
   else
      return ( Fibonacci(n-1) + Fibonacci(n-2) );
} 

int main (void) {
	/* initialize symbol table */
	int i;
	for(i=0; i<52; i++) {
		symbols[i] = 0;
	}

	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "%s\n", s);} 