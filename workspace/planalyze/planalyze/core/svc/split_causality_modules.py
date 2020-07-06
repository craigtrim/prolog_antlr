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

    def _load_src(self) -> dict:
        d_modules = {}
        
        for relative_path in self._config['modules']:
            absolute_path = os.path.join(self._config['home'], relative_path)            
            module = FileIO.file_to_lines_by_relative_path(absolute_path)

            self.logger.debug('\n'.join([
                "Loaded Module",
                f"\tRelative Path: {relative_path}",
                f"\tAbsolute Path: {absolute_path}",
                f"\tTotal Size: {len(module)}"]))

            d_modules[absolute_path] = module

        return d_modules

    def process(self):
        print ("Hello, World")
        
        d_modules = self._load_src()
        source_lines = d_modules['/home/craig/git/prolognlp/cl/misc/misc.pro']
        
        parser_api = ParsePrologAPI(is_debug=self._is_debug)
        ast = parser_api.parse(source_lines)

        pprint.pprint(ast)


if __name__ == "__main__":
    SplitCausalityModules().process()
