# Generated from Prolog.g4 by ANTLR 4.8
from antlr4 import *
if __name__ is not None and "." in __name__:
    from .PrologParser import PrologParser
else:
    from workspace.parser import PrologParser

# This class defines a complete listener for a parse tree produced by PrologParser.
class PrologListener(ParseTreeListener):

    # Enter a parse tree produced by PrologParser#p_text.
    def enterP_text(self, ctx:PrologParser.P_textContext):
        pass

    # Exit a parse tree produced by PrologParser#p_text.
    def exitP_text(self, ctx:PrologParser.P_textContext):
        pass


    # Enter a parse tree produced by PrologParser#directive.
    def enterDirective(self, ctx:PrologParser.DirectiveContext):
        pass

    # Exit a parse tree produced by PrologParser#directive.
    def exitDirective(self, ctx:PrologParser.DirectiveContext):
        pass


    # Enter a parse tree produced by PrologParser#clause.
    def enterClause(self, ctx:PrologParser.ClauseContext):
        pass

    # Exit a parse tree produced by PrologParser#clause.
    def exitClause(self, ctx:PrologParser.ClauseContext):
        pass


    # Enter a parse tree produced by PrologParser#termlist.
    def enterTermlist(self, ctx:PrologParser.TermlistContext):
        pass

    # Exit a parse tree produced by PrologParser#termlist.
    def exitTermlist(self, ctx:PrologParser.TermlistContext):
        pass


    # Enter a parse tree produced by PrologParser#atom_term.
    def enterAtom_term(self, ctx:PrologParser.Atom_termContext):
        pass

    # Exit a parse tree produced by PrologParser#atom_term.
    def exitAtom_term(self, ctx:PrologParser.Atom_termContext):
        pass


    # Enter a parse tree produced by PrologParser#binary_operator.
    def enterBinary_operator(self, ctx:PrologParser.Binary_operatorContext):
        pass

    # Exit a parse tree produced by PrologParser#binary_operator.
    def exitBinary_operator(self, ctx:PrologParser.Binary_operatorContext):
        pass


    # Enter a parse tree produced by PrologParser#unary_operator.
    def enterUnary_operator(self, ctx:PrologParser.Unary_operatorContext):
        pass

    # Exit a parse tree produced by PrologParser#unary_operator.
    def exitUnary_operator(self, ctx:PrologParser.Unary_operatorContext):
        pass


    # Enter a parse tree produced by PrologParser#braced_term.
    def enterBraced_term(self, ctx:PrologParser.Braced_termContext):
        pass

    # Exit a parse tree produced by PrologParser#braced_term.
    def exitBraced_term(self, ctx:PrologParser.Braced_termContext):
        pass


    # Enter a parse tree produced by PrologParser#list_term.
    def enterList_term(self, ctx:PrologParser.List_termContext):
        pass

    # Exit a parse tree produced by PrologParser#list_term.
    def exitList_term(self, ctx:PrologParser.List_termContext):
        pass


    # Enter a parse tree produced by PrologParser#variable.
    def enterVariable(self, ctx:PrologParser.VariableContext):
        pass

    # Exit a parse tree produced by PrologParser#variable.
    def exitVariable(self, ctx:PrologParser.VariableContext):
        pass


    # Enter a parse tree produced by PrologParser#float.
    def enterFloat(self, ctx:PrologParser.FloatContext):
        pass

    # Exit a parse tree produced by PrologParser#float.
    def exitFloat(self, ctx:PrologParser.FloatContext):
        pass


    # Enter a parse tree produced by PrologParser#compound_term.
    def enterCompound_term(self, ctx:PrologParser.Compound_termContext):
        pass

    # Exit a parse tree produced by PrologParser#compound_term.
    def exitCompound_term(self, ctx:PrologParser.Compound_termContext):
        pass


    # Enter a parse tree produced by PrologParser#integer_term.
    def enterInteger_term(self, ctx:PrologParser.Integer_termContext):
        pass

    # Exit a parse tree produced by PrologParser#integer_term.
    def exitInteger_term(self, ctx:PrologParser.Integer_termContext):
        pass


    # Enter a parse tree produced by PrologParser#curly_bracketed_term.
    def enterCurly_bracketed_term(self, ctx:PrologParser.Curly_bracketed_termContext):
        pass

    # Exit a parse tree produced by PrologParser#curly_bracketed_term.
    def exitCurly_bracketed_term(self, ctx:PrologParser.Curly_bracketed_termContext):
        pass


    # Enter a parse tree produced by PrologParser#operator.
    def enterOperator(self, ctx:PrologParser.OperatorContext):
        pass

    # Exit a parse tree produced by PrologParser#operator.
    def exitOperator(self, ctx:PrologParser.OperatorContext):
        pass


    # Enter a parse tree produced by PrologParser#empty_list.
    def enterEmpty_list(self, ctx:PrologParser.Empty_listContext):
        pass

    # Exit a parse tree produced by PrologParser#empty_list.
    def exitEmpty_list(self, ctx:PrologParser.Empty_listContext):
        pass


    # Enter a parse tree produced by PrologParser#empty_braces.
    def enterEmpty_braces(self, ctx:PrologParser.Empty_bracesContext):
        pass

    # Exit a parse tree produced by PrologParser#empty_braces.
    def exitEmpty_braces(self, ctx:PrologParser.Empty_bracesContext):
        pass


    # Enter a parse tree produced by PrologParser#name.
    def enterName(self, ctx:PrologParser.NameContext):
        pass

    # Exit a parse tree produced by PrologParser#name.
    def exitName(self, ctx:PrologParser.NameContext):
        pass


    # Enter a parse tree produced by PrologParser#graphic.
    def enterGraphic(self, ctx:PrologParser.GraphicContext):
        pass

    # Exit a parse tree produced by PrologParser#graphic.
    def exitGraphic(self, ctx:PrologParser.GraphicContext):
        pass


    # Enter a parse tree produced by PrologParser#quoted_string.
    def enterQuoted_string(self, ctx:PrologParser.Quoted_stringContext):
        pass

    # Exit a parse tree produced by PrologParser#quoted_string.
    def exitQuoted_string(self, ctx:PrologParser.Quoted_stringContext):
        pass


    # Enter a parse tree produced by PrologParser#dq_string.
    def enterDq_string(self, ctx:PrologParser.Dq_stringContext):
        pass

    # Exit a parse tree produced by PrologParser#dq_string.
    def exitDq_string(self, ctx:PrologParser.Dq_stringContext):
        pass


    # Enter a parse tree produced by PrologParser#backq_string.
    def enterBackq_string(self, ctx:PrologParser.Backq_stringContext):
        pass

    # Exit a parse tree produced by PrologParser#backq_string.
    def exitBackq_string(self, ctx:PrologParser.Backq_stringContext):
        pass


    # Enter a parse tree produced by PrologParser#semicolon.
    def enterSemicolon(self, ctx:PrologParser.SemicolonContext):
        pass

    # Exit a parse tree produced by PrologParser#semicolon.
    def exitSemicolon(self, ctx:PrologParser.SemicolonContext):
        pass


    # Enter a parse tree produced by PrologParser#cut.
    def enterCut(self, ctx:PrologParser.CutContext):
        pass

    # Exit a parse tree produced by PrologParser#cut.
    def exitCut(self, ctx:PrologParser.CutContext):
        pass


    # Enter a parse tree produced by PrologParser#integer.
    def enterInteger(self, ctx:PrologParser.IntegerContext):
        pass

    # Exit a parse tree produced by PrologParser#integer.
    def exitInteger(self, ctx:PrologParser.IntegerContext):
        pass



del PrologParser