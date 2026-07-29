USE tasks;
-- ajout colonne phone dans la table account--
ALTER TABLE `account` ADD COLUMN phone VARCHAR(20); 

-- ajout date de naissance -- 
ALTER TABLE `account` ADD COLUMN birthday DATE; 

-- modifier une colonne --- 
ALTER TABLE task MODIFY COLUMN title VARCHAR(100); 

-- modifier la taille d'une description --
ALTER TABLE task MODIFY COLUMN `description` VARCHAR(500); 

-- ajouter une valeur date par défaut -- 
ALTER TABLE category ADD COLUMN created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL; 

-- ajouter une priorité et une valeur par défaut -- 
ALTER TABLE task ADD COLUMN priority VARCHAR(20) NOT NULL DEFAULT 'normale'; 

-- renommer une colonne sans modifier le type de données -- 
ALTER TABLE task RENAME COLUMN `repeat` TO recurrence; 

-- supprimer une colonne et non un enregistrement (donc une ligne)-- 
ALTER TABLE `account` DROP COLUMN image; 

-- ajouter une contrainte d'unicité à une table existante -- 
ALTER TABLE `account` ADD CONSTRAINT unique_phone UNIQUE (phone); 

-- ajouter une nouvelle table dans une BDD existante avec suppression en cascade -- 
CREATE TABLE IF NOT EXISTS `comment` (
id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
content VARCHAR(500) NOT NULL,
created_at DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
task_id INT NOT NULL,
CONSTRAINT fk_to_assign_comment
FOREIGN KEY(task_id)
REFERENCES task(id) ON DELETE CASCADE
);
