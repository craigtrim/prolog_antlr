# !/usr/bin/env python
# -*- coding: UTF-8 -*-


from uuid import uuid1

from tssbase import BaseObject
from tssbase import ClientRules
from tssbase import ModelName
from tssbase import ModelResults
from tssbase import ModelResultsTranform


class PostKillChainModel(BaseObject):
    """ POST KilChain Model Web Method """

    def __init__(self,
                 client_rules: ClientRules):
        """
        Created:
            24-Mar-2020
            craigtrim@gmail.com.com
            *   https://github.ibm.com/security-think-tank/ara_nist/issues/14

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
            f"Instantiated PostKilChainModel ("
            f"total-rules={len(self._client_rules.rules)})"]))

        self._df_client_rules = ClientRules.to_dataframe(client_rules)
        self.logger.debug('\n'.join([
            "Model Training Input",
            self.tabulate_sample(self._df_client_rules)]))
        # self.conn = None
        # self.cursor = None
        # if 'conn' in kwargs:
        #     self.conn = kwargs['conn']
        # if 'cursor' in kwargs:
        #     self.cursor = kwargs['cursor']

    def process(self) -> ModelResults:
        from arakillchain.run.bp import RunKillChainModelAPI
        _result_id = str(uuid1())

        api = RunKillChainModelAPI()

        df_results = api.run(df_client_rules=self._df_client_rules)
        self.logger.debug('\n'.join([
            "KillChain Training Results",
            self.tabulate_sample(df_results)]))

        return ModelResultsTranform.process(result_id=_result_id,
                                            df_results=df_results,
                                            model_name=ModelName.KILLCHAIN)
