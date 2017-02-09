%% Author: James Walker
%% Copyrighted 2017 under the MIT license:
%%   http://www.opensource.org/licenses/mit-license.php
%%
%% Purpose: Defines a context free grammar that is used to parse the list of
%%          lexed tokens into a structured list. The structured list is then 
%%          used with the initial list of tokens to create a formatted list of 
%%          parsed tokens for the interpreter.
%% E.g.,    tokenize_file('input.txt', TokenList),
%%          lexer(TokenList, LexedList),
%%          parse_list(LexedList, StructuredList),
%%          clean_parsed_list(TokenList, StructuredList, ParsedList).

% Required files
:- consult('tokenizer').
:- consult('lexer').
:- consult('grammar').

% parse_list/2
% parse_list(+LexedList, -StructuredList)
% Creates the StructuredList from the LexedList
parse_list(LexedList, StructuredList) :-
  phrase(program(StructuredList), LexedList, []).

% clean_parsed_list/3
% clean_parsed_list(TokenList, StructuredList, ParsedList)
% Simplifies the call for the clean_parsed_list/4 predicate which uses an extra
% variable for handling the token list
clean_parsed_list(TokenList, StructuredList, ParsedList) :-
  clean_parsed_list(TokenList, StructuredList, ParsedList, _).

% clean_parsed_list/4
% clean_parsed_list(TokenList, StructuredList, ParsedList, ).
% Recurses through structured list and replaces lexeme types with their
% corresponding token
clean_parsed_list(TokenList, [], [], TokenList).
clean_parsed_list(TokenList, [Head|StructuredList], [Parse|ParsedList],
                  NewTokenList) :-
  is_list(Head),
  clean_parsed_list(TokenList, Head, Parse, RemainingTokens),
  clean_parsed_list(RemainingTokens, StructuredList, ParsedList, NewTokenList).
clean_parsed_list([Token|TokenList], [_|StructuredList], [Token|ParsedList],
                  NewTokenList) :-
  clean_parsed_list(TokenList, StructuredList, ParsedList, NewTokenList).

% parse_token_list/2
% parse_token_list(TokenList, ParsedList).
% Simplifies creating the parsed list by wrapping other predicates
parse_token_list(TokenList, ParsedList) :-
  lexer(TokenList, LexedList),
  parse_list(LexedList, StructuredList),
  clean_parsed_list(TokenList, StructuredList, ParsedList).
