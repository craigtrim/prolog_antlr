#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from pandas import DataFrame


class GraphvizAPI(object):

    def __init__(self,
                 is_debug: bool = False):
        self._is_debug = is_debug

    def graph_v1(self,
                 df_ast: DataFrame,
                 file_name: str):
        """
        Purpose:
            Generates a DOT graph, somewhat summarized, but generally faithful to the AST
        Reference (sample visual):
            https://github.com/craigtrim/prolog_antlr/issues/5#issuecomment-638597971
        """
        from plgraph.core.svc import GenerateGraphV1

        gen = GenerateGraphV1(df_ast=df_ast,
                              is_debug=self._is_debug)

        gen.process(file_name=file_name,
                    engine="dot")

    def graph_v2(self,
                 df_ast: DataFrame,
                 file_name: str):
        """
        Purpose:

        Reference (sample visual):
            https://github.com/craigtrim/prolog_antlr/issues/9#issuecomment-639106295
        """
        from plgraph.core.svc import GenerateGraphV2

        gen = GenerateGraphV2(df_ast=df_ast,
                              is_debug=self._is_debug)

        gen.process(file_name=file_name,
                    engine="dot")
