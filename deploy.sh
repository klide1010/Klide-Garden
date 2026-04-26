#!/bin/bash
cd /Users/klide/Documents/AI/Giardino
git add .
git commit -m "Aggiornamento app giardino - $(date '+%d/%m/%Y %H:%M')"
git push origin main
echo "✅ Pubblicato! Attendi 1-2 minuti per vedere le modifiche."