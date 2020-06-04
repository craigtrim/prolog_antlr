#!/usr/bin/env python
# -*- coding: UTF-8 -*-


class PostProcessPrologAST(object):
    """ Given a pandas Dataframe from the ANTLR parse as input
        Generate a simplified DataFrame suitable for Graphviz visualization """

    def __init__(self,
                 ast: list,
                 is_debug: bool = True):
        """
        Created:
            3-June-2020
            craig.trim@ibm.com
            *   https://github.com/craigtrim/prolog_antlr/issues/4
        """
        self._ast = ast
        self._is_debug = is_debug

    @staticmethod
    def _atomic_string_transformation(ast: list) -> list:
        """
        Purpose:
            1.  Find an Atomic -> String pattern
            2.  Delete the String row
            3.  Rename the Atomic row to String
        Sample Input:
            |  16 | 7f80aa52-a530-11ea-89ec-acde48001122 | Atomic   | "Pam"  | 7f80aa02-a530-11ea-89ec-acde48001122 |
            |  17 | 7f80aa8e-a530-11ea-89ec-acde48001122 | String   | "Pam"  | 7f80aa52-a530-11ea-89ec-acde48001122 |
        Sample Output:
            |  16 | 7f80aa52-a530-11ea-89ec-acde48001122 | String   | "Pam"  | 7f80aa02-a530-11ea-89ec-acde48001122 |
        Reference:
            https://github.com/craigtrim/prolog_antlr/issues/4#issuecomment-638285825
        """

        def _has_single_string(items: list) -> bool:
            if len(items) != 1:
                return False
            return items[0]['type'] == 'String'

        def _iter(items: list):
            for item in items:
                if item['type'] == 'Atomic':
                    if _has_single_string(item['results']):
                        item['results'] = []
                        item['type'] = 'String'
                _iter(item['results'])

        _iter(ast)
        return ast

    @staticmethod
    def _binary_operator_transformation(ast: list) -> list:
        """
        Purpose:
            1.  Find a Binary -> Operator pattern
            2.  Replace the Binary Text with Operator Text
            3.  Replace all Parent References to the Operator UUID with the Binary UUID
            4.  Delete the Operator Row
        Sample Input:
            |  15 | 7f80aa02-a530-11ea-89ec-acde48001122 | Binary   | "Pam","Bill" | 7f80a976-a530-11ea-89ec-acde48001122 |
            |  17 | 7f80aa8e-a530-11ea-89ec-acde48001122 | String   | "Pam"        | 7f80aa52-a530-11ea-89ec-acde48001122 |
            |  18 | 7f80aade-a530-11ea-89ec-acde48001122 | Operator | ,            | 7f80aa02-a530-11ea-89ec-acde48001122 |
            |  20 | 7f80ab7e-a530-11ea-89ec-acde48001122 | String   | "Bill"       | 7f80ab42-a530-11ea-89ec-acde48001122 |        Sample Output:
        Sample Output
            |  15 | 7f80aa02-a530-11ea-89ec-acde48001122 | Binary   | "AND"        | 7f80a976-a530-11ea-89ec-acde48001122 |
            |  17 | 7f80aa8e-a530-11ea-89ec-acde48001122 | String   | "Pam"        | 7f80aa02-a530-11ea-89ec-acde48001122 |
            |  20 | 7f80ab7e-a530-11ea-89ec-acde48001122 | String   | "Bill"       | 7f80aa02-a530-11ea-89ec-acde48001122 |        Sample Output:
        Reference:
            https://github.com/craigtrim/prolog_antlr/issues/4#issuecomment-638285905
        """

        def _find_child_operator(items: list) -> dict or None:
            for item in items:
                if item['type'] == 'Operator':
                    return item

        def _operator_text(operator: dict) -> str:
            if operator['text'] == ',':
                return "AND"
            if operator['text'] == ':-':
                return "IF"
            raise NotImplementedError(f"Operator Text: {operator['text']}")

        def _results(items: list) -> list:
            normalized = []
            [normalized.append(item) for item in items if item['type'] != 'Operator']
            return normalized

        def _iter(items: list):
            for item in items:

                _iter(item['results'])
                if item['type'] != 'Binary':
                    continue

                operator = _find_child_operator(item['results'])
                if operator:
                    item['text'] = _operator_text(operator)
                    item['results'] = _results(item['results'])

        _iter(ast)
        return ast

    @staticmethod
    def _termlist_elimination_transformation(ast: list) -> list:
        """
        Purpose:
            Elimnate the 'TermList' node (adds no visual value)
        Steps:
            1.  Find a Compound node with a TermList child
            2.  Create a new results list for the Compound Node
            3.  Copy the 'Name' element
            4.  Copy all the children of the 'TermList' element
        Reference:
            https://github.com/craigtrim/prolog_antlr/issues/4#issuecomment-638433601
        """

        def _has_termlist(items: list) -> bool:
            for item in items:
                if item['type'] == 'Termlist':
                    return True
            return False

        def _iter(items: list):
            for item in items:

                _iter(item['results'])
                if item['type'] != 'Compound':
                    continue

                if _has_termlist(item['results']):

                    if len(item['results']) != 2:
                        raise NotImplementedError("Unknown Pattern")

                    results = [item['results'][0]]
                    [results.append(x) for x in item['results'][1]['results']]
                    item['results'] = results

        _iter(ast)
        return ast

    @staticmethod
    def _operator_renaming(ast: list) -> list:

        def _type(item: dict) -> str:
            if item['text'].lower() == 'and':
                return 'Conjunction'
            if item['text'].lower() == 'if':
                return 'Conditional'
            raise NotImplementedError(f"Unrecognized Operator Type: {item['text']}")

        def _iter(items: list):
            for item in items:
                _iter(item['results'])
                if item['type'] == 'Binary':
                    item['type'] = _type(item)
                    item['text'] = '|'.join([x['text'] for x in item['results']])

        _iter(ast)
        return ast

    def process(self) -> list:
        normalized = self._ast

        normalized = self._atomic_string_transformation(normalized)
        normalized = self._binary_operator_transformation(normalized)
        normalized = self._termlist_elimination_transformation(normalized)
        normalized = self._operator_renaming(normalized)

        return normalized
