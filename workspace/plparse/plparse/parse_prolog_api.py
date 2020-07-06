#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import json

from pandas import DataFrame
from tabulate import tabulate

IS_DEBUG = True


class ParsePrologAPI(object):
    """ API for Prolog Parse Operations """

    def __init__(self,
                 is_debug: bool = False):
        self._is_debug = is_debug

    def as_dataframe(self,
                     ast: list) -> DataFrame:
        """

        @param ast:
        @return:
        """
        from plparse.postprocess.svc import GenerateASTDataFrame

        df = GenerateASTDataFrame(ast=ast,
                                  is_debug=self._is_debug).process()
        if type(df) != DataFrame:
            raise ValueError("Expected DataFrame Ouput")

        if self._is_debug:
            print(tabulate(df, tablefmt='psql', headers='keys'))

        return df

    def post_process(self,
                     ast: list) -> list:
        """

        @param ast:
        @return:
        """
        from plparse.postprocess.svc import PostProcessPrologAST

        ast = PostProcessPrologAST(ast=ast,
                                   is_debug=self._is_debug).process()
        if type(ast) != list:
            raise ValueError("Expected List Ouput")

        if self._is_debug:
            print(json.dumps(ast))

        return ast

    def parse(self,
              source_lines: list) -> list:
        """

        @param source_lines:
        @return:
        """
        from plparse.preprocess.svc import PreprocessPrologSource
        from plparse.antlr.svc import ParsePrologSource
        from plparse.antlr.svc import BuildPrologAST

        if type(source_lines) != list:
            raise ValueError("Expected List Input")

        source_lines = PreprocessPrologSource(source_lines=source_lines,
                                              is_debug=self._is_debug).process()

        tree = ParsePrologSource(source_lines=source_lines,
                                 is_debug=self._is_debug).process()

        ast = BuildPrologAST(tree=tree,
                             is_debug=self._is_debug).process()
        if type(ast) != list:
            raise ValueError("Expected List Ouput")

        # if self._is_debug:
        #     print(json.dumps(ast))

        return ast
