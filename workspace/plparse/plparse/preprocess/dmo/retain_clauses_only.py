#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from plbase import BaseObject

import pprint

from antlr4.tree.Tree import ErrorNodeImpl
from antlr4.tree.Tree import TerminalNodeImpl


class RetainClausesOnly(BaseObject):
    """ A Visual Prolog module is structured like this
    
            % Comment

            implement misc
                open core

            facts
                db : database.
                datetime : date.
                ctx : context.
                pats : patterns.

            clauses
                new(Database, DateTime, Context, Patterns) :-
                    db := Database,
                    datetime := DateTime,
            
                reloadWordsAfterCleaning() :-
                    db:getIncrementalParsing(_MaxNumberOfParagraphs, _NbrParagraphsAtATime, _MaxNbrSentencesAtATime, CurrentFirstParagraph, CurrentLastParagraph,
                        _FileExtension).
            
            end implement misc
    
        At the conclusion of this module we will only retain the clauses

            new(Database, DateTime, Context, Patterns) :-
                db := Database,
                datetime := DateTime,
        
            reloadWordsAfterCleaning() :-
                db:getIncrementalParsing(_MaxNumberOfParagraphs, _NbrParagraphsAtATime, _MaxNbrSentencesAtATime, CurrentFirstParagraph, CurrentLastParagraph,
                    _FileExtension).
        
    """

    def __init__(self,
                 source_lines: list,
                 is_debug: bool = False):
        """
        Created:
            6-July-2020
            craigtrim@gmail.com
            *   refactored out of 'preprocess-prolog-source'
        """
        BaseObject.__init__(self, __name__)
        self._is_debug = is_debug
        self._source_lines = source_lines

    def process(self) -> list:
        normalized = []

        is_clauses_section = False

        i = 0
        while i < len(self._source_lines):
            if is_clauses_section:
                if not self._source_lines[i].strip().startswith('end implement'):
                    normalized.append(self._source_lines[i])
            else:
                is_clauses_section = self._source_lines[i].strip() == 'clauses'

            i += 1

        return normalized
