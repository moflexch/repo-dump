#!/bin/bash

file="repos.txt"
title="# Status at "
date=`TZ='Europe/Zurich' date +"%Y-%m-%d %H:%M"`
header="|Site|ilisite|ilimodels|ilidata|\n|---|---|---|---|\n"

printf "$title$date\n$header" > README.md

while read -r line
do
  [[ "$line" =~ (^#.*$)|(^\s*$) ]] && continue
  [[ "$line" =~ (^https?://)([^/]+) ]] && folder="${BASH_REMATCH[2]}"
  [[ "$folder" =~ ([[:alnum:]-]+)\.([[:alnum:]]+)$ ]] && folder="${BASH_REMATCH[2]}.${BASH_REMATCH[1]}"

  printf "|[$folder]($line)|" >> README.md

  for idx in ilisite ilimodels ilidata
  do
    http_response=$(curl -s "$line$idx.xml" -o "$folder/$idx.xml" --create-dir -w "%{http_code}")
    if [ $http_response != "200" ]; then
      echo "[ignored - $http_response] $line$idx.xml"
      rm "$folder/$idx.xml"
      printf ":black_square_button: ([$http_response]($line$idx.xml))|" >> README.md
    else
      printf ":white_check_mark: ([$http_response]($line$idx.xml))|" >> README.md
    fi
  done
  printf "\n" >> README.md
done < $file
