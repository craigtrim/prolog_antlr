# !/usr/bin/env python
# -*- coding: UTF-8 -*-


from graphviz import Digraph


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
            -   resources/config/graph/graphviz_prolog_graph.yml
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
                a_node_id: str,
                a_node: dict) -> Digraph:
        """
        :param graph:
        :param a_node_id:
            a unique identifier for the node.
            will not be displayed on the graph.
        :param a_node:
            the actual node
        :return:
        """

        d_node_style = self._node_style_matcher.process(a_tag_type=a_node['type'])
        a_node_label = self._text_cleanser.process(a_node['label'])
        a_node_text = self._text_cleanser.process(a_node['text'])

        def _label() -> str:
            if 'text' not in d_node_style:
                return a_node_label
            if d_node_style['text'].lower() == 'false':
                return ""
            return d_node_style['text'].replace('P0', a_node_text)

        graph.node(a_node_id,
                   label=_label(),
                   **d_node_style)

        return graph
