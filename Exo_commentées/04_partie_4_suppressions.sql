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
PARTIE 4 — REQUÊTES DE SUPPRESSION
Exercices 27 à 31
=====================================================================
*/


/*
---------------------------------------------------------------------
EXERCICE 27 — Supprimer une association
---------------------------------------------------------------------
DELETE cible uniquement la ligne de task_category.
La tâche et la catégorie restent présentes.
*/
DELETE tc
FROM task_category AS tc
INNER JOIN task AS t
    ON t.id = tc.task_id
INNER JOIN category AS c
    ON c.id = tc.category_id
WHERE t.title LIKE '%Préparer la réunion%'
  AND c.category_name = 'Administratif';


/*
---------------------------------------------------------------------
EXERCICE 28 — Supprimer les tâches terminées depuis plus de 30 jours
---------------------------------------------------------------------
DATE_SUB calcule la date située trente jours avant maintenant.
Les lignes liées dans task_category et comment sont supprimées
automatiquement grâce aux contraintes ON DELETE CASCADE.
*/
DELETE FROM task
WHERE `status` = FALSE
  AND finish_on < DATE_SUB(NOW(), INTERVAL 30 DAY);


/*
---------------------------------------------------------------------
EXERCICE 29 — Supprimer les catégories inutilisées
---------------------------------------------------------------------
LEFT JOIN conserve toutes les catégories.
Si aucune association n'existe, tc.category_id vaut NULL.
*/
DELETE c
FROM category AS c
LEFT JOIN task_category AS tc
    ON tc.category_id = c.id
WHERE tc.category_id IS NULL;


/*
---------------------------------------------------------------------
EXERCICE 30 — Supprimer les comptes sans tâche
---------------------------------------------------------------------
LEFT JOIN permet de repérer les comptes qui n'ont aucune ligne
correspondante dans task.
*/
DELETE a
FROM `account` AS a
LEFT JOIN task AS t
    ON t.account_id = a.id
WHERE t.id IS NULL;


/*
---------------------------------------------------------------------
EXERCICE 31 — Observer une suppression en cascade
---------------------------------------------------------------------
Étape 1 : création d'un compte temporaire.
*/
SELECT id
INTO @temp_right_id
FROM rights
WHERE rights_name = 'Utilisateur';

INSERT INTO `account`
    (lastname, firstname, email, `password`, image, rights_id)
VALUES
    ('Temporaire', 'Compte', 'temporaire@test.fr',
     'temp1234', 'temp.png', @temp_right_id);

SELECT id
INTO @temp_account_id
FROM `account`
WHERE email = 'temporaire@test.fr';


/*
Étape 2 : création de plusieurs tâches pour ce compte.
*/
INSERT INTO task
    (title, `description`, finish_on, `status`,
     recurrence, priority, account_id)
VALUES
    ('Tâche temporaire 1',
     'Première tâche utilisée pour tester la cascade',
     DATE_ADD(NOW(), INTERVAL 3 DAY),
     TRUE, NULL, 'normale', @temp_account_id),

    ('Tâche temporaire 2',
     'Deuxième tâche utilisée pour tester la cascade',
     DATE_ADD(NOW(), INTERVAL 5 DAY),
     TRUE, 'hebdomadaire', 'haute', @temp_account_id);


/*
Étape 3 : récupération des id des tâches temporaires.
*/
SELECT id INTO @temp_task_1_id
FROM task
WHERE title = 'Tâche temporaire 1'
  AND account_id = @temp_account_id;

SELECT id INTO @temp_task_2_id
FROM task
WHERE title = 'Tâche temporaire 2'
  AND account_id = @temp_account_id;


/*
Étape 4 : association aux catégories encore disponibles.
On choisit les catégories à partir de leur nom.
*/
SELECT id INTO @temp_cat_1_id
FROM category
ORDER BY id
LIMIT 1;

SELECT id INTO @temp_cat_2_id
FROM category
ORDER BY id
LIMIT 1 OFFSET 1;

INSERT INTO task_category (task_id, category_id)
VALUES
    (@temp_task_1_id, @temp_cat_1_id),
    (@temp_task_2_id, @temp_cat_1_id),
    (@temp_task_2_id, @temp_cat_2_id);


/*
Vérification avant suppression.
*/
SELECT * FROM task
WHERE account_id = @temp_account_id;

SELECT tc.*
FROM task_category AS tc
INNER JOIN task AS t
    ON t.id = tc.task_id
WHERE t.account_id = @temp_account_id;


/*
Étape 5 : suppression du compte temporaire.
ON DELETE CASCADE supprime ses tâches.
La cascade de task vers task_category supprime ensuite les associations.
Les catégories ne sont pas supprimées.
*/
DELETE FROM `account`
WHERE id = @temp_account_id;


/*
Vérification après suppression.
Les deux premières requêtes doivent retourner zéro ligne.
La troisième doit encore afficher les catégories.
*/
SELECT * FROM task
WHERE account_id = @temp_account_id;

SELECT *
FROM task_category
WHERE task_id IN (@temp_task_1_id, @temp_task_2_id);

SELECT * FROM category
ORDER BY id;
