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
PARTIE 1 — MODIFICATION DE LA STRUCTURE
Exercices 1 à 10
=====================================================================
*/


/*
---------------------------------------------------------------------
EXERCICE 1 — Ajouter une colonne phone dans account
---------------------------------------------------------------------
VARCHAR(20) limite le numéro à 20 caractères.
NULL indique que la valeur est facultative.
*/
ALTER TABLE `account`
ADD COLUMN phone VARCHAR(20) NULL;


/*
---------------------------------------------------------------------
EXERCICE 2 — Ajouter une date de naissance
---------------------------------------------------------------------
DATE stocke uniquement une date, sans heure.
La colonne peut rester vide grâce à NULL.
*/
ALTER TABLE `account`
ADD COLUMN birthdate DATE NULL;


/*
---------------------------------------------------------------------
EXERCICE 3 — Agrandir la colonne title
---------------------------------------------------------------------
MODIFY COLUMN permet de modifier le type ou la taille d'une colonne.
On conserve NOT NULL, présent dans la structure d'origine.
*/
ALTER TABLE task
MODIFY COLUMN title VARCHAR(100) NOT NULL;


/*
---------------------------------------------------------------------
EXERCICE 4 — Agrandir la colonne description
---------------------------------------------------------------------
La colonne passe de VARCHAR(255) à VARCHAR(500).
*/
ALTER TABLE task
MODIFY COLUMN `description` VARCHAR(500) NOT NULL;


/*
---------------------------------------------------------------------
EXERCICE 5 — Ajouter created_at dans category
---------------------------------------------------------------------
CURRENT_TIMESTAMP renseigne automatiquement la date et l'heure
au moment où la catégorie est créée.
*/
ALTER TABLE category
ADD COLUMN created_at DATETIME
DEFAULT CURRENT_TIMESTAMP
NOT NULL;


/*
---------------------------------------------------------------------
EXERCICE 6 — Ajouter une priorité dans task
---------------------------------------------------------------------
La priorité est obligatoire et vaut « normale » si aucune valeur
n'est indiquée pendant l'insertion.
*/
ALTER TABLE task
ADD COLUMN priority VARCHAR(20)
NOT NULL
DEFAULT 'normale';


/*
---------------------------------------------------------------------
EXERCICE 7 — Renommer repeat en recurrence
---------------------------------------------------------------------
MySQL 8.0 accepte RENAME COLUMN.
Le type VARCHAR(50) est automatiquement conservé.
*/
ALTER TABLE task
RENAME COLUMN `repeat` TO recurrence;


/*
---------------------------------------------------------------------
EXERCICE 8 — Supprimer la colonne image
---------------------------------------------------------------------
DROP COLUMN supprime la colonne et toutes les valeurs qu'elle contient.
La colonne sera recréée dans la partie 2 avant l'insertion d'Alice,
comme demandé dans la progression pédagogique.
*/
ALTER TABLE `account`
DROP COLUMN image;


/*
---------------------------------------------------------------------
EXERCICE 9 — Rendre phone unique
---------------------------------------------------------------------
La contrainte empêche deux comptes d'avoir exactement le même numéro.
Plusieurs valeurs NULL restent autorisées par MySQL.
*/
ALTER TABLE `account`
ADD CONSTRAINT uq_account_phone UNIQUE (phone);


/*
---------------------------------------------------------------------
EXERCICE 10 — Créer la table comment
---------------------------------------------------------------------
La clé étrangère relie chaque commentaire à une tâche.
ON DELETE CASCADE supprime automatiquement les commentaires
lorsque leur tâche est supprimée.
*/
CREATE TABLE `comment` (
    id INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
    content VARCHAR(500) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    task_id INT NOT NULL,
    CONSTRAINT fk_comment_task
        FOREIGN KEY (task_id)
        REFERENCES task(id)
        ON DELETE CASCADE
);


/*
---------------------------------------------------------------------
VÉRIFICATION FACULTATIVE
---------------------------------------------------------------------
*/
DESCRIBE `account`;
DESCRIBE task;
DESCRIBE category;
DESCRIBE `comment`;
