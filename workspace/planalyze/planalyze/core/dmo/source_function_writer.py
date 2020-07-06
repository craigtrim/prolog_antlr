#!/usr/bin/env python
# -*- coding: UTF-8 -*-



import os
import pprint

import json
from plbase import BaseObject
from plbase import FileIO
from plparse import ParsePrologAPI

class SourceFunctionWriter(BaseObject):
    """ Write decomposed functions to file """


    def __init__(self,
                d_functions:dict,
                module_name:str,
                outdir:str,
                 is_debug: bool = True):
        """
        Created:
            6-July-2020
            craig.trim@causalitylink.com
        """
        BaseObject.__init__(self, __name__)
        self._outdir = outdir
        self._is_debug = is_debug
        self._module_name = module_name
        self._d_functions = d_functions

    def process(self) -> dict:
        
        path = os.path.join(self._outdir, self._module_name, 'functions/src')
        if not os.path.exists(path):
            os.makedirs(path)

        for function_name in self._d_functions:
            file_path = os.path.join(path, f"{function_name}.pl")
            FileIO.lines_to_file(some_lines=self._d_functions[function_name], file_path=file_path)