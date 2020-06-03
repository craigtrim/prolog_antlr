#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from antlr4 import InputStream
from antlr4 import CommonTokenStream
from parser.dmo import PrologLexer
from parser.dmo import PrologParser


class ParsePrologSource(object):
    """ Given Prolog source lines as a list input
        Generate an ANTLR tree structure """

    def __init__(self,
                 source_lines: list):
        if type(source_lines) != list:
            raise ValueError("List Input Expected")

        source_code = '\n'.join(source_lines)
        self._input_stream = InputStream(source_code)

    def process(self) -> PrologParser.P_textContext:
        lexer = PrologLexer(self._input_stream)
        stream = CommonTokenStream(lexer)
        parser = PrologParser(stream)

        tree = parser.p_text()

        return tree
