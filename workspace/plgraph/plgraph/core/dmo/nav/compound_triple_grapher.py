#!/usr/bin/env python
# -*- coding: UTF-8 -*-


from plbase import BaseObject


class CompoundTripleGrapher(BaseObject):
    """ Generates Compound Triples for Graphviz """

    def __init__(self,
                 is_debug: bool = True):
        """
        Created:
            8-June-2020
            craig.trim@ibm.com
            *   refactored out of 'generate-graph-v2'
        Updated:
            16-June-2020
            craig.trim@ibm.com
            *   added multi-arity extraction
                https://github.com/craigtrim/prolog_antlr/issues/14
        """
        BaseObject.__init__(self, __name__)
        from plgraph.core.dto import UUIDTransform

        self._edges = []
        self._d_nodes = {}
        self._is_debug = is_debug
        self._uuid_transform = UUIDTransform()

    def _create_nodes(self,
                      triples: list,
                      tag: str = None,
                      suffix: str = None) -> None:
        """ Create Nodes """
        for triple in triples:
            for d_node in triple["Triple"]:

                def _type() -> str:
                    if tag:
                        return f"{d_node['Type']}_{tag}"
                    return d_node['Type']

                uuid = self._uuid_transform.cleanse(d_node['UUID'], suffix=suffix)

                self._d_nodes[uuid] = {"label": d_node['Text'],
                                       "text": d_node['Text'],
                                       "type": _type()}

    def _create_edges(self,
                      triples: list,
                      suffix: str = None) -> None:

        for triple in triples:

            unique_ids = set(x['UUID'] for x in triple['Triple'])

            if len(unique_ids) == 1:  # arity of /1
                pass  # no edges exist

            elif len(unique_ids) == 2:  # arity of /2
                subj = triple['Triple'][0]
                obj = triple['Triple'][1]

                self._edges.append({
                    "subject": self._uuid_transform.cleanse(subj["UUID"], suffix=suffix),
                    "predicate": subj['Predicate'],
                    "object": self._uuid_transform.cleanse(obj["UUID"], suffix=suffix)})

            else:
                self.logger.warning(f"Unhandled Arity (total-triples={len(triples)})")
                # raise NotImplementedError("Unhandled Arity")
                continue

    def process(self,
                compound_triples: list) -> (dict, list):
        self._create_nodes(compound_triples)
        self._create_edges(compound_triples)

        return self._d_nodes, self._edges
