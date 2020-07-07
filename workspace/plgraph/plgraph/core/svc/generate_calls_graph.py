#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import os

from graphviz import Digraph
from pandas import DataFrame
from pandas import Series


class GenerateCallsGraph(object):
    """ Generates a CALLS graph

    Reference
        """

    def __init__(self,
                 calls: list,
                 graph_style: str = "calls",
                 is_debug: bool = True):
        """
        Created:
            6-June-2020
            craigtrim@gmail.com
            *   based on 'generate-graph-v1'
        """
        from plgraph.core.dmo import GraphStyleLoader
        from plgraph.core.dmo import NodeStyleMatcher
        from plgraph.core.dmo import DigraphNodeGenerator
        from plgraph.core.dmo import DigraphEdgeGenerator

        self._calls = calls
        self._is_debug = is_debug

        self._style_loader = GraphStyleLoader(style_name=graph_style,
                                              is_debug=self._is_debug)

        self._node_style_matcher = NodeStyleMatcher(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

        self._node_generator = DigraphNodeGenerator(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

        self._edge_generator = DigraphEdgeGenerator(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

    @staticmethod
    def _cleanse(a_uuid: str) -> str:
        return f"UUID_{a_uuid.replace('-', '_').upper()}"

    @staticmethod
    def _node_id(path: str, module: str) -> str:
        return f"{path}_{module}".upper()

    def _add_nodes(self,
                   graph: Digraph) -> None:
        """
        :param graph:
        """

        def _label(d_call: dict) -> dict:
            row_type = d_call['path'].lower()
            row_text = d_call['module']

            return {'type': row_type,
                    'label': row_text,
                    'text': row_text}

        def _node_dict() -> dict:
            d = {}

            for call in self._calls:
                node_id = self._node_id(path=call['path'], module=call['module'])
                d[node_id] = _label(call)

            return d

        d_nodes = _node_dict()

        for call in self._calls:
            node_id = self._node_id(path=call['path'], module=call['module'])
            graph = self._node_generator.process(graph,
                                                 a_node_id=node_id,
                                                 a_node=d_nodes[node_id])

    def _add_edges(self,
                   graph: Digraph) -> None:

        for call in self._calls:

            subj = self._node_id(path=call['path'], module=call['module'])

            for call_node in call['calls']:
                obj = self._node_id(path=call_node, module=call['module'])

                graph = self._edge_generator.process(graph,
                                                    subj, ".", obj)

    def process(self,
                file_name: str,
                engine: str,
                file_extension: str = "png") -> Digraph:
        graph = Digraph(engine=engine,
                        comment='Calls',
                        format=file_extension,
                        name=file_name)

        graph.attr('node',
                   **self._node_style_matcher.default_node_style())

        self._add_nodes(graph)
        self._add_edges(graph)

        graph.render(file_name)

        return graph


def main():
    import uuid
    from plbase import FileIO

    d_calls = FileIO.file_to_json('resources/output/analysis/calls.json')
    # print (d_calls)

    outdir = os.path.join(os.environ['PROJECT_BASE'], 'resources/output/graphviz/calls')
    if not os.path.exists(outdir):
        os.makedirs(outdir)

    outfile = os.path.join(outdir, f"CALLS-{str(uuid.uuid1())}.d".upper())

    GenerateCallsGraph(d_calls, is_debug=True).process(file_name=outfile, engine="fdp")


if __name__ == "__main__":
    main()