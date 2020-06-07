#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import json
import os

from graphviz import Digraph
from pandas import DataFrame


class GenerateGraphV2(object):
    """

    Reference
        https://github.com/craigtrim/prolog_antlr/issues/9#issuecomment-639106295"""

    def __init__(self,
                 df_ast: DataFrame,
                 graph_style: str = "gv2",
                 is_debug: bool = True):
        """
        Created:
            2-June-2020
            craig.trim@ibm.com
            *   https://github.com/craigtrim/prolog_antlr/issues/2
        """
        from grapher.core.dmo import GraphStyleLoader
        from grapher.core.dmo import NodeStyleMatcher
        from grapher.core.dmo import DigraphNodeGenerator
        from grapher.core.dmo import DigraphEdgeGenerator

        self._df_ast = df_ast
        self._is_debug = is_debug
        self._d_node_ids = {}

        self._style_loader = GraphStyleLoader(style_name=graph_style,
                                              is_debug=self._is_debug)

        self._node_style_matcher = NodeStyleMatcher(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

        self._node_generator = DigraphNodeGenerator(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

        self._edge_generator = DigraphEdgeGenerator(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

    def _iter(self,
              items: list):
        pass

    def _cleanse(self,
                 a_uuid: str,
                 suffix: str = None) -> str:

        giz_uuid = f"UUID_{a_uuid.replace('-', '_').upper()}"
        if giz_uuid not in self._d_node_ids:
            self._d_node_ids[giz_uuid] = []

        if not suffix:
            return giz_uuid

        variant = f"{giz_uuid}_{suffix}"
        if variant not in self._d_node_ids[giz_uuid]:
            self._d_node_ids[giz_uuid].append(variant)

        return variant

    def _add_nodes(self,
                   graph: Digraph,
                   triples: list,
                   tag: str = None,
                   suffix: str = None) -> None:
        """
        :param graph:
        """

        for triple in triples:
            for d_node in triple["Triple"]:

                def _type() -> str:
                    if tag:
                        return f"{d_node['Type']}_{tag}"
                    return d_node['Type']

                uuid = self._cleanse(d_node['UUID'], suffix=suffix)
                graph = self._node_generator.process(
                    graph=graph,
                    a_node_id=uuid,
                    a_node={"label": d_node['Text'],
                            "text": d_node['Text'],
                            "type": _type()})

    def _add_edges(self,
                   graph: Digraph,
                   triples: list,
                   suffix: str = None) -> None:

        for triple in triples:
            if len(triple['Triple']) != 2:
                raise NotImplementedError("Unhandled Triple Style")

            subj = triple['Triple'][0]
            obj = triple['Triple'][1]

            graph = self._edge_generator.process(graph,
                                                 self._cleanse(subj["UUID"], suffix=suffix),
                                                 subj["Predicate"],
                                                 self._cleanse(obj["UUID"], suffix=suffix))

    def _triples(self,
                 dump_json: bool = False) -> list:
        """
        Purpose:
            Extract Triples from AST Compound Formations
        Reference:
            https://github.com/craigtrim/prolog_antlr/issues/9#issuecomment-640114990
        """
        from grapher.core.dmo import CompoundTripleExtractor

        triples = []
        triple_extractor = CompoundTripleExtractor(df_ast=self._df_ast,
                                                   is_debug=self._is_debug)

        df_compounds = self._df_ast[self._df_ast['Type'] == 'Compound']
        for _, row in df_compounds.iterrows():
            triples.append({
                "Compound": row['Text'],
                "Triple": triple_extractor.process(row)})

        if dump_json:
            print(json.dumps(triples))

        return triples

    @staticmethod
    def _cartesian(some_values: list) -> list:
        """
        Purpose:
            Generate a Cartesian Product of a Series of Lists
        Implementation:
            1.  Given a Series of Lists
                [ [44, 12, 8], [49], [47] ]
            2.  Generate a Cartesian Product
                [(44, 49, 47), (12, 49, 47), (8, 49, 47)]
        Reference:
            https://stackoverflow.com/questions/533905/get-the-cartesian-product-of-a-series-of-lists
        :param some_values:
            a list of avlues
        :return:
            a Cartesian Product of the input values
        """
        s = set()

        for x in some_values:
            for y in some_values:
                if x != y:
                    s.add(','.join(sorted({x, y})))

        return sorted(s)

    def process(self,
                file_name: str,
                engine: str,
                file_extension: str = "png") -> Digraph:

        graph = Digraph(engine=engine,
                        comment='Schema',
                        format=file_extension,
                        name=file_name)

        graph.attr('node',
                   **self._node_style_matcher.default_node_style())

        triples = self._triples(dump_json=True)

        predicate_set = set()
        for triple in triples:
            predicate_set.add(triple['Triple'][0]['Predicate'])

        predicate_set = sorted(predicate_set)

        def _color_scheme() -> str:
            if len(predicate_set) <= 3:
                return "orrd3"
            if len(predicate_set) <= 4:
                return "orrd4"
            if len(predicate_set) <= 5:
                return "orrd5"
            if len(predicate_set) <= 6:
                return "orrd6"
            if len(predicate_set) <= 7:
                return "orrd7"
            if len(predicate_set) <= 8:
                return "orrd8"
            if len(predicate_set) <= 9:
                return "orrd9"
            raise NotImplementedError("Color Scheme Needs Attention")

        def _color_int(a_triple: dict) -> str:
            for i in range(0, len(predicate_set)):
                if predicate_set[i] == a_triple['Triple'][0]['Predicate']:
                    return str(i + 1)

            raise NotImplementedError

        color_scheme = _color_scheme()

        ctr = 0
        for triple in triples:
            subgraph_name = f"Cluster{ctr}"
            with graph.subgraph(name=subgraph_name) as c:
                c.attr(label=triple['Compound'],
                       colorscheme=color_scheme,
                       color=_color_int(triple),
                       fontsize='10',
                       fontname='Helvetica')
                self._add_nodes(c, [triple], suffix=subgraph_name, tag="cluster")
                self._add_edges(c, [triple], suffix=subgraph_name)
            ctr += 1

        self._add_nodes(graph, triples)
        self._add_edges(graph, triples)

        for k in self._d_node_ids:
            cartesian = self._cartesian(self._d_node_ids[k])
            cartesian = [x.split(',') for x in cartesian]

            print('\n'.join([
                "Cartesian Join on Clustered Values",
                f"\tOriginal UUID: {k}",
                f"\tCartesian Values: {cartesian}"]))

            for vc in cartesian:
                s = vc[0].split('_')[-1]
                o = vc[1].split('_')[-1]

                print("HERE --------> ", vc[0], " --> ", vc[1], " --> ", s, " --> ", o)

                # style: 'dotted'
                # colorscheme: 'greys9'
                # color: '2'
                # arrowhead: none
                # fontsize: '5'
                # weight: '0.5'
                graph.edge(tail_name=vc[0],
                           head_name=vc[1],
                           label="",
                           ltail=s,
                           lhead=o,
                           style="dotted",
                           colorscheme="greys9",
                           color="4",
                           arrowhead="none",
                           fontsize="5",
                           weight="2")

                # "Item 1" -> "Item 3"[ltail = cluster_0 lhead = cluster_1];
                # "Item 1" -> "Item 5"[ltail = cluster_0 lhead = cluster_2];

                # graph = self._edge_generator.process(graph,
                #                                      vc[0],
                #                                      "equivalent",
                #                                      vc[1])

            for value in self._d_node_ids[k]:
                graph = self._edge_generator.process(graph,
                                                     k,
                                                     "definition",
                                                     value)

        graph.save("graph_v2.d", os.environ["PROJECT_BASE"])
        graph.render(os.path.join(os.environ["PROJECT_BASE"],
                                  "resources/output/graph_v2"))

        return graph
