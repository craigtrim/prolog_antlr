#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from plbase import BaseObject

import pprint

from antlr4.tree.Tree import ErrorNodeImpl
from antlr4.tree.Tree import TerminalNodeImpl


class TransformConditionals(BaseObject):
    """ This is a common pattern in the Visual Prolog code:
            if  <CLAUSE> then
                <CLAUSE>
            else
                <CLAUSE>
            end if.

        This valid for Visual Prolog, but our ANTLR grammar does not handle this.

        This routine will transform the above code to:
            (   <CLAUSE> ->
                <CLAUSE>
            ;
                <CLAUSE>
            ).

        Reference
            https://stackoverflow.com/questions/6023717/prolog-building-list-with-conditional-clauses
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
        
    @staticmethod
    def _transform_1(some_lines:list) -> list:
        normalized = []

        for line in some_lines:
            temp = line.strip().lower()

            if 'elseif' in temp:
                line = line.replace('elseif', 'if')
                temp = temp.replace('elseif', 'if')

            if temp.startswith('if '):
                line = f"({line[3:]}"

            if temp.endswith(' then'):
                line = f"{line[:len(line)-5]} ->"
            elif temp.startswith('then ') or temp == 'then':
                line = f"{line[5:]} ->"
            elif temp == 'else':
                line = ';'
            elif temp.startswith('end if'):
                line = ').'

            normalized.append(line)

        return normalized

    @staticmethod
    def _transform_2(some_lines:list) -> list:
        """ Handle nested conditionals

            Transform this (invalid syntax):
                (condition ->
                    (condition -> 
                        a ;
                        b .
                    ).
                ).

            into:
                (condition ->
                    (condition -> 
                        a ;
                        b .
                )).

            note the nested parenthesis
        """

        normalized = []
        
        i = 0
        while i < len(some_lines):

            if i + 1 >= len(some_lines):
                break

            match_curr = some_lines[i].strip() == ').'
            match_next = some_lines[i + 1].strip() == ').'

            if match_curr and match_next:
                normalized.append(')).')
                i += 1
            else:
                normalized.append(some_lines[i])
            
            i += 1

        return normalized

    def process(self) -> list:
        lines = self._source_lines
        lines = self._transform_1(lines)
        lines = self._transform_2(lines)

        return lines
