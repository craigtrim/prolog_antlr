#!/usr/bin/env python
# -*- coding: UTF-8 -*-


class NestedElementTransformation(object):
    """
    Purpose:
        1.  Find a nested element pattern (X -> X)
        2.  Remove the inner element
    Sample Input:
        | 16 | cb735b36-bccc-11ea-8d2e-00155df5ff10 | Termlist    | Directory,"\\KB\\settings.txt"
        | 17 | cb735c26-bccc-11ea-8d2e-00155df5ff10 | Termlist    | Directory|"\\KB\\settings.txt"
    Sample Output
        | 16 | cb735b36-bccc-11ea-8d2e-00155df5ff10 | Termlist    | Directory,"\\KB\\settings.txt"
    Reference:
        https://github.com/craigtrim/prolog_antlr/issues/16
    """

    def __init__(self,
                 ast: list,
                 is_debug: bool = True):
        """
        Created:
            2-Jul-2020
            craigtrim@gmail.com.com
            *   https://github.com/craigtrim/prolog_antlr/issues/7
        """
        self._ast = ast
        self._is_debug = is_debug

    def _remove(self,
                some_term: str):
        def _has_inner_integer(items: list) -> bool:
            if len(items) != 1:
                return False
            if items[0]['type'] != some_term:
                return False
            return True

        def _iter(items: list):
            for item in items:
                is_element = item['type'] == some_term
                has_inner_element = _has_inner_integer(item['results'])
                if is_element and has_inner_element:
                    item['results'] = []
                _iter(item['results'])

        _iter(self._ast)

    def process(self) -> list:
        """

        @return:
        """
        self._remove('Termlist')

        return self._ast
