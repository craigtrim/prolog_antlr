#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import os

from graphviz import Digraph
from pandas import DataFrame


class GenerateGraphV2(object):
    """

    Reference
        https://github.com/craigtrim/prolog_antlr/issues/9#issuecomment-639106295"""

    def __init__(self,
                 df_ast: DataFrame,
                 graph_style: str = "gv2",
                 is_debug: bool = True):
        """
        Created:
            2-June-2020
            craigtrim@gmail.com.com
            *   https://github.com/craigtrim/prolog_antlr/issues/2
        """
        from plgraph.core.dmo import GraphStyleLoader
        from plgraph.core.dmo import NodeStyleMatcher
        from plgraph.core.dmo import DigraphNodeGenerator
        from plgraph.core.dmo import DigraphEdgeGenerator
        from plgraph.core.dto import UUIDTransform

        self._df_ast = df_ast
        self._is_debug = is_debug
        self._graph_style = graph_style
        self._uuid_transform = UUIDTransform()

        self._style_loader = GraphStyleLoader(is_debug=self._is_debug,
                                              style_name=self._graph_style)

        self._node_style_matcher = NodeStyleMatcher(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

        self._node_generator = DigraphNodeGenerator(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

        self._edge_generator = DigraphEdgeGenerator(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

    @staticmethod
    def _cartesian(some_values: list) -> list:
        """
        Purpose:
            Generate a Cartesian Product of a Series of Lists
        Implementation:
            1.  Given a Series of Lists
                [ [44, 12, 8], [49], [47] ]
            2.  Generate a Cartesian Product
                [(44, 49, 47), (12, 49, 47), (8, 49, 47)]
        Reference:
            https://stackoverflow.com/questions/533905/get-the-cartesian-product-of-a-series-of-lists
        :param some_values:
            a list of avlues
        :return:
            a Cartesian Product of the input values
        """
        s = set()

        for x in some_values:
            for y in some_values:
                if x != y:
                    s.add(','.join(sorted({x, y})))

        return sorted(s)

    def process(self,
                file_name: str,
                engine: str,
                file_extension: str = "png") -> Digraph:

        from plgraph.core.svc import GenerateCompoundTriples
        from plgraph.core.svc import GenerateFactClusters
        from plgraph.core.svc import GenerateRuleClusters

        graph = Digraph(engine=engine,
                        comment='Schema',
                        format=file_extension,
                        name=file_name)

        graph.attr('node',
                   **self._node_style_matcher.default_node_style())

        graph.attr('graph',
                   compound='True')

        triple_gen = GenerateCompoundTriples(graph=graph,
                                             df_ast=self._df_ast,
                                             is_debug=self._is_debug,
                                             graph_style=self._graph_style)
        graph, triples = triple_gen.process()

        fact_gen = GenerateFactClusters(graph=graph,
                                        is_debug=self._is_debug,
                                        graph_style=self._graph_style)

        graph, compound_mapping, atomic_mapping = fact_gen.process(triples)

        rule_gen = GenerateRuleClusters(graph=graph,
                                        df_ast=self._df_ast,
                                        is_debug=self._is_debug,
                                        graph_style=self._graph_style)

        rule_gen.process(atomic_mapping=atomic_mapping,
                         compound_mapping=compound_mapping)

        # START LOGIC TO ADD CLUSTER-TO-CLUSTER CONNECTIONS

        # for k in self._d_node_ids:
        #     cartesian = self._cartesian(self._d_node_ids[k])
        #     cartesian = [x.split(',') for x in cartesian]
        #
        #     print('\n'.join([
        #         "Cartesian Join on Clustered Values",
        #         f"\tOriginal UUID: {k}",
        #         f"\tCartesian Values: {cartesian}"]))
        #
        #     for vc in cartesian:
        #         s = vc[0].split('_')[-1]
        #         o = vc[1].split('_')[-1]
        #
        #         graph.edge(tail_name=vc[0],
        #                    head_name=vc[1],
        #                    label="",
        #                    ltail=s,
        #                    lhead=o,
        #                    style="dotted",
        #                    colorscheme="greys9",
        #                    color="4",
        #                    arrowhead="none",
        #                    fontsize="5",
        #                    weight="2")
        # ... END LOGIC ...

        # for value in self._d_node_ids[k]:
        #     graph = self._edge_generator.process(graph,
        #                                          k,
        #                                          "definition",
        #                                          value)

        # now I want to add relationships between clusters

        if ".pl" in file_name:
            file_name = file_name.split('.pl')[0].strip()

        # graph.save(f"{file_name}.d", os.environ["PROJECT_BASE"])
        graph.render(os.path.join(os.environ["PROJECT_BASE"],
                                  f"resources/output/{file_name}"))

        return graph
