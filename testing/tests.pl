% Required files/library
:- consult('tokenizer').
:- consult('lexer').
:- consult('grammar').
:- consult('parser').

% test_all/0
% test_all.
% Runs every test in this file.
test_all :-
  test_tokenizer,
  test_lexer,
  test_structured_list,
  test_parser,
  writeln('\n*** TESTING COMPLETE ***\n').

% print_all/0
% print_all(+InputFileName).
% Produces outputs for each module with a corresponding test for the given
% input file.
print_all :-
  print_tokenizer_output(InputFileName),
  print_lexer_output(InputFileName),
  print_structured_list(InputFileName),
  print_parser_output(InputFileName),
  print_symbol_table(InputFileName),
  writeln('\n*** PRINTING COMPLETE ***\n').

%%%%%%%%%%%%%%%%%%%
% TOKENIZER TESTS %
%%%%%%%%%%%%%%%%%%%

% test_tokenizer/0
% test_tokenizer.
% A string is written to a temp file and provided as input to the predicates
% used by the tokenize_file/2 predicate. The resulting list of tokens is then
% compared to an expected output.
%   Input:      int add ( int a , int b ) = a + b
%   TokenList:  [int,add,(,int,a,,,int,b,),=,a,+,b]
test_tokenizer :-
  writeln('\nTesting Tokenizer'),
  TestString = 'int add ( int a , int b ) = a + b',
  Expected = ['int','add','(','int','a',',','int','b',')','=','a','+','b'],
  new_memory_file(TempFile),
  open_memory_file(TempFile, write, Writer),
  write(Writer, TestString),
  close(Writer),
  open_memory_file(TempFile, read, Reader, [free_on_close(true)]),
  get_tokens(Reader, Tokens),
  close(Reader),
  remove_empty_tokens(Tokens, TokenList),
  output_test_result(TokenList, Expected).

% print_tokenizer_output/1
% print_tokenizer_output(+InputFileName).
% The tokenizer output for the given file is printed
print_tokenizer_output(InputFileName) :-
  write('\nTokenizer output for the contents in file "'),
  write(InputFileName),
  writeln('"'),
  tokenize_file(InputFileName, TokenList),
  writeq(TokenList).

% save_tokenizer_output/2
% save_tokenizer_output(+InputFileName, +OutputFile).
% The tokenizer output is saved to the given filename
save_tokenizer_output(InputFileName, OutputFile). :-
  write('\nTokenizer output to file "'),
  write(InputFileName),
  writeln('"'),
  tokenize_file(InputFileName, TokenList),
  write_output_to_file(InputFileName, TokenList).


%%%%%%%%%%%%%%%
% LEXER TESTS %
%%%%%%%%%%%%%%%

% test_lexer/0
% test_lexer.
% A list of tokens is provided as input to the lexer/2 predicate. The 
% resulting lexed list is then compared with the expected output.
test_lexer :-
  writeln('\nTesting Lexer'),
  TokenList = ['int','add','(','int','a',',','int','b',')','=','a','+','b'],
  Expected = ['TYPE_INT','IDENTIFIER','OPEN_P','TYPE_INT','IDENTIFIER','COMMA',
              'TYPE_INT','IDENTIFIER','CLOSE_P','ASSIGN','IDENTIFIER',
              'ARITH_ADD','IDENTIFIER'],
  lexer(TokenList, LexedList),
  output_test_result(LexedList, Expected).

% print_lexer_output/1
% print_lexer_output(+InputFileName).
% The lexer output for the given file is printed
print_lexer_output(InputFileName) :-
  write('\nLexer output for the contents in file "'),
  write(InputFileName),
  writeln('"'),
  tokenize_file(InputFileName, TokenList),
  lexer(TokenList, LexedList),
  writeq(LexedList).

% save_lexer_output/2
% save_lexer_output(+InputFileName, +OutputFile).
% The lexer output is saved to the given filename
save_lexer_output(InputFileName, OutputFile). :-
  write('\nLexer output to file "'),
  write(InputFileName),
  writeln('"'),
  tokenize_file(InputFileName, TokenList),
  lexer(TokenList, LexedList),
  write_output_to_file(InputFileName, LexedList).


%%%%%%%%%%%%%%%%
% PARSER TESTS %
%%%%%%%%%%%%%%%%

% test_structured_list/0
% test_structured_list.
% A lexed list is provided as test input to the grammar via the parse_list/2
% predicate. The resulting structured list is then compared to an expected
% output.
test_structured_list :-
  writeln('\nTesting Structured List'),
  LexedList = ['TYPE_INT','IDENTIFIER','OPEN_P','TYPE_INT','IDENTIFIER','COMMA',
               'TYPE_INT','IDENTIFIER','CLOSE_P','ASSIGN','IDENTIFIER',
               'ARITH_ADD','IDENTIFIER'],
  Expected = [[['int','?'],'(',[['int','?'],[',',[['int','?'],[]]]],')','=',
             [['?',[]],[['+',['?',[]]]]]]],
  parse_list(LexedList, StructuredList),
  output_test_result(StructuredList, Expected).

% print_structured_list/1
% print_structured_list(+InputFileName).
% The structured list output for the given file is printed
print_structured_list(InputFileName) :-
  write('\nStructured list output for the contents in file "'),
  write(InputFileName),
  writeln('"'),
  tokenize_file(InputFileName, TokenList),
  lexer(TokenList, LexedList),
  parse_list(LexedList, StructuredList),
  writeq(StructuredList).

% save_structured_list/2
% save_structured_list(+InputFileName, +OutputFile).
% The structured list output is saved to the given filename
save_structured_list(InputFileName, OutputFile). :-
  write('\nStructured list output to file "'),
  write(InputFileName),
  writeln('"'),
  tokenize_file(InputFileName, TokenList),
  lexer(TokenList, LexedList),
  parse_list(LexedList, StructuredList),
  write_output_to_file(InputFileName, StructuredList).

% test_parser/0
% test_parser.
% A token list and structured list are provided as test input to the
% clean_parses/3 predicate. The resulting parsed list is then compared to an
% expected output.
test_parser :-
  writeln('\nTesting Parsed List'),
  TokenList = ['int','add','(','int','a',',','int','b',')','=','a','+','b'],
  Expected = [[['int','add'],'(',[['int','a'],[',',[['int','b'],[]]]],')','=',
             [['a',[]],[['+',['b',[]]]]]]],
  parse_token_list(TokenList, ParsedList),
  output_test_result(ParsedList, Expected).

% print_parser_output/1
% print_parser_output(+InputFileName).
% The structured list output for the given file is printed
print_parser_output(InputFileName) :-
  write('\nParser output for the contents in file "'),
  write(InputFileName),
  writeln('"'),
  tokenize_file(InputFileName, TokenList),
  parse_token_list(TokenList, ParsedList),
  writeq(ParsedList).

% save_parsed_list/2
% save_parsed_list(+InputFileName, +OutputFile).
% The structured list output is saved to the given filename
save_parsed_output(InputFileName, OutputFile). :-
  write('\nSaving parser output to file "'),
  write(InputFileName),
  writeln('"'),
  tokenize_file(InputFileName, TokenList),
  parse_token_list(TokenList, ParsedList),
  write_output_to_file(InputFileName, ParsedList).


%%%%%%%%%%%%%%%%%%%%%%
%%  SYMBOL_TABLE  %%
%%%%%%%%%%%%%%%%%%%%%%

% print_symbol_table/1
% print_symbol_table(+InputFileName).
% The initialized symbol table output for the given file is printed
print_symbol_table(InputFileName) :-
  write('\nSymbol table output for the contents in file "'),
  write(OutputFile),
  writeln('"'),
  tokenize_file(InputFileName, TokenList),
  parse_token_list(TokenList, ParsedList),
  initialize_table(ParsedList),
  b_getval(symbol_table, SymbolTable),
  writeq(SymbolTable).

% save_symbol_table/2
% save_symbol_table(+InputFileName, +OutputFile).
% Initializes the symbol table from an input file and save the contents of the
% table to an output file.
save_symbol_table(InputFileName, OutputFile) :-
  write('\nSaving symbol table output to file "'),
  write(OutputFile),
  writeln('"'),
  tokenize_file(InputFileName, TokenList),
  parse_token_list(TokenList, ParsedList),
  initialize_table(ParsedList),
  b_getval(symbol_table, SymbolTable),
  write_output_to_file(OutputFile, SymbolTable).


%%%%%%%%%%%%%%%%%%%%%
% OUTPUT FROM TESTS %
%%%%%%%%%%%%%%%%%%%%%

% output_test_result/2
% output_test_result(+Result, +Expected).
% Output results of tests to standard output (used in later programs)
output_test_result(Result, Expected) :-
  (Result == Expected -> (writeln('*** TEST PASSED ***'),
                          writeln(Result), nl)
                         ;
                         (writeln('*** TEST FAILED ***'),
                          writeln(Result), nl)).

% write_output_to_file/2
% write_output_to_file(+OutputFile, +List).
% Writes the given list to the designated output file
write_output_to_file(OutputFile, List) :-
  open(OutputFile, write, Stream),
  writeq(Stream, List),
  !,
  close(Stream).
