# !/usr/bin/env python
# -*- coding: UTF-8 -*-


from graphviz import Digraph
from pandas import DataFrame
from tabulate import tabulate


class GenerateRuleClusters(object):
    """ Generate Edges between Graphviz Clusters
            based on Rule definitions

     Reference:
        https://github.com/craigtrim/prolog_antlr/issues/12
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
        from plgraph.core.dmo import GraphStyleLoader
        from plgraph.core.dmo import DigraphNodeGenerator
        from plgraph.core.dmo import DigraphEdgeGenerator
        from plgraph.core.dto import UUIDTransform

        self._graph = graph
        self._df_ast = df_ast
        self._is_debug = is_debug
        self._subgraph_mapping = {}
        self._uuid_transform = UUIDTransform()

        self._style_loader = GraphStyleLoader(style_name=graph_style,
                                              is_debug=self._is_debug)

        self._node_generator = DigraphNodeGenerator(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

        self._edge_generator = DigraphEdgeGenerator(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

    # @staticmethod
    # def _cartesian(some_values: list) -> list:
    #     """
    #     Purpose:
    #         Generate a Cartesian Product of a Series of Lists
    #     Implementation:
    #         1.  Given a Series of Lists
    #             [ [44, 12, 8], [49], [47] ]
    #         2.  Generate a Cartesian Product
    #             [(44, 49, 47), (12, 49, 47), (8, 49, 47)]
    #     Reference:
    #         https://stackoverflow.com/questions/533905/get-the-cartesian-product-of-a-series-of-lists
    #     :param some_values:
    #         a list of avlues
    #     :return:
    #         a Cartesian Product of the input values
    #     """
    #     s = set()
    #
    #     for x in some_values:
    #         for y in some_values:
    #             if x != y:
    #                 s.add(','.join(sorted({x, y})))
    #
    #     return sorted(s)

    def process(self,
                atomic_mapping: dict,
                compound_mapping: dict) -> Digraph:

        def _first_node_by_cluster_name(a_cluster_name: str) -> str:
            for k in atomic_mapping:
                for v in atomic_mapping[k]:
                    if v == a_cluster_name:
                        return k

        df_clause = self._df_ast[self._df_ast['Type'] == 'Clause']

        for _, row_clause in df_clause.iterrows():
            df_conditional = self._df_ast[(self._df_ast['Parent'] == row_clause['UUID']) &
                                          (self._df_ast['Type'] == 'Conditional')]

            if len(df_conditional) == 0:
                continue
            elif len(df_conditional) > 1:
                raise NotImplementedError(f"Unexpected Conditional (size={len(df_conditional)})")

            print('\n'.join([
                f"Extracted Conditionals from Clause (total={len(df_conditional)}):",
                tabulate(df_conditional, tablefmt='psql', headers='keys')]))

            for _, row_conditional in df_conditional.iterrows():
                df_compounds = self._df_ast[(self._df_ast['Parent'] == row_conditional['UUID']) &
                                            (self._df_ast['Type'] == 'Compound')]

                if len(df_compounds) == 2:  # a known pattern

                    print('\n'.join([
                        f"Extracted Compounds from Conditional "
                        f"(total={len(df_compounds)}, "
                        f"pattern=Double Compound):",
                        tabulate(df_compounds, tablefmt='psql', headers='keys')]))

                    uuids = df_compounds['UUID'].unique()

                    cluster_1 = compound_mapping[uuids[0]][0]
                    cluster_2 = compound_mapping[uuids[1]][0]

                    head = self._uuid_transform.cleanse(uuids[0], cluster_1)
                    tail = self._uuid_transform.cleanse(uuids[1], cluster_2)

                    cluster_1_node = _first_node_by_cluster_name(cluster_1)
                    cluster_2_node = _first_node_by_cluster_name(cluster_2)

                    print('\n'.join([
                        f"Head ({cluster_1}, {head}, {cluster_1_node})",
                        f"Tail ({cluster_2}, {tail}, {cluster_2_node})"]))

                    self._graph.edge(tail_name=cluster_1_node,
                                     head_name=cluster_2_node,
                                     label=row_clause['Text'],
                                     ltail=cluster_1,
                                     lhead=cluster_2,
                                     style="normal",
                                     colorscheme="greys9",
                                     color="8",
                                     arrowhead="normal",
                                     fontsize="10",
                                     weight="2")


                elif len(df_compounds == 1):
                    df_conjunction = self._df_ast[(self._df_ast['Parent'] == row_conditional['UUID']) &
                                                  (self._df_ast['Type'] == 'Conjunction')]
                    for _, temp in df_conjunction.iterrows():
                        df_compounds_object = self._df_ast[(self._df_ast['Parent'] == temp['UUID']) &
                                                           (self._df_ast['Type'] == 'Compound')]

                        if len(df_compounds_object) != 2:
                            raise NotImplementedError

                        print('\n'.join([
                            f"Extracted Compound and Conjunction from Conditional "
                            f"pattern=Compound/Compound):",
                            tabulate(df_compounds, tablefmt='psql', headers='keys'),
                            tabulate(df_compounds_object, tablefmt='psql', headers='keys')]))

                        s = df_compounds['UUID'].unique()[0]
                        o1 = df_compounds_object['UUID'].unique()[0]
                        o2 = df_compounds_object['UUID'].unique()[1]

                        s_cluster = compound_mapping[s][0]
                        o1_cluster = compound_mapping[o1][0]
                        o2_cluster = compound_mapping[o2][0]

                        s_node = _first_node_by_cluster_name(s_cluster)
                        o1_node = _first_node_by_cluster_name(o1_cluster)
                        o2_node = _first_node_by_cluster_name(o2_cluster)

                        print('\n'.join([
                            "Conjunction Pattern Analysis:",
                            f"\tSubj ({s}, {s_cluster}, {s_node})",
                            f"\tObj1 ({o1}, {o1_cluster}, {o1_node})",
                            f"\tObj2 ({o2}, {o2_cluster}, {o2_node})"]))

                        self._graph.edge(tail_name=s_node,
                                         head_name=o1_node,
                                         label=row_clause['Text'],
                                         ltail=s_cluster,
                                         lhead=o1_cluster,
                                         style="normal",
                                         colorscheme="greys9",
                                         color="8",
                                         arrowhead="normal",
                                         fontsize="10",
                                         weight="2")

                        self._graph.edge(tail_name=s_node,
                                         head_name=o2_node,
                                         label=row_clause['Text'],
                                         ltail=s_cluster,
                                         lhead=o2_cluster,
                                         style="normal",
                                         colorscheme="greys9",
                                         color="8",
                                         arrowhead="normal",
                                         fontsize="10",
                                         weight="2")

        return self._graph
