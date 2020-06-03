#!/usr/bin/env python
# -*- coding: UTF-8 -*-



import json
from pandas import DataFrame


class ParsePrologAPI(object):

    def __init__(self):
        pass

    @staticmethod
    def parse(source_lines: list,
              as_dataframe: bool = False) -> list or DataFrame:
        from parser.svc import ParsePrologSource
        from parser.svc import BuildPrologAST
        from parser.svc import GeneratePandasDataFrame

        if type(source_lines) != list:
            raise ValueError("Expected List Input")

        tree = ParsePrologSource(source_lines=source_lines).process()

        ast = BuildPrologAST(tree=tree).process()
        if type(ast) != list:
            raise ValueError("Expected List Ouput")

        print (json.dumps(ast))

        if not as_dataframe:
            return ast

        df = GeneratePandasDataFrame(ast=ast).process()
        if type(df) != DataFrame:
            raise ValueError("Expected DataFrame Ouput")

        return df


def main():
    source_code = """
        parent("Bill", "John").
        parent("Pam", "Bill").
    """

    source_lines = [x.strip() for x in source_code.split('\n')]

    tree = ParsePrologAPI.parse(source_lines)
    print(type(tree))

    import pprint
    pprint.pprint(tree, indent=4)


if __name__ == '__main__':
    main()
