#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import json
import os

from graphviz import Digraph
from pandas import DataFrame


class GenerateGraphV2(object):
    """

    Reference
        https://github.com/craigtrim/prolog_antlr/issues/9#issuecomment-639106295"""

    def __init__(self,
                 df_ast: DataFrame,
                 graph_style: str = "GV2",
                 is_debug: bool = True):
        """
        Created:
            2-June-2020
            craig.trim@ibm.com
            *   https://github.com/craigtrim/prolog_antlr/issues/2
        """
        from grapher.core.dmo import GraphStyleLoader
        from grapher.core.dmo import NodeStyleMatcher
        from grapher.core.dmo import DigraphNodeGenerator
        from grapher.core.dmo import DigraphEdgeGenerator

        self._df_ast = df_ast
        self._is_debug = is_debug

        self._style_loader = GraphStyleLoader(style_name=graph_style,
                                              is_debug=self._is_debug)

        self._node_style_matcher = NodeStyleMatcher(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

        self._node_generator = DigraphNodeGenerator(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

        self._edge_generator = DigraphEdgeGenerator(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

    def _iter(self,
              items: list):
        pass

    @staticmethod
    def _cleanse(a_uuid: str) -> str:
        return f"UUID_{a_uuid.replace('-', '_').upper()}"

    def _add_nodes(self,
                   graph: Digraph,
                   triples: list) -> None:
        """
        :param graph:
        """

        for triple in triples:
            for d_node in triple:
                graph = self._node_generator.process(
                    graph=graph,
                    a_node_id=self._cleanse(d_node['UUID']),
                    a_node={"label": d_node['Text'],
                            "text": d_node['Text'],
                            "type": d_node['Type']})

    def _add_edges(self,
                   graph: Digraph,
                   triples: list) -> None:

        for triple in triples:
            if len(triple) != 2:
                raise NotImplementedError("Unhandled Triple Style")

            subj = triple[0]
            obj = triple[1]

            graph = self._edge_generator.process(graph,
                                                 self._cleanse(subj["UUID"]),
                                                 subj["Predicate"],
                                                 self._cleanse(obj["UUID"]))

    def _triples(self,
                 dump_json: bool = False) -> list:
        """
        Purpose:
            Extract Triples from AST Compound Formations
        Reference:
            https://github.com/craigtrim/prolog_antlr/issues/9#issuecomment-640114990
        """
        from grapher.core.dmo import CompoundTripleExtractor

        triples = []
        triple_extractor = CompoundTripleExtractor(df_ast=self._df_ast,
                                                   is_debug=self._is_debug)

        df_compounds = self._df_ast[self._df_ast['Type'] == 'Compound']
        for _, row in df_compounds.iterrows():
            triples.append(triple_extractor.process(row))

        if dump_json:
            print(json.dumps(triples))

        return triples

    def process(self,
                file_name: str,
                engine: str,
                file_extension: str = "png") -> Digraph:

        graph = Digraph(engine=engine,
                        comment='Schema',
                        format=file_extension,
                        name=file_name)

        graph.attr('node',
                   **self._node_style_matcher.default_node_style())

        triples = self._triples()

        self._add_nodes(graph, triples)
        self._add_edges(graph, triples)

        graph.save("graph_v2.d", os.environ["PROJECT_BASE"])

        graph.render(os.path.join(os.environ["PROJECT_BASE"],
                                  "resources/output/graph_v2"))

        return graph
