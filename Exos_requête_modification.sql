USE tasks; 
-- modifier un enregistrement à partir d'un nom --
UPDATE `account`
SET email = 'alice.dupont@entreprise.fr'
WHERE (lastname, firstname) = ('DUPONT', 'Alice'); 

-- modifier le statut d'une tâche -- 
UPDATE task 
SET `status` = 0, 
	updated_at = CURRENT_TIMESTAMP
WHERE title = 'Préparer la réunion'; 
	
-- modifier statut plusieurs tâches avec date_fin terminées & MAJ mis colonne updated_date -- 
UPDATE task 
SET `status` = 0, 
	updated_at = CURRENT_TIMESTAMP
WHERE finish_on < now() ; 

-- modifier les priorités -- 
