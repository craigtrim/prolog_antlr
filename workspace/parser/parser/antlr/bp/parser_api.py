#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import json

from pandas import DataFrame
from tabulate import tabulate

IS_DEBUG = True


class ParsePrologAPI(object):

    def __init__(self,
                 is_debug: bool = False):
        self._is_debug = is_debug

    def as_dataframe(self,
                     ast: list,
                     print_output: bool = False) -> DataFrame:
        from parser.ast.svc import GenerateASTDataFrame

        df = GenerateASTDataFrame(ast=ast,
                                  is_debug=self._is_debug).process()
        if type(df) != DataFrame:
            raise ValueError("Expected DataFrame Ouput")

        if print_output:
            print(tabulate(df, tablefmt='psql', headers='keys'))

        return df

    def post_process(self,
                     ast: list,
                     print_output: bool = False) -> list:
        from parser.ast.svc import PostProcessPrologAST

        ast = PostProcessPrologAST(ast=ast,
                                   is_debug=self._is_debug).process()
        if type(ast) != list:
            raise ValueError("Expected List Ouput")

        if print_output:
            print(json.dumps(ast))

        return ast

    def parse(self,
              source_lines: list,
              print_output: bool = False) -> list:
        from parser.antlr.svc import ParsePrologSource
        from parser.antlr.svc import BuildPrologAST

        if type(source_lines) != list:
            raise ValueError("Expected List Input")

        tree = ParsePrologSource(source_lines=source_lines,
                                 is_debug=self._is_debug).process()

        ast = BuildPrologAST(tree=tree,
                             is_debug=self._is_debug).process()
        if type(ast) != list:
            raise ValueError("Expected List Ouput")

        if print_output:
            print(json.dumps(ast))

        return ast


def main():
    source_code = """
        /* animal.pro
          animal identification game.  
        
            start with ?- go.     */
        
        go :- hypothesize(Animal),
              write('I guess that the animal is: '),
              write(Animal),
              nl,
              undo.
        
        /* hypotheses to be tested */
        hypothesize(cheetah)   :- cheetah, !.
        hypothesize(tiger)     :- tiger, !.
        hypothesize(giraffe)   :- giraffe, !.
        hypothesize(zebra)     :- zebra, !.
        hypothesize(ostrich)   :- ostrich, !.
        hypothesize(penguin)   :- penguin, !.
        hypothesize(albatross) :- albatross, !.
        hypothesize(unknown).             /* no diagnosis */
        
        /* animal identification rules */
        cheetah :- mammal, 
                   carnivore, 
                   verify(has_tawny_color),
                   verify(has_dark_spots).
        tiger :- mammal,  
                 carnivore,
                 verify(has_tawny_color), 
                 verify(has_black_stripes).
        giraffe :- ungulate, 
                   verify(has_long_neck), 
                   verify(has_long_legs).
        zebra :- ungulate,  
                 verify(has_black_stripes).
        
        ostrich :- bird,  
                   verify(does_not_fly), 
                   verify(has_long_neck).
        penguin :- bird, 
                   verify(does_not_fly), 
                   verify(swims),
                   verify(is_black_and_white).
        albatross :- bird,
                     verify(appears_in_story_Ancient_Mariner),
                     verify(flys_well).
        
        /* classification rules */
        mammal    :- verify(has_hair), !.
        mammal    :- verify(gives_milk).
        bird      :- verify(has_feathers), !.
        bird      :- verify(flys), 
                     verify(lays_eggs).
        carnivore :- verify(eats_meat), !.
        carnivore :- verify(has_pointed_teeth), 
                     verify(has_claws),
                     verify(has_forward_eyes).
        ungulate :- mammal, 
                    verify(has_hooves), !.
        ungulate :- mammal, 
                    verify(chews_cud).
        
        /* how to ask questions */
        ask(Question) :-
            write('Does the animal have the following attribute: '),
            write(Question),
            write('? '),
            read(Response),
            nl,
            ( (Response == yes ; Response == y)
              ->
               assert(yes(Question)) ;
               assert(no(Question)), fail).
        
        :- dynamic yes/1,no/1.
        
        /* How to verify something */
        verify(S) :-
           (yes(S) 
            ->
            true ;
            (no(S)
             ->
             fail ;
             ask(S))).
        
        /* undo all yes/no assertions */
        undo :- retract(yes(_)),fail. 
        undo :- retract(no(_)),fail.
        undo.
"""
    from grapher.core.bp import GraphvizAPI

    source_lines = [x.strip() for x in source_code.split('\n')]

    parser_api = ParsePrologAPI(is_debug=IS_DEBUG)
    grapher_api = GraphvizAPI(is_debug=IS_DEBUG)

    ast = parser_api.parse(source_lines, print_output=False)
    ast = parser_api.post_process(ast, print_output=True)
    df_ast = parser_api.as_dataframe(ast, print_output=True)

    grapher_api.dot(df_ast)


if __name__ == '__main__':
    main()
