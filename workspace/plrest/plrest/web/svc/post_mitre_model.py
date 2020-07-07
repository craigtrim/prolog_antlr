# !/usr/bin/env python
# -*- coding: UTF-8 -*-


from uuid import uuid1

from tssbase import ClientRules
from tssbase import ModelName
from tssbase import ModelResults
from tssbase import ModelResultsTranform
from tssbase.core.dmo import BaseObject
from aramitre.run.bp import RunMITREModelAPI


class PostMITREModel(BaseObject):
    """
    """

    def __init__(self,
                 client_rules: ClientRules):
        """
        Created:
            27-Mar-2020
            craigtrim@gmail.com.com
            *   https://github.ibm.com/security-think-tank/ara_nist/issues/20

        Updated:
            8-Apr-2020
            rishabsi@in.ibm.com
            *   add **kwargs in constructor to accept Mysql connection object from main api file
                from run_nist_model_api
                https://github.ibm.com/security-think-tank/ara_nist/issues/44
        """
        BaseObject.__init__(self, __name__)

        self._client_rules = client_rules
        self.logger.info('\n'.join([
            f"Instantiated PostMITREModel ("
            f"total-rules={len(self._client_rules.rules)})"]))

        self._df_client_rules = ClientRules.to_dataframe(client_rules)
        self.logger.debug('\n'.join([
            "Model Training Input",
            self.tabulate_sample(self._df_client_rules)]))

    def process(self) -> ModelResults:
        _result_id = str(uuid1())

        df_client_rules = ClientRules.to_dataframe(self._client_rules)
        df_results = RunMITREModelAPI().run(df_client_rules)

        self.logger.debug('\n'.join([
            "MITRE Training Results",
            self.tabulate_sample(df_results)]))

        return ModelResultsTranform.process(result_id=_result_id,
                                            df_results=df_results,
                                            model_name=ModelName.MITRE)
