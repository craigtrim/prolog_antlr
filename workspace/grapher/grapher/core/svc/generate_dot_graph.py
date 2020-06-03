#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import os

from graphviz import Digraph
from pandas import DataFrame


class GenerateDotGraph(object):
    """ Given a Pandas Dataframe as input
        Generate an AST as a list for output """

    def __init__(self,
                 df_ast: DataFrame,
                 graph_style: str = "nlp",
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
    def _cleanse_uuid(a_uuid: str) -> str:
        return f"UUID_{a_uuid.replace('-', '_').upper()}"

    def _add_nodes(self,
                   graph: Digraph) -> None:
        """
        :param graph:
        """

        def _schema_elements() -> list:
            s = set()
            [s.add(self._cleanse_uuid(x)) for x in self._df_ast['UUID'].unique()]
            return sorted(s)

        for schema in _schema_elements():
            graph = self._node_generator.process(graph,
                                                 a_node_name=schema,
                                                 a_node_type="schema",
                                                 is_primary=True,
                                                 is_variant=False)

        # for _, row in self._df_ast.iterrows():
        #     graph = self._node_generator.process(graph,
        #                                          a_node_name=row["ExplicitTag"],
        #                                          a_node_type="tag",
        #                                          is_primary=True,
        #                                          is_variant=False)
        #
        #     graph = self._node_generator.process(graph,
        #                                          a_node_name=row["ImplicitTag"],
        #                                          a_node_type="tag",
        #                                          is_primary=False,
        #                                          is_variant=row["Relationship"] == "Variant")

    def _add_edges(self,
                   graph: Digraph) -> None:
        for _, row in self._df_ast.iterrows():
            graph = self._edge_generator.process(graph,
                                                 self._cleanse_uuid(row["UUID"]),
                                                 "type-of",
                                                 self._cleanse_uuid(row["Parent"]))

            # graph = self._edge_generator.process(graph,
            #                                      row["ImplicitTag"],
            #                                      "type-of",
            #                                      row["ImplicitSchema"])
            #
            # graph = self._edge_generator.process(graph,
            #                                      row["ExplicitTag"],
            #                                      row["Relationship"],
            #                                      row["ImplicitTag"])

    def process(self,
                file_name: str,
                engine: str = "fdp",
                file_extension: str = "png") -> Digraph:
        graph = Digraph(engine=engine,
                        comment='Schema',
                        format=file_extension,
                        name=file_name)

        graph.attr('node',
                   **self._node_style_matcher.default_node_style())

        self._add_nodes(graph)
        self._add_edges(graph)

        graph.render(os.path.join(os.environ["PROJECT_BASE"],
                                  "resources/output/graph.png"))

        return graph
