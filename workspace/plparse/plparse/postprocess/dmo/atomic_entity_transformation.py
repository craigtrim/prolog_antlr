#!/usr/bin/env python
# -*- coding: UTF-8 -*-


class AtomicEntityTransformation(object):
    """
    Purpose:
        1.  Find an Atomic -> String pattern
        2.  Delete the String row
        3.  Rename the Atomic row to String
    Sample Input:
        | 20 | d12c91fe-a832-11ea-827b-acde48001122 | Atomic      | skill  | d12c908c-a832-11ea-827b-acde48001122 |
        | 21 | d12c9262-a832-11ea-827b-acde48001122 | Name        | skill  | d12c91fe-a832-11ea-827b-acde48001122 |
    Sample Output:
        | 20 | d12c91fe-a832-11ea-827b-acde48001122 | Entity      | skill  | d12c908c-a832-11ea-827b-acde48001122 |
    Reference:
        https://github.com/craigtrim/prolog_antlr/issues/4#issuecomment-638285825
    """

    def __init__(self,
                 ast: list,
                 is_debug: bool = True):
        """
        Created:
            3-June-2020
            craig.trim@ibm.com
            *   https://github.com/craigtrim/prolog_antlr/issues/7
        """
        self._ast = ast
        self._is_debug = is_debug

    def process(self) -> list:
        def _has_single_string(items: list) -> bool:
            if len(items) != 1:
                return False
            return items[0]['type'] == 'Name'

        def _iter(items: list):
            for item in items:
                if item['type'] == 'Atomic':
                    if _has_single_string(item['results']):
                        item['results'] = []
                        item['type'] = 'Entity'
                _iter(item['results'])

        _iter(self._ast)
        return self._ast
