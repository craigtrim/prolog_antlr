# !/usr/bin/env python
# -*- coding: UTF-8 -*-


from graphviz import Digraph


class DigraphEdgeGenerator(object):
    """
    Purpose:
    Edge Generation for a grapher.Digraph object

    Notes:
    -   'digraph-edge-generator' is not the same as 'grapher-edge-generator'
    -   this module generates a library-specific Digraph edge element
    -   the grapher-edge-generator creates a string value that conforms to the Graphviz format

    Traceability:
    https://github.com/craigtrim/prolog_antlr/issues/2
    """

    __s_unique = set()

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
        from grapher.core.dmo import EdgeStyleMatcher

        self.is_debug = is_debug
        self._edge_style_matcher = EdgeStyleMatcher(is_debug=self.is_debug,
                                                    graph_style=graph_style)
        self._text_cleanser = DigraphTextCleanser(graph_style=graph_style,
                                                  is_debug=self.is_debug)

    def process(self,
                graph: Digraph,
                a_subject: str,
                a_predicate: str,
                a_object: str) -> Digraph:

        if not a_subject or not a_predicate or not object:
            return graph

        uid = " ".join(sorted([a_subject.lower(), a_object.lower()]))

        def _is_valid():
            if "unlisted" in uid:
                return False
            return uid not in self.__s_unique and a_subject != a_object

        if _is_valid():
            self.__s_unique.add(uid)
            d_edge = self._edge_style_matcher.process(a_subject=a_subject,
                                                      a_predicate=a_predicate,
                                                      a_object=a_object)

            if "display_label" in d_edge:
                if not d_edge["display_label"]:
                    a_predicate = ''

            graph.edge(tail_name=self._text_cleanser.process(a_subject),
                       head_name=self._text_cleanser.process(a_object),
                       label=self._text_cleanser.process(a_predicate),
                       **d_edge["style"])

        return graph
