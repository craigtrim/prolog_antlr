# !/usr/bin/env python
# -*- coding: UTF-8 -*-


import unittest

from plparse import RetainClausesOnly

IS_DEBUG = True


class RetainClausesOnlyTest(unittest.TestCase):

    def execute(self,
                    source_lines:list):
        return RetainClausesOnly(is_debug=True, source_lines=source_lines).process()

    def test_01(self):
        the_input = [
            '\ufeff% CausalityLink', 
            '', 
            'implement misc', 
            'open core', 
            '', 
            'facts', 
            'db : database.', 
            'datetime : date.', 
            'ctx : context.', 
            'pats : patterns.', 
            '', 
            'clauses', 
            'new(Database, DateTime, Context, Patterns) :-', 
            'db := Database,', 
            'datetime := DateTime,',
            'ctx := Context,', 
            'pats := Patterns.', 
            '', 
            'reloadWordsAfterCleaning() :-', 
            'db:getIncrementalParsing(_MaxNumberOfParagraphs, _NbrParagraphsAtATime, _MaxNbrSentencesAtATime, CurrentFirstParagraph, CurrentLastParagraph,', 
            '_FileExtension),', 
            '!,', 
            'db:getParagraph(_AID, PID, _CID, PositionInArticle),', 
            'PositionInArticle < CurrentLastParagraph + 1,', 
            'PositionInArticle > CurrentFirstParagraph - 1,', 
            'reloadWordsAfterCleaningInParagraph(PID, PositionInArticle),', 
            'fail()', 
            'or', 
            'succeed().', 
            '', 
            'end implement misc'
        ]


        the_expected_output = [
            'new(Database, DateTime, Context, Patterns) :-', 
            'db := Database,', 
            'datetime := DateTime,',
            'ctx := Context,', 
            'pats := Patterns.', 
            '', 
            'reloadWordsAfterCleaning() :-', 
            'db:getIncrementalParsing(_MaxNumberOfParagraphs, _NbrParagraphsAtATime, _MaxNbrSentencesAtATime, CurrentFirstParagraph, CurrentLastParagraph,', 
            '_FileExtension),', 
            '!,', 
            'db:getParagraph(_AID, PID, _CID, PositionInArticle),', 
            'PositionInArticle < CurrentLastParagraph + 1,', 
            'PositionInArticle > CurrentFirstParagraph - 1,', 
            'reloadWordsAfterCleaningInParagraph(PID, PositionInArticle),', 
            'fail()', 
            'or', 
            'succeed().', 
            ''
        ]

        the_actual_output = self.execute(the_input)

        self.assertEqual(len(the_actual_output), len(the_expected_output))
        self.assertEqual(the_actual_output, the_expected_output)


if __name__ == '__main__':
    unittest.main()
