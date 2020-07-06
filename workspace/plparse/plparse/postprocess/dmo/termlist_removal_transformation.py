#!/usr/bin/env python
# -*- coding: UTF-8 -*-


class TermListRemovalTransformation(object):
    """
    Purpose:
        Elimnate the 'TermList' node (adds no visual value)
    Steps:
        1.  Find a Compound node with a TermList child
        2.  Create a new results list for the Compound Node
        3.  Copy the 'Name' element
        4.  Copy all the children of the 'TermList' element
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
        def _has_termlist(items: list) -> bool:
            for item in items:
                if item['type'] == 'Termlist':
                    return True
            return False

        def _iter(items: list):
            for item in items:

                _iter(item['results'])
                if item['type'] != 'Compound':
                    continue

                if _has_termlist(item['results']):

                    if len(item['results']) != 2:
                        raise NotImplementedError("Unknown Pattern")

                    results = [item['results'][0]]
                    [results.append(x) for x in item['results'][1]['results']]
                    item['results'] = results

        _iter(self._ast)
        return self._ast
