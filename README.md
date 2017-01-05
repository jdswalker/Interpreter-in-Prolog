# CSCI 3136 - Simple Script Interpreter
Author: [James Walker](github.com/JDSWalker/)  
©2016 under the [MIT license](www.opensource.org/licenses/mit-license.php)  

## Overview  

#### Motivation:
This Prolog program was developed in as part of a term project for CSCI 3136, [Principles of Programming Langauges](academiccalendar.dal.ca/Catalog/ViewCatalog.aspx?pageid=viewcatalog&entitytype=CID&entitycode=CSCI+3136), in the winter semester of 2016. The program can read a simple space-delimited script to calculate a result. I am currently updating it so it can handle functions with more than one parameter.  

#### Required Tools:  
- [SWI-Prolog](http://portableapps.com/apps/development/swi-prolog_portable)  

#### Program Status & Known Issues:  
- [x] Tokenizer is working  
- [ ] Lexer is working  
- [ ] Grammar is working  
- [ ] Symbol Table is working  
- [ ] Interpreter is working  
- [ ] Modify so multi-argument functions can be used as input

#### Program Notes:  
The program starts by reading whitespace delmited text from a file. For example,  
`int add ( int a , int b ) = a + b`  
A list of tokens is created from the text in the file as it is read.
`[int,add,(,int,a,,,int,b,),=,a,+,b]`
