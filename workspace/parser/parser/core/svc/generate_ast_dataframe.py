#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import pandas as pd
from pandas import DataFrame


class GenerateASTDataFrame(object):
    """ Given a Prolog AST as a list input
        Generate a Pandas Dataframe as output """

    def __init__(self,
                 ast: list,
                 is_debug: bool = False):
        """
        Created:
            2-June-2020
            craig.trim@ibm.com
            *   https://github.com/craigtrim/prolog_antlr/issues/1
        """
        if type(ast) != list:
            raise ValueError("List Input Expected")

        self._ast = ast
        self._is_debug = is_debug

    def _iter(self,
              results: list,
              parent: dict or None,
              items: list):
        for item in items:

            def _parent_uid() -> str or None:
                if parent:
                    return parent['uid']
                return None

            results.append({
                "UUID": item['uid'],
                "Type": item['type'],
                "Text": item['text'],
                "Parent": _parent_uid()})

            self._iter(results, item, item['results'])

    def process(self) -> DataFrame:
        results = [{
            "UUID": self._ast[0]['uid'],
            "Type": "Root",
            "Text": "Root",
            "Parent": None}]

        self._iter(results, self._ast[0], self._ast)

        return pd.DataFrame(results)
