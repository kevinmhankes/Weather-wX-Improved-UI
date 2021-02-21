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

mapLines = list(open("transform.txt"))
mappings = {}
for line in mapLines:
    items = line.strip().split()
    mappings[items[0]] = items[1]

for key, value in mappings.items():
    for filen in files:
        foundIt = False
        fh = open(filen)
        lines = list(fh)
        for line in lines:
            if key in line:
                foundIt = True
                if not args.commit:
                    print(filen, key)
        fh.close()
        if foundIt and args.commit:
            fh = open(filen, "w")
            for line in lines:
                line = line.rstrip().replace(key, value)
                print(line, file=fh)
            fh.close()
