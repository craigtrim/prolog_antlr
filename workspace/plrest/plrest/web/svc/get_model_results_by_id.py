# !/usr/bin/env python
# -*- coding: UTF-8 -*-


from tssbase import BaseObject
from tssbase import ModelName
from tssbase import ModelResults
from tssdata import ModelPersistenceAPI


class GetModelResultsByID(BaseObject):
    """ GET Model Result Web Method by Result ID """

    def __init__(self,
                 result_id: str,
                 model_name: ModelName):
        """
        Created:
            30-Mar-2020
            craigtrim@gmail.com.com
            *   https://github.ibm.com/security-think-tank/ara_nist/issues/14
        """
        BaseObject.__init__(self, __name__)
        self.logger.info(f"Instantiated GetModelResults "
                         f"(model-name={model_name}, result-id={result_id})")
        self._result_id = result_id
        self._model_name = model_name

    def process(self) -> ModelResults:
        return ModelPersistenceAPI.csv(self._model_name).results_by_id(result_id=self._result_id)
