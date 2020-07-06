#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from plbase import BaseObject

import pprint

from antlr4.tree.Tree import ErrorNodeImpl
from antlr4.tree.Tree import TerminalNodeImpl


class RemoveLogStatements(BaseObject):
    """ Remove Log Statements from Prolog Source Code """

    def __init__(self,
                 source_lines: list,
                 is_debug: bool = False):
        """
        Created:
            6-Jul-2020
            craigtrim@gmail.com
        """
        BaseObject.__init__(self, __name__)
        self._is_debug = is_debug
        self._source_lines = source_lines

    def process(self) -> list:
        log_statements = [x.lower().strip() for x in
                          ['db:printTrace', '%stdIO::writef', '%', 'stdio']]

        def _is_logging_line(a_line: str) -> bool:
            for stmt in log_statements:
                if stmt in a_line.lower().strip():
                    return True
            return False

        normalized = [line for line in self._source_lines
                      if not _is_logging_line(line)]

        return normalized
