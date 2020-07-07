#!/usr/bin/env python
# -*- coding: UTF-8 -*-


class NestedIntegerTransformation(object):
    """
    Purpose:
        1.  Find a nested (Integer -> Integer) pattern
        2.  Remove the Inner Integer
    Sample Input:
        | 14 | 85bcb0c8-b02f-11ea-bcdc-acde48001122 | Integer     | 72                      | 85bcaeca-b02f-11ea-bcdc-acde48001122 |
        | 15 | 85bcb136-b02f-11ea-bcdc-acde48001122 | Integer     | 72                      | 85bcb0c8-b02f-11ea-bcdc-acde48001122 |
    Sample Output
        | 14 | 85bcb0c8-b02f-11ea-bcdc-acde48001122 | Integer     | 72                      | 85bcaeca-b02f-11ea-bcdc-acde48001122 |
    Reference:
        https://github.com/craigtrim/prolog_antlr/issues/16
    """

    def __init__(self,
                 ast: list,
                 is_debug: bool = True):
        """
        Created:
            16-June-2020
            craigtrim@gmail.com.com
            *   https://github.com/craigtrim/prolog_antlr/issues/7
        """
        self._ast = ast
        self._is_debug = is_debug

    def process(self) -> list:
        def _has_inner_integer(items: list) -> bool:
            if len(items) != 1:
                return False
            if items[0]['type'] != 'Integer':
                return False
            return True

        def _iter(items: list):
            for item in items:
                is_integer = item['type'] == 'Integer'
                has_inner_integer = _has_inner_integer(item['results'])
                if is_integer and has_inner_integer:
                    item['results'] = []
                _iter(item['results'])

        _iter(self._ast)
        return self._ast
