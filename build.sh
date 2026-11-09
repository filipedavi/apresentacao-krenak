#!/usr/bin/env bash
# Regenera index.html a partir dos slides em slides-html/, na ordem de deck.json.
set -e
cd "$(dirname "$0")"
IDS=$(python -c "import json;print(' '.join(json.load(open('slides-html/deck.json',encoding='utf-8'))['order']))")
[ -n "$IDS" ] || { echo "nenhum slide encontrado em deck.json"; exit 1; }
for i in $IDS; do [ -f "slides-html/$i.html" ] || { echo "falta slides-html/$i.html"; exit 1; }; done
{ sed -n '1,/<div id="stage">/p' index.html
  for i in $IDS; do cat "slides-html/$i.html"; done
  printf '</div>\n'
  sed -n '/<div id="notes">/,$p' index.html
} > index.new.html && mv index.new.html index.html
echo "index.html regenerado com $(echo $IDS | wc -w) slides"
