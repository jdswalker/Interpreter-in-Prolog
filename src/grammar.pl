%% Author: James Walker
%% Copyrighted 2016 under the MIT license:
%%   http://www.opensource.org/licenses/mit-license.php
%%
%% Purpose: Defines a context free grammar that is used to create the parsed
%%          list of tokens used by the interpreter.

program(FunctionList) -->
  functionList(FunctionList).

functionList([Function|FunctionListCollection]) -->
  function(Function), functionListCollection(FunctionListCollection).

functionListCollection(FunctionListCollection) -->
  functionList(FunctionListCollection).
functionListCollection([]) --> [].

function([TypeID, '(', TypeIDList, ')', '=', Expression]) -->
  typeID(TypeID),
  ['OPEN_P'],
  typeIDList(TypeIDList),
  ['CLOSE_P'],
  ['ASSIGN'],
  expression(Expression).

typeID(['int', '?']) -->
  ['TYPE_INT'],
  ['IDENTIFIER'].
typeID(['bool', '?']) -->
  ['TYPE_BOOL'],
  ['IDENTIFIER'].

typeIDList([TypeID, TypeIDListCollection]) -->
  typeID(TypeID),
  typeIDListCollection(TypeIDListCollection).

typeIDListCollection([',', TypeIDList]) -->
  ['COMMA'],
  typeIDList(TypeIDList).
typeIDListCollection([]) --> [].

expression(['if', Comparison, 'then', ValueIfTrue, 'else', ValueIfFalse]) -->
  ['COND_IF'],
  comparison(Comparison),
  ['COND_THEN'],
  value(ValueIfTrue),
  ['COND_ELSE'],
  value(ValueIfFalse).
expression(['let', _, '=', Value, 'in', Expression]) -->
  ['LET'],
  ['IDENTIFIER'],
  ['ASSIGN'],
  value(Value),
  ['LET_IN'],
  expression(Expression).
expression([Value, Expression]) -->
  value(Value),
  extraExpression(Expression).

extraExpression([Arithmetic]) -->
  arithmetic(Arithmetic).
extraExpression([]) --> [].

arithmetic(['+', Value]) -->
  ['ARITH_ADD'],
  value(Value).
arithmetic(['-', Value]) -->
  ['ARITH_SUB'],
  value(Value).

comparison([Value, Comparison]) -->
  value(Value),
  comparisonRight(Comparison).

comparisonRight(['==', Value]) -->
  ['LOGIC_EQ'],
  value(Value).
comparisonRight(['!=', Value]) -->
  ['LOGIC_NOT_EQ'],
  value(Value).
comparisonRight(['>', Value]) -->
  ['LOGIC_GT'],
  value(Value).
comparisonRight(['>=', Value]) -->
  ['LOGIC_GTEQ'],
  value(Value).

value([integer]) -->
  ['INTEGER'].
value(['?', ValueParameters]) -->
  ['IDENTIFIER'],
  valueParameters(ValueParameters).

valueParameters(['(', Parameters, ')']) -->
  ['OPEN_P'],
  parameters(Parameters),
  ['CLOSE_P'].
valueParameters([]) --> [].

parameters([Value, ParametersList]) -->
  value(Value),
  parametersList(ParametersList).

parametersList([',', Parameters]) -->
  ['COMMA'],
  parameters(Parameters).
parametersList([]) --> [].
