#!/bin/sh

./StripeCSV2XML.m $1 > transfers.xml
xsltproc StripeXML2HTML.xslt transfers.xml > transfer.html
open transfer.html