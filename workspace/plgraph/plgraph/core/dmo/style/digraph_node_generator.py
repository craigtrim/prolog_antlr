# !/usr/bin/env python
# -*- coding: UTF-8 -*-


from graphviz import Digraph


class DigraphNodeGenerator(object):
    """
    Purpose:
    Node Generation for a plgraph.Digraph object

    Notes:
    -   'digraph-node-generator' is not the same as 'plgraph-node-generator'
    -   this module generates a library-specific Digraph node element
    -   the plgraph-node-generator creates a string value that conforms to the Graphviz format

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
            -   resources/config/graph/graphviz_gv1_graph.yml
            -   resources/config/graph/graphviz_big_graph.yml
        :param is_debug:
            True     increase log output at DEBUG level
        """
        from plgraph.core.dmo import DigraphTextCleanser
        from plgraph.core.dmo import NodeStyleMatcher

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

        def _split(a_label:str) -> str:
            master = []
            buffer = []
            for ch in a_label:
                if ch.isupper():
                    if len(buffer) > 3:
                        master.append(''.join(buffer))
                        buffer = []
                buffer.append(ch)
            master.append(''.join(buffer))
            return "\\n".join(master)

        graph.node(a_node_id,
                   label=_split(_label()),
                   **d_node_style)

        return graph
