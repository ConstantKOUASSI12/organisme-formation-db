// COLLECTION : historique_actions
USE historique_actions;

db.historique_actions.insertMany([
  {
    date_action     : ISODate("2024-09-02T08:30:00Z"),
    type_action     : "INSCRIPTION",
    acteur          : {
      role  : "secretariat",
      login : "u_secretariat"
    },
    entite_cible    : {
      table      : "inscription",
      id_sql     : 1
    },
    detail          : {
      id_etudiant  : 1,
      id_formation : 1,
      statut       : "en_cours"
    },
    ip_source       : "192.168.1.42",
    succes          : true
  },
  {
    date_action     : ISODate("2024-12-10T14:15:00Z"),
    type_action     : "SAISIE_NOTE",
    acteur          : {
      role  : "formateur",
      login : "u_formateur1"
    },
    entite_cible    : {
      table      : "suivi",
      id_sql     : 3
    },
    detail          : {
      id_etudiant  : 1,
      id_module    : 1,
      ancienne_note: null,
      nouvelle_note: 18.00
    },
    ip_source       : "192.168.1.55",
    succes          : true
  }
]);


// COLLECTION : logs
USE logs;

db.logs.insertMany([
  {
    timestamp     : ISODate("2024-09-02T07:58:12Z"),
    niveau        : "INFO",
    service       : "api_formation",
    message       : "Connexion établie",
    utilisateur   : "u_secretariat",
    duree_ms      : 12,
    details       : {
      session_id  : "sess_abc123",
      user_agent  : "Mozilla/5.0"
    }
  },
  {
    timestamp     : ISODate("2024-12-10T14:16:03Z"),
    niveau        : "WARNING",
    service       : "api_formation",
    message       : "Requête lente détectée",
    utilisateur   : "u_direction",
    duree_ms      : 4520,
    details       : {
      requete     : "SELECT AVG(note) FROM suivi JOIN ...",
      seuil_ms    : 2000
    }
  }
]);

// COLLECTION : commentaires_pedagogiques

USE commentaires_pedagogiques;

db.commentaires_pedagogiques.insertMany([
  {
    date            : ISODate("2024-10-16T10:00:00Z"),
    id_etudiant_sql : 1,
    etudiant        : { nom: "Dupont", prenom: "Alice" },
    id_module_sql   : 3,
    module          : "HTML / CSS",
    id_formation_sql: 1,
    auteur          : {
      id_sql    : 1,
      nom       : "Martin",
      prenom    : "Sophie",
      role      : "formateur"
    },
    type_commentaire: "positif",
    contenu         : "Alice maîtrise parfaitement les sélecteurs CSS avancés. Elle aide régulièrement ses camarades.",
    visible_etudiant: true,
    tags            : ["autonomie", "entraide", "CSS"]
  },
  {
    date            : ISODate("2025-01-12T09:45:00Z"),
    id_etudiant_sql : 5,
    etudiant        : { nom: "Petit", prenom: "Emma" },
    id_module_sql   : 6,
    module          : "Machine Learning",
    id_formation_sql: 2,
    auteur          : {
      id_sql    : 2,
      nom       : "Dubois",
      prenom    : "Thomas",
      role      : "formateur"
    },
    type_commentaire: "positif",
    contenu         : "Excellente compréhension des algorithmes de régression. Projet final remarquable.",
    visible_etudiant: true,
    tags            : ["ML", "excellence", "projet"]
  }
]);

// COLLECTION : evaluations_libres

USE evaluations_libres;

db.evaluations_libres.insertMany([
  {
    date              : ISODate("2025-01-20T11:00:00Z"),
    type              : "evaluation_a_chaud",
    id_etudiant_sql   : 1,
    etudiant          : { nom: "Dupont", prenom: "Alice" },
    id_formation_sql  : 1,
    formation         : "Développement Web Full Stack",
    notes_criteres    : {
      qualite_contenu     : 5,
      clarte_formateur    : 4,
      rythme_formation    : 4,
      environnement_travail: 5,
      utilite_pratique    : 5
    },
    note_globale      : 4.6,
    points_positifs   : "Contenu très complet et formateurs disponibles. Les projets pratiques sont vraiment utiles.",
    points_amelioration: "Certains modules pourraient être plus longs (Node.js notamment).",
    recommanderait    : true,
    anonyme           : false
  },
  {
    date              : ISODate("2025-01-21T14:30:00Z"),
    type              : "evaluation_a_chaud",
    id_etudiant_sql   : 2,
    etudiant          : { nom: "Lefevre", prenom: "Bastien" },
    id_formation_sql  : 1,
    formation         : "Développement Web Full Stack",
    notes_criteres    : {
      qualite_contenu     : 3,
      clarte_formateur    : 3,
      rythme_formation    : 2,
      environnement_travail: 4,
      utilite_pratique    : 3
    },
    note_globale      : 3.0,
    points_positifs   : "Bonne ambiance de groupe.",
    points_amelioration: "Le rythme est trop rapide pour les débutants en JavaScript. Plus d'exercices progressifs seraient bienvenus.",
    recommanderait    : false,
    anonyme           : true
  }
]);