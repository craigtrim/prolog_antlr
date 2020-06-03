#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from pandas import DataFrame


class GraphvizAPI(object):

    def __init__(self,
                 is_debug: bool = False):
        self._is_debug = is_debug

    def dot(self,
            df_ast: DataFrame):
        from grapher.core.svc import GenerateDotGraph

        GenerateDotGraph(df_ast=df_ast,
                         graph_style="nlp").process(file_name="output",
                                                    engine="dot")
