#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from pandas import DataFrame


class GraphvizAPI(object):

    def __init__(self):
        pass

    @staticmethod
    def dot(df_ast: DataFrame):
        from grapher.core.svc import GenerateDotGraph

        GenerateDotGraph(df_ast=df_ast,
                         graph_style="nlp").process(file_name="output",
                                                    engine="dot")


def main():
    ast = [
        {
            "uid": "051b25f6-a532-11ea-989f-acde48001122",
            "type": "Clause",
            "text": "parent(\"Bill\",\"John\").",
            "results": [
                {
                    "uid": "051b2862-a532-11ea-989f-acde48001122",
                    "type": "Compound",
                    "text": "parent(\"Bill\",\"John\")",
                    "results": [
                        {
                            "uid": "051b28d0-a532-11ea-989f-acde48001122",
                            "type": "Name",
                            "text": "parent",
                            "results": []
                        },
                        {
                            "uid": "051b29c0-a532-11ea-989f-acde48001122",
                            "type": "Termlist",
                            "text": "\"Bill\",\"John\"",
                            "results": [
                                {
                                    "uid": "051b2a74-a532-11ea-989f-acde48001122",
                                    "type": "Binary",
                                    "text": "\"Bill\",\"John\"",
                                    "results": [
                                        {
                                            "uid": "051b2ae2-a532-11ea-989f-acde48001122",
                                            "type": "Atomic",
                                            "text": "\"Bill\"",
                                            "results": [
                                                {
                                                    "uid": "051b2b46-a532-11ea-989f-acde48001122",
                                                    "type": "String",
                                                    "text": "\"Bill\"",
                                                    "results": []
                                                }
                                            ]
                                        },
                                        {
                                            "uid": "051b2bb4-a532-11ea-989f-acde48001122",
                                            "type": "Operator",
                                            "text": ",",
                                            "results": []
                                        },
                                        {
                                            "uid": "051b2c2c-a532-11ea-989f-acde48001122",
                                            "type": "Atomic",
                                            "text": "\"John\"",
                                            "results": [
                                                {
                                                    "uid": "051b2c86-a532-11ea-989f-acde48001122",
                                                    "type": "String",
                                                    "text": "\"John\"",
                                                    "results": []
                                                }
                                            ]
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ]
        },
        {
            "uid": "051b2dd0-a532-11ea-989f-acde48001122",
            "type": "Clause",
            "text": "parent(\"Pam\",\"Bill\").",
            "results": [
                {
                    "uid": "051b2eca-a532-11ea-989f-acde48001122",
                    "type": "Compound",
                    "text": "parent(\"Pam\",\"Bill\")",
                    "results": [
                        {
                            "uid": "051b2f1a-a532-11ea-989f-acde48001122",
                            "type": "Name",
                            "text": "parent",
                            "results": []
                        },
                        {
                            "uid": "051b2fe2-a532-11ea-989f-acde48001122",
                            "type": "Termlist",
                            "text": "\"Pam\",\"Bill\"",
                            "results": [
                                {
                                    "uid": "051b308c-a532-11ea-989f-acde48001122",
                                    "type": "Binary",
                                    "text": "\"Pam\",\"Bill\"",
                                    "results": [
                                        {
                                            "uid": "051b30f0-a532-11ea-989f-acde48001122",
                                            "type": "Atomic",
                                            "text": "\"Pam\"",
                                            "results": [
                                                {
                                                    "uid": "051b314a-a532-11ea-989f-acde48001122",
                                                    "type": "String",
                                                    "text": "\"Pam\"",
                                                    "results": []
                                                }
                                            ]
                                        },
                                        {
                                            "uid": "051b31ae-a532-11ea-989f-acde48001122",
                                            "type": "Operator",
                                            "text": ",",
                                            "results": []
                                        },
                                        {
                                            "uid": "051b321c-a532-11ea-989f-acde48001122",
                                            "type": "Atomic",
                                            "text": "\"Bill\"",
                                            "results": [
                                                {
                                                    "uid": "051b3276-a532-11ea-989f-acde48001122",
                                                    "type": "String",
                                                    "text": "\"Bill\"",
                                                    "results": []
                                                }
                                            ]
                                        }
                                    ]
                                }
                            ]
                        }
                    ]
                }
            ]
        }
    ]



    GraphvizAPI.dot(ast)


if __name__ == '__main__':
    main()
