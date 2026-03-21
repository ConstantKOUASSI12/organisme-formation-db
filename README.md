# Développement SQL & NoSQL — Organisme de Formation


## Sommaire

- [Structure du dépôt](#structure-du-dépôt)
- [Partie 1 — Les choix de conception](#partie-1--Les-choix-de-conception)
- [Partie 2 — Logique des requêtes](#partie-2--Requêtes-opérationnelles)
- [Partie 3 — Instructions d'exécution](#partie-3--Instructions-dexécution)

---


## Structure du dépôt

```
📦 organisme-formation-db
├── 📄 README.md
├── 📁 conception/
│   ├── dictionnaire_donnees.xlsx
│   ├── MCD.jpg
│   ├── MLD.jpg
│   ├── MPD.jpg
│   └── regles_gestion.md
├── 📁 sql/
│   ├── 01_creation_base.sql
│   ├── 02_donnees_test.sql
│   ├── 03_requetes_operationnelles.sql
│   ├── 04_analyse_reporting.sql
│   └── 05_securite_sauvegarde.sql
└── 📁 nosql/
    ├── 06_nosql_mongodb.js
```

---

## Partie 1 — Les choix de conception

## Architecture hybride SQL + NoSQL
## Organisme de formation

### Répartition des responsabilités

#### PostgreSQL (données structurées, transactionnelles)
- etudiant
- formation
- module
- intervenant
- inscription
- formation_module
- suivi
- animation

#### MongoDB (données flexibles, volumineuses)
- historique_actions   → qui a fait quoi et quand
- logs_techniques      → erreurs, performances, connexions
- commentaires_peda    → texte libre des formateurs
- evaluations_libres   → retours qualitatifs des étudiants

--

## Partie 2 — Requêtes opérationnelles

### Logique des requêtes (`03_requetes_operationnelles.sql`)

**Parcours complet d'un étudiant (A2)**
Utilise un `LEFT JOIN` sur `suivi` pour afficher tous les modules du programme, qu'ils aient été commencés ou non. Un `INNER JOIN` ne retournerait que les modules effectivement enregistrés dans `suivi`.

```sql
-- Pattern clé : LEFT JOIN pour inclure les modules non encore suivis
LEFT JOIN suivi s ON s.id_inscription = i.id_inscription
                 AND s.id_module      = m.id_module
```

**Formations sans inscrits (B3) et modules sans intervenant (C3)**
Utilise le pattern `LEFT JOIN ... WHERE IS NULL` — plus performant que `NOT IN` sur sous-requête, surtout sur de grands volumes.

```sql
-- Pattern : anti-jointure
LEFT JOIN inscription i ON i.id_formation = f.id_formation
WHERE i.id_inscription IS NULL
```

**Modules avec le plus d'inscrits (B2)**
Utilise `COUNT(DISTINCT id_inscription)` pour éviter de comptabiliser plusieurs fois le même étudiant si des jointures produisent des doublons.

---

## Partie 3 — Instructions d'exécution

### PostgreSQL

```bash
# 1. Créer la base de données
psql -U postgres -c "CREATE DATABASE organisme_formation ENCODING 'UTF8';"

# 2. Créer les tables
psql -U postgres -d organisme_formation -f sql/01_creation_base.sql

# 3. Insérer les données de test
psql -U postgres -d organisme_formation -f sql/02_donnees_test.sql

# 4. Exécuter les requêtes opérationnelles
psql -U postgres -d organisme_formation -f sql/03_requetes_operationnelles.sql

# 5. Exécuter les requêtes d'analyse
psql -U postgres -d organisme_formation -f sql/04_analyse_reporting.sql

```