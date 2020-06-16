# !/usr/bin/env python
# -*- coding: UTF-8 -*-


from graphviz import Digraph


class GenerateFactClusters(object):
    """ Generate Clusters with Prolog Facts and add edges between clusters (facts)
            if clusters (facts) are used within rules

     Reference:
        https://github.com/craigtrim/prolog_antlr/issues/11
    """

    def __init__(self,
                 graph: Digraph,
                 graph_style: str = "gv2",
                 is_debug: bool = True):
        """
        Created:
            8-June-2020
            craig.trim@ibm.com
            *   Refactored out of 'generate-graph-v2'
                https://github.com/craigtrim/prolog_antlr/issues/10
        """
        from plgraph.core.dmo import GraphStyleLoader
        from plgraph.core.dmo import DigraphNodeGenerator
        from plgraph.core.dmo import DigraphEdgeGenerator
        from plgraph.core.dto import UUIDTransform

        self._graph = graph
        self._is_debug = is_debug

        self._atomic_mapping = {}  # map "Atomic Fact" UUIDs to Graphviz Clusters
        self._compound_mapping = {}  # map "Compound" UUIDs to Graphviz Clusters

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

    @staticmethod
    def _update_mapping(uuid: str,
                        d_map: dict,
                        cluster_name: str):
        """
        Purpose:
            Map Prolog Facts to Graphviz Cluster Names
        Reference:
            https://github.com/craigtrim/prolog_antlr/issues/11#issuecomment-640867602
        """
        if uuid not in d_map:
            d_map[uuid] = []
        d_map[uuid].append(cluster_name)

    def process(self,
                triples: list) -> (Digraph, dict, dict):

        predicates = self._list_predicates(triples)
        color_scheme = self._color_scheme(predicates)

        ctr = 0
        for triple in triples:
            cluster_name = f"Cluster{ctr}"
            self._update_mapping(d_map=self._compound_mapping,
                                 cluster_name=cluster_name,
                                 uuid=triple['Compound']['UUID'])

            with self._graph.subgraph(name=cluster_name) as c:
                label = triple['Compound']['Text']
                c.attr(label=label,
                       colorscheme=color_scheme,
                       color=self._color_int(predicates, triple),
                       fontsize='10',
                       fontname='Helvetica')

                self._add_nodes(c, [triple], suffix=cluster_name, tag="cluster")

                # Connect Atomics (aka "Triples") to Compounds (aka "Facts")
                for node in triple['Triple']:
                    s = self._uuid_transform.cleanse(node['UUID'])
                    # self._update_mapping(d_map=self._atomic_mapping,
                    #                      cluster_name=cluster_name,
                    #                      uuid=s)

                    o = self._uuid_transform.cleanse(node['UUID'], suffix=cluster_name)
                    self._update_mapping(d_map=self._atomic_mapping,
                                         cluster_name=cluster_name,
                                         uuid=o)

                    self._graph = self._edge_generator.process(self._graph,
                                                               s, "definition", o)

            ctr += 1

        return self._graph, self._compound_mapping, self._atomic_mapping
