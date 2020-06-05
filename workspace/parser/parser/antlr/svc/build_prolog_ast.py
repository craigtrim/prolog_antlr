#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from uuid import uuid1

from antlr4.tree.Tree import ErrorNodeImpl
from antlr4.tree.Tree import TerminalNodeImpl

from parser.antlr.dmo import PrologParser


class BuildPrologAST(object):
    """ Given an ANTLR tree structure as input
        Generate an AST as a list for output """

    def __init__(self,
                 tree: PrologParser.P_textContext,
                 is_debug: bool = False):
        """
        Created:
            2-June-2020
            craig.trim@ibm.com
            *   https://github.com/craigtrim/prolog_antlr/issues/2
        Updated:
            3-Jun-2020
            craig.trim@ibm.com
            *   add UUID standardization
                https://github.com/craigtrim/prolog_antlr/issues/6#issuecomment-638514140
        """
        self._tree = tree
        self._is_debug = is_debug
        self._d_session_uuid = {}

    def _cached_uuid_by_name(self,
                             ctx_name: str,
                             ctx_text: str) -> str:
        if ctx_name not in self._d_session_uuid:
            self._d_session_uuid[ctx_name] = {}
        if ctx_text not in self._d_session_uuid[ctx_name]:
            self._d_session_uuid[ctx_name][ctx_text] = str(uuid1())
        return self._d_session_uuid[ctx_name][ctx_text]

    def _to_dict(self,
                 ctx_text: str,
                 ctx_name: str,
                 children: list) -> dict:

        def _uuid() -> str:
            if ctx_name.lower() == 'variable':
                return self._cached_uuid_by_name(ctx_name='variable',
                                                 ctx_text=ctx_text)
            if ctx_name.lower() == 'name':
                return self._cached_uuid_by_name(ctx_name='name',
                                                 ctx_text=ctx_text)
            if ctx_name.lower() in ['atomic', 'string']:
                return self._cached_uuid_by_name(ctx_name='string',
                                                 ctx_text=ctx_text)

            return str(uuid1())

        return {
            "uuid": _uuid(),
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

    def _term_context(self,
                      ctx: PrologParser.List_termContext) -> dict:
        return self._to_dict(ctx.getText(), "Termlist", ctx.children)

    def _cut_context(self,
                     ctx: PrologParser.CutContext) -> dict:
        return self._to_dict(ctx.getText(), "Cut", ctx.children)

    def _braced_term_context(self,
                             ctx: PrologParser.Braced_termContext) -> dict:
        return self._to_dict(ctx.getText(), "BracedTerm", ctx.children)

    def _directive_context(self,
                           ctx: PrologParser.DirectiveContext) -> dict:
        return self._to_dict(ctx.getText(), "Directive", ctx.children)

    def _unary_operator_context(self,
                                ctx: PrologParser.Unary_operatorContext) -> dict:
        return self._to_dict(ctx.getText(), "Unary", ctx.children)

    def _integer_context(self,
                         ctx: PrologParser.Integer_termContext) -> dict:
        return self._to_dict(ctx.getText(), "Integer", ctx.children)

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
            elif type(child) == PrologParser.List_termContext:
                results.append(self._term_context(child))
            elif type(child) == PrologParser.CutContext:
                results.append(self._cut_context(child))
            elif type(child) == PrologParser.Braced_termContext:
                results.append(self._braced_term_context(child))
            elif type(child) == PrologParser.DirectiveContext:
                results.append(self._directive_context(child))
            elif type(child) == PrologParser.Unary_operatorContext:
                results.append(self._unary_operator_context(child))
            elif type(child) == PrologParser.Integer_termContext \
                    or type(child) == PrologParser.IntegerContext:
                results.append(self._integer_context(child))
            elif type(child) == ErrorNodeImpl:
                results.append(self._error_node(child))
            elif type(child) == TerminalNodeImpl:
                continue
            else:
                raise NotImplementedError(type(child))

        return results

    def process(self) -> list:
        d = self._iter_tree(self._tree.children)

        return d
