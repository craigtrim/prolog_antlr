# !/usr/bin/env python
# -*- coding: UTF-8 -*-


from tssbase import BaseObject
from tssbase import ModelName
from tssbase import ModelResults
from tssdata import ModelPersistenceAPI


class GetModelResults(BaseObject):
    """ GET Model Result Summaries Web Method via Model Name """

    def __init__(self,
                 model_name: ModelName):
        """
        Created:
            30-Mar-2020
            craigtrim@gmail.com.com
            *   https://github.ibm.com/security-think-tank/ara_nist/issues/14
        """
        BaseObject.__init__(self, __name__)
        self._model_name = model_name
        self.logger.info(f"Instantiated GetModelResults (name={self._model_name})")

    def process(self) -> ModelResults:
        return ModelPersistenceAPI.csv(self._model_name).results()
