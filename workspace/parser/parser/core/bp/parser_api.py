#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import json

from pandas import DataFrame
from tabulate import tabulate


class ParsePrologAPI(object):

    def __init__(self):
        pass

    @staticmethod
    def as_dataframe(ast: list,
                     print_output: bool = False) -> DataFrame:
        from parser.core.svc import GeneratePandasDataFrame

        df = GeneratePandasDataFrame(ast=ast).process()
        if type(df) != DataFrame:
            raise ValueError("Expected DataFrame Ouput")

        if print_output:
            print(tabulate(df, tablefmt='psql', headers='keys'))

        return df

    @staticmethod
    def parse(source_lines: list,
              print_output: bool = False) -> list:
        from parser.core.svc import ParsePrologSource
        from parser.core.svc import BuildPrologAST

        if type(source_lines) != list:
            raise ValueError("Expected List Input")

        tree = ParsePrologSource(source_lines=source_lines).process()

        ast = BuildPrologAST(tree=tree).process()
        if type(ast) != list:
            raise ValueError("Expected List Ouput")

        if print_output:
            print(json.dumps(ast))

        return ast


def main():

    source_code = """
        parent("Bill", "John").
        parent("Pam", "Bill").
    """

    source_lines = [x.strip() for x in source_code.split('\n')]

    ast = ParsePrologAPI.parse(source_lines, print_output=True)
    df_ast = ParsePrologAPI.as_dataframe(ast, print_output=True)

    from grapher.core.bp import GraphvizAPI

    GraphvizAPI.dot(df_ast)


if __name__ == '__main__':
    main()
