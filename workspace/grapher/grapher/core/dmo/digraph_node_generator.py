# !/usr/bin/env python
# -*- coding: UTF-8 -*-


from grapher import Digraph


class DigraphNodeGenerator(object):
    """
    Purpose:
    Node Generation for a grapher.Digraph object

    Notes:
    -   'digraph-node-generator' is not the same as 'grapher-node-generator'
    -   this module generates a library-specific Digraph node element
    -   the grapher-node-generator creates a string value that conforms to the Graphviz format

    Traceability:
    https://github.com/craigtrim/prolog_antlr/issues/2
    """

    def __init__(self,
                 graph_style: dict,
                 is_debug: bool = True):
        """
        Created:
            2-Jun-2020
            craigtrim@gmail.com
            *   https://github.com/craigtrim/prolog_antlr/issues/3
        :param graph_style:
            a graph style defined in a graph stylesheet
            e.g.:
            -   resources/config/graph/graphviz_nlp_graph.yml
            -   resources/config/graph/graphviz_big_graph.yml
        :param is_debug:
            True     increase log output at DEBUG level
        """
        from grapher.core.dmo import DigraphTextCleanser
        from grapher.core.dmo import NodeStyleMatcher

        self.is_debug = is_debug
        self._node_style_matcher = NodeStyleMatcher(is_debug=is_debug,
                                                    graph_style=graph_style)

        self._text_cleanser = DigraphTextCleanser(is_debug=self.is_debug,
                                                  graph_style=graph_style)

    def process(self,
                graph: Digraph,
                a_node_name: str,
                a_node_type: str,
                is_primary: bool,
                is_variant: bool) -> Digraph:
        """
        :param graph:
        :param a_node_name:
        :param a_node_type:
        :param is_primary:
        :param is_variant:
        :return:
        """

        d_node_style = self._node_style_matcher.process(a_tag_type=a_node_type,
                                                        is_variant=is_variant,
                                                        is_primary=is_primary)

        a_node_name = self._text_cleanser.process(a_node_name)
        graph.node(a_node_name,
                   label=a_node_name,
                   **d_node_style)

        return graph
