# Script Interpreter Written in Prolog  
Author: James Walker  
©2017 under the [MIT license]  

## Testing Overview  

### Tests for Individual Modules:  
The `tests_for_modules.pl` file contains predicates for each module of the interpreter, i.e.:  
- `tokenizer.pl`  
- `lexer`  
- `grammar`  
- `parser`  
- `symbol_table.pl`  

Each module has three predicates associated with it, a `test_module/0` predicate, a `print_module_output/1` predicate, and a `save_module_output/2` predicate. For example, the tokenizer testing predicates are:  
- `test_tokenizer` which provides an input and checks if the expected result is generated  
- `print_tokenizer_output(InputFileName)` which runs the tokenizer with a given script file and prints the result to the terminal  
- `save_tokenizer_output(InputFileName, OutputFile)` which runs the tokenizer with a given script file and saves the result to the given output file  

There are also additional auxilliary functions for producing relevant outputs and a predicate that runs the test for every module (i.e., `test_all_modules/0`).  

### Tests the Interpreter with Scripts:  
The `tests_for_script_output.pl` file contains predicates which run the interpreter with the provided scripts and check against the expected result.  
- `test1.txt` adds `1` to the input argument  
- `test2.txt` subtracts the two input arguments  
- `test3.txt` multiplies the input by `3`  
- `test4.txt` tests _if-then-else_ and _let_ <_variable_> = <_value_> _in_ <_expression_> functionality  
- `test5.txt` tests all 5 arithmetic operators  
- `test6.txt` tests all 6 comparison operators  

As with the `tests_for_modules.pl` file, there are additional auxilliary functions for producing relevant outputs and a predicate that runs the tests for all of the provided scripts (i.e., `test_all_scripts/0`).  

[MIT license]: http://www.opensource.org/licenses/mit-license.php  
