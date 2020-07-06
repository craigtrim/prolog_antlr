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
        while i < len(self._source_lines):

            if self._source_lines[i].strip() == '/*':
                while self._source_lines[i] != '*/':
                    i += 1

            if not self._source_lines[i].strip() == '*/':
                normalized.append(self._source_lines[i])

            i += 1

        return normalized
