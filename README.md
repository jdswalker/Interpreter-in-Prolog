# CSCI 3136 - Simple Script Interpreter
Author: [James Walker](github.com/JDSWalker/)  
©2016 under the [MIT license](www.opensource.org/licenses/mit-license.php)  

## Overview  

#### Motivation:
This Prolog program was developed in as part of a term project for CSCI 3136, [Principles of Programming Langauges](academiccalendar.dal.ca/Catalog/ViewCatalog.aspx?pageid=viewcatalog&entitytype=CID&entitycode=CSCI+3136), in the winter semester of 2016. The program can read a simple space-delimited script to calculate a result. While the interpreter is functional, it can currently only handle functions that use a single parameter.  

#### Required Tools:  
- [SWI-Prolog](http://portableapps.com/apps/development/swi-prolog_portable)  
- A plain text script in a file with at least one function defined as `main`

#### Program Status & Known Issues:  
- [x] Tokenizer is working  
- [x] Lexer is working  
- [x] Grammar is defined
- [x] Parser is working
- [x] Symbol Table is working  
- [x] Interpreter is working  
- [ ] Modify code to allow multi-argument functions

#### Program Notes:  
The language executor to run a script can be called using the `run_program/3` predicate. For example, `run_program('test1.txt', [2], Result).`  

The executor starts by reading the whitespace delmited text from the given file.  
<pre>int main ( int input ) = input + 3</pre>  

A list of tokens is created from the text in the file as it is read.  
<pre>['int','main','(','int','input',')','=','input','+','3']</pre>  

Next, the list of tokens is lexed into a second list identifying token types.  
<pre>['TYPE_INT','IDENTIFIER','OPEN_P','TYPE_INT','IDENTIFIER','CLOSE_P',  
 'ASSIGN','IDENTIFIER','ARITH_ADD','INTEGER']</pre>  

The lexed list is then formatted into a structured list.  
<pre>[[['int','?'],'(',[['int','?'],[]],')','=',[['?',[]],[['+',['integer']]]]]]</pre>  

The token list is then merged with the structured list to recover the values and create the parsed list used as input for the interpreter.  
<pre>[[['int','main'],'(',[['int','input'],[]],')',=,[['input',[]],[['+',['3']]]]]]</pre>  

Each function defined in the parsed list is then placed into a global symbol table for look-up during execution of the script.  
<pre>t('main',['int',[['int','input'],[]],[['input',[]],[['+',['3']]]]],-,t,t)</pre>  

Finally, the interpreter calls the `main` function and returns the result.
<pre>Result:    5</pre>
