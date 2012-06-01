!SLIDE bullets
# Declarative Programming #

* SQL, XSLT, SPARQL, Pig

.notes Next: sql? xslt?

!SLIDE bullets incremental

* Did the last slide just say SQL and XSLT?

* Seriously?

.notes Next: can be fun

!SLIDE bullets incremental

* declarative programming can be fun

* Prolog, Erlang

.notes Next: prolog

!SLIDE
![prolog](prolog.jpg)

.notes Next: aaron

!SLIDE
![Aaron](aaron-1.jpg)

.notes Next: fact

!SLIDE

    @@@ prolog
    ruby_core(tenderlove).
    
    ?- ruby_core(tenderlove).
    Yes
    
    ?- ruby_core(X).
    X = tenderlove

.notes Next: rule

!SLIDE

    @@@ prolog
    ruby_core(tenderlove).
    rails_core(tenderlove).

    ubercore(X) :-
      ruby_core(X), rails_core(X).

    ?- ubercore(X).
    X = tenderlove

.notes Next: car & cdr

!SLIDE

## Prolog is Lisp, kinda

    @@@ prolog
    car([H|_], H).
    cdr([_|T], T).

    ?- car([1, 2, 3], X).
    X = 1


    ?- cdr([1, 2, 3], X).
    X = [2, 3]

.notes Next: sorting

!SLIDE

## Sort a list

    @@@ prolog
    sorted([]).
    sorted([_]).
    sorted([X,Y|T]) :-
      X =< Y, sorted([Y|T]).

    sort(X,Y) :-
      perm(X,Y), sorted(Y).

.notes Next: mind blown