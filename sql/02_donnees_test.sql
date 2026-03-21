
-- FORMATIONS

INSERT INTO formation (libelle, description, duree_prevue, annee) VALUES
('Développement Web Full Stack',  'Formation complète HTML/CSS/JS/Node/PostgreSQL', 420, 2024),
('Data Science & IA',             'Python, SQL avancé, Machine Learning, Deep Learning', 350, 2024),
('Administration Systèmes Linux', 'Bash, réseau, sécurité, DevOps',                     280, 2024),
('Développement Web Full Stack',  'Même formation, promotion 2025',                      420, 2025),
('Cybersécurité',                 'Pentest, OWASP, forensic, cryptographie',             300, 2025);

-- MODULES
INSERT INTO module (libelle, duree_prevue) VALUES
('SQL & Bases de données',        40), 
('Algorithmique & Python',        35),
('HTML / CSS',                    30), 
('JavaScript avancé',             45), 
('Node.js & Express',             40), 
('Machine Learning',              50),
('Deep Learning & Réseaux de neurones', 45), 
('Administration Linux',          35),
('Réseau & Protocoles',           30),
('Sécurité applicative (OWASP)',  40),
('Cryptographie',                 30),
('Docker & Kubernetes',           30);

-- FORMATION_MODULE
INSERT INTO formation_module (id_formation, id_module) VALUES
(1, 3), 
(1, 4),
(1, 1), 
(1, 5), 
(2, 1), 
(2, 6), 
(2, 7), 
(3, 8), 
(3, 9),
(3, 12),
(4, 3),
(4, 4),
(4, 1),
(4, 5),
(5, 2), 
(5, 8), 
(5, 9), 
(5, 10),
(5, 11);


-- INTERVENANTS
INSERT INTO intervenant (nom, prenom, email, specialite) VALUES
('Martin',   'Sophie',  'sophie.martin@formateurs.fr',  'Développement Web'),
('Dubois',   'Thomas',  'thomas.dubois@formateurs.fr',  'Data Science'),
('Bernard',  'Claire',  'claire.bernard@formateurs.fr', 'DevOps & Linux'),
('Leroy',    'Paul',    'paul.leroy@formateurs.fr',     'Cybersécurité'),
('Moreau',   'Julie',   'julie.moreau@formateurs.fr',   'Bases de données');

-- ANIMATION
INSERT INTO animation (id_intervenant, id_module) VALUES
(1, 3),  
(1, 4),   
(1, 5),   
(5, 1),   
(2, 2),   
(2, 6),   
(2, 7),   
(3, 8),   
(3, 12),  
(4, 10),  
(4, 11);

-- ÉTUDIANTS
INSERT INTO etudiant (nom, prenom, email, date_naissance, date_inscription) VALUES
('Dupont',    'Alice',   'alice.dupont@mail.fr',    '2000-03-15', '2024-09-01'),
('Lefevre',   'Bastien', 'bastien.lefevre@mail.fr', '1999-07-22', '2024-09-01'),
('Nguyen',    'Linh',    'linh.nguyen@mail.fr',     '2001-11-05', '2024-09-01'),
('Garcia',    'Carlos',  'carlos.garcia@mail.fr',   '1998-04-30', '2024-09-01'),
('Petit',     'Emma',    'emma.petit@mail.fr',       '2002-01-18', '2024-09-01'),
('Rousseau',  'Marc',    'marc.rousseau@mail.fr',   '2000-08-09', '2024-09-01'),
('Lambert',   'Sarah',   'sarah.lambert@mail.fr',   '1997-12-25', '2025-01-15'),
('Morel',     'Kevin',   'kevin.morel@mail.fr',      '2001-06-14', '2025-01-15'),
('Simon',     'Laura',   'laura.simon@mail.fr',      '1999-09-03', '2025-01-15'),
('Michel',    'Alexis',  'alexis.michel@mail.fr',   '2000-02-27', '2025-01-15');

-- INSCRIPTIONS

INSERT INTO inscription (id_etudiant, id_formation, date_debut, statut) VALUES
(1, 1, '2024-09-02', 'reussite'),
(2, 1, '2024-09-02', 'echec'),
(3, 1, '2024-09-02', 'reussite'),
(4, 1, '2024-09-02', 'en_cours'),
(3, 2, '2024-09-02', 'en_cours'),
(5, 2, '2024-09-02', 'reussite'),
(6, 2, '2024-09-02', 'echec'),
(4, 3, '2024-09-02', 'reussite'),  
(7, 3, '2024-09-02', 'en_cours'),
(8,  4, '2025-01-16', 'en_cours'),
(9,  4, '2025-01-16', 'en_cours'),
(10, 4, '2025-01-16', 'en_cours'),
(7, 5, '2025-01-16', 'en_cours'),
(9, 5, '2025-01-16', 'en_cours');

-- SUIVI

INSERT INTO suivi (id_inscription, id_module, note, duree_reelle, date_suivi) VALUES
(1, 3, 16.50, 28, '2024-10-15'),
(1, 4, 14.00, 44, '2024-11-20'),
(1, 1, 18.00, 38, '2024-12-10'),
(1, 5, 15.50, 39, '2025-01-15'),
(2, 3,  8.00, 30, '2024-10-15'),
(2, 4,  5.50, 40, '2024-11-20'),
(2, 1,  7.00, 35, '2024-12-10'),
(2, 5,  6.50, 38, '2025-01-15'),
(3, 3, 19.00, 30, '2024-10-15'),
(3, 4, 17.50, 45, '2024-11-20'),
(3, 1, 16.00, 40, '2024-12-10'),
(3, 5, 18.50, 40, '2025-01-15'),
(4, 3, 12.00, 28, '2024-10-15'),
(4, 4, NULL,  NULL, NULL),
(4, 1, 11.00, 38, '2024-12-10'),
(5, 2, 15.00, 34, '2024-10-20'),
(5, 1, 16.00, 38, '2024-11-25'),
(5, 6, 14.00, 48, '2025-01-10'),
(5, 7, NULL,  NULL, NULL),
(6, 2, 17.00, 35, '2024-10-20'),
(6, 1, 19.00, 40, '2024-11-25'),
(6, 6, 18.00, 50, '2025-01-10'),
(6, 7, 16.50, 45, '2025-02-15'),
(7, 2,  4.00, 30, '2024-10-20'),
(7, 1,  6.00, 35, '2024-11-25'),
(7, 6,  5.00, 40, '2025-01-10'),
(7, 7,  3.00, 38, '2025-02-15'),
(8, 8,  14.00, 35, '2024-10-10'),
(8, 9,  13.50, 28, '2024-11-15'),
(8, 12, 15.00, 29, '2024-12-20'),
(9, 8,  NULL, NULL, NULL),
(9, 9,  NULL, NULL, NULL),
(9, 12, NULL, NULL, NULL),
(10, 3, 11.00, 28, '2025-02-15'),
(10, 4, NULL,  NULL, NULL),
(11, 3, 13.50, 30, '2025-02-15'),
(11, 4, 12.00, 42, '2025-03-10'),
(12, 3, 9.50,  29, '2025-02-15'),
(13, 2,  14.00, 33, '2025-02-01'),
(13, 8,  16.00, 35, '2025-02-20'),
(13, 9,  NULL,  NULL, NULL),
(13, 10, NULL,  NULL, NULL),
(14, 2,  12.00, 34, '2025-02-01'),
(14, 8,  11.00, 35, '2025-02-20'),
(14, 9,  NULL,  NULL, NULL);
 