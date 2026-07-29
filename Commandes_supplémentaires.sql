-- commandes supplémentaires pour avoir des infos -- 
 -- pour voir le détail d'une table -- 
 DESCRIBE `account`;
SHOW CREATE TABLE `account`;
-- pour avoir une date + un nbre de jours particulier , ici 7 jours-- 
DATE_ADD(NOW(), INTERVAL 7 DAY); 
-- Pour quelques heures plus tard -- 
DATE_ADD(NOW(), INTERVAL 2 HOUR); 
-- pour une date passée -- 
DATE_SUB(NOW(), INTERVAL 3 DAY); 
-- OU -- 
DATE_ADD(NOW(), INTERVAL -3 DAY);

-- pour modifier en fct date_fin -- 
-- option 1 : ts date_fin passé peu importe combien -- 
UPDATE task 
SET `status` = 0, 
    updated_at = CURRENT_TIMESTAMP
WHERE finish_on < NOW() -- ;

-- option 2 : date_fin passé d'au moins 1 jour ou plus 
UPDATE task 
SET `status` = 0, 
    updated_at = CURRENT_TIMESTAMP
WHERE finish_on <= DATE_SUB(NOW(), INTERVAL 1 DAY) -- ;

-- option 3 : date_fin correspond exactement à hier sans tenir compte heure --
UPDATE task 
SET `status` = 0, 
    updated_at = CURRENT_TIMESTAMP
WHERE DATE(finish_on) = DATE_SUB(CURDATE(), INTERVAL 1 DAY) -- ;

-- CURDATE() renvoie uniquement la date sans l'heure

 DESCRIBE task;