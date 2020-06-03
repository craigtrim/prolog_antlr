# !/usr/bin/env python
# -*- coding: UTF-8 -*-


class EdgeStyleMatcher(object):
    """
    Purpose:
    Find a matching edge style from a Graphviz Stylesheet

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
        :param is_debug:
            if True     increase log output at DEBUG level
        """
        self._is_debug = is_debug
        self._graph_style = graph_style

    def process(self,
                a_subject: str,
                a_predicate: str,
                a_object: str) -> dict:

        for edge in self._graph_style["edges"]:
            d_edge = edge["edge"]

            def _matches_by_type(a_type: str,
                                 a_value: str) -> bool:
                if a_type not in d_edge:
                    return True

                return d_edge[a_type].lower().strip() == a_value.lower().strip()

            def _matches() -> bool:
                if not _matches_by_type("subject", a_subject):
                    return False
                if not _matches_by_type("predicate", a_predicate):
                    return False
                if not _matches_by_type("object", a_object):
                    return False
                return True

            if _matches():
                return d_edge

        raise NotImplementedError("Default Edge Style Undefineds")
