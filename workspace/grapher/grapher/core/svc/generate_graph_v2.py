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
        from grapher.core.dto import UUIDTransform

        self._df_ast = df_ast
        self._is_debug = is_debug
        # self._d_node_ids = {}
        self._uuid_transform = UUIDTransform()

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

    # def _cleanse(self,
    #              a_uuid: str,
    #              suffix: str = None) -> str:
    #
    #     giz_uuid = f"UUID_{a_uuid.replace('-', '_').upper()}"
    #     if giz_uuid not in self._d_node_ids:
    #         self._d_node_ids[giz_uuid] = []
    #
    #     if not suffix:
    #         return giz_uuid
    #
    #     variant = f"{giz_uuid}_{suffix}"
    #     if variant not in self._d_node_ids[giz_uuid]:
    #         self._d_node_ids[giz_uuid].append(variant)
    #
    #     return variant

    # def _add_nodes(self,
    #                graph: Digraph,
    #                triples: list,
    #                tag: str = None,
    #                suffix: str = None) -> None:
    #     """
    #     :param graph:
    #     """
    #
    #     for triple in triples:
    #         for d_node in triple["Triple"]:
    #
    #             def _type() -> str:
    #                 if tag:
    #                     return f"{d_node['Type']}_{tag}"
    #                 return d_node['Type']
    #
    #             uuid = self._uuid_transform.cleanse(d_node['UUID'], suffix=suffix)
    #             graph = self._node_generator.process(
    #                 graph=graph,
    #                 a_node_id=uuid,
    #                 a_node={"label": d_node['Text'],
    #                         "text": d_node['Text'],
    #                         "type": _type()})
    #
    # def _add_edges(self,
    #                graph: Digraph,
    #                triples: list,
    #                suffix: str = None) -> None:
    #
    #     for triple in triples:
    #
    #         unique_ids = set(x['UUID'] for x in triple['Triple'])
    #         if len(unique_ids) != 2:
    #             print('\n'.join([
    #                 "Triple Style Not Recognized",
    #                 pprint.pformat(triple['Triple'])]))
    #             raise NotImplementedError("Unhandled Triple Style")
    #
    #         subj = triple['Triple'][0]
    #         obj = triple['Triple'][1]
    #
    #         graph = self._edge_generator.process(graph,
    #                                              self._uuid_transform.cleanse(subj["UUID"], suffix=suffix),
    #                                              subj["Predicate"],
    #                                              self._uuid_transform.cleanse(obj["UUID"], suffix=suffix))

    def _compound_triples(self,
                          graph: Digraph,
                          dump_json: bool = False) -> Digraph:
        """
        Purpose:
            Extract Triples from AST Compound Formations
        Reference:
            https://github.com/craigtrim/prolog_antlr/issues/9#issuecomment-640114990
        """
        from grapher.core.dmo import CompoundTripleExtractor
        from grapher.core.dmo import CompoundTripleGrapher

        def _extract() -> list:
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

        def _graph(g: Digraph,
                   triples: list) -> Digraph:
            triple_grapher = CompoundTripleGrapher(uuid_transform=self._uuid_transform,
                                                   is_debug=self._is_debug)

            d_nodes, edges = triple_grapher.process(compound_triples=triples)

            for k in d_nodes:
                g = self._node_generator.process(graph=g,
                                                 a_node_id=k,
                                                 a_node=d_nodes[k])

            for edge in edges:
                g = self._edge_generator.process(g,
                                                 edge['subject'],
                                                 edge['predicate'],
                                                 edge['object'])

            return g

        return _graph(graph, _extract())

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

        graph.attr('graph',
                   compound='True')

        self._compound_triples(graph=graph,
                               dump_json=True)

        # self._add_nodes(graph, compound_triples)
        # self._add_edges(graph, compound_triples)

        # predicate_set = set()
        # for triple in triples:
        #     predicate_set.add(triple['Triple'][0]['Predicate'])

        # predicate_set = sorted(predicate_set)
        #
        # def _color_scheme() -> str:
        #     if len(predicate_set) <= 3:
        #         return "orrd3"
        #     if len(predicate_set) <= 4:
        #         return "orrd4"
        #     if len(predicate_set) <= 5:
        #         return "orrd5"
        #     if len(predicate_set) <= 6:
        #         return "orrd6"
        #     if len(predicate_set) <= 7:
        #         return "orrd7"
        #     if len(predicate_set) <= 8:
        #         return "orrd8"
        #     if len(predicate_set) <= 9:
        #         return "orrd9"
        #     raise NotImplementedError("Color Scheme Needs Attention")
        #
        # def _color_int(a_triple: dict) -> str:
        #     for i in range(0, len(predicate_set)):
        #         if predicate_set[i] == a_triple['Triple'][0]['Predicate']:
        #             return str(i + 1)
        #
        #     raise NotImplementedError

        # color_scheme = _color_scheme()
        #
        # d_cluster_to_compound = {}
        #
        # ctr = 0
        # for triple in triples:
        #     subgraph_name = f"Cluster{ctr}"
        #     d_cluster_to_compound[triple['Triple'][0]['UUID']] = subgraph_name
        #
        #     with graph.subgraph(name=subgraph_name) as c:
        #         c.attr(label=triple['Compound'],
        #                colorscheme=color_scheme,
        #                color=_color_int(triple),
        #                fontsize='10',
        #                fontname='Helvetica')
        #         self._add_nodes(c, [triple], suffix=subgraph_name, tag="cluster")
        #         self._add_edges(c, [triple], suffix=subgraph_name)
        #     ctr += 1

        # START LOGIC TO ADD CLUSTER-TO-CLUSTER CONNECTIONS

        # # pattern: 'Clause/Conditional/(Compound, Compound)
        # df_clause = self._df_ast[self._df_ast['Type'] == 'Clause']
        #
        # print (d_cluster_to_compound)

        # for _, row_clause in df_clause.iterrows():
        #     df_conditional = self._df_ast[(self._df_ast['Parent'] == row_clause['UUID']) &
        #                                   (self._df_ast['Type'] == 'Conditional')]
        #
        #     for _, row_conditional in df_conditional.iterrows():
        #         df_compounds = self._df_ast[(self._df_ast['Parent'] == row_conditional['UUID']) &
        #                                     (self._df_ast['Type'] == 'Compound')]
        #
        #         if len(df_compounds) == 2:  # a known pattern
        #             print("UUIDS HERE ----> ", df_compounds['UUID'].unique())
        #             uuids = df_compounds['UUID'].unique()
        #
        #             if uuids[0] not in d_cluster_to_compound or uuids[1] not in d_cluster_to_compound:
        #                 continue
        #
        #             s = d_cluster_to_compound[uuids[0]]
        #             o = d_cluster_to_compound[uuids[1]]
        #
        #             graph.edge(tail_name=self._cleanse(uuids[0]),
        #                        head_name=self._cleanse(uuids[1]),
        #                        label="",
        #                        ltail=s,
        #                        lhead=o,
        #                        style="dotted",
        #                        colorscheme="greys9",
        #                        color="4",
        #                        arrowhead="none",
        #                        fontsize="5",
        #                        weight="2")

        # for k in self._d_node_ids:
        #     cartesian = self._cartesian(self._d_node_ids[k])
        #     cartesian = [x.split(',') for x in cartesian]
        #
        #     print('\n'.join([
        #         "Cartesian Join on Clustered Values",
        #         f"\tOriginal UUID: {k}",
        #         f"\tCartesian Values: {cartesian}"]))
        #
        #     for vc in cartesian:
        #         s = vc[0].split('_')[-1]
        #         o = vc[1].split('_')[-1]
        #
        #         graph.edge(tail_name=vc[0],
        #                    head_name=vc[1],
        #                    label="",
        #                    ltail=s,
        #                    lhead=o,
        #                    style="dotted",
        #                    colorscheme="greys9",
        #                    color="4",
        #                    arrowhead="none",
        #                    fontsize="5",
        #                    weight="2")
        # ... END LOGIC ...

        # for value in self._d_node_ids[k]:
        #     graph = self._edge_generator.process(graph,
        #                                          k,
        #                                          "definition",
        #                                          value)

        # now I want to add relationships between clusters

        graph.save("graph_v2.d", os.environ["PROJECT_BASE"])
        graph.render(os.path.join(os.environ["PROJECT_BASE"],
                                  "resources/output/graph_v2"))

        return graph
