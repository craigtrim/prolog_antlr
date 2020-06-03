#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import os

from graphviz import Digraph
from pandas import DataFrame
from pandas import Series


class GenerateDotGraph(object):
    """ Given a Pandas Dataframe as input
        Generate an AST as a list for output """

    def __init__(self,
                 df_ast: DataFrame,
                 graph_style: str = "prolog",
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
                   graph: Digraph) -> None:
        """
        :param graph:
        """

        def _label(a_row: Series) -> dict:
            row_type = a_row['Type'].lower()
            row_text = a_row['Text']

            if row_type == 'clause':
                return {'type': row_type,
                        'label': 'Clause',
                        'text': row_text}
            elif row_type == 'atomic':
                return {'type': row_type,
                        'label': '',
                        'text': row_text}
            elif row_type == 'binary':
                return {'type': row_type,
                        'label': row_text.upper(),
                        'text': row_text}
            elif row_type == 'string':
                return {'type': row_type,
                        'label': row_text,
                        'text': row_text}
            elif row_type == 'name':
                return {'type': row_type,
                        'label': row_text,
                        'text': row_text}
            elif row_type == 'termlist':
                return {'type': row_type,
                        'label': 'List',
                        'text': row_text}
            elif row_type == 'variable':
                return {'type': row_type,
                        'label': row_text,
                        'text': row_text}

            return {'type': row_type,
                    'label': row_type,
                    'text': row_text}

        def _node_dict() -> dict:
            d = {}

            for _, row in self._df_ast.iterrows():
                d[self._cleanse(row['UUID'])] = _label(row)

            return d

        d_nodes = _node_dict()

        for node_id in d_nodes:
            graph = self._node_generator.process(graph,
                                                 a_node_id=node_id,
                                                 a_node=d_nodes[node_id])

    def _add_edges(self,
                   graph: Digraph) -> None:
        for _, row in self._df_ast.iterrows():

            if not row['Parent']:
                continue
            if not row['UUID']:
                raise ValueError("Missing Expected UUID")

            graph = self._edge_generator.process(graph,
                                                 self._cleanse(row["Parent"]),
                                                 "type-of",
                                                 self._cleanse(row["UUID"]))

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

        self._add_nodes(graph)
        self._add_edges(graph)

        graph.save("graph3.d", os.environ["PROJECT_BASE"])

        graph.render(os.path.join(os.environ["PROJECT_BASE"],
                                  "resources/output/graph3"))

        return graph
