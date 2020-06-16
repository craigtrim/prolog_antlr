# !/usr/bin/env python
# -*- coding: UTF-8 -*-


import os

import yaml
from yaml import Loader


class GraphStyleLoader(object):
    """
    Purpose:
    Load a Graphviz Stylesheet

    Traceability:
    https://github.com/craigtrim/prolog_antlr/issues/2#issuecomment-637885469

    Prereq:
    """

    def __init__(self,
                 style_name: str,
                 is_debug: bool = True):
        """
        Created:
            2-Jun-2020
            craigtrim@gmail.com
        :param style_name:
            the name of the graph stylesheet to use
        :param is_debug:
            if True     increase log output at DEBUG level
        """
        self._is_debug = is_debug
        self._style_name = self._load(style_name)

    def style(self) -> dict:
        return self._style_name

    @staticmethod
    def _file_to_yaml(file_path: str) -> dict:
        with open(file_path, 'r') as stream:
            try:
                return yaml.load(stream, Loader=Loader)
            except yaml.YAMLError:
                raise ValueError("\n".join([
                    "Invalid File",
                    "\t{0}".format(file_path)]))

    def _file_to_yaml_by_relative_path(self,
                                       relative_file_path: str) -> dict:
        path = os.path.join(os.environ["PROJECT_BASE"],
                            relative_file_path)
        return self._file_to_yaml(path)

    def _load(self,
              some_style_name) -> dict:
        def _relative_path():
            if "gv1" in some_style_name.lower():
                return "resources/config/graph/graphviz_gv1_graph.yml"
            if "gv2" in some_style_name.lower():
                return "resources/config/graph/graphviz_gv2_graph.yml"
            raise NotImplementedError(f"Unrecognized Style: {some_style_name}")

        return self._file_to_yaml_by_relative_path(
            _relative_path())
