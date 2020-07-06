#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from plbase import BaseObject

import pprint

from antlr4.tree.Tree import ErrorNodeImpl
from antlr4.tree.Tree import TerminalNodeImpl


class TransformLogicalOperators(BaseObject):
    """ These are the logical operators acceptable to our ANTLR grammar, with the Visual Prolog equivalents

            VP      SWI-PL          meaning
                    0	            false
                    1	            true
                    variable	    unknown truth value
                    atom	        universally quantified variable
                    ~ Expr	        logical NOT
                    Expr + Expr	    logical OR
            and     Expr * Expr	    logical AND
            or      Expr # Expr	    exclusive OR
                    Var ^ Expr	    existential quantification
                    Expr =:= Expr	equality
                    Expr =\= Expr	disequality (same as #)
                    Expr =< Expr	less or equal (implication)
                    Expr >= Expr	greater or equal
                    Expr < Expr	    less than
                    Expr > Expr	    greater than
                    card(Is,Exprs)	cardinality constraint (see below)

        Reference
            https://www.swi-prolog.org/pldoc/man?section=clpb-exprs
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
        

    d_corpus = {
        'and': '*',
        'or': '+',
        'not': '~'
    }


    def process(self) -> list:
        normalized = []

        for line in self._source_lines:

            for k in self.d_corpus:

                pk_1 = f" {k} "
                pv_1 = f" {self.d_corpus[k]} "

                if pk_1 in line:
                    line = line.replace(pk_1, pv_1)
                else:

                    pk_2 = f" {k}"
                    pv_2 = f" {self.d_corpus[k]}"

                    if pk_2 in line:
                        line = line.replace(pk_2, pv_2)

                    else:

                        pk_3 = f"{k} "
                        pv_3 = f"{self.d_corpus[k]} "

                        if pk_3 in line:
                            line = line.replace(pk_3, pv_3)

            normalized.append(line)

        return normalized
