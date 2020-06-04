#!/usr/bin/env python
# -*- coding: UTF-8 -*-


class OperatorRenaming(object):
    """
    Purpose:
        Rename Operators
    Reference:
        https://github.com/craigtrim/prolog_antlr/issues/4#issuecomment-638433601
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

        def _type(item: dict) -> str:
            if item['text'].lower() == 'and':
                return 'Conjunction'
            if item['text'].lower() == 'if':
                return 'Conditional'
            raise NotImplementedError(f"Unrecognized Operator Type: {item['text']}")

        def _iter(items: list):
            for item in items:
                _iter(item['results'])
                if item['type'] == 'Binary':
                    item['type'] = _type(item)
                    item['text'] = '|'.join([x['text'] for x in item['results']])

        _iter(self._ast)
        return self._ast
