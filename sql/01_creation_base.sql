
-- Création de la base de donnée
-- DROP DATABASE IF EXISTS organisme_formation;
-- CREATE DATABASE organisme_formation ENCODING 'UTF8';

DROP TABLE IF EXISTS suivi;
DROP TABLE IF EXISTS formation_module;
DROP TABLE IF EXISTS inscription;
DROP TABLE IF EXISTS animation;
DROP TABLE IF EXISTS module;
DROP TABLE IF EXISTS etudiant;
DROP TABLE IF EXISTS formation;
DROP TABLE IF EXISTS intervenant;




-- Table ETUDIANT
CREATE TABLE etudiant(
    id_etudiant SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email  VARCHAR(150) NOT NULL,
    date_naissance  DATE,
    date_inscription DATE  NOT NULL DEFAULT CURRENT_DATE,
    CONSTRAINT uq_etudiant_email UNIQUE (email)
);

-- Table FORMATION
CREATE TABLE formation(
    id_formation SERIAL PRIMARY KEY,
    libelle VARCHAR(200) NOT NULL,
    description TEXT,
    duree_prevue INT NOT NULL CHECK (duree_prevue > 0),
    annee INT NOT NULL CHECK (annee >= 2000)
);

-- Table MODULE
CREATE TABLE module(
    id_module SERIAL PRIMARY KEY,
    libelle VARCHAR(200) NOT NULL,
    duree_prevue INT NOT NULL CHECK (duree_prevue > 0)
);

-- Table INTERVENANT
CREATE TABLE intervenant(
    id_intervenant SERIAL PRIMARY KEY,
    nom VARCHAR(100)    NOT NULL,
    prenom VARCHAR(100)    NOT NULL,
    email VARCHAR(150),
    specialite VARCHAR(150),
    CONSTRAINT uq_intervenant_email UNIQUE (email)
);

-- Table INSCRIPTION (Étudiant S'inscrit à Formation)
CREATE TABLE inscription(
    id_inscription SERIAL  PRIMARY KEY,
    id_etudiant INT NOT NULL REFERENCES etudiant(id_etudiant),
    id_formation INT NOT NULL REFERENCES formation(id_formation),
    date_debut DATE  NOT NULL DEFAULT CURRENT_DATE,
    statut VARCHAR(20) NOT NULL DEFAULT 'en_cours',
    CONSTRAINT uq_inscription UNIQUE (id_etudiant, id_formation),
    CONSTRAINT ck_inscription_statut CHECK (statut IN ('en_cours', 'reussite', 'echec'))
);

-- Table FORMATION_MODULE
CREATE TABLE formation_module(
    id_formation INT NOT NULL REFERENCES formation(id_formation),
    id_module INT NOT NULL REFERENCES module(id_module),
    PRIMARY KEY (id_formation, id_module)
);

-- Table SUIVI
CREATE TABLE suivi(
    id_suivi SERIAL PRIMARY KEY,
    id_inscription INT NOT NULL REFERENCES inscription(id_inscription),
    id_module INT NOT NULL REFERENCES module(id_module),
    note NUMERIC(4,2) CHECK (note >= 0 AND note <= 20),
    duree_reelle INT CHECK (duree_reelle >= 0),
    date_suivi DATE,
    CONSTRAINT uq_suivi UNIQUE (id_inscription, id_module)
);

-- Table ANIMATION
CREATE TABLE animation(
    id_intervenant INT NOT NULL REFERENCES intervenant(id_intervenant),
    id_module INT NOT NULL REFERENCES module(id_module),
    PRIMARY KEY (id_intervenant, id_module)
);