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
        parent("Bill", "John").
        parent("Pam", "Bill").
        father(Person, Father) :- parent(Person, Father), person(Father, "male").
        mother(Person, Mother) :- parent(Person, Mother), person(Mother, "female").
        
        person("Bill", "male").
        person("Pam", "female").
        
        father(person("Bill", "male"), person("John", "male")).
        father(person("Pam", "male"), person("Bill", "male")).
        father(person("Sue", "female"), person("Jim", "male")).
        grandfather(Person, Grandfather) :-
            father(Father, Grandfather),
            father(Person, Father).
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
