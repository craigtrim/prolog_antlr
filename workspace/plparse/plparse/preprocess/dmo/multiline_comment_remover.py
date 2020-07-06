#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from plbase import BaseObject

import pprint

from antlr4.tree.Tree import ErrorNodeImpl
from antlr4.tree.Tree import TerminalNodeImpl


class MultilineCommentRemover(BaseObject):
    """ MultiLine Comment Remover """

    def __init__(self,
                 source_lines: list,
                 is_debug: bool = False):
        """
        Created:
            6-July-2020
            craigtrim@gmail.com
            *   refactored out of 'preprocess-prolog-source'0
        """
        BaseObject.__init__(self, __name__)
        self._is_debug = is_debug
        self._source_lines = source_lines

    def process(self) -> list:
        normalized = []

        i = 0
        tloc = len(self._source_lines)

        while i < tloc:

            if self._source_lines[i].strip() == '/*':
                while i < tloc and self._source_lines[i] != '*/':
                    i += 1

            if i >= tloc:
                break

            if not self._source_lines[i].strip() == '*/':
                normalized.append(self._source_lines[i])

            i += 1

        return normalized
