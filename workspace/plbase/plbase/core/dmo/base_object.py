#!/usr/bin/env python
# -*- coding: UTF-8 -*-


import logging
import os
import uuid
from datetime import datetime

logging.basicConfig(
    format='%(asctime)s : %(levelname)s : %(filename)s : %(funcName)s() : %(lineno)d : %(message)s',
    level=logging.DEBUG)

# set WARNING for Matplotlib
logging.getLogger('matplotlib').setLevel(logging.WARNING)


class BaseObject(object):
    def __del__(self):
        self.timer.log()

    def __init__(self, some_name: str):
        """
        Created:
            9-Nov-2018
            craigtrim@gmail.com
        Updated:
            26-Aug-2019
            craigtrim@gmail.com
            *   use UUID for generate-tts function
                https://github.ibm.com/GTS-CDO/unstructured-analytics/pull/833
        :param some_name:
            the component name
        """
        from . import BaseTimer

        self.logger = logging.getLogger(some_name)
        self.timer = BaseTimer(self.logger)

    def get_logger(self) -> logging.Logger:
        return self.logger

    @staticmethod
    def verbose() -> bool:
        return bool(os.environ["LOG_VERBOSE"])

    @staticmethod
    def generate_tts(ensure_random=False) -> str:
        """
        Purpose:
            plbase way to ensure a unique timestamp (tts)
        """

        return str(uuid.uuid1())

    @staticmethod
    def get_time_tts(uuid1: str or uuid) -> str:
        """
        Purpose:
            Convert the uuid1 timestamp to a standard datetime format
            It simply rewinds the code in the standard library's uuid1 function

            Can be called using get_posixtime(uuid.UUID("159c8e8c-e788-11e9-a4f6-067dcd8573bd"))

            input: uuid timestamp
            output: string in format %Y-%m-%d %H:%M:%S
        """

        if type(uuid1) == str:
            uuid1 = uuid.UUID(uuid1)

        assert uuid1.version == 1, ValueError('only applies to uuid type 1')
        t = uuid1.time
        t = t - 0x01b21dd213814000
        t = t / 1e7
        return datetime.utcfromtimestamp(t).strftime('%Y-%m-%d %H:%M:%S')
