# !/usr/bin/env python
# -*- coding: UTF-8 -*-


class DigraphTextCleanser(object):
    """
    Purpose:
    Edge Generation for a grapher.Digraph object

    Traceability:
    https://github.com/craigtrim/prolog_antlr/issues/2
    """

    def __init__(self,
                 graph_style: dict,
                 is_debug: bool = True):
        """
        Created:
            21-Nov-2019
            craig.trim@ibm.com
            *   https://github.com/craigtrim/prolog_antlr/issues/3
        :param graph_style:
            a graph style defined in a graph stylesheet
            e.g.:
            -   resources/config/graph/graphviz_nlp_graph.yml
            -   resources/config/graph/graphviz_big_graph.yml
        :param is_debug:
            True     increase log output at DEBUG level
        """
        self._is_debug = is_debug
        self._graph_style = graph_style

    def process(self,
                some_text: str) -> str:
        """
        Purpose:
            determine whether to split the text for readability
        :param some_text:
            input text
        :return:
            (optionally) processed text
        """
        if "graph" not in self._graph_style:
            return some_text
        if "split_text" not in self._graph_style["graph"]:
            return some_text
        if not self._graph_style["graph"]["split_text"]:
            return some_text
        if " " not in some_text:
            return some_text

        tokens = some_text.split(" ")
        return "{}\\n{}".format(tokens[0], " ".join(tokens[1:]))
