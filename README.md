# Simple Script Interpreter  
Author: James Walker
©2017 under the [MIT license]  

## Overview  

### Motivation:  
This Prolog program was developed in as part of a term project for CSCI 3136, [Principles of Programming Langauges], in the winter semester of 2016. The program can read a simple space-delimited script from a plain-text file and calculate a result. Scripts can contain multiple functions, one per line, with each function requiring one or more input arguments.  

### Required Tools:  
- [SWI-Prolog]  
- A plain text script in a file with the last function defined as `main`  

### Program Capabilities:  
- Supports integer and boolean values for function arguments and return values  
- Arithmetic operators have been defined for:  
**>** addition (`+`)  
**>** subtraction (`-`)  
**>** multiplication (`*`)  
**>** division (`/`)  
**>** modulus (`%`)  
- Relational operators have been defined for:  
**>** Equal (`==`)  
**>** Not equal (`!=`)  
**>** Greater than (`>`)  
**>** Greater than or equal (`>=`)  
**>** Lesser than (`<`)  
**>** Lesser than or equal (`<=`)  
- The six scripts in the `testing` folder above use the full range of the interpreter's capabilities  

### Program Notes:  
The language executor will run a script from a file using the `run_program/3` predicate.  
For example, `run_program('input.txt', [2], Result).`  

The executor starts by tokenizing whitespace-delmited text from the given file. If `input.txt` contained  
`int main ( int input ) = input + 3`  
then this would be the resulting list of tokens created:  
`[int,main,(,int,input,),=,input,+,3]`  

The lexer will take this list of tokens and create a second list identifying token types.  
`[TYPE_INT,ID,OPEN_P,TYPE_INT,ID,CLOSE_P,ASSIGN,ID,ARITH_ADD,INTEGER]`  

The parser takes the lexer output and formats it into a structured list.  
`[[[int,id],(,[[int,id],[]],),=,[[id,[]],[[+,[integer]]]]],[]]`  

Following this, the parser takes the token list from earlier and merges it with the structured list to recover the identifiers and values.  
`[[[int,main],(,[[int,input],[]],),=,[[input,[]],[[+,[3]]]]],[]]`  

Each function defined in the parsed list is then placed into a global symbol table for look-up during execution of the script. For the `main` function in the symbol table output below, the function name is first, followed by its return type, its input arguments, and the function body.  
`t(main,[[int,[[int,input],[]],[[input,[]],[[+,[3]]]]]],-,t,t)`  

Finally, the interpreter calls the `main` function and returns the result.  
`Result:    5`  

[MIT license]: http://www.opensource.org/licenses/mit-license.php  
[Principles of Programming Langauges]: http://academiccalendar.dal.ca/Catalog/ViewCatalog.aspx?pageid=viewcatalog&entitytype=CID&entitycode=CSCI+3136  
[SWI-Prolog]: http://portableapps.com/apps/development/swi-prolog_portable  
