%% Author: James Walker
%% Copyrighted 2017 under the MIT license:
%%  http://www.opensource.org/licenses/mit-license.php
%%
%% Purpose: Tokenize the source file, lex the tokens, structure/parse the
%%          lexes, add functions to symbol table, run source code to obtain
%%          the result
%% E.g.,    run_program('script.txt', [2], Result).

% Required files/library
:- consult('tokenizer').
:- consult('parser').
:- consult('symbol_table').
:- consult('interpreter').

% run_program/3
% run_program(+FileName, +Arguments, ?Result).
% This predictate will run the script in the indicated file
run_program(FileName, Arguments, Result) :-
  tokenize_file(FileName, TokenList),
  parse_token_list(TokenList, ParsedList),
  initialize_table(ParsedList),
  !,
  call_function('main', Arguments, Result),
  !.
