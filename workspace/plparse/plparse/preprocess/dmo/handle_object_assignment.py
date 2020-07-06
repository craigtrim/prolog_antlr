#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from plbase import BaseObject

import pprint

from antlr4.tree.Tree import ErrorNodeImpl
from antlr4.tree.Tree import TerminalNodeImpl


class HandleObjectAssignment(BaseObject):
    """ Visual Prolog uses both ':=' and '=' 

        This operator ':=' is used for assignment
            name := none().
        assigns the 'none' value to the name fact.

        This operator '=' is used for unification
            name = none().
        the clause will suceed if the name fact is set to none, otherwise it will fail.

        Notes:
        -   from a parser standpoint, I don't care about this nuance.  
        -   perhaps deeper analysis will alter this perception down the road, but for now I'm content to standardize on '='

        Reference
            https://discuss.visual-prolog.com/viewtopic.php?t=15532
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

        for line in self._source_lines:
            if ':=' in line:
                line = line.replace(':=', '=')

            normalized.append(line)

        return normalized
