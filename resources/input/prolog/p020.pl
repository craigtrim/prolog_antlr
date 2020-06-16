%https://github.com/craigtrim/prolog_antlr/issues/9#issuecomment-639981372

label(analysis_skill, "Analysis Skill").
label(business_analysis_skill, "Business Analysis Skill").

parent(analysis_skill, skill).
parent(business_analysis_skill, analysis_skill).

ancestor(X,Y):-
    parent(X,Y).   		/* someone is your ancestor if there are your parent */
ancestor(X,Y):-
    parent(X,Z), 		/* or somebody is your ancestor if they are the parent */
    ancestor(Z,Y). 		/* of someone who is your ancestor */
