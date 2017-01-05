%% Author: James Walker
%% Copyrighted 2016 under the MIT license:
%%   http://www.opensource.org/licenses/mit-license.php
%%
%% Purpose: Executes functions from the symbol table based on the integer
%%          arguments provided
%% E.g.,    call_function(FunctionName, Arguments, Result).

% Required files/library
:- consult('symbol_table').

% call_function/3
% call_function(+FunctionName, +Arguments, ?Result).
% Retrieves the function from the symbol table, executes it, and returns a
% result
call_function(FunctionName, Arguments, Result) :-
  get_symbol(FunctionName, [ReturnType, Parameters, FunctionBody]),
  check_parameter_types(Parameters, Arguments, ParameterList),
  expression_handler(FunctionBody, Result),
  type_handler(ReturnType, Result),
  remove_symbols(ParameterList).

% check_parameter_types/3
% check_parameter_types(+Parameters, +Arguments, ?ParameterList).
% Checks whether the arguments provided match the expected input for the
% function and verifies that each value in the Arguments list has an integer
% value that is of the same type (bool or int) as the corresponding parameter
% type from the function data and adds it to the symbol table
check_parameter_types([], [], []).
check_parameter_types([[Type, Identifier],[]], [Value], [Identifier]) :-
  type_handler(Type, Value),
  add_symbol(Identifier, Value).
check_parameter_types([[Type, Identifier],[',', Parameters]],
                      [Value,[',',Arguments]], [Identifier|ParameterList]) :-
  type_handler(Type, Value),
  add_symbol(Identifier, Value),
  check_parameter_types(Parameters, Arguments, ParameterList).

% expression_handler/2
% expression_handler(+Expression, ?Result).
% Parses expressions based on the context-free grammar defined in grammar.pl
expression_handler(['if', Comparison, 'then', ValueIfTrue, 'else',
                   ValueIfFalse], Result) :-
  comparison_handler(Comparison, ComparisonResult),
  (ComparisonResult == 0 -> evaluate(ValueIfTrue, Result)
                            ;
                            evaluate(ValueIfFalse, Result)).
expression_handler(['let', Identifier, '=', Value, 'in', Expression], Result) :-
  value_handler(Value, NewValue),
  add_symbol(Identifier, NewValue),
  expression_handler(Expression, Result),
  remove_symbol(Identifier).
expression_handler([Value, [Expression]], Result) :-
  value_handler(Value, NewValue),
  extra_expression_handler(Expression, ExpressionResult),
  evaluate(NewValue, ExpressionResult, Result).
expression_handler([[FunctionName, ['(', Arguments, ')']], []], Result) :- 
  call_function(FunctionName, Arguments, Result).

% extra_expression_handler/2
% extra_expression_handler(+Expression, ?Result).
% Parses addition terms in an expression based on the context-free grammar
% defined in grammar.pl
extra_expression_handler([], []).
extra_expression_handler([Operator, Expression], Result) :-
  arithmetic_handler([Operator, Expression], Result).
  
% arithmetic_handler/2
% arithmetic_handler(+Expression, ?Result).
% Evaluates an arithmetic term in an expression before returning the expression
arithmetic_handler([Operator, Term], [Operator, Value]) :-
  value_handler(Term, Value).

% comparison_handler/2
% comparison_handler(+Expression, ?Result).
% Evaluates comparisons between terms in an expression before returning the
% expression
comparison_handler([Term1, [Operator, Term2]], Result) :-
  value_handler(Term1, Value1),
  value_handler(Term2, Value2),
  evaluate([Value1, Operator, Value2], Result).

% value_handler/2
% value_handler(+Expression, ?Result)
% Evaluates terms in an expression and unifies with their value
value_handler([Number], Result) :-
  atom(Number),
  atom_number(Number, Result).
value_handler([Result], Result).
value_handler([Identifier, []], Result) :-
  get_symbol(Identifier, Result).
value_handler([Identifier, Parameters], Result) :-
  value_parameter_handler(Parameters, ParameterList),
  call_function(Identifier, ParameterList, Result).

% value_parameter_handler/2
% value_parameter_handler(+Expression, ?Result).
% Evaluates parameter in an expression and unifies with the parameter value
value_parameter_handler([], []).
value_parameter_handler(['(', Parameters, ')'], Result) :-
  parameter_handler(Parameters, Result).

% parameter_handler/2
% parameter_handler(+Expression, ?Result).
% Evaluates parameters from an expression sequentially using recursive calls
parameter_handler([Value, ParametersList], [NewValue|NewParameterList]) :-
  value_handler(Value, NewValue),
  parameter_list_handler(ParametersList, NewParameterList).

% parameter_list_handler/2
% parameter_list_handler(+Expression, ?Result).
% If the head of a parameter list is a comma, it is ignored and the next
% parameter is parsed
parameter_list_handler([], []).
parameter_list_handler([',', Parameters], Result) :-
  parameter_handler(Parameters, Result).

% type_handler/2
% type_handler(+Type, ?Result).
% Checks if the return type for the function is correct
type_handler(Type, [Value]) :- 
  type_handler(Type, Value).
type_handler(Type, [Identifier, []]) :-
  value_handler([Identifier, []], Value),
  type_handler(Type, Value).
type_handler('int', Value) :-
  integer(Value).
type_handler('bool', 0).
type_handler('bool', 1).

% evaluate/3
% evaluate(+Value, +OpValue,  ?Result).
% Evaluates the value provided with the next part and returns the result
evaluate(Value1, ['+', Value2], Result) :-
  Result is Value1 + Value2.
evaluate(Value1, ['-', Value2], Result) :-
  Result is Value1 - Value2.
evaluate(Value1, ['==', Value2], Result) :-
  (Value1 == Value2 -> Result is 0
                       ;
                       Result is 1).
evaluate(Value1, ['!=', Value2], Result) :-
  (Value1 \== Value2 -> Result is 0
                        ;
                        Result is 1).
evaluate(Value1, ['>', Value2], Result) :-
  (Value1 @> Value2 -> Result is 0
                       ;
                       Result is 1).
evaluate(Value1, ['>=', Value2], Result) :-
  (Value1 @>= Value2 -> Result is 0
                        ;
                        Result is 1).
