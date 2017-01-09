%% Author: James Walker
%% Copyrighted 2016 under the MIT license:
%%   http://www.opensource.org/licenses/mit-license.php
%%
%% Purpose: Assign labels to all of the tokens in the TokenList
%% E.g.,    tokenize_file('input.txt', TokenList),
%%          lexer(TokenList, LexedList).

% Required files
:- consult('tokenizer').

% lexer/2
% lexer(+TokenList, -LexedList).
% Takes in a list of tokens and returns a list of lexemes (i.e., abstract units
% defining the meaning of the token)
lexer([], []).
lexer([Token|TokenList], [Lexeme|LexedList]) :-
  lex_token(Token, Lexeme),
  lexer(TokenList, LexedList).

% lex_token/2
% lex_token(+Token, -Lexeme)
% Definitions of the rules used to creating the lexeme list
lex_token('int',  'TYPE_INT').
lex_token('bool', 'TYPE_BOOL').
lex_token(',',    'COMMA').
lex_token('=',    'ASSIGN').
lex_token('let',  'LET').
lex_token('in',   'LET_IN').
lex_token('if',   'COND_IF').
lex_token('then', 'COND_THEN').
lex_token('else', 'COND_ELSE').
lex_token('==',   'LOGIC_EQ').
lex_token('!=',   'LOGIC_NOT_EQ').
lex_token('>',    'LOGIC_GT').
lex_token('>=',   'LOGIC_GTEQ').
lex_token('+',    'ARITH_ADD').
lex_token('-',    'ARITH_SUB').
lex_token('*',    'ARITH_MUL').
lex_token('/',    'ARITH_DIV').
lex_token('%',    'ARITH_MOD').
lex_token('(',    'OPEN_P').
lex_token(')',    'CLOSE_P').
lex_token(ANY_INTEGER, 'INTEGER') :-
  atom_number(ANY_INTEGER, Number),
  integer(Number).
lex_token(_, 'IDENTIFIER').
