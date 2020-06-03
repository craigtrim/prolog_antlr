#!/usr/bin/env python
# -*- coding: UTF-8 -*-


class ParsePrologAPI(object):

    def __init__(self):
        pass

    @staticmethod
    def parse(source_lines: list) -> list:
        from parser.svc import ParsePrologSource
        from parser.svc import BuildPrologAST
        from parser.svc import GeneratePandasDataFrame

        if type(source_lines) != list:
            raise ValueError("Expected List Input")

        tree = ParsePrologSource(source_lines=source_lines).process()
        ast = BuildPrologAST(tree=tree).process()

        df = GeneratePandasDataFrame(ast=ast).process()
        from tabulate import tabulate

        print(tabulate(df, tablefmt='psql', headers='keys'))

        if type(ast) != list:
            raise ValueError("Expected List Ouput")

        return ast


def main():
    source_code = """
        parent("Bill", "John").
        parent("Pam", "Bill").
        father(Person, Father) :- parent(Person, Father), person(Father, "male").
        mother(Person, Mother) :- parent(Person, Mother), person(Mother, "female").

        person('Bill', "male").
        person("Pam", "female").

        father(person("Bill", "male"), person("John", "male")).
        father(person("Pam", "male"), person("Bill", "male")).
        father(person("Sue", "female"), person("Jim", "male")).
        grandfather(Person, Grandfather) :-
            father(Father, Grandfather),
            father(Person, Father).
    """

    source_lines = [x.strip() for x in source_code.split('\n')]

    tree = ParsePrologAPI.parse(source_lines)
    print(type(tree))

    # import pprint
    # pprint.pprint(tree, indent=4)


if __name__ == '__main__':
    main()
