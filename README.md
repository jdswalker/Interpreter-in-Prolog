# Interpreter Written in Prolog  
Author: James Walker  
©2017 under the [MIT license]  

## Overview  

### Motivation:  
The interpreter program reads functions from a given plain-text file based on a simple scripting language, executes the script, and returns the result. This Prolog program was initially developed as a term project in my CSCI 3136 course, [Principles of Programming Languages], during the winter semester of 2016. In early 2017, the interpreter program was extended to handle three additional arithmetic operators and two additional comparison operators not required in the original project assignment.  

### Required Tools:  
- [SWI-Prolog]  
- A file containing a plain-text script to execute  

### Interpreter Capabilities:  
- Scripts can contain multiple function definitions so long as:  
**>** Each function is defined on a single line  
**>** Each function has one or more input arguments  
**>** The last function is defined as `main`  
- Supports integer and Boolean values for function arguments and return values  
- Supports if-then-else conditional statements
- Arithmetic operators have been defined for:  
**>** Addition (`+`)  
**>** Subtraction (`-`)  
**>** Multiplication (`*`)  
**>** Division (`/`)  
**>** Modulus (`%`)  
- Relational operators have been defined for:  
**>** Equal to (`==`)  
**>** Not equal to (`!=`)  
**>** Greater than (`>`)  
**>** Greater than or equal to (`>=`)  
**>** Less than (`<`)  
**>** Less than or equal to (`<=`)  
- The six scripts in the `testing` folder use the full range of the interpreter's capabilities  

### Program Notes:  
The code in `language_executor.pl` will run a script from a given plain-text file using the `run_program/3` predicate. For example, `run_program('input.txt', [2], Result).` will attempt to execute the `main` function using the single argument, `2`, from the file called `input.txt`. Extending this example, suppose `input.txt` contained the following line of text:  

`int main ( int input ) = input + 3`  

**First**, the code in `tokenizer.pl` reads this as space-delimited text and create a list of tokens.  

**Second**, the code in `lexer.pl` uses the token list to create a lexed list of identified token types.  

**Third**, the code in `parser.pl` uses the lexed list and formats it into a structured list based on the definite clause grammar predicates in `grammar.pl`.  

**Fourth**, the parser merges the token list with the structured list to recover the identifiers and values.  

**Fifth**, the code in `structured_list.pl` takes each function defined in the parsed list and places it into a global symbol table for look-up during execution of the script. As a side note for the symbol table output below, the `main` function is structured so that the function name is first, followed by its return type, its input arguments, and then its function body.  

**Sixth**, the code in `interpreter.pl` is used to call the `main` function with `2` as input, the script is executed, and the calculated result is returned.  

**Summary**  
**1.** Read \& tokenize file contents  
`[int,main,(,int,input,),=,input,+,3]`  
**2.** Lex \& identify token types  
`[TYPE_INT,ID,OPEN_P,TYPE_INT,ID,CLOSE_P,ASSIGN,ID,ARITH_ADD,INTEGER]`  
**3.** Format types into a structured list  
`[[[int,id],(,[[int,id],[]],),=,[[id,[]],[[+,[integer]]]]],[]]`  
**4.** Recover values into a parsed list  
`[[[int,main],(,[[int,input],[]],),=,[[input,[]],[[+,[3]]]]],[]]`  
**5.** Place functions into a global symbol table  
`t(main,[[int,[[int,input],[]],[[input,[]],[[+,[3]]]]]],-,t,t)`  
**6.** Execute the `main` function and return the result:  
`Result:    5`  

[MIT license]: http://www.opensource.org/licenses/mit-license.php  
[Principles of Programming Languages]: http://academiccalendar.dal.ca/Catalog/ViewCatalog.aspx?pageid=viewcatalog&entitytype=CID&entitycode=CSCI+3136  
[SWI-Prolog]: http://portableapps.com/apps/development/swi-prolog_portable  
