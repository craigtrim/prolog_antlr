#!/usr/bin/env python
# -*- coding: UTF-8 -*-



import os
import pprint

import json
from plbase import BaseObject
from plbase import FileIO
from plparse import ParsePrologAPI

class SplitCausalityModules(BaseObject):
    """ Perform a Module-by-Module analysis of Causality Prolog code

     Reference:
        https://github.com/craigtrim/prolog_antlr/issues/10    """


    CONFIG_FILE = "resources/config/causality/prolog_modules.yml"

    def __init__(self,
                 is_debug: bool = True):
        """
        Created:
            6-July-2020
            craig.trim@causalitylink.com
        """
        BaseObject.__init__(self, __name__)
        self._is_debug = is_debug
        self._config = FileIO.file_to_yaml_by_relative_path(self.CONFIG_FILE)

    def _load_src(self, relative_path:str) -> dict:
        d_modules = {}
        
        absolute_path = os.path.join(self._config['input']['path'], relative_path)            
        module_lines = FileIO.file_to_lines_by_relative_path(absolute_path)

        self.logger.debug('\n'.join([
            "Loaded Module",
            f"\tRelative Path: {relative_path}",
            f"\tAbsolute Path: {absolute_path}",
            f"\tTotal Size: {len(module_lines)}"]))

        d_modules[absolute_path] = module_lines

        return d_modules

    def process(self):
        from planalyze import ModuleFunctionDecomposer
        from planalyze import SourceFunctionWriter
        from planalyze import ParseFunctionWriter

        for module in self._config['input']['modules']:

            # try:
            d_modules = self._load_src(module['path'])
            source_lines = d_modules[f"/home/craig/git/prolognlp/{module['path']}"]
            
            d_functions = ModuleFunctionDecomposer(
                source_lines=source_lines, 
                is_debug=self._is_debug).process()
            
            SourceFunctionWriter(
                d_functions=d_functions, 
                outdir = self._config['output']['path'], 
                module_name=module['name'],
                is_debug=self._is_debug).process()

            ParseFunctionWriter(
                d_functions=d_functions,
                outdir = self._config['output']['path'], 
                module_name=module['name'],
                is_debug=self._is_debug).process()

            # except PermissionError as e:
            #     self.logger.error(e)


if __name__ == "__main__":
    SplitCausalityModules(is_debug=True).process()
