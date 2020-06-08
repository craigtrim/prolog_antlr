#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import json

from graphviz import Digraph
from pandas import DataFrame


class GenerateCompoundTriples(object):
    """ Extract Triples from AST Compound Formations and add to the Graph

     Reference:
        https://github.com/craigtrim/prolog_antlr/issues/10
    """

    def __init__(self,
                 graph: Digraph,
                 df_ast: DataFrame,
                 graph_style: str = "gv2",
                 is_debug: bool = True):
        """
        Created:
            8-June-2020
            craig.trim@ibm.com
            *   Refactored out of 'generate-graph-v2'
                https://github.com/craigtrim/prolog_antlr/issues/10
        """
        from grapher.core.dmo import GraphStyleLoader
        from grapher.core.dmo import DigraphNodeGenerator
        from grapher.core.dmo import DigraphEdgeGenerator

        self._graph = graph
        self._df_ast = df_ast
        self._is_debug = is_debug

        self._style_loader = GraphStyleLoader(style_name=graph_style,
                                              is_debug=self._is_debug)

        self._node_generator = DigraphNodeGenerator(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

        self._edge_generator = DigraphEdgeGenerator(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

    def _extract_triples(self) -> list:
        from grapher.core.dmo import CompoundTripleExtractor

        triples = []
        triple_extractor = CompoundTripleExtractor(df_ast=self._df_ast,
                                                   is_debug=self._is_debug)

        df_compounds = self._df_ast[self._df_ast['Type'] == 'Compound']
        for _, row in df_compounds.iterrows():
            triples.append({
                "Compound": {
                    'UUID': row['UUID'],
                    'Text': row['Text']},
                "Triple": triple_extractor.process(row)})

        if self._is_debug:
            print(json.dumps(triples))

        return triples

    def _add_triples(self,
                     triples: list) -> None:
        from grapher.core.dmo import CompoundTripleGrapher

        triple_grapher = CompoundTripleGrapher(is_debug=self._is_debug)

        d_nodes, edges = triple_grapher.process(compound_triples=triples)

        for k in d_nodes:
            self._graph = self._node_generator.process(graph=self._graph,
                                                       a_node_id=k,
                                                       a_node=d_nodes[k])

        for edge in edges:
            self._graph = self._edge_generator.process(self._graph,
                                                       edge['subject'],
                                                       edge['predicate'],
                                                       edge['object'])

    def process(self) -> (Digraph, list):
        triples = self._extract_triples()

        self._add_triples(triples)

        return self._graph, triples
