#!/usr/bin/env python
# -*- coding: UTF-8 -*-


class BinaryOperatorTransformation(object):
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

    def __init__(self,
                 ast: list,
                 is_debug: bool = True):
        """
        Created:
            3-June-2020
            craig.trim@ibm.com
            *   https://github.com/craigtrim/prolog_antlr/issues/7
        """
        self._ast = ast
        self._is_debug = is_debug

    def process(self) -> list:
        def _find_child_operator(items: list) -> dict or None:
            for item in items:
                if item['type'] == 'Operator':
                    return item

        def _operator_text(operator: dict) -> str:
            if operator['text'] == ',':
                return "AND"
            if operator['text'] == ':-':
                return "IF"
            if operator['text'] == '-->':
                return "CFG"
            if operator['text'] == '==':
                return "EQ"
            if operator['text'] == ';':
                return "OR"
            if operator['text'] == '*':
                return "AND"
            if operator['text'] == '+':
                return "OR"
            if operator['text'] == '~':
                return "NOT"
            if operator['text'] == '->':
                return "IF"
            if operator['text'] == '/':
                return "UNK"  # TODO
            if operator['text'] == '=':
                return "UNK"  # TODO
            if operator['text'] == ':':
                return "UNK"  # TODO
            if operator['text'] == '>':
                return "UNK"  # TODO
            if operator['text'] == '-':
                return "UNK"  # TODO
            if operator['text'] == '<':
                return "UNK"  # TODO
            if operator['text'] == 'mod':
                return "UNK"  # TODO
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

        _iter(self._ast)
        return self._ast
