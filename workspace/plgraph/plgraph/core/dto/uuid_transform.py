#!/usr/bin/env python
# -*- coding: UTF-8 -*-


class UUIDTransform(object):
    """ Cleanse and Transform UUIDs and
        maintain mapping of normalized UUIDs to original UUID """

    def __init__(self):
        """
        Created:
            8-June-2020
            craig.trim@ibm.com
            *   refactored out of 'generate-graph-v2'
        """
        self._d_node_ids = {}

    def mapping(self) -> dict:
        return self._d_node_ids

    def cleanse(self,
                a_uuid: str,
                suffix: str = None) -> str:

        giz_uuid = f"UUID_{a_uuid.replace('-', '_').upper()}"
        if giz_uuid not in self._d_node_ids:
            self._d_node_ids[giz_uuid] = []

        if not suffix:
            return giz_uuid

        normalized = f"{giz_uuid}_{suffix}"
        if normalized not in self._d_node_ids[giz_uuid]:
            self._d_node_ids[giz_uuid].append(normalized)

        return normalized
