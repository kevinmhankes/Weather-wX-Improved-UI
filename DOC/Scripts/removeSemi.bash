#!/bin/bash

# run from current directory to remove all trailing semi-colons

for i in *swift
do
	sed -i ''  "s/;$//g" $i
done
