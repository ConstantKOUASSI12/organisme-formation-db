-- Nombre total d’étudiants, de formations et de modules

SELECT
    (SELECT COUNT(*) FROM etudiant) nb_etudiants,
    (SELECT COUNT(*) FROM formation) nb_formations,
    (SELECT COUNT(*) FROM module) nb_modules,
    (SELECT COUNT(*) FROM intervenant) nb_intervenants,
    (SELECT COUNT(*) FROM inscription) nb_inscriptions;

-- Moyenne générale des notes par formation
SELECT
    f.libelle formation,
    f.annee,
    COUNT(DISTINCT i.id_etudiant) nb_etudiants,
    COUNT(s.note) nb_notes_saisies,
    ROUND(AVG(s.note), 2) moyenne_generale,
    ROUND(MIN(s.note), 2) note_min,
    ROUND(MAX(s.note), 2) note_max
FROM formation f
INNER JOIN inscription i on i.id_formation   = f.id_formation
INNER JOIN suivi s on s.id_inscription = i.id_inscription
WHERE s.note IS NOT NULL
GROUP BY f.id_formation, f.libelle, f.annee
ORDER BY f.annee, moyenne_generale DESC;

-- Répartition des étudiants par statut (réussite / échec / en cours)
SELECT
    i.statut,
    COUNT(*) nb_inscriptions
FROM inscription i
GROUP BY i.statut
ORDER BY nb_inscriptions DESC;

-- Moyenne des notes par formation et par module
SELECT
    f.libelle formation,
    f.annee,
    m.libelle module,
    COUNT(s.note) nb_notes,
    ROUND(AVG(s.note), 2) moyenne
FROM formation f
INNER JOIN formation_module fm on fm.id_formation = f.id_formation
INNER JOIN module m on m.id_module = fm.id_module
INNER JOIN inscription i on i.id_formation   = f.id_formation
INNER JOIN suivi s on s.id_inscription = i.id_inscription AND s.id_module     = m.id_module
WHERE s.note IS NOT NULL
GROUP BY f.id_formation, f.libelle, f.annee,
         m.id_module, m.libelle
ORDER BY f.annee, f.libelle;

-- Nombre d’étudiants par formation et par année
SELECT
    f.annee,
    f.libelle formation,
    COUNT(DISTINCT i.id_etudiant) nb_etudiants,
    COUNT(CASE WHEN i.statut = 'reussite' THEN 1 END) nb_reussites,
    COUNT(CASE WHEN i.statut = 'echec' THEN 1 END) nb_echecs,
    COUNT(CASE WHEN i.statut = 'en_cours' THEN 1 END) nb_en_cours
FROM formation f
LEFT JOIN inscription i ON i.id_formation = f.id_formation
GROUP BY f.id_formation, f.annee, f.libelle
ORDER BY f.annee, nb_etudiants DESC;

-- Évolution du nombre d’inscriptions au fil du temps
SELECT
    TO_CHAR(DATE_TRUNC('month', i.date_debut), 'YYYY-MM') mois,
    COUNT(*) nb_inscriptions,
    COUNT(DISTINCT i.id_etudiant) nb_etudiants_distincts
FROM inscription i
GROUP BY DATE_TRUNC('month', i.date_debut)
ORDER BY mois;

-- Classer les étudiants par catégorie de résultat (ex : excellent, moyen, insuffisant)
SELECT
    e.nom,
    e.prenom,
    f.libelle formation,
    ROUND(AVG(s.note), 2) moyenne,
    COUNT(s.note) nb_modules_notes,
    CASE
        WHEN AVG(s.note) >= 15  THEN 'Excellent'
        WHEN AVG(s.note) >= 12  THEN 'Bien'
        WHEN AVG(s.note) >= 10  THEN 'Moyen'
        ELSE 'Insuffisant'
    END categorie
FROM etudiant e
INNER JOIN inscription i on i.id_etudiant = e.id_etudiant
INNER JOIN formation f on f.id_formation = i.id_formation
INNER JOIN suivi s on s.id_inscription = i.id_inscription
WHERE s.note IS NOT NULL
GROUP BY e.id_etudiant, e.nom, e.prenom, f.id_formation, f.libelle
ORDER BY f.libelle;

-- Identifier les formations dont la moyenne est inférieure à un seuil défini
WITH moyennes_formations AS (
    SELECT
        f.id_formation,
        f.libelle formation,
        f.annee,
        ROUND(AVG(s.note), 2) moyenne_generale,
        COUNT(DISTINCT i.id_etudiant) nb_etudiants
    FROM formation f
    INNER JOIN inscription i on i.id_formation = f.id_formation
    INNER JOIN suivi s on s.id_inscription = i.id_inscription
    WHERE s.note IS NOT NULL
    GROUP BY f.id_formation, f.libelle, f.annee
)
SELECT
    formation,
    annee,
    moyenne_generale,
    nb_etudiants,
    12 AS seuil
FROM moyennes_formations
WHERE moyenne_generale < 12
ORDER BY moyenne_generale;

-- Mettre en évidence les modules “à risque” (taux d’échec élevé)
WITH stats_modules AS (
    SELECT
        m.id_module,
        m.libelle module,
        COUNT(s.id_suivi) nb_notes,
        COUNT(CASE WHEN s.note < 10  THEN 1 END) nb_echecs,
        COUNT(CASE WHEN s.note >= 10 THEN 1 END) nb_reussites,
        ROUND(AVG(s.note), 2) moyenne,
        ROUND(
            COUNT(CASE WHEN s.note < 10 THEN 1 END)
            * 100.0 / NULLIF(COUNT(s.id_suivi), 0)
        , 1) taux_echec_pct
    FROM module m
    INNER JOIN suivi s ON s.id_module = m.id_module
    WHERE s.note IS NOT NULL
    GROUP BY m.id_module, m.libelle
)
SELECT
    module,
    nb_notes,
    nb_echecs,
    nb_reussites,
    moyenne,
    taux_echec_pct,
    CASE
        WHEN taux_echec_pct >= 50 THEN 'Critique'
        WHEN taux_echec_pct >= 30 THEN 'A risque'
        ELSE 'Correct'
    END niveau_alerte
FROM stats_modules
WHERE taux_echec_pct > 30
ORDER BY taux_echec_pct DESC;