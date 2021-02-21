#!/usr/bin/env python3
import os
import sys
import re
from glob import glob
from typing import List
import argparse

#
# Main
#
parser = argparse.ArgumentParser()
parser.add_argument("-c", "--commit", help="commit changes", action="store_true")
args = parser.parse_args()

files: List[str] = glob("wX/*/*.swift")

for f in files:
    data = open(f).read()
    data = data.replace("2016, 2017, 2018, 2019, 2020", "2016, 2017, 2018, 2019, 2020, 2021")
    fh = open(f, "w")
    fh.write(data)
    fh.close()
