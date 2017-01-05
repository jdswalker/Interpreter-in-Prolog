% Required files/library
:- consult('tokenizer').
:- consult('lexer').
:- consult('grammar').
:- consult('parser').

% TOKENIZER TESTS

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

% check_tokenizer_output/0
% check_tokenizer_output.
% The tokenizer output from two test files is printed
check_tokenizer_output :-
  writeln('\nTokenizer output from file "test1.txt"'),
  tokenize_file('test1.txt', TokenList1),
  writeq(TokenList1),
  writeln('\nTokenizer output from file "test2.txt"'),
  tokenize_file('test2.txt', TokenList2),
  writeq(TokenList2).


% LEXER TESTS

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

% check_lexer_output/0
% check_lexer_output.
% The lexer output from two test files is printed
check_lexer_output :-
  writeln('\nLexer output from file "test1.txt"'),
  tokenize_file('test1.txt', TokenList1),
  lexer(TokenList1, LexedList1),
  writeq(LexedList1),
  writeln('\nLexer output from file "test2.txt"'),
  tokenize_file('test2.txt', TokenList2),
  lexer(TokenList2, LexedList2),
  writeq(LexedList2).


% PARSER TESTS

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

% check_structured_list_output/0
% check_structured_list_output.
% The structured list output from two files is printed
check_structured_list_output :-
  writeln('\nStructured list output from file "test1.txt"'),
  tokenize_file('test1.txt', TokenList1),
  lexer(TokenList1, LexedList1),
  parse_list(LexedList1, StructuredList1),
  writeq(StructuredList1),
  writeln('\nStructured list output from file "test2.txt"'),
  tokenize_file('test2.txt', TokenList2),
  lexer(TokenList2, LexedList2),
  parse_list(LexedList2, StructuredList2),
  writeq(StructuredList2).

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

% check_parser_output/0
% check_parser_output.
% The parsed output from two files is printed
check_parser_output :-
  writeln('\nTesting Parsed List with file "test2.txt"'),
  tokenize_file('test2.txt', TokenList),
  parse_token_list(TokenList, ParsedList),
  writeq(ParsedList).


% OUTPUT FROM TESTS

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
