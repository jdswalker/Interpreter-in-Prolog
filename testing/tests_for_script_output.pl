%% Author: James Walker
%% Copyrighted 2017 under the MIT license:
%%   http://www.opensource.org/licenses/mit-license.php
%%
%% Purpose: Predicates for running tests with the provided scripts

% Required files/library
:- consult('../src/language_executor.pl').

% test_all/0
% test_all.
% Runs every test script with various inputs to test the interpreters outputs.
test_all_scripts :-
  nl,
  writeln('*** STARTING INTERPRETER OUTPUT TESTING ***'),
  test_script_1,
  test_script_2,
  test_script_3,
  test_script_4,
  test_script_5,
  test_script_6,
  nl,
  writeln('*** INTERPRETER OUTPUT TESTING COMPLETE ***\n').

% test_script_1/0
% test_script_1.
% Runs tests for the first input file which adds 1 to the input.
test_script_1 :-
  Test_Script = 'test1.txt',
  starting_output_test_with(Test_Script),
  run_program(Test_Script, [-2], -1),
  run_program(Test_Script, [-1],  0),
  run_program(Test_Script,  [0],  1),
  run_program(Test_Script,  [1],  2),
  finished_output_test_with(Test_Script).

% test_script_2/0
% test_script_2.
% Runs tests for the second input file which subtracts two numbers.
test_script_2 :-
  Test_Script = 'test2.txt',
  starting_output_test_with(Test_Script),
  run_program(Test_Script, [-1, -2],  1),
  run_program(Test_Script, [-1,  2], -3),
  run_program(Test_Script,  [1, -2],  3),
  run_program(Test_Script,  [1,  2], -1),
  finished_output_test_with(Test_Script).

% test_script_3/0
% test_script_3.
% Runs tests for the third input file which multiplies the input by 3.
test_script_3 :-
  Test_Script = 'test3.txt',
  starting_output_test_with(Test_Script),
  run_program(Test_Script, [-3], -9),
  run_program(Test_Script,  [0],  0),
  run_program(Test_Script,  [3],  9),
  run_program(Test_Script,  [6], 18),
  finished_output_test_with(Test_Script).

% test_script_4/0
% test_script_4.
% Runs tests for the fourth input file which adds 10 if the input is 4, and
% returns 4 if the input anything other than 4.
test_script_4 :-
  Test_Script = 'test4.txt',
  starting_output_test_with(Test_Script),
  run_program(Test_Script, [-4],  4),
  run_program(Test_Script,  [0],  4),
  run_program(Test_Script,  [4], 14),
  run_program(Test_Script,  [8],  4),
  finished_output_test_with(Test_Script).

% test_script_5/0
% test_script_5.
% Runs tests for the fifth input file which uses addition, subtraction, 
% multiplication, division, and modulus operators.
test_script_5 :-
  Test_Script = 'test5.txt',
  starting_output_test_with(Test_Script),
  run_program(Test_Script, [-5],    -3),
  run_program(Test_Script,  [0], 10007),
  run_program(Test_Script,  [5],     2),
  run_program(Test_Script, [10],     7),
  finished_output_test_with(Test_Script).

% test_script_6/0
% test_script_6.
% Runs tests for the sixth input file which defines functions with Boolean
% return values and uses the ==, !=, <, <=, > and >= comparison operators.
test_script_6 :-
  Test_Script = 'test6.txt',
  starting_output_test_with(Test_Script),
  run_program(Test_Script, [-6, -6],  0),
  run_program(Test_Script, [-6,  6], -1),
  run_program(Test_Script,  [6, -6],  3),
  run_program(Test_Script,  [6,  6],  0),
  finished_output_test_with(Test_Script).

starting_output_test_with(Test_Script_File_Name) :-
  nl,
  write('*** Testing Interpretor Output using '),
  write(Test_Script_File_Name),
  writeln(' ***').

finished_output_test_with(Test_Script_File_Name) :-
  write('*** Interpretor Output Testing with '),
  write(Test_Script_File_Name),
  writeln(' is complete ***').
