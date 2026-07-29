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
PARTIE 6 — CONSULTATIONS AVEC WHERE
Exercices 36 à 43
=====================================================================
*/


/*
---------------------------------------------------------------------
EXERCICE 36 — Afficher les tâches actives
---------------------------------------------------------------------
BOOLEAN est représenté par TRUE/FALSE, soit 1/0 dans MySQL.
*/
SELECT *
FROM task
WHERE `status` = TRUE;


/*
---------------------------------------------------------------------
EXERCICE 37 — Afficher les tâches terminées
---------------------------------------------------------------------
*/
SELECT *
FROM task
WHERE `status` = FALSE;


/*
---------------------------------------------------------------------
EXERCICE 38 — Afficher les tâches actives en retard
---------------------------------------------------------------------
Les deux conditions doivent être vraies.
*/
SELECT *
FROM task
WHERE `status` = TRUE
  AND finish_on < NOW();


/*
---------------------------------------------------------------------
EXERCICE 39 — Afficher les tâches des sept prochains jours
---------------------------------------------------------------------
BETWEEN inclut les deux limites.
*/
SELECT *
FROM task
WHERE finish_on BETWEEN NOW()
                    AND DATE_ADD(NOW(), INTERVAL 7 DAY)
ORDER BY finish_on;


/*
---------------------------------------------------------------------
EXERCICE 40 — Rechercher le mot réunion dans le titre
---------------------------------------------------------------------
% signifie : n'importe quelle suite de caractères avant ou après.
*/
SELECT *
FROM task
WHERE title LIKE '%réunion%';


/*
---------------------------------------------------------------------
EXERCICE 41 — Afficher les tâches sans récurrence
---------------------------------------------------------------------
On prend en compte :
- une valeur NULL ;
- une chaîne vide ;
- la valeur textuelle « aucune » utilisée dans les insertions.
*/
SELECT *
FROM task
WHERE recurrence IS NULL
   OR recurrence = ''
   OR recurrence = 'aucune';


/*
---------------------------------------------------------------------
EXERCICE 42 — Filtrer les emails finissant par @entreprise.fr
---------------------------------------------------------------------
Le symbole % autorise n'importe quel texte avant le domaine.
*/
SELECT *
FROM `account`
WHERE email LIKE '%@entreprise.fr';


/*
---------------------------------------------------------------------
EXERCICE 43 — Filtrer par priorité
---------------------------------------------------------------------
IN évite d'écrire deux conditions reliées par OR.
*/
SELECT *
FROM task
WHERE priority IN ('haute', 'urgente');
