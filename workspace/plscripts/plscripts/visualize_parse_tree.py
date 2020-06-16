#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import os

from plbase import FileIO
from plgraph import GraphvizAPI
from plparse import ParsePrologAPI

IS_DEBUG = True


def main(input_file):
    """
    Purpose:
        Performs a straightforward AST visualization
        This graph tends to get noisy with large prolog programs, but is suitable for visualizing snippets of code
    Reference:
        https://github.com/craigtrim/prolog_antlr/issues/14#issuecomment-645004352
    Updated:
        16-June-2020
        craigtrim@gmail.com
        *   renamed from 'generate_graph_v1_01'
    """

    source_lines = FileIO.file_to_lines(os.path.join(os.environ['PROJECT_BASE'],
                                                     'resources/input/prolog',
                                                     input_file))

    parser_api = ParsePrologAPI(is_debug=IS_DEBUG)
    grapher_api = GraphvizAPI(is_debug=IS_DEBUG)

    ast = parser_api.parse(source_lines)
    ast = parser_api.post_process(ast)
    df_ast = parser_api.as_dataframe(ast)

    grapher_api.graph_v1(df_ast, file_name=input_file)


if __name__ == '__main__':
    import plac

    plac.call(main)
