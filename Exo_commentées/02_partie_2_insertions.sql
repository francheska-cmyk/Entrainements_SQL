/*
=====================================================================
CORRECTIONS SQL — MySQL 8.0 / MySQL Workbench 8.0 CE
Base de données : tasks
Serveur local : Laragon

Conseil :
- Exécuter les fichiers dans l'ordre des parties.
- Dans Workbench, placer le curseur dans une requête et utiliser
  Ctrl + Entrée pour exécuter uniquement cette requête.
- Les commentaires n'empêchent pas l'exécution.
=====================================================================
*/

USE tasks;


/*
=====================================================================
PARTIE 2 — REQUÊTES D'INSERTION
Exercices 11 à 19
=====================================================================
*/


/*
---------------------------------------------------------------------
EXERCICE 11 — Ajouter les droits
---------------------------------------------------------------------
Une seule requête INSERT ajoute les trois lignes.
*/
INSERT INTO rights (rights_name)
VALUES
    ('Administrateur'),
    ('Utilisateur'),
    ('Manager');


/*
---------------------------------------------------------------------
EXERCICE 12 — Ajouter les catégories
---------------------------------------------------------------------
Une seule requête ajoute les cinq catégories.
created_at est rempli automatiquement.
*/
INSERT INTO category (category_name)
VALUES
    ('Travail'),
    ('Personnel'),
    ('Urgent'),
    ('Formation'),
    ('Administratif');


/*
---------------------------------------------------------------------
EXERCICE 13 — Ajouter le compte d'Alice Dupont
---------------------------------------------------------------------
L'exercice 8 a supprimé image. On la recrée donc avant l'insertion.

La première requête récupère l'identifiant du droit Utilisateur
dans une variable MySQL. Cela évite une sous-requête dans l'INSERT.
*/
ALTER TABLE `account`
ADD COLUMN image VARCHAR(255) NOT NULL AFTER `password`;

SELECT id
INTO @utilisateur_right_id
FROM rights
WHERE rights_name = 'Utilisateur';

INSERT INTO `account`
    (lastname, firstname, email, `password`, image, rights_id)
VALUES
    ('Dupont', 'Alice', 'alice.dupont@test.fr', '1234',
     'alice.png', @utilisateur_right_id);


/*
---------------------------------------------------------------------
EXERCICE 14 — Ajouter plusieurs comptes
---------------------------------------------------------------------
On récupère d'abord les identifiants des droits, puis on réalise
une seule insertion contenant quatre comptes supplémentaires.

À la fin, la base contient au minimum :
- un administrateur ;
- un manager ;
- trois utilisateurs, Alice comprise.
*/
SELECT id
INTO @administrateur_right_id
FROM rights
WHERE rights_name = 'Administrateur';

SELECT id
INTO @manager_right_id
FROM rights
WHERE rights_name = 'Manager';

INSERT INTO `account`
    (lastname, firstname, email, `password`, image, rights_id, phone, birthdate)
VALUES
    ('Martin', 'Sophie', 'sophie.martin@entreprise.fr', 'admin1234',
     'sophie.png', @administrateur_right_id, '0600000001', '1990-02-15'),

    ('Bernard', 'Lucas', 'lucas.bernard@entreprise.fr', 'manager1234',
     'lucas.png', @manager_right_id, '0600000002', '1988-06-21'),

    ('Petit', 'Emma', 'emma.petit@test.fr', 'user1234',
     'emma.png', @utilisateur_right_id, '0600000003', '1998-11-03'),

    ('Robert', 'Hugo', 'hugo.robert@test.fr', 'user1234',
     'hugo.png', @utilisateur_right_id, '0600000004', '1996-04-17');


/*
---------------------------------------------------------------------
EXERCICE 15 — Ajouter une tâche à Alice Dupont
---------------------------------------------------------------------
L'identifiant d'Alice est récupéré à partir de son adresse email.
DATE_ADD ajoute sept jours à la date et l'heure actuelles.
TRUE signifie que la tâche est active.
*/
SELECT id
INTO @alice_id
FROM `account`
WHERE email = 'alice.dupont@test.fr';

INSERT INTO task
    (title, `description`, finish_on, `status`,
     recurrence, priority, account_id)
VALUES
    ('Préparer la réunion',
     'Préparer les documents nécessaires pour la réunion',
     DATE_ADD(NOW(), INTERVAL 7 DAY),
     TRUE,
     'aucune',
     'normale',
     @alice_id);


/*
---------------------------------------------------------------------
EXERCICE 16 — Ajouter au minimum dix tâches
---------------------------------------------------------------------
On récupère les identifiants des autres comptes pour éviter de
supposer que leurs id valent forcément 2, 3, 4 ou 5.

Les données comprennent :
- des tâches actives et terminées ;
- des dates passées et futures ;
- des tâches récurrentes et sans récurrence.
*/
SELECT id INTO @sophie_id
FROM `account`
WHERE email = 'sophie.martin@entreprise.fr';

SELECT id INTO @lucas_id
FROM `account`
WHERE email = 'lucas.bernard@entreprise.fr';

SELECT id INTO @emma_id
FROM `account`
WHERE email = 'emma.petit@test.fr';

SELECT id INTO @hugo_id
FROM `account`
WHERE email = 'hugo.robert@test.fr';

INSERT INTO task
    (title, `description`, finish_on, `status`,
     recurrence, priority, account_id)
VALUES
    ('Envoyer le compte rendu',
     'Envoyer le compte rendu de la réunion',
     DATE_ADD(NOW(), INTERVAL 2 DAY),
     TRUE, NULL, 'normale', @alice_id),

    ('Classer les factures',
     'Classer les factures du mois précédent',
     DATE_SUB(NOW(), INTERVAL 40 DAY),
     FALSE, 'mensuelle', 'normale', @sophie_id),

    ('Mettre à jour le planning',
     'Vérifier et mettre à jour le planning de l’équipe',
     DATE_SUB(NOW(), INTERVAL 3 DAY),
     TRUE, 'hebdomadaire', 'haute', @lucas_id),

    ('Réserver une salle',
     'Réserver une salle pour la formation',
     DATE_ADD(NOW(), INTERVAL 5 DAY),
     TRUE, NULL, 'normale', @emma_id),

    ('Suivre la formation SQL',
     'Terminer les exercices de la formation SQL',
     DATE_ADD(NOW(), INTERVAL 12 DAY),
     TRUE, 'hebdomadaire', 'normale', @hugo_id),

    ('Archiver les dossiers',
     'Archiver les anciens dossiers administratifs',
     DATE_SUB(NOW(), INTERVAL 35 DAY),
     FALSE, NULL, 'basse', @alice_id),

    ('Appeler le fournisseur',
     'Demander le nouveau catalogue au fournisseur',
     DATE_ADD(NOW(), INTERVAL 1 DAY),
     TRUE, NULL, 'haute', @sophie_id),

    ('Préparer le budget',
     'Préparer le budget du prochain trimestre',
     DATE_ADD(NOW(), INTERVAL 20 DAY),
     TRUE, 'trimestrielle', 'normale', @lucas_id),

    ('Nettoyer la boîte mail',
     'Supprimer les messages inutiles',
     DATE_SUB(NOW(), INTERVAL 1 DAY),
     TRUE, 'mensuelle', 'basse', @emma_id),

    ('Mettre à jour le profil',
     'Compléter les informations du profil',
     DATE_ADD(NOW(), INTERVAL 6 DAY),
     FALSE, NULL, 'normale', @hugo_id);


/*
---------------------------------------------------------------------
EXERCICE 17 — Associer Préparer la réunion à Travail
---------------------------------------------------------------------
On récupère les deux identifiants, puis on les insère dans la table
d'association task_category.
*/
SELECT id
INTO @reunion_task_id
FROM task
WHERE title = 'Préparer la réunion';

SELECT id
INTO @travail_category_id
FROM category
WHERE category_name = 'Travail';

INSERT INTO task_category (task_id, category_id)
VALUES (@reunion_task_id, @travail_category_id);


/*
---------------------------------------------------------------------
EXERCICE 18 — Associer la réunion à plusieurs catégories
---------------------------------------------------------------------
L'association avec Travail existe déjà depuis l'exercice 17.
On ajoute donc seulement Urgent et Administratif pour éviter
une erreur de clé primaire dupliquée.
*/
SELECT id INTO @urgent_category_id
FROM category
WHERE category_name = 'Urgent';

SELECT id INTO @administratif_category_id
FROM category
WHERE category_name = 'Administratif';

INSERT INTO task_category (task_id, category_id)
VALUES
    (@reunion_task_id, @urgent_category_id),
    (@reunion_task_id, @administratif_category_id);


/*
---------------------------------------------------------------------
EXERCICE 19 — Compléter les associations
---------------------------------------------------------------------
Chaque tâche reçoit au moins une catégorie.
Certaines tâches apparaissent plusieurs fois afin d'avoir plusieurs
catégories.

INSERT IGNORE évite une erreur si une association existe déjà.
*/
SELECT id INTO @personnel_category_id
FROM category
WHERE category_name = 'Personnel';

SELECT id INTO @formation_category_id
FROM category
WHERE category_name = 'Formation';

INSERT IGNORE INTO task_category (task_id, category_id)
SELECT t.id, @travail_category_id
FROM task AS t
WHERE t.title IN (
    'Envoyer le compte rendu',
    'Mettre à jour le planning',
    'Préparer le budget',
    'Appeler le fournisseur'
);

INSERT IGNORE INTO task_category (task_id, category_id)
SELECT t.id, @administratif_category_id
FROM task AS t
WHERE t.title IN (
    'Classer les factures',
    'Archiver les dossiers'
);

INSERT IGNORE INTO task_category (task_id, category_id)
SELECT t.id, @formation_category_id
FROM task AS t
WHERE t.title IN (
    'Réserver une salle',
    'Suivre la formation SQL'
);

INSERT IGNORE INTO task_category (task_id, category_id)
SELECT t.id, @personnel_category_id
FROM task AS t
WHERE t.title IN (
    'Nettoyer la boîte mail',
    'Mettre à jour le profil'
);

-- Quelques tâches reçoivent une seconde catégorie.
INSERT IGNORE INTO task_category (task_id, category_id)
SELECT t.id, @urgent_category_id
FROM task AS t
WHERE t.title IN (
    'Mettre à jour le planning',
    'Appeler le fournisseur'
);

INSERT IGNORE INTO task_category (task_id, category_id)
SELECT t.id, @travail_category_id
FROM task AS t
WHERE t.title = 'Suivre la formation SQL';


/*
---------------------------------------------------------------------
VÉRIFICATION FACULTATIVE
---------------------------------------------------------------------
*/
SELECT * FROM rights;
SELECT * FROM category;
SELECT * FROM `account`;
SELECT * FROM task;
SELECT * FROM task_category;
