#!/bin/bash

file="repos.txt"
curlglob="{ilisite,ilimodels,ilidata}.xml"

while read -r line
do
  [[ "$line" =~ (^#.*$)|(^\s*$) ]] && continue
  curl "$line$curlglob" -o /dev/null --write-out "%{response_code} %{url_effective}\n" -s
done < $file
