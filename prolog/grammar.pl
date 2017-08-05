/*************************************************************************

    File: grammar.pl
    Copyright (C) 2017, Michael White

    This file accompanies dycccg.pl, which makes use of BB1, and shares
    the same license.

    BB1 is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    BB1 is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with BB1; if not, write to the Free Software Foundation, Inc.,
    59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

*************************************************************************/

:- module(grammar,[typeraise/3,lexclass/3]).


/*========================================================================
   Type Raising (grammar specific)
========================================================================*/

%                 np : X : e
% ----------------------------------------
% s/(s\np) : lam P . (P X) : (e -> t) -> t
typeraise(cat(Cat1,Sem1,Type1),cat(Cat,Sem,Type),Op) :-
	Cat1=np, Cat=fslash(s,bslash(s,np)),
	Sem=lam(P,app(P,Sem1)),
	Type1=e, Type=to(to(e,t),t),
	Op = ['T>'].


/*========================================================================
   Proper Names
========================================================================*/

lexclass(pn,Pred,cat(np,Pred,e)).


/*========================================================================
   Intransitive Verbs
========================================================================*/

% nb: agreement not handled
lexclass(iv,Pred,cat(bslash(s,np),lam(X,Prop),to(e,t))) :-
	Prop =.. [Pred,X].


/*========================================================================
   Transitive Verbs
========================================================================*/

lexclass(tv,Pred,cat(fslash(bslash(s,np),np),lam(Y,lam(X,Prop)),to(e,to(e,t)))) :-
	 Prop =.. [Pred,X,Y].


/*========================================================================
   Ditransitive Verbs
========================================================================*/

lexclass(dtv,Pred,
	 cat(fslash(fslash(bslash(s,np),np),np),
	     lam(Y,lam(Z,lam(X,Prop))),
	     to(e,to(e,to(e,t))))) :-
	Prop =.. [Pred,X,Y,Z].


/*========================================================================
   Ditransitive + PP[for] Verbs
========================================================================*/

lexclass(dtv_for,Pred,
	 cat(fslash(fslash(fslash(bslash(s,np),pp_for),np),np),
	     lam(Y,lam(Z,lam(W,lam(X,Prop)))),
	     to(e,to(e,to(e,to(e,t)))))) :-
	Prop =.. [Pred,X,Y,Z,W].


/*========================================================================
   Nouns
========================================================================*/

% nb: plurals not treated seriously, just there to go with 'most'
lexclass(n,Pred,cat(n,lam(X,Prop),to(e,t))) :-
	Prop =.. [Pred,X].


/*========================================================================
   Relational Nouns
========================================================================*/

% e.g. 'friend of Y'
lexclass(rn,Pred,
	 cat(fslash(n,pp_of),
	     lam(Y,lam(X,Prop)),
	   to(e,to(e,t)))) :-
	Prop =.. [Pred,X,Y].


/*========================================================================
   Adjectives (attributive)
========================================================================*/

lexclass(adj,Pred,
	 cat(fslash(n,n),lam(P,lam(X,and(app(P,X),Prop))),
	     to(to(e,t),to(e,t)))) :-
	Prop =.. [Pred,X].


/*========================================================================
   Prepositions
========================================================================*/

% regular prep
lexclass(prep,Pred,
	 cat(fslash(bslash(n,n),np),
	     lam(Y,lam(P,lam(X,and(app(P,X),Prop)))),
	     to(e,to(to(e,t),to(e,t))))) :-
	Prop =.. [Pred,X,Y].


/*========================================================================
   Case-Marking Prepositions
========================================================================*/

% adds prep to target cat, e.g. pp_of
lexclass(case_prep,Prep,cat(fslash(Target,np),lam(X,X),to(e,e))) :-
	concat('pp_',Prep,Target).



