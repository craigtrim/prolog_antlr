# !/usr/bin/env python
# -*- coding: UTF-8 -*-


from uuid import uuid1

from tssbase import BaseObject
from tssbase import ClientRules
from tssbase import ModelResults
from tssbase import ModelName
from tssbase import ModelResultsTranform
from aranist.run.bp import RunNISTModelAPI


class PostNISTModel(BaseObject):
    """ POST NIST Model Web Method """

    def __init__(self,
                 client_rules: ClientRules):
        """
        Created:
            24-Mar-2020
            craig.trim@ibm.com
            *   https://github.ibm.com/security-think-tank/ara_nist/issues/14

        Updated:
            7-Apr-2020
            rishabsi@in.ibm.com
            *   add **kwargs in constructor to accept Mysql connection object from main api
                https://github.ibm.com/security-think-tank/ara_nist/issues/44
        """
        BaseObject.__init__(self, __name__)

        self._client_rules = client_rules
        self.logger.info('\n'.join([
            f"Instantiated PostNISTModel ("
            f"total-rules={len(self._client_rules.rules)})"]))

        self._df_client_rules = ClientRules.to_dataframe(client_rules)
        self.logger.debug('\n'.join([
            "Model Training Input",
            self.tabulate_sample(self._df_client_rules)]))

    def process(self) -> ModelResults:
        _result_id = str(uuid1())

        api = RunNISTModelAPI()

        df_results = api.run(df_client_rules=self._df_client_rules)
        self.logger.debug('\n'.join([
            "NIST Training Results",
            self.tabulate_sample(df_results)]))

        return ModelResultsTranform.process(result_id=_result_id,
                                            df_results=df_results,
                                            model_name=ModelName.NIST)
