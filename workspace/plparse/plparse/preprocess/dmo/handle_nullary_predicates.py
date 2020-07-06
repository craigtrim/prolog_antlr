#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from plbase import BaseObject

import pprint

from antlr4.tree.Tree import ErrorNodeImpl
from antlr4.tree.Tree import TerminalNodeImpl


class HandleNullaryPredicates(BaseObject):
    """ This is a common pattern in the Visual Prolog code:
            fail()
            or
            succeed().

        fail/0 and succeed/0 are two built-in nullary predicates. 
        fail/0 always fails and succeed/0 always succeeds, besides this the predicates have no effect.

        Notes:
        -   I'm going to remove this pattern when I see it.

        Reference
            https://wiki.visual-prolog.com/index.php?title=Language_Reference/Terms#fail.2F0_and_succeed.2F0
    """

    def __init__(self,
                 source_lines: list,
                 is_debug: bool = False):
        """
        Created:
            6-July-2020
            craigtrim@gmail.com
        """
        BaseObject.__init__(self, __name__)
        self._is_debug = is_debug
        self._source_lines = source_lines

    def process(self) -> list:
        normalized = []

        tloc = len(self._source_lines)

        i = 0

        print ("tloc: ", tloc)
        while i < tloc:

            if 'fail()' in self._source_lines[i]:
                if i + 1 < tloc and 'or' in self._source_lines[i + 1].strip():
                    if i + 2 < tloc and 'succeed()' in self._source_lines[i + 2].strip():
                        i += 3

            if i >= tloc:
                break

            normalized.append(self._source_lines[i])
            i += 1

        return normalized
