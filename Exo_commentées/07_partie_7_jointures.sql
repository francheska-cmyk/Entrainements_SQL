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
PARTIE 7 — JOINTURES
Exercices 44 à 51
=====================================================================
*/


/*
---------------------------------------------------------------------
EXERCICE 44 — Afficher les comptes et leurs droits
---------------------------------------------------------------------
INNER JOIN ne retourne que les comptes associés à un droit existant.
*/
SELECT
    a.lastname,
    a.firstname,
    a.email,
    r.rights_name
FROM `account` AS a
INNER JOIN rights AS r
    ON r.id = a.rights_id
ORDER BY a.lastname, a.firstname;


/*
---------------------------------------------------------------------
EXERCICE 45 — Afficher les tâches et leurs propriétaires
---------------------------------------------------------------------
*/
SELECT
    t.title,
    t.finish_on,
    a.lastname AS owner_lastname,
    a.firstname AS owner_firstname
FROM task AS t
INNER JOIN `account` AS a
    ON a.id = t.account_id
ORDER BY t.finish_on;


/*
---------------------------------------------------------------------
EXERCICE 46 — Afficher les tâches d'Alice Dupont
---------------------------------------------------------------------
Le filtre porte sur le nom et le prénom du compte relié.
Après l'exercice 25, certains titres peuvent commencer par
[À vérifier], mais ils appartiennent toujours à Alice.
*/
SELECT
    t.*
FROM task AS t
INNER JOIN `account` AS a
    ON a.id = t.account_id
WHERE a.lastname = 'Dupont'
  AND a.firstname = 'Alice'
ORDER BY t.finish_on;


/*
---------------------------------------------------------------------
EXERCICE 47 — Afficher les tâches et leurs catégories
---------------------------------------------------------------------
Une tâche liée à plusieurs catégories apparaît sur plusieurs lignes.
*/
SELECT
    t.title,
    c.category_name
FROM task AS t
INNER JOIN task_category AS tc
    ON tc.task_id = t.id
INNER JOIN category AS c
    ON c.id = tc.category_id
ORDER BY t.title, c.category_name;


/*
---------------------------------------------------------------------
EXERCICE 48 — Consultation complète
---------------------------------------------------------------------
La requête relie cinq tables :
task, account, rights, task_category et category.
*/
SELECT
    t.title,
    t.`status`,
    t.finish_on,
    a.lastname,
    a.firstname,
    r.rights_name,
    c.category_name
FROM task AS t
INNER JOIN `account` AS a
    ON a.id = t.account_id
INNER JOIN rights AS r
    ON r.id = a.rights_id
INNER JOIN task_category AS tc
    ON tc.task_id = t.id
INNER JOIN category AS c
    ON c.id = tc.category_id
ORDER BY t.title, c.category_name;


/*
---------------------------------------------------------------------
EXERCICE 49 — Afficher tous les comptes, même sans tâche
---------------------------------------------------------------------
LEFT JOIN conserve tous les comptes.
Les colonnes de task valent NULL lorsqu'un compte n'a aucune tâche.
*/
SELECT
    a.id,
    a.lastname,
    a.firstname,
    a.email,
    t.id AS task_id,
    t.title AS task_title
FROM `account` AS a
LEFT JOIN task AS t
    ON t.account_id = a.id
ORDER BY a.lastname, a.firstname, t.finish_on;


/*
---------------------------------------------------------------------
EXERCICE 50 — Afficher les catégories sans tâche
---------------------------------------------------------------------
La condition IS NULL garde uniquement les catégories sans association.
*/
SELECT
    c.*
FROM category AS c
LEFT JOIN task_category AS tc
    ON tc.category_id = c.id
WHERE tc.task_id IS NULL
ORDER BY c.category_name;


/*
---------------------------------------------------------------------
EXERCICE 51 — Afficher les tâches sans catégorie
---------------------------------------------------------------------
LEFT JOIN conserve toutes les tâches.
Une valeur NULL dans tc.category_id indique l'absence de catégorie.
*/
SELECT
    t.*
FROM task AS t
LEFT JOIN task_category AS tc
    ON tc.task_id = t.id
WHERE tc.category_id IS NULL
ORDER BY t.finish_on;


/*
---------------------------------------------------------------------
EXERCICE 52
---------------------------------------------------------------------
L'énoncé de l'exercice 52 n'apparaît pas dans le PDF transmis.
Aucune requête n'est inventée ici afin de ne pas te fournir une
fausse correction pendant une évaluation.
*/
