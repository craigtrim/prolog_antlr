#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from graphviz import Digraph
from pandas import DataFrame


class GenerateRuleClusters(object):
    """ Generate Clusters with Prolog Facts and add edges between clusters (facts)
            if clusters (facts) are used within rules

     Reference:
        https://github.com/craigtrim/prolog_antlr/issues/11
    """

    def __init__(self,
                 graph: Digraph,
                 df_ast: DataFrame,
                 graph_style: str = "gv2",
                 is_debug: bool = True):
        """
        Created:
            8-June-2020
            craig.trim@ibm.com
            *   Refactored out of 'generate-graph-v2'
                https://github.com/craigtrim/prolog_antlr/issues/10
        """
        from grapher.core.dmo import GraphStyleLoader
        from grapher.core.dmo import DigraphNodeGenerator
        from grapher.core.dmo import DigraphEdgeGenerator
        from grapher.core.dto import UUIDTransform

        self._graph = graph
        self._df_ast = df_ast
        self._is_debug = is_debug
        self._uuid_transform = UUIDTransform()

        self._style_loader = GraphStyleLoader(style_name=graph_style,
                                              is_debug=self._is_debug)

        self._node_generator = DigraphNodeGenerator(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

        self._edge_generator = DigraphEdgeGenerator(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

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

                uuid = self._uuid_transform.cleanse(d_node['UUID'], suffix=suffix)
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
            print(">>>>LEN: ", len(triple['Triple']))

            # if len(triple['Triple']) != 2:
            #     raise NotImplementedError("Unhandled Triple Style")

            subj = triple['Triple'][0]
            obj = triple['Triple'][1]

            graph = self._edge_generator.process(graph,
                                                 self._uuid_transform.cleanse(subj["UUID"], suffix=suffix),
                                                 subj["Predicate"],
                                                 self._uuid_transform.cleanse(obj["UUID"], suffix=suffix))

    def process(self,
                triples: list):

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

        d_subgraph_to_triple = {}  # map subgraphs to triples

        ctr = 0
        for triple in triples:
            subgraph_name = f"Cluster{ctr}"
            d_subgraph_to_triple[triple['Triple'][0]['UUID']] = subgraph_name

            with self._graph.subgraph(name=subgraph_name) as c:
                c.attr(label=triple['Compound'],
                       colorscheme=color_scheme,
                       color=_color_int(triple),
                       fontsize='10',
                       fontname='Helvetica')

                self._add_nodes(c, [triple], suffix=subgraph_name, tag="cluster")

                d_subgraph_to_triple[subgraph_name] = triple

                for node in triple['Triple']:
                    s = self._uuid_transform.cleanse(node['UUID'])
                    o = self._uuid_transform.cleanse(node['UUID'], suffix="cluster")

                    self._graph = self._edge_generator.process(self._graph,
                                                               s,
                                                               "",
                                                               o)

            ctr += 1

        import pprint
        pprint.pprint(d_subgraph_to_triple)


# !/usr/bin/env python
# -*- coding: UTF-8 -*-


from graphviz import Digraph
from pandas import DataFrame


class GenerateRuleClusters(object):
    """ Generate Clusters with Prolog Facts and add edges between clusters (facts)
            if clusters (facts) are used within rules

     Reference:
        https://github.com/craigtrim/prolog_antlr/issues/11
    """

    def __init__(self,
                 graph: Digraph,
                 df_ast: DataFrame,
                 graph_style: str = "gv2",
                 is_debug: bool = True):
        """
        Created:
            8-June-2020
            craig.trim@ibm.com
            *   Refactored out of 'generate-graph-v2'
                https://github.com/craigtrim/prolog_antlr/issues/10
        """
        from grapher.core.dmo import GraphStyleLoader
        from grapher.core.dmo import DigraphNodeGenerator
        from grapher.core.dmo import DigraphEdgeGenerator
        from grapher.core.dto import UUIDTransform

        self._graph = graph
        self._df_ast = df_ast
        self._is_debug = is_debug
        self._subgraph_mapping = {}
        self._uuid_transform = UUIDTransform()

        self._style_loader = GraphStyleLoader(style_name=graph_style,
                                              is_debug=self._is_debug)

        self._node_generator = DigraphNodeGenerator(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

        self._edge_generator = DigraphEdgeGenerator(is_debug=self._is_debug,
                                                    graph_style=self._style_loader.style())

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

                uuid = self._uuid_transform.cleanse(d_node['UUID'], suffix=suffix)
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
            print(">>>>LEN: ", len(triple['Triple']))

            # if len(triple['Triple']) != 2:
            #     raise NotImplementedError("Unhandled Triple Style")

            subj = triple['Triple'][0]
            obj = triple['Triple'][1]

            graph = self._edge_generator.process(graph,
                                                 self._uuid_transform.cleanse(subj["UUID"], suffix=suffix),
                                                 subj["Predicate"],
                                                 self._uuid_transform.cleanse(obj["UUID"], suffix=suffix))

    @staticmethod
    def _color_scheme(predicate_set: list) -> str:
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

    @staticmethod
    def _color_int(predicate_set: list,
                   a_triple: dict) -> str:
        for i in range(0, len(predicate_set)):
            if predicate_set[i] == a_triple['Triple'][0]['Predicate']:
                return str(i + 1)

        raise NotImplementedError

    @staticmethod
    def _list_predicates(triples: list):
        """
        Purpose:
            Build a list of predicates
        Reference:
            https://github.com/craigtrim/prolog_antlr/issues/11#issuecomment-640869651
        """
        pset = set()
        for triple in triples:
            pset.add(triple['Triple'][0]['Predicate'])

        return sorted(pset)

    def _update_mapping(self,
                        triple: dict,
                        subgraph_name: str):
        """
        Purpose:
            Map Prolog Facts to Graphviz Cluster Names
        Reference:
            https://github.com/craigtrim/prolog_antlr/issues/11#issuecomment-640867602
        """
        if triple['Compound'] not in self._subgraph_mapping:
            self._subgraph_mapping[triple['Compound']] = []
        self._subgraph_mapping[triple['Compound']].append(subgraph_name)

    def process(self,
                triples: list) -> (Digraph, dict):

        predicates = self._list_predicates(triples)
        color_scheme = self._color_scheme(predicates)

        ctr = 0
        for triple in triples:
            subgraph_name = f"Cluster{ctr}"
            self._update_mapping(triple, subgraph_name)

            with self._graph.subgraph(name=subgraph_name) as c:
                c.attr(label=triple['Compound'],
                       colorscheme=color_scheme,
                       color=self._color_int(predicates, triple),
                       fontsize='10',
                       fontname='Helvetica')

                self._add_nodes(c, [triple], suffix=subgraph_name, tag="cluster")

                # Connect Atomics (aka "Triples") to Compounds (aka "Facts")
                for node in triple['Triple']:
                    s = self._uuid_transform.cleanse(node['UUID'])
                    o = self._uuid_transform.cleanse(node['UUID'], suffix=subgraph_name)
                    self._graph = self._edge_generator.process(self._graph,
                                                               s, "definition", o)

            ctr += 1

        return self._graph, self._subgraph_mapping
