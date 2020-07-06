#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from pandas import DataFrame
from pandas import Series
from tabulate import tabulate

from plbase import BaseObject


class ArityOfOneExtractor(BaseObject):
    """ Given a Predicate with an arity of /1
            extract the single argument in a 'Triple' format

    Sample Input (Prolog):
        person(sam)
    Sample Input (DataFrame AST):
        Compound    | mortal(X)             | 98b40414-b012-11ea-ba15-acde48001122
        Name        | mortal                | 98b404d2-b012-11ea-ba15-acde48001122
        Variable    | X                     | 98b404d2-b012-11ea-ba15-acde48001122
    Sample Output (psudeo-code):
        [   {text: sam, type: String, predicate: person} ]

    Reference:
        https://github.com/craigtrim/prolog_antlr/issues/9#issuecomment-640114990
    """

    def __init__(self,
                 df_ast: DataFrame,
                 is_debug: bool = True):
        """
        Created:
            16-June-2020
            craig.trim@ibm.com
            *   based on 'arity_of_two_extractor'
                https://github.com/craigtrim/prolog_antlr/issues/14
        """
        BaseObject.__init__(self, __name__)
        self._df_ast = df_ast
        self._is_debug = is_debug

    def _children_by_type(self,
                          row: Series,
                          type_name: str) -> DataFrame:
        return self._df_ast[(self._df_ast['Parent'] == row['UUID']) &
                            (self._df_ast['Type'] == type_name)]

    def _extract_by_type(self,
                         a_row: Series,
                         possible_types: list) -> (str, str):

        for a_type in possible_types:
            df = self._children_by_type(a_row, a_type)
            if df.empty:
                continue

            if len(df['UUID'].unique()) != 1:
                print(tabulate(df, headers='keys', tablefmt='psql'))
                raise NotImplementedError("Unexpected Condition")

            text = df['Text'].unique()[0]
            uuid = df['UUID'].unique()[0]

            return text, uuid

        return None, None

    def process(self,
                row: Series) -> list:
        """
        Expected Input (DataFrame AST) -- TYPE 1:
            Compound    | mortal(X)             | 98b40414-b012-11ea-ba15-acde48001122
            Name        | mortal                | 98b404d2-b012-11ea-ba15-acde48001122
            Variable    | X                     | 98b404d2-b012-11ea-ba15-acde48001122
        Expected Input (DataFrame AST) -- TYPE 2:
            Compound    | mortal(socrates)      | 98b40414-b012-11ea-ba15-acde48001122
            Name        | mortal                | 98b404d2-b012-11ea-ba15-acde48001122
            Entity      | socrates              | 98b404d2-b012-11ea-ba15-acde48001122
        Steps:
            1.  Find Name
                = mortal
            2.  Find Variable (or String)
                = X (or 'socrates')
        """

        df_names = self._children_by_type(row, 'Name')
        if len(df_names['UUID'].unique()) != 1:
            self.logger.warning('\n'.join([
                "Unexpected Condition (Names Pattern)",
                tabulate(df_names, headers='keys', tablefmt='psql')]))
            raise NotImplementedError("Unexpected Condition (Names)")

        predicate = df_names['Text'].unique()[0]
        self.logger.debug('\n'.join([
            f"Located Predicate: {predicate}"]))

        text, uuid = self._extract_by_type(row, ['Variable'])
        if text and uuid:  # TYPE-1; mortal(X)
            return [{"Text": text,
                     "Type": "Variable",
                     "Predicate": predicate,
                     "UUID": uuid}]

        text, uuid = self._extract_by_type(row, ['Entity', 'String', 'Integer'])
        if text and uuid:  # TYPE-2; person(socrates)
            return [{"Text": text,
                     "Type": "String",
                     "Predicate": predicate,
                     "UUID": uuid}]

        if self._is_debug:
            self.logger.warning('\n'.join([
                "Unknown Pattern",
                tabulate(df_names, headers='keys', tablefmt='psql')]))
        raise NotImplementedError  # an unknown pattern
