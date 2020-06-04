#!/usr/bin/env python
# -*- coding: UTF-8 -*-


class AtomicStringTransformation(object):
    """
    Purpose:
        1.  Find an Atomic -> String pattern
        2.  Delete the String row
        3.  Rename the Atomic row to String
    Sample Input:
        |  16 | 7f80aa52-a530-11ea-89ec-acde48001122 | Atomic   | "Pam"  | 7f80aa02-a530-11ea-89ec-acde48001122 |
        |  17 | 7f80aa8e-a530-11ea-89ec-acde48001122 | String   | "Pam"  | 7f80aa52-a530-11ea-89ec-acde48001122 |
    Sample Output:
        |  16 | 7f80aa52-a530-11ea-89ec-acde48001122 | String   | "Pam"  | 7f80aa02-a530-11ea-89ec-acde48001122 |
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
            return items[0]['type'] == 'String'

        def _iter(items: list):
            for item in items:
                if item['type'] == 'Atomic':
                    if _has_single_string(item['results']):
                        item['results'] = []
                        item['type'] = 'String'
                _iter(item['results'])

        _iter(self._ast)
        return self._ast
