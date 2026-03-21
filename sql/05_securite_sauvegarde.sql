
-- Une réflexion sur la gestion des rôles et des droits

DROP ROLE IF EXISTS role_lecteur;
DROP ROLE IF EXISTS role_secretariat;
DROP ROLE IF EXISTS role_formateur;
DROP ROLE IF EXISTS role_admin;

CREATE ROLE role_lecteur;
CREATE ROLE role_secretariat;
CREATE ROLE role_formateur;
CREATE ROLE role_admin;

+------------------+-------------------------+--------------------------+
| Rôle             | Profil réel             | Accès                    |
+------------------+-------------------------+--------------------------+
| role_lecteur     | Direction, reporting    | SELECT uniquement        |
| role_secretariat | Secrétariat pédagogique | Étudiants + inscriptions |
| role_formateur   | Intervenants            | Notes + suivi            |
| role_admin       | DBA                     | Tout                     |
+------------------+-------------------------+--------------------------+

+------------------+-----------+---------------+------------+------------+
| Table            | Lecteur   | Secrétariat   | Formateur  | Admin      |
+------------------+-----------+---------------+------------+------------+
| etudiant         | SELECT    | SELECT+IUD    | SELECT     | ALL        |
| formation        | SELECT    | SELECT        | SELECT     | ALL        |
| module           | SELECT    | SELECT        | SELECT+U   | ALL        |
| intervenant      | SELECT    | SELECT        | SELECT     | ALL        |
| inscription      | SELECT    | SELECT+IUD    | SELECT     | ALL        |
| formation_module | SELECT    | SELECT        | SELECT     | ALL        |
| suivi            | SELECT    | SELECT        | SELECT+IU  | ALL        |
| animation        | SELECT    | SELECT        | SELECT     | ALL        |
+------------------+-----------+---------------+------------+------------+


-- des exemples de mise en œuvre (droits de lecture, écriture, administration)

GRANT SELECT ON
    etudiant,
    formation,
    module,
    intervenant,
    inscription,
    formation_module,
    suivi,
    animation
TO role_lecteur;

GRANT role_lecteur TO role_secretariat;
 
GRANT INSERT, UPDATE, DELETE ON
    etudiant,
    inscription
TO role_secretariat;

GRANT role_lecteur TO role_formateur;
GRANT INSERT, UPDATE ON suivi TO role_formateur;
GRANT UPDATE ON module TO role_formateur;

GRANT role_secretariat TO role_admin;
GRANT role_formateur TO role_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO role_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO role_admin;



-- une stratégie de sauvegarde et de restauration

    ## Stratégie à deux niveaux :

    1. **Sauvegarde complète chaque nuit à 2h00** 
    2. **Sauvegarde légère toutes les 6h pour limiter la perte de données**
    
    /** Sauvegarde des données **/
        /*
            BASH :
            
            pg_dump \
            --host=localhost \
            --username=u_dba \
            --data-only \
            --format=custom \
            --file=/backups/data_only_$(date +%Y%m%d).dump \
            organisme_formation
        */

  /** Restauration complète **/
        /*
            BASH :
            
            psql -U u_dba -c "DROP DATABASE IF EXISTS organisme_formation;"
            psql -U u_dba -c "CREATE DATABASE organisme_formation;"
            
            pg_restore \
            --host=localhost \
            --username=u_dba \
            --dbname=organisme_formation \
            --verbose \
            /backups/organisme_formation_20240915_0200.dump
        */







