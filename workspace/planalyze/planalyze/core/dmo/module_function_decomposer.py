#!/usr/bin/env python
# -*- coding: UTF-8 -*-



import os
import pprint

import json
from plbase import BaseObject
from plbase import FileIO
from plparse import ParsePrologAPI

class ModuleFunctionDecomposer(BaseObject):
    """ Decompose a Visual Prolog module into functions """


    def __init__(self,
                source_lines:list,
                 is_debug: bool = True):
        """
        Created:
            6-July-2020
            craig.trim@causalitylink.com
        """
        BaseObject.__init__(self, __name__)
        self._is_debug = is_debug
        self._source_lines = source_lines

    def process(self) -> dict:
        
        i = 0
        tloc = len(self._source_lines)

        buffer = []
        d_functions = {}

        def _cleanse(a_line:str) -> str:
            a_line = a_line.lower().strip()
            a_line = a_line.replace(') :-', '):-')

            return a_line

        while i < tloc:

            line = self._source_lines[i]
            temp = _cleanse(line)

            if temp.endswith('):-'):
                if '(' not in temp and i - 1 >= 0 and '(' in self._source_lines[i - 1]:
                    line = f"{self._source_lines[i-1]} {self._source_lines[i]}"
                    temp = _cleanse(line)

            if temp.endswith('):-'):
                title = line.split('(')[0].strip()
                d_functions[title] = buffer

                buffer = []
            
            buffer.append(line)
            i += 1

        self.logger.debug('\n'.join([
            "Module Function Decomposition Complete",
            f"\Total Functions: {len(sorted(d_functions.keys()))}",
            f"\tFunction Names: {sorted(d_functions.keys())}"]))

        return d_functions
