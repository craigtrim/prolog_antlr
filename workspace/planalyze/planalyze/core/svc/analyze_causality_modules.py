#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import os
import json

from plbase import BaseObject
from plbase import FileIO

from pandas import DataFrame
import pandas as pd
from tabulate import tabulate

class AnalyzeCausalityModules(BaseObject):
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

    def process(self):

        master = []
        
        for module in self._config['output']['modules']:

            path = os.path.join(
                os.environ['PROJECT_BASE'], 
                self._config['output']['path'],
                module['path'])

            files = FileIO.load_files(path, "tsv")
            self.logger.debug('\n'.join([
                f"Loaded Files",
                f"\tTotal Files: {len(files)}",
                f"\tPath : {path}"]))
            
            for a_file in files:

                df = pd.read_csv(a_file, encoding="utf-8", sep="\t", skiprows=1, names=['UUID', 'Type', 'Text', 'Parent'])
                if df.empty:
                    self.logger.debug(f"Empty File: {a_file}")
                    continue

                names = list(df[df['Type'] == 'Name']['Text'])
                if not names or not len(names):
                    continue

                module = names[0]
                calls = sorted(set(names[1:]))

                blacklist = [module, 'succeed', 'fail']
                for k in blacklist:
                    if k in calls:
                        calls.remove(k)

                path = path.split('prolog/')[-1].strip().split('/functions')[0].strip()
                master.append({
                    "module": names[0],
                    "calls": calls,
                    "path": path})

        outdir = os.path.join(os.environ['PROJECT_BASE'], 'resources/output/analysis')
        if not os.path.exists(outdir):
            os.makedirs(outdir)

        outfile = os.path.join(outdir, 'calls.json')

        FileIO.json_to_file(
            out_file_path=outfile,
            data=master,
            flush_data=False,
            is_debug=True)




if __name__ == "__main__":
    AnalyzeCausalityModules(is_debug=True).process()
