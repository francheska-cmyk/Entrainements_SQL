-- insérer des lignes (enregistrements) dans un tableau existant -- 
INSERT INTO rights (rights_name) VALUES ('Administrateur'), ('Utilisateur'), ('Manager');

-- insérer des lignes (enregistrements) dans un tableau existant
 INSERT INTO category (category_name) VALUES ('Travail'), ('Personnel'), ('Urgent'), ('Formation'), ('Administratif');

-- ajouter un compte --- 
ALTER TABLE `account` ADD COLUMN image VARCHAR(255);
INSERT INTO `account` (lastname, firstname, email, `password`, rights_id, image) VALUES ('DUPONT', 'Alice', 'alice.dupont@test.fr','1234', 2, 'alice.png'); 

-- ajouter plusieurs comptes -- 
INSERT INTO `account` (lastname, firstname, email, `password`, rights_id, image) VALUES 
('NIELS', 'Xavier', 'xavier.niels@free.fr','8794', 1, 'xavier.png'), 
('BRUNO', 'Lecon', 'lecon.bruno@test.fr','azerty20', 2, 'lecon.png'),
('MACRON', 'Inutile', 'inutile.macron@presi.fr','49LOI', 3, 'inutile.png'),
('PIERRE', 'Marie', 'marie.pierre@pauvre.fr','1234', 2, 'marie.png');

-- assigner une tâche à un utilisateur existant -- 

-- meilleure version que celle en-dessous sans sous-requete et plus performante -- 
INSERT INTO task (title, `description`, finish_on, `status`, recurrence, account_id)
SELECT 
    'Gérer les feedbacks',
    'Consignes les différents commentaires des participants',
    DATE_SUB(NOW(), INTERVAL 7 DAY),
    1,
    'aucune',
    id
FROM `account`
WHERE email = 'marie.pierre@pauvre.fr';
 

INSERT INTO task (title, `description`, finish_on, `status`, recurrence, account_id) VALUES 
('Préparer la réunion', 'Préparer les documents nécessaires pour la réunion', '2026-07-28 03:47:55', 1, 'aucune', 1);
-- assigner une tâche à un utilisateur avec des données calculées et non en dur -- 
INSERT INTO task ( title, `description`, finish_on, `status`, recurrence, account_id) VALUES 
('Animer la réunion', 
'Préparer le support de présentation, l''expliquer et répondre aux questions', 
DATE_ADD(NOW(), INTERVAL 7 DAY), 
1, 
'aucune', 
(SELECT id FROM `account` WHERE email = 'marie.pierre@pauvre.fr'));

INSERT INTO task ( title, `description`, finish_on, `status`, recurrence, account_id) VALUES 
('Gérer les feedbacks', 
'Consignes les différents commentaires des partcipants', 
date_sub(now(), INTERVAL 7 DAY), 
1, 
'aucune', 
(SELECT id FROM `account` WHERE email = 'marie.pierre@pauvre.fr')), 
('Ranger les dossiers', 
'Organiser les dossiers par date de création et sauvegarder les données', 
date_add(now(), INTERVAL 60 DAY), 
1, 
'Mensuelle', 
(SELECT id FROM `account` WHERE email = 'xavier.niels@free.fr')), 
('Géerer les comptes', 
'Gérer les comptes utilisateurs', 
date_add(now(), INTERVAL 100 DAY), 
1, 
'Quotidienne', 
(SELECT id FROM `account` WHERE email = 'xavier.niels@free.fr')),
('Participer à des réunions', 
'Assister à la réunion de présentation', 
date_sub(now(), INTERVAL 2 HOUR), 
0, 
'aucune', 
(SELECT id FROM `account` WHERE email = 'lecon.bruno@test.fr')),
('Gérer le SAV', 
'Appeler le client X', 
date_sub(now(), INTERVAL 1 DAY), 
0, 
'aucune', 
(SELECT id FROM `account` WHERE email = 'lecon.bruno@test.fr')),
('Partciper à des réunions', 
'Animer la réunion mensuelle', 
date_add(now(), INTERVAL 90 DAY), 
1, 
'Mensuelle', 
(SELECT id FROM `account` WHERE email = 'inutile.macron@presi.fr')),
('Réviser le budget', 
'Mettre à jour le budget', 
date_add(now(), INTERVAL 365 DAY), 
1, 
'Mensuelle', 
(SELECT id FROM `account` WHERE email = 'inutile.macron@presi.fr'));

-- associer une tâche à une catégorie -- 
INSERT INTO task_category (task_id, category_id) VALUES 
(
(SELECT id FROM task WHERE title = 'Préparer la réunion'), 
(SELECT id FROM category WHERE category_name ='Travail')
); 
-- associer une tâche à plusieurs catégories  sans sous requete -- 
INSERT INTO task_category (task_id, category_id)
SELECT t.id, c.id
FROM task AS t
JOIN category AS c ON c.category_name IN ('Urgent', 'Administratif')
WHERE t.title = 'Préparer la réunion';

