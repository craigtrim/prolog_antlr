#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from pandas import DataFrame
from pandas import Series
from tabulate import tabulate

from plbase import BaseObject


class ArityOfTwoExtractor(BaseObject):
    """ Given a Predicate with an arity of /2
            extract both arguments in a 'Triple' format

    Sample Input (Prolog):
        ancestor(Z,Y)
    Sample Input (DataFrame AST):
        +-------------+----------------+--------------------------------------+
        ...
        | Compound    | ancestor(Z,Y)  | 5b93bbc4-b02b-11ea-b4b6-acde48001122 |
        | Name        | ancestor       | 5b93bee4-b02b-11ea-b4b6-acde48001122 |
        | Conjunction | Z|Y            | 5b93bee4-b02b-11ea-b4b6-acde48001122 |
        | Variable    | Z              | 5b93c18c-b02b-11ea-b4b6-acde48001122 |
        | Variable    | Y              | 5b93c18c-b02b-11ea-b4b6-acde48001122 |
        ...
        +-------------+----------------+--------------------------------------+
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
            craigtrim@gmail.com
            *   refactored out of 'generate-graph-v2'
        """
        BaseObject.__init__(self, __name__)
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
            if self._is_debug:
                self.logger.debug(tabulate(df_names, headers='keys', tablefmt='psql'))
            raise NotImplementedError("Unexpected Condition")

        predicate = df_names['Text'].unique()[0]
        if self._is_debug:
            self.logger.debug('\n'.join([
                f"Located Predicate: {predicate}"]))

        df_conjunctions = self._children_by_type(row, 'Conjunction')
        if self._is_debug:
            self.logger.debug('\n'.join([
                'Located Conjunction Types',
                tabulate(df_conjunctions, headers='keys', tablefmt='psql')]))

        if len(df_conjunctions) == 0:
            raise NotImplementedError("Unexpected Conjunction Pattern (empty dataframe)")

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
