#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from uuid import uuid1

from antlr4 import InputStream
from antlr4 import StdinStream
from antlr4 import CommonTokenStream
from antlr4.tree.Tree import ErrorNodeImpl
from antlr4 import ParseTreeWalker
from PrologLexer import PrologLexer
from PrologListener import PrologListener
from PrologParser import PrologParser
from antlr4.tree.Tree import TerminalNodeImpl
import json
from io import StringIO


def _to_dict(ctx_text: str,
             ctx_name: str,
             children: list) -> dict:
    return {
        "uid": str(uuid1()),
        "type": ctx_name,
        "text": ctx_text,
        "results": _iter_tree(children=children)}


def _clause_context(ctx: PrologParser.ClauseContext):
    return _to_dict(ctx.getText(), "Clause", ctx.children)


def _variable_ctx(ctx: PrologParser.VariableContext):
    return _to_dict(ctx.getText(), "Variable", ctx.children)


def _operator_ctx(ctx: PrologParser.OperatorContext):
    return _to_dict(ctx.getText(), "Operator", ctx.children)


def _atom_ctx(ctx: PrologParser.Atom_termContext):
    return _to_dict(ctx.getText(), "Atomic", ctx.children)


def _graphic_ctx(ctx: PrologParser.GraphicContext):
    return _to_dict(ctx.getText(), "Graphic", ctx.children)


def _error_node(ctx: ErrorNodeImpl):
    return _to_dict(ctx.getText(), "Error Node", [])


def _binary_op_ctx(ctx: PrologParser.Binary_operatorContext):
    return _to_dict(ctx.getText(), "Binary", ctx.children)


def _term_list_context(ctx: PrologParser.TermlistContext):
    return _to_dict(ctx.getText(), "Termlist", ctx.children)


def _name_context(ctx: PrologParser.NameContext):
    return _to_dict(ctx.getText(), "Name", ctx.children)


def _compound_term_ctx(ctx: PrologParser.Compound_termContext) -> dict:
    return _to_dict(ctx.getText(), "Compound", ctx.children)


def _dq_ctx(ctx: PrologParser.Dq_stringContext) -> dict:
    return _to_dict(ctx.getText(), "DQS", ctx.children)


def _iter_tree(children: list):
    results = []
    for child in children:
        if type(child) == PrologParser.TermlistContext:
            results.append(_term_list_context(child))
        elif type(child) == PrologParser.NameContext:
            results.append(_name_context(child))
        elif type(child) == PrologParser.Compound_termContext:
            results.append(_compound_term_ctx(child))
        elif type(child) == PrologParser.Binary_operatorContext:
            results.append(_binary_op_ctx(child))
        elif type(child) == PrologParser.VariableContext:
            results.append(_variable_ctx(child))
        elif type(child) == PrologParser.ClauseContext:
            results.append(_clause_context(child))
        elif type(child) == PrologParser.OperatorContext:
            results.append(_operator_ctx(child))
        elif type(child) == PrologParser.Dq_stringContext:
            results.append(_dq_ctx(child))
        elif type(child) == PrologParser.Atom_termContext:
            results.append(_atom_ctx(child))
        elif type(child) == PrologParser.GraphicContext:
            results.append(_graphic_ctx(child))
        elif type(child) == ErrorNodeImpl:
            results.append(_error_node(child))
        elif type(child) == TerminalNodeImpl:
            continue
        else:
            raise NotImplementedError(type(child))

    return results


def main():
    char_stream = InputStream("""
        parent("Bill", "John").
        parent("Pam", "Bill").
        father(Person, Father) :- parent(Person, Father), person(Father, "male").
        mother(Person, Mother) :- parent(Person, Mother), person(Mother, "female").
        
        person("Bill", "male").
        person("Pam", "female").
        
        father(person("Bill", "male"), person("John", "male")).
        father(person("Pam", "male"), person("Bill", "male")).
        father(person("Sue", "female"), person("Jim", "male")).
        grandfather(Person, Grandfather) :-
            father(Father, Grandfather),
            father(Person, Father).
    """)

    lexer = PrologLexer(char_stream)
    stream = CommonTokenStream(lexer)
    parser = PrologParser(stream)

    tree = parser.p_text()
    d = _to_dict("Root", "Root", tree.children)

    io = StringIO()
    json.dump([d], io)
    print(io.getvalue())


if __name__ == '__main__':
    main()
