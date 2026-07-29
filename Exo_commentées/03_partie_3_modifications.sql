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
PARTIE 3 — REQUÊTES DE MODIFICATION
Exercices 20 à 26
=====================================================================
*/


/*
---------------------------------------------------------------------
EXERCICE 20 — Modifier l'email d'Alice Dupont
---------------------------------------------------------------------
WHERE limite la modification au compte d'Alice.
*/
UPDATE `account`
SET email = 'alice.dupont@entreprise.fr'
WHERE lastname = 'Dupont'
  AND firstname = 'Alice';


/*
---------------------------------------------------------------------
EXERCICE 21 — Terminer la tâche Préparer la réunion
---------------------------------------------------------------------
FALSE représente ici une tâche terminée.
NOW() renseigne la date et l'heure actuelles.
*/
UPDATE task
SET `status` = FALSE,
    updated_at = NOW()
WHERE title = 'Préparer la réunion';


/*
---------------------------------------------------------------------
EXERCICE 22 — Terminer toutes les tâches dépassées
---------------------------------------------------------------------
Seules les tâches encore actives et dont finish_on est dans le passé
sont modifiées.
*/
UPDATE task
SET `status` = FALSE,
    updated_at = NOW()
WHERE finish_on < NOW()
  AND `status` = TRUE;


/*
---------------------------------------------------------------------
EXERCICE 23 — Mettre en priorité haute les tâches Urgent
---------------------------------------------------------------------
MySQL permet de faire un UPDATE avec des jointures.
Les jointures relient task à category en passant par task_category.
*/
UPDATE task AS t
INNER JOIN task_category AS tc
    ON tc.task_id = t.id
INNER JOIN category AS c
    ON c.id = tc.category_id
SET t.priority = 'haute',
    t.updated_at = NOW()
WHERE c.category_name = 'Urgent';


/*
---------------------------------------------------------------------
EXERCICE 24 — Reporter de sept jours les tâches actives
---------------------------------------------------------------------
DATE_ADD ajoute sept jours à la date de fin actuelle.
*/
UPDATE task
SET finish_on = DATE_ADD(finish_on, INTERVAL 7 DAY),
    updated_at = NOW()
WHERE `status` = TRUE;


/*
---------------------------------------------------------------------
EXERCICE 25 — Préfixer les tâches d'Alice
---------------------------------------------------------------------
CONCAT assemble la mention et le titre existant.
La jointure évite une sous-requête.
*/
UPDATE task AS t
INNER JOIN `account` AS a
    ON a.id = t.account_id
SET t.title = CONCAT('[À vérifier] ', t.title),
    t.updated_at = NOW()
WHERE a.lastname = 'Dupont'
  AND a.firstname = 'Alice'
  AND t.title NOT LIKE '[À vérifier] %';


/*
---------------------------------------------------------------------
EXERCICE 26 — Donner le droit Manager à Alice
---------------------------------------------------------------------
La jointure avec rights permet de récupérer directement le bon id.
*/
UPDATE `account` AS a
INNER JOIN rights AS r
    ON r.rights_name = 'Manager'
SET a.rights_id = r.id
WHERE a.lastname = 'Dupont'
  AND a.firstname = 'Alice';


/*
---------------------------------------------------------------------
VÉRIFICATION FACULTATIVE
---------------------------------------------------------------------
*/
SELECT
    t.id,
    t.title,
    t.finish_on,
    t.`status`,
    t.priority,
    t.updated_at
FROM task AS t
ORDER BY t.id;

SELECT
    a.lastname,
    a.firstname,
    a.email,
    r.rights_name
FROM `account` AS a
INNER JOIN rights AS r
    ON r.id = a.rights_id
ORDER BY a.lastname, a.firstname;
