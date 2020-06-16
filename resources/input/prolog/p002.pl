% MORTAL - The first illustrative Prolog program
% Merritt, Dennis. Adventure in Prolog (pp. 14-15). Kindle Edition.

mortal(X) :- person(X).

person(socrates).
person(plato).
person(aristotle).

mortal_report :-
    write('Known mortals are:'),nl,
    mortal(X),
    write(X),nl,
    fail.

