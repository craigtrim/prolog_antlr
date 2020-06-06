#!/usr/bin/env python
# -*- coding: UTF-8 -*-


class PostProcessPrologAST(object):
    """ Given a pandas Dataframe from the ANTLR parse as input
        Generate a simplified DataFrame suitable for Graphviz visualization """

    def __init__(self,
                 ast: list,
                 is_debug: bool = True):
        """
        Created:
            3-June-2020
            craig.trim@ibm.com
            *   https://github.com/craigtrim/prolog_antlr/issues/4
        """
        self._ast = ast
        self._is_debug = is_debug

    def process(self) -> list:
        normalized = self._ast

        from parser.ast.dmo import AtomicStringTransformation
        from parser.ast.dmo import AtomicEntityTransformation
        from parser.ast.dmo import OperatorRenaming
        from parser.ast.dmo import TermListRemovalTransformation
        from parser.ast.dmo import BinaryOperatorTransformation

        normalized = AtomicStringTransformation(normalized).process()
        normalized = AtomicEntityTransformation(normalized).process()
        normalized = BinaryOperatorTransformation(normalized).process()
        normalized = TermListRemovalTransformation(normalized).process()
        normalized = OperatorRenaming(normalized).process()

        return normalized
