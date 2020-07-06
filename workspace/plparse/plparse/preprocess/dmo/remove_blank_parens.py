#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from plbase import BaseObject

import pprint

from antlr4.tree.Tree import ErrorNodeImpl
from antlr4.tree.Tree import TerminalNodeImpl


class RemoveBlankParens(BaseObject):
    """ """

    def __init__(self,
                 source_lines: list,
                 is_debug: bool = False):
        """
        Created:
            6-July-2020
            craigtrim@gmail.com
            *   refactored out of 'preprocess-prolog-source'
        """
        BaseObject.__init__(self, __name__)
        self._is_debug = is_debug
        self._source_lines = source_lines

    def process(self) -> list:
        normalized = []

        for line in self._source_lines:
            if '()' in line:
                normalized.append(line.replace('()', ''))

            else:
                normalized.append(line)

        return normalized
