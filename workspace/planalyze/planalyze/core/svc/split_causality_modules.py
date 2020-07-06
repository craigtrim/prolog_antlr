#!/usr/bin/env python
# -*- coding: UTF-8 -*-



import os

import json
from plbase import BaseObject
from plbase import FileIO

class SplitCausalityModules(BaseObject):
    """ Perform a Module-by-Module analysis of Causality Prolog code

     Reference:
        https://github.com/craigtrim/prolog_antlr/issues/10    """

    def __init__(self,
                 is_debug: bool = True):
        """
        Created:
            6-July-2020
            craig.trim@causalitylink.com
        """
        BaseObject.__init__(self, __name__)
        self._is_debug = is_debug

    def process(self):
        print ("Hello, World")
        
        config = FileIO.file_to_yaml_by_relative_path("resources/config/causality/prolog_modules.yml")
        
        for module in config['modules']:
            module_path = os.path.join(os.environ['PROJECT_BASE'], module)
            
            module_lines = FileIO.file_to_lines_by_relative_path(module)

            self.logger.debug('\n'.join([
                "Loaded Module",
                f"\tRelative Path: {module}",
                f"\tAbsolute Path: {module_path}",
                f"\tTotal Lines: {len(module_lines)}"]))



if __name__ == "__main__":
    SplitCausalityModules().process()