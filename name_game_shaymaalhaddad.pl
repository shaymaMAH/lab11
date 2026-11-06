% name_game.pl - Lab 9: the "Name Game"
% Run with:  ?- start.
% Type every answer followed by a full stop, e.g.  1.   or   m.

% The letters live in the database, so they can change at run time.
:- dynamic letter/1.

% The starting set of letters
letter(a).
letter(b).
letter(c).

% ---------- start ----------
start :-
    nl,
    write('Hi, This is the "Name Game".'), nl,
    write('You will be given a set of English letters in which you will add, delete or move to create your name.'), nl,
    menu.

% ---------- menu ----------
menu :-
    nl,
    write('Choose from the following:'), nl,
    write('1- Display the current set of letters'), nl,
    write('2- Add a letter'), nl,
    write('3- Add a letter at the top'), nl,
    write('4- Add a letter at the bottom'), nl,
    write('5- Delete a letter'), nl,
    write('6- Delete all letters'), nl,
    write('7- Move a letter'), nl,
    write('8- Exit'), nl,
    write('Enter your choice....'), nl,
    read(Choice),
    do(Choice).

% ---------- actions ----------

% 1- display the letters (in order)
do(1) :-
    findall(L, letter(L), Letters),
    write('Current letters: '), write(Letters), nl,
    menu.

% 2- add a letter (assert = adds it as the last clause)
do(2) :-
    write('Enter the letter to add: '), nl,
    read(L),
    assert(letter(L)),
    write('The letter has been added.'), nl,
    menu.

% 3- add a letter at the top (asserta = first clause)
do(3) :-
    write('Enter the letter to add at the top: '), nl,
    read(L),
    asserta(letter(L)),
    write('The letter has been added at the top.'), nl,
    menu.

% 4- add a letter at the bottom (assertz = last clause)
do(4) :-
    write('Enter the letter to add at the bottom: '), nl,
    read(L),
    assertz(letter(L)),
    write('The letter has been added at the bottom.'), nl,
    menu.

% 5- delete a letter (retract removes the first match, fails if none)
do(5) :-
    write('Enter the letter to delete: '), nl,
    read(L),
    (   retract(letter(L))
    ->  write('The letter has been deleted.'), nl
    ;   write('This letter is not in the set.'), nl
    ),
    menu.

% 6- delete all letters (retractall always succeeds)
do(6) :-
    retractall(letter(_)),
    write('All letters have been deleted.'), nl,
    menu.

% 8- exit
do(8) :-
    write('Goodbye!'), nl.

% 7- move a letter to a new position
do(7) :-
    write('Enter the letter to move: '), nl,
    read(L),
    findall(X, letter(X), Letters),
    (   select(L, Letters, Rest)            % take the letter out (first match)
    ->  write('Enter the new position (1 = top): '), nl,
        read(N),
        length(Rest, Len),
        Max is Len + 1,
        (   integer(N), N >= 1, N =< Max
        ->  nth1(N, NewLetters, L, Rest),   % put it back at position N
            retractall(letter(_)),
            forall(member(Y, NewLetters), assertz(letter(Y))),
            write('The letter has been moved.'), nl
        ;   write('Invalid position.'), nl
        )
    ;   write('This letter is not in the set.'), nl
    ),
    menu.

% anything else
do(_) :-
    write('Invalid choice, please enter a number from 1 to 8.'), nl,
    menu.
