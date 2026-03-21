-- Lister les étudiants inscrits à une formation donnée
SELECT 
	a.id_etudiant,
    a.nom,
    a.prenom,
    a.email,
    b.date_debut,
    b.statut,
	c.libelle
FROM etudiant a
INNER JOIN inscription b on a.id_etudiant = b.id_etudiant
INNER JOIN formation c on b.id_formation = c.id_formation
WHERE c.id_formation=1;

-- Afficher le parcours d’un étudiant (formations, modules suivis)
SELECT 
	a.id_etudiant,
    a.nom,
    a.prenom,
    a.email,
    b.date_debut,
    b.statut,
	c.libelle formation,
	d.note,
	d.duree_reelle duree_reelle_formation,
	d.date_suivi,
	e.libelle module,
	e.duree_prevue duree_prevue_module
FROM etudiant a
INNER JOIN inscription b on a.id_etudiant = b.id_etudiant
INNER JOIN formation c on b.id_formation = c.id_formation
INNER JOIN suivi d on b.id_inscription = d.id_inscription
INNER JOIN module e on d.id_module = e.id_module
WHERE a.id_etudiant=4;

-- Identifier les étudiants n’ayant pas encore de note dans un module
SELECT DISTINCT
    e.nom,
    e.prenom,
    f.libelle formation,
	s.note,
    m.libelle module_sans_note
FROM suivi s
INNER JOIN inscription i on i.id_inscription = s.id_inscription
INNER JOIN etudiant e on e.id_etudiant = i.id_etudiant
INNER JOIN formation f on f.id_formation = i.id_formation
JOIN module m on m.id_module = s.id_module
WHERE s.note IS NULL
ORDER BY e.nom, f.libelle, m.libelle;

-- Afficher les étudiants en situation d’échec ou de réussite selon des critères définis par vous

    -- Étudiants en situation d'ÉCHEC (au moins une note < 10 dans leur formation courante)

    SELECT
        e.nom,
        e.prenom,
        f.libelle formation,
        COUNT(s.id_suivi) nb_modules_echoues,
        ROUND(AVG(s.note), 2) moyenne_generale,
        MIN(s.note) note_min
    FROM etudiant e
    INNER JOIN inscription i on i.id_etudiant = e.id_etudiant
    INNER JOIN formation f on f.id_formation = i.id_formation
    INNER JOIN suivi s on s.id_inscription = i.id_inscription
    WHERE s.note IS NOT NULL
    GROUP BY e.id_etudiant, e.nom, e.prenom, f.id_formation, f.libelle
    HAVING AVG(s.note) < 10
    ORDER BY AVG(s.note);

    -- Étudiants en situation de RÉUSSITE (moyenne >= 10 sur tous les modules notés)

    SELECT
        e.nom,
        e.prenom,
        f.libelle formation,
        COUNT(s.id_suivi) nb_modules_valides,
        ROUND(AVG(s.note), 2) moyenne_generale,
        MAX(s.note) note_max
    FROM etudiant e
    INNER JOIN inscription i on i.id_etudiant = e.id_etudiant
    INNER JOIN formation f on f.id_formation = i.id_formation
    INNER JOIN suivi s on s.id_inscription = i.id_inscription
    WHERE s.note IS NOT NULL
    GROUP BY e.id_etudiant, e.nom, e.prenom, f.id_formation, f.libelle
    HAVING AVG(s.note) >= 10
    ORDER BY AVG(s.note) DESC;


-- Lister les modules composant une formation
SELECT 
	a.id_formation,
	a.libelle,
	a.description,
	a.duree_prevue duree_prevue_formation,
	a.annee,
	c.libelle module,
	c.duree_prevue duree_prevue_module
FROM formation a
INNER JOIN formation_module b on a.id_formation = b.id_formation
INNER JOIN module c on b.id_module = c.id_module
WHERE a.id_formation=1;

-- Identifier les modules avec le plus grand nombre d’inscrits

SELECT
    a.libelle module,
    COUNT(DISTINCT b.id_inscription) nb_etudiants_inscrits
FROM module a
INNER JOIN suivi b ON a.id_module = b.id_module
GROUP BY a.id_module, a.libelle
ORDER BY nb_etudiants_inscrits DESC;

-- Afficher les formations n’ayant aucun étudiant inscrit
SELECT
    a.id_formation,
    a.libelle,
    a.annee
FROM formation a
LEFT JOIN inscription b ON a.id_formation = b.id_formation
WHERE b.id_inscription IS NULL
ORDER BY a.annee, a.libelle;

-- Comparer la durée totale prévue d’une formation avec la durée réellement suivie
SELECT
    f.libelle formation,
    e.nom,
    e.prenom,
    SUM(m.duree_prevue) duree_prevue_totale_h,
    COALESCE(SUM(s.duree_reelle), 0) duree_reelle_totale_h,
    SUM(m.duree_prevue) - COALESCE(SUM(s.duree_reelle), 0) ecart_h
FROM formation f
INNER JOIN formation_module fm on fm.id_formation  = f.id_formation
INNER JOIN module m on m.id_module = fm.id_module
INNER JOIN inscription i on i.id_formation = f.id_formation
INNER JOIN etudiant e on e.id_etudiant = i.id_etudiant
LEFT JOIN suivi s on s.id_inscription = i.id_inscription AND s.id_module = m.id_module
GROUP BY f.id_formation, f.libelle, e.id_etudiant, e.nom, e.prenom
ORDER BY f.libelle, e.nom;

-- Lister les modules animés par un intervenant
SELECT
    iv.nom,
    iv.prenom,
    iv.specialite,
    m.libelle  module,
    m.duree_prevue duree_h,
    STRING_AGG(DISTINCT f.libelle, ', ') formations_concernees
FROM intervenant iv
INNER JOIN animation a on a.id_intervenant = iv.id_intervenant
INNER JOIN module m on m.id_module = a.id_module
INNER JOIN formation_module fm on fm.id_module = m.id_module
INNER JOIN formation f on f.id_formation = fm.id_formation
WHERE iv.id_intervenant = 1 
GROUP BY iv.id_intervenant, iv.nom, iv.prenom, iv.specialite,
         m.id_module, m.libelle, m.duree_prevue
ORDER BY m.libelle;

-- Identifier les intervenants ayant le plus de modules

SELECT
    iv.nom,
    iv.prenom,
    iv.specialite,
    COUNT(a.id_module) nb_modules
FROM intervenant iv
LEFT JOIN animation a on a.id_intervenant = iv.id_intervenant
GROUP BY iv.id_intervenant, iv.nom, iv.prenom, iv.specialite
ORDER BY nb_modules DESC;

-- Repérer les modules sans intervenant affecté
SELECT
    m.id_module,
    m.libelle module,
    m.duree_prevue duree_h,
    STRING_AGG(DISTINCT f.libelle, ', ') formations_concernees
FROM module m
INNER JOIN formation_module fm on fm.id_module = m.id_module
INNER JOIN formation f on f.id_formation  = fm.id_formation
LEFT JOIN animation a on a.id_module = m.id_module
WHERE a.id_module IS NULL
GROUP BY m.id_module, m.libelle, m.duree_prevue
ORDER BY m.libelle;