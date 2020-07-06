#!/usr/bin/env python
# -*- coding: UTF-8 -*-



import os
import pprint

import json
from plbase import BaseObject
from plbase import FileIO
from plparse import ParsePrologAPI

class ParseFunctionWriter(BaseObject):
    """ Parse Decomposed Functions """


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
        from plparse import ParsePrologAPI

        parse_api = ParsePrologAPI(is_debug=self._is_debug)
        
        path = os.path.join(self._outdir, self._module_name, 'functions/tag')
        if not os.path.exists(path):
            os.makedirs(path)

        for function_name in self._d_functions:
            file_path = os.path.join(path, f"{function_name}.pl")

            source_lines = self._d_functions[function_name]

            ast = parse_api.parse(source_lines)
            ast = parse_api.post_process(ast)

            FileIO.json_to_file(
                out_file_path=file_path,
                data=ast,
                flush_data=True,
                is_debug=False)


            # FileIO.lines_to_file(some_lines=ast, file_path=file_path)