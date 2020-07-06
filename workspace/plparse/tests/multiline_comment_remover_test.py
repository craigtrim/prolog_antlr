# !/usr/bin/env python
# -*- coding: UTF-8 -*-


import unittest

from plparse import MultilineCommentRemover

IS_DEBUG = True


class MultilineCommentRemoverTest(unittest.TestCase):

    def execute(self,
                    source_lines:list):
        return MultilineCommentRemover(is_debug=True, source_lines=source_lines).process()

    def test_01(self):
        the_input = [
            'line 1',
            'line 2',
            '/*',
            'line 3',
            'line 4',
            'line 5',
            'line 6',
            '*/',
            'line 7',
            'line 8',
            'line 9'
        ]

        the_expected_output = [
            'line 1',
            'line 2',
            'line 7',
            'line 8',
            'line 9'
        ]

        the_actual_output = self.execute(the_input)
        self.assertEqual(the_actual_output, the_expected_output)

if __name__ == '__main__':
    unittest.main()
