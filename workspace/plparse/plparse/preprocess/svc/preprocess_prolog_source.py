#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from plbase import BaseObject

import pprint

from antlr4.tree.Tree import ErrorNodeImpl
from antlr4.tree.Tree import TerminalNodeImpl


class PreprocessPrologSource(BaseObject):
    """ PreProcess PROLOG source code to bring Visual Prolog in line with the ANTLR Grammar expectations """

    def __init__(self,
                 source_lines: list,
                 is_debug: bool = False):
        """
        Created:
            2-July-2020
            craigtrim@gmail.com
        """
        BaseObject.__init__(self, __name__)
        self._is_debug = is_debug
        self._source_lines = source_lines

    @staticmethod
    def _remove_blank_parens(some_lines: list) -> list:
        normalized = []

        for line in some_lines:
            if '()' in line:
                normalized.append(line.replace('()', ''))

            else:
                normalized.append(line)

        return normalized

    @staticmethod
    def _handle_ownership(some_lines: list) -> list:
        normalized = []

        for line in some_lines:
            if '::' in line:
                normalized.append(line.replace('::', ':'))

            else:
                normalized.append(line)

        return normalized

    # @staticmethod
    # def _remove_log_statements(some_lines: list) -> list:
    #     log_statements = [x.lower().strip() for x in
    #                       ['db:printTrace', '%stdIO::writef', '%']]

    #     def _is_logging_line(a_line: str) -> bool:
    #         for stmt in log_statements:
    #             if stmt in a_line.lower().strip():
    #                 return True
    #         return False

    #     normalized = [line for line in some_lines
    #                   if not _is_logging_line(line)]

    #     return normalized

    @staticmethod
    def _induce_commas(some_lines: list) -> list:
        normalized = []

        known_terminators = [',', '.']

        def _has_known_terminator(a_line: str) -> bool:
            a_line = a_line.strip().lower()
            for kt in known_terminators:
                if a_line.endswith(kt):
                    return True
            return False

        for line in [x for x in some_lines if len(x.strip())]:
            if _has_known_terminator(line):
                normalized.append(line)
            else:
                normalized.append(f"{line},")

        return normalized

    def process(self) -> list:
        """

        @return:
        """
        from plparse.preprocess.dmo import MultilineCommentRemover
        from plparse.preprocess.dmo import RemoveLogStatements
        from plparse.preprocess.dmo import RemoveBlankParens
        from plparse.preprocess.dmo import HandleObjectAssignment
        from plparse.preprocess.dmo import HandleObjectReferences
        from plparse.preprocess.dmo import RetainClausesOnly
        from plparse.preprocess.dmo import HandleNullaryPredicates

        lines = self._source_lines
        lines = RetainClausesOnly(source_lines=lines, is_debug=self._is_debug).process()
        lines = MultilineCommentRemover(source_lines=lines, is_debug=self._is_debug).process()
        lines = HandleNullaryPredicates(source_lines=lines, is_debug=self._is_debug).process()
        lines = RemoveLogStatements(source_lines=lines, is_debug=self._is_debug).process()
        lines = RemoveBlankParens(source_lines=lines, is_debug=self._is_debug).process()
        lines = HandleObjectReferences(source_lines=lines, is_debug=self._is_debug).process()
        lines = HandleObjectAssignment(source_lines=lines, is_debug=self._is_debug).process()

        if self._is_debug:
            self.logger.debug("PreProcessing Complete\n")
            self.logger.debug('\n'.join([
                "PreProcessing Complete",
                "\n-----------------------------------",
                '\n'.join(lines),
                "-----------------------------------\n"]))

        return lines

