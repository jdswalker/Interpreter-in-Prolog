%% Author: James Walker
%% Copyrighted 2017 under the MIT license:
%%   http://www.opensource.org/licenses/mit-license.php
%%
%% Purpose: Formats the parsed list and adds them to a global symbol table
%% E.g.,    tokenize_file('input.txt', TokenList),
%%          lexer(TokenList, LexedList),
%%          parse_list(LexedList, StructuredList),
%%          clean_parsed_list(TokenList, StructuredList, ParsedList),
%%          initialize_table(ParsedList).

% Required files/library
:- consult('tokenizer').
:- consult('lexer').
:- consult('grammar').
:- consult('parser').

:- use_module(library(assoc)).

% create_empty_table/0
% create_empty_table.
% Creates an empty association list and stores it in a global variable for use
% as a symbol table.
create_empty_table :-
  empty_assoc(SymbolTable),
  b_setval(symbol_table, SymbolTable).

% initialize_functions/1
% initialize_functions(+FunctionList).
% Accepts a list of functions and stores them in the symbol table.
initialize_functions([]).
initialize_functions([[ReturnType, FunctionName], '(', Parameters, ')', '=',
                     FunctionBody]) :-
  b_getval(symbol_table, SymbolTable),
  put_assoc(FunctionName, SymbolTable, 
            [[ReturnType, Parameters, FunctionBody]], NewSymbolTable),
  b_setval(symbol_table, NewSymbolTable),
  !.
initialize_functions([Function|FunctionList]) :-
  is_list(Function),
  initialize_functions(Function),
  initialize_functions(FunctionList),
  !.
initialize_functions([_|FunctionList]) :-
  initialize_functions(FunctionList).

% initialize_table/1
% initialize_table(+ParsedList).
% Initializes the global symbol table from functions contained in the parsed
% list
initialize_table(ParsedList) :-
  create_empty_table,
  initialize_functions(ParsedList).

% add_symbol/2
% add_symbol(+Key, +Value).
% Accepts a (key->value) pair and adds it to the table in the form:
% key -> [value|Rest].
add_symbol(Key, Value) :-
  b_getval(symbol_table, SymbolTable),
  contains_symbol(Key, SymbolTable, OldValue),
  put_assoc(Key, SymbolTable, [Value|OldValue], NewSymbolTable),
  b_setval(symbol_table, NewSymbolTable).

% contains_symbol/3
% contains_symbol(+Key, +SymbolTable, ?Value)
% Returns the first value associated with the key provided or an empty list
contains_symbol(Key, SymbolTable, Value) :-
  get_assoc(Key, SymbolTable, Value). % get_assoc(+Key, +Assoc, ?Value)
contains_symbol(_, _, []).

% get_symbol/2
% get_symbol(+Key, ?Value).
% Returns the first value associated with the key provided
get_symbol(Key, Value) :-
  b_getval(symbol_table, SymbolTable),
  get_assoc(Key, SymbolTable, [Value|_]). % get_assoc(+Key, +Assoc, ?Value)

% remove_symbol/1
% remove_symbol(+FunctionName)
% Accepts a (key->value) pair and removes the most recently added value for
% that key such that the symbol table is changed from key -> [value|Rest]
% to key -> Rest.
remove_symbol(FunctionName) :-
  b_getval(symbol_table, SymbolTable),
  get_assoc(FunctionName, SymbolTable, [_|FunctionList], NewTable,
            FunctionList),
  b_setval(symbol_table, NewTable).

% remove_symbols/1
% remove_symbols(+ParameterList)
% Accepts a (key->value) pair and removes the most recently added value for
% that key such that the symbol table is changed from key -> [value|Rest] to 
% key -> Rest.
remove_symbols([]).
remove_symbols([Parameter|ParameterList]) :-
  remove_symbol(Parameter),
  remove_symbols(ParameterList).
