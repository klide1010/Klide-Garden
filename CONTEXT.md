# 🌿 Il Mio Giardino — Contesto del Progetto

## Cos'è questo progetto
Una **PWA (Progressive Web App)** per gestire il giardino di casa, installabile su Android e iOS direttamente dal browser, senza app store. Pubblicata su **GitHub Pages**.

## URL di produzione
```
https://klide1010.github.io/Klide-Garden
```

## Struttura dei file
```
/Giardino
├── index.html        ← Tutta l'app (HTML + CSS + JS in un solo file)
├── manifest.json     ← Configurazione PWA (nome, icona, colori)
├── icon-192.png      ← Icona app 192x192 (obbligatoria Android)
├── icon-512.png      ← Icona app 512x512 (splash screen)
├── icon.svg          ← Icona sorgente vettoriale
├── deploy.sh         ← Script per pubblicare su GitHub Pages
└── CONTEXT.md        ← Questo file
```

## Come pubblicare le modifiche
```bash
bash deploy.sh
```
Oppure dal pannello Git dell'editor: Stage All → Commit → Push.
GitHub Pages si aggiorna in 1-2 minuti.

---

## Architettura tecnica

### Stack
- **Zero dipendenze** — HTML + CSS + JS vanilla puro, nessun framework
- **Storage** — `localStorage` (dati salvati localmente sul dispositivo)
- **Font** — Google Fonts: Playfair Display (serif, titoli) + DM Sans (corpo)
- **Tema** — Dark mode nativa, sfondo `#111111`

### Chiavi localStorage
| Chiave | Contenuto |
|--------|-----------|
| `gdn2_plants` | Array JSON delle piante |
| `gdn2_harvests` | Array JSON dei raccolti |
| `gdn2_settings` | Oggetto impostazioni notifiche |

### Struttura dati — Pianta
```json
{
  "id": "p01",
  "name": "Basilico",
  "type": "aromatic",
  "waterEveryDays": 2,
  "sun": "full",
  "plantDate": "2026-04-01",
  "notes": "Testo libero...",
  "lastWatered": "2026-04-24"
}
```
**Tipi pianta:** `aromatic` | `fruit` | `spice` | `flower` | `veggie`
**Esposizione:** `full` | `partial` | `shade`

### Struttura dati — Raccolto
```json
{
  "id": "h1714000000000",
  "plantId": "p01",
  "plantName": "Basilico",
  "plantType": "aromatic",
  "mode": "count",
  "amount": 5,
  "date": "2026-04-24",
  "notes": "Testo libero..."
}
```
**Modalità raccolto:** `count` (numero pezzi) | `weight` (kg)

---

## Navigazione — 4 schermate

| ID schermata | Contenuto |
|---|---|
| `screen-home` | Dashboard: stats, alert irrigazione, consigli stagionali |
| `screen-garden` | Lista piante con ricerca e filtri per tipo |
| `screen-detail` | Dettaglio pianta: stato irrigazione, consigli stagione |
| `screen-harvests` | Storico raccolti con totali |
| `screen-settings` | Notifiche, backup, installazione PWA |

---

## Logica di irrigazione

### Calcolo giorni
```javascript
// Confronto su date pure YYYY-MM-DD (senza fuso orario)
function daysSince(dateStr)  // giorni dall'ultima annaffiatura
function daysUntil(plant)    // giorni alla prossima
function overdueBy(plant)    // giorni di ritardo (0 se non in ritardo)
```

### Stati irrigazione
| Stato | Condizione | Colore |
|-------|-----------|--------|
| `0` urgente | In ritardo o scade oggi | 🔴 `#e05a2b` |
| `1` warning | Scade domani o dopodomani | 🟡 `#e8b84b` |
| `2` ok | Nei prossimi giorni | 🟢 `#5db860` |
| `3` fresca | Appena annaffiata | ⚫ grigio |

---

## Sistema notifiche
- **07:30 ogni mattina** — lista piante da bagnare calcolata in tempo reale
- **Ogni 4 ore** — controllo ritardi, notifica solo se ci sono piante scadute
- Tutto wrappato in `getN()` per evitare crash in ambienti sandbox/preview

```javascript
function getN()           // accesso safe a window['Notification']
function scheduleMorning() // pianifica notifica delle 07:30
function scheduleOverdueCheck() // polling ogni 4 ore
function buildWaterLines() // costruisce lista piante da notificare
```

---

## Le piante del giardino (default)

| ID | Nome | Tipo | Ogni (gg) |
|----|------|------|-----------|
| p01 | Basilico | aromatic | 2 |
| p02 | Origano | aromatic | 6 |
| p03 | Limone | fruit | 5 |
| p04 | Nespolo | fruit | 8 |
| p05 | Peperoni piccanti | spice | 3 |
| p06 | Peperoncino | spice | 3 |
| p07 | Gelsomino | flower | 5 |
| p08 | Erba cipollina | aromatic | 3 |
| p09 | Salvia | aromatic | 6 |
| p10 | Rosmarino | aromatic | 8 |

---

## Variabili CSS principali
```css
--bg:        #111111   /* sfondo principale */
--bg2:       #1c1c1c   /* card e header */
--bg3:       #252525   /* elementi interni */
--green:     #5db860   /* colore primario */
--green-dim: #3a7a3d   /* bottoni primari */
--green-pale:#c8f0c8   /* titolo header */
--yellow:    #e8b84b   /* warning / raccolti */
--red:       #e05a2b   /* urgente / pericolo */
--blue:      #5ba3d9   /* irrigazione / info */
--text1:     #f0f0f0   /* testo principale */
--text2:     #b0b0b0   /* testo secondario */
--text3:     #666666   /* testo disattivato */
```

---

## Regole importanti per le modifiche

1. **Non usare framework** — tutto vanilla JS, nessun import esterno
2. **`index.html` è un file unico** — CSS e JS sono inline, non creare file separati
3. **Date sempre in formato `YYYY-MM-DD`** — usare `todayStr()` per la data odierna
4. **Notifiche sempre tramite `getN()`** — mai usare `Notification` direttamente
5. **Dopo ogni modifica JS** — verificare che non ci siano errori di sintassi
6. **localStorage keys** — usare sempre il prefisso `gdn2_` per non confliggere

---

## Contesto conversazione originale
Questo progetto è stato sviluppato insieme a Claude (Anthropic) in una conversazione su claude.ai. L'utente gestisce un giardino a Bergamo con le 10 piante elencate sopra. L'app è pensata per uso quotidiano su smartphone Android, installata come PWA dalla schermata Home.
