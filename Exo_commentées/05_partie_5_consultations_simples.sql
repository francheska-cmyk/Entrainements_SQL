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
PARTIE 5 — CONSULTATIONS SIMPLES
Exercices 32 à 35
=====================================================================
*/


/*
---------------------------------------------------------------------
EXERCICE 32 — Afficher tous les comptes
---------------------------------------------------------------------
Le tri se fait d'abord par nom, puis par prénom.
ASC est facultatif car l'ordre ascendant est utilisé par défaut.
*/
SELECT *
FROM `account`
ORDER BY lastname ASC, firstname ASC;


/*
---------------------------------------------------------------------
EXERCICE 33 — Afficher certaines colonnes et fullname
---------------------------------------------------------------------
CONCAT assemble le prénom, un espace et le nom.
AS crée un alias seulement dans le résultat affiché.
*/
SELECT
    lastname,
    firstname,
    email,
    CONCAT(firstname, ' ', lastname) AS fullname
FROM `account`
ORDER BY lastname, firstname;


/*
---------------------------------------------------------------------
EXERCICE 34 — Afficher les catégories par ordre alphabétique
---------------------------------------------------------------------
*/
SELECT *
FROM category
ORDER BY category_name ASC;


/*
---------------------------------------------------------------------
EXERCICE 35 — Afficher certaines colonnes des tâches
---------------------------------------------------------------------
La date la plus proche apparaît en premier grâce à ASC.
*/
SELECT
    title,
    `description`,
    created_at,
    finish_on,
    `status`
FROM task
ORDER BY finish_on ASC;
