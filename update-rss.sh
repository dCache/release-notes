#!/bin/bash

cd $(dirname $0)

/usr/bin/xsltproc XMLMerge.xslt noop.xml  > emi-releases.xml
