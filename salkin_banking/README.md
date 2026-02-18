# salkin_banking (ESX)

Ein modernes Banking-System für FiveM (ESX) mit einer sauberen NUI-Oberfläche, ATM-Interaktion und Bankberater-Peds.

<img width="817" height="448" alt="Screenshot 2026-02-18 100321" src="https://github.com/user-attachments/assets/d21b6325-3db7-4f3c-b643-cb4e44c6c160" />

## Features
*   **ATM & Banken:** Interaktion via `ox_target`.
*   **Animationen:** Realistische Scenarios beim Benutzen von Automaten oder Schaltern.
*   **NUI Interface:** Modernes Design für Einzahlungen, Auszahlungen und Kontostandsabfrage.
*   **Transaktionsverlauf:** Zeigt die letzten 10 Transaktionen aus der Datenbank an.
*   **Optimiert:** Niedriger MS-Verbrauch und effiziente Server-Callbacks.

## Anforderungen
*   [es_extended](https://github.com/esx-framework/es_extended)
*   [ox_target](https://github.com/overextended/ox_target)
*   [oxmysql](https://github.com/overextended/oxmysql)

## Installation
1. Erstelle die `banking` Tabelle in deiner Datenbank (für den Verlauf):

---
```sql
CREATE TABLE IF NOT EXISTS `banking` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `time` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
);
```
---

Kopiere den Ordner salkin_banking in dein resources Verzeichnis.
Füge ensure salkin_banking in deine server.cfg ein.
Konfiguration
In der config.lua kannst du Standorte, ATM-Modelle und Peds anpassen.
code
Code
### 4. GitHub Beschreibung (Repository)

**Vorschlag (Allgemein für das Repository "salkin_banking"):**
> "Modern ESX Banking system for FiveM. Features a clean NUI, ATM/Bank interactions via ox_target, and transaction history."

**Vorschlag (Deutsch):**
> "Modernes Banking-System für FiveM (ESX). Bietet NUI-Interface, ATM-Interaktionen über ox_target und einen Transaktionsverlauf."
