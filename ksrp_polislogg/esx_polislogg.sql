CREATE TABLE `polis_loggs` (
	`serie` VARCHAR(10) NOT NULL COLLATE 'utf8mb4_bin',
	`firstname` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_bin',
	`lastname` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_bin',
	`kostnad` VARCHAR(50) NULL DEFAULT '' COLLATE 'utf8mb4_bin',
	`händelse` LONGTEXT NULL COLLATE 'utf8mb4_bin',
	`date` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_bin',
	PRIMARY KEY (`serie`)
)
COLLATE='utf8mb4_bin'
ENGINE=InnoDB
;