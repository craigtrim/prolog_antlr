#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import json

from plbase import BaseObject


class AnalyzeCausalityModules(BaseObject):
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
    
    
    
        pass
