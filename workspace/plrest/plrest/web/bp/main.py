#!/usr/bin/env python
# -*- coding: utf-8 -*-


import pprint
import time

from fastapi import FastAPI
from fastapi import Response, status

app = FastAPI()


@app.post("/antlr/parse/{language_name}",
          response_model=list,
          response_model_exclude_unset=True,
          tags=["Parse"],
          summary="Parse Prolog Source Code",
          description="Generate an AST (Abstract Syntax Tree) from Prolog Source Code",
          response_description="An AST (Abstract Syntax Tree) as a JSON-compatible list")
def apply_model(source_lines: list):
    start = time.time()

    svcresult = None

    from plparse.antlr.bp import ParsePrologAPI

    parser_api = ParsePrologAPI(is_debug=False)
    ast = parser_api.parse(source_lines=source_lines,
                                         print_output=False)
    ast = parser_api.post_process(ast, print_output=True)

    print('\n'.join([
        "Web Method Completed",
        f"\tTotal Time: {time.time() - start}",
        f"\tInput: {pprint.pformat(source_lines, indent=4)}",
        f"\tOutput: {pprint.pformat(svcresult.json, indent=4)}"]))

    return ast
