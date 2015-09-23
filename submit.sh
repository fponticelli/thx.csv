#!/bin/sh
rm thx.csv.zip
zip -r thx.csv.zip hxml src test doc/ImportCsv.hx extraParams.hxml haxelib.json LICENSE README.md -x "*/\.*"
haxelib submit thx.csv.zip
