#!/usr/bin/env python3

import logging
import sys
from airbyte_cdk.entrypoint import launch
from source_customize_api import SourceCustomizeAPI


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    logging.debug("===============================starting=====================")
    source = SourceCustomizeAPI()
    launch(source, sys.argv[1:])
