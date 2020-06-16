#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from pandas import DataFrame
from pandas import Series
from tabulate import tabulate


# from plbase import BaseObject


class CompoundTripleExtractor(object):
    """
    Purpose:
        Given a 'Compound' row, extract a Triple from the DataFrame
    Sample Input:
        ancestor(Z,Y)
    Sample Output (psudeo-code):
        [   {text: Z, type: Variable, predicate: ancestor},
            {text: Y, type: Variable, predicate: ancestor} ]
    Reference:
        https://github.com/craigtrim/prolog_antlr/issues/9#issuecomment-640114990
    """

    def __init__(self,
                 df_ast: DataFrame,
                 is_debug: bool = True):
        """
        Created:
            6-June-2020
            craig.trim@ibm.com
            *   refactored out of 'generate-graph-v2'
        """
        # BaseObject.__init__(self, __name__)
        self._df_ast = df_ast
        self._is_debug = is_debug

    def _children_by_type(self,
                          row: Series,
                          type_name: str) -> DataFrame:
        return self._df_ast[(self._df_ast['Parent'] == row['UUID']) &
                            (self._df_ast['Type'] == type_name)]

    def process(self,
                row: Series) -> list:
        results = []

        df_names = self._children_by_type(row, 'Name')
        if len(df_names['UUID'].unique()) != 1:
            print(tabulate(df_names, headers='keys', tablefmt='psql'))
            raise NotImplementedError("Unexpected Condition")

        predicate = df_names['Text'].unique()[0]
        print('\n'.join([
            f"Located Predicate: {predicate}"]))

        df_conjunctions = self._children_by_type(row, 'Conjunction')
        if len(df_conjunctions) == 0:
            print(tabulate(df_conjunctions, headers='keys', tablefmt='psql'))
            raise NotImplementedError("Unexpected Condition")

        for _, conjunction_row in df_conjunctions.iterrows():

            df_entities = self._children_by_type(conjunction_row, 'Entity')
            for _, entity_row in df_entities.iterrows():
                results.append({"Text": entity_row['Text'],
                                "Type": 'Entity',
                                "Predicate": predicate,
                                "UUID": entity_row['UUID']})

            df_strings = self._children_by_type(conjunction_row, 'String')
            for _, string_row in df_strings.iterrows():
                results.append({"Text": string_row['Text'],
                                "Type": 'String',
                                "Predicate": predicate,
                                "UUID": string_row['UUID']})

            df_variables = self._children_by_type(conjunction_row, 'Variable')
            for _, variable_row in df_variables.iterrows():
                results.append({"Text": variable_row['Text'],
                                "Type": 'Variable',
                                "Predicate": predicate,
                                "UUID": variable_row['UUID']})

        return results
