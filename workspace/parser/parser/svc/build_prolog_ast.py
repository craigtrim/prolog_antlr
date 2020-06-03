#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from uuid import uuid1

from antlr4.tree.Tree import ErrorNodeImpl
from antlr4.tree.Tree import TerminalNodeImpl
from parser.dmo import PrologParser


class BuildPrologAST(object):
    """ Given an ANTLR tree structure as input
        Generate an AST as a list for output """

    def __init__(self,
                 tree: PrologParser.P_textContext):
        """
        Created:
            2-June-2020
            craig.trim@ibm.com
            *   https://github.com/craigtrim/prolog_antlr/issues/2
        """
        self._tree = tree

    def _to_dict(self,
                 ctx_text: str,
                 ctx_name: str,
                 children: list) -> dict:
        uuid = str(uuid1())

        return {
            "uid": uuid,
            "type": ctx_name,
            "text": ctx_text,
            "results": self._iter_tree(children=children)}

    def _clause_context(self,
                        ctx: PrologParser.ClauseContext):
        return self._to_dict(ctx.getText(), "Clause", ctx.children)

    def _variable_ctx(self,
                      ctx: PrologParser.VariableContext):
        return self._to_dict(ctx.getText(), "Variable", ctx.children)

    def _operator_ctx(self,
                      ctx: PrologParser.OperatorContext):
        return self._to_dict(ctx.getText(), "Operator", ctx.children)

    def _atom_ctx(self,
                  ctx: PrologParser.Atom_termContext):
        return self._to_dict(ctx.getText(), "Atomic", ctx.children)

    def _graphic_ctx(self,
                     ctx: PrologParser.GraphicContext):
        return self._to_dict(ctx.getText(), "Graphic", ctx.children)

    def _error_node(self,
                    ctx: ErrorNodeImpl):
        return self._to_dict(ctx.getText(), "Error Node", [])

    def _binary_op_ctx(self,
                       ctx: PrologParser.Binary_operatorContext):
        return self._to_dict(ctx.getText(), "Binary", ctx.children)

    def _term_list_context(self,
                           ctx: PrologParser.TermlistContext):
        return self._to_dict(ctx.getText(), "Termlist", ctx.children)

    def _name_context(self,
                      ctx: PrologParser.NameContext):
        return self._to_dict(ctx.getText(), "Name", ctx.children)

    def _compound_term_ctx(self,
                           ctx: PrologParser.Compound_termContext) -> dict:
        return self._to_dict(ctx.getText(), "Compound", ctx.children)

    def _dq_ctx(self,
                ctx: PrologParser.Dq_stringContext) -> dict:
        return self._to_dict(ctx.getText(), "String", ctx.children)

    def _sq_ctx(self,
                ctx: PrologParser.Quoted_stringContext) -> dict:
        return self._to_dict(ctx.getText(), "String", ctx.children)

    def _iter_tree(self,
                   children: list) -> list:
        results = []
        for child in children:
            if type(child) == PrologParser.TermlistContext:
                results.append(self._term_list_context(child))
            elif type(child) == PrologParser.NameContext:
                results.append(self._name_context(child))
            elif type(child) == PrologParser.Compound_termContext:
                results.append(self._compound_term_ctx(child))
            elif type(child) == PrologParser.Binary_operatorContext:
                results.append(self._binary_op_ctx(child))
            elif type(child) == PrologParser.VariableContext:
                results.append(self._variable_ctx(child))
            elif type(child) == PrologParser.ClauseContext:
                results.append(self._clause_context(child))
            elif type(child) == PrologParser.OperatorContext:
                results.append(self._operator_ctx(child))
            elif type(child) == PrologParser.Dq_stringContext:
                results.append(self._dq_ctx(child))
            elif type(child) == PrologParser.Quoted_stringContext:
                results.append(self._sq_ctx(child))
            elif type(child) == PrologParser.Atom_termContext:
                results.append(self._atom_ctx(child))
            elif type(child) == PrologParser.GraphicContext:
                results.append(self._graphic_ctx(child))
            elif type(child) == ErrorNodeImpl:
                results.append(self._error_node(child))
            elif type(child) == TerminalNodeImpl:
                continue
            else:
                raise NotImplementedError(type(child))

        return results

    def process(self) -> list:
        return self._iter_tree(self._tree.children)
