#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import os

from graphviz import Digraph
from pandas import DataFrame
from pandas import Series
from tabulate import tabulate


class GenerateGraphV2(object):
    """

    Reference
        https://github.com/craigtrim/prolog_antlr/issues/9#issuecomment-639106295"""

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

    def _children(self,
                  row: Series) -> DataFrame:
        return self._df_ast[self._df_ast['Parent'] == row['UUID']]

    def _children_by_type(self,
                          row: Series,
                          type_name: str) -> DataFrame:
        return self._df_ast[(self._df_ast['Parent'] == row['UUID']) &
                            (self._df_ast['Type'] == type_name)]

    def _extract_triple(self,
                        row: Series) -> list:
        """
        Purpose:
            Given a 'Compound' row, extract a Triple from the DataFrame
        Sample Input:
            ancestor(Z,Y)
        Sample Output (psudeo-code):
            [   {text: Z, type: Variable, predicate: ancestor},
                {text: Y, type: Variable, predicate: ancestor} ]
        Reference:
            https://github.com/craigtrim/prolog_antlr/issues/9#issuecomment-640114990
        """
        results = []

        df_names = self._children_by_type(row, 'Name')
        if len(df_names) != 1:
            print(tabulate(df_names, headers='keys', tablefmt='psql'))
            raise NotImplementedError("Unexpected Condition")

        predicate = df_names['Text'].unique()[0]

        df_conjunctions = self._children_by_type(row, 'Conjunction')
        if len(df_conjunctions) == 0:
            print(tabulate(df_conjunctions, headers='keys', tablefmt='psql'))
            raise NotImplementedError("Unexpected Condition")

        for _, conjunction_row in df_conjunctions.iterrows():

            df_entities = self._children_by_type(conjunction_row, 'Entity')
            for _, entity_row in df_entities.iterrows():
                results.append({"Text": entity_row['Text'],
                                "Type": 'Entity',
                                "Predicate": predicate,
                                "UUID": entity_row['UUID']})

            df_strings = self._children_by_type(conjunction_row, 'String')
            for _, string_row in df_strings.iterrows():
                results.append({"Text": string_row['Text'],
                                "Type": 'String',
                                "Predicate": predicate,
                                "UUID": string_row['UUID']})

            df_variables = self._children_by_type(conjunction_row, 'Variable')
            for _, variable_row in df_variables.iterrows():
                results.append({"Text": variable_row['Text'],
                                "Type": 'Variable',
                                "Predicate": predicate,
                                "UUID": variable_row['UUID']})

        return results

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

        df_compounds = self._df_ast[self._df_ast['Type'] == 'Compound']
        triples = []
        for _, row in df_compounds.iterrows():
            triples.append(self._extract_triple(row))

        # import json
        # print(json.dumps(triples))

        self._add_nodes(graph, triples)
        self._add_edges(graph, triples)

        graph.save("graph_v2.d", os.environ["PROJECT_BASE"])

        graph.render(os.path.join(os.environ["PROJECT_BASE"],
                                  "resources/output/graph_v2"))

        return graph
