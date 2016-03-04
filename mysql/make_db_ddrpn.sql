-- V1.0
-- DDr PartNumber database with OrCAD CIS support

SET sql_mode='';
DROP DATABASE IF EXISTS db_ddrpn;
CREATE SCHEMA db_ddrpn;

/* ---------------------------------
    Users and their permissions

    ddrpnuser:      read only
    ddrpnadmin:     edit tables
    ddrpnsadmin:    full
    orcadcisuser:   to use cis from OrCAD
    orcadcisadmin:  to edit cis related info

*/

/* DROP will fail if user does not exist so it should be done only ones
DROP USER 'ddrpnsadmin';
DROP USER 'ddrpnadmin';
DROP USER 'orcadcisadmin';
DROP USER 'ddrpnuser';
DROP USER 'orcadcisuser';

CREATE USER 'ddrpnsadmin'   IDENTIFIED BY 'd1g15admin';
CREATE USER 'ddrpnadmin'    IDENTIFIED BY 'dig1admin';
CREATE USER 'orcadcisadmin' IDENTIFIED BY 'www.DDR.hu';
CREATE USER 'ddrpnuser'     IDENTIFIED BY 'www.ddr.hu';
CREATE USER 'orcadcisuser'  IDENTIFIED BY 'www.ddr.hu';
*/

/* TODO: need to test what does it do if runs many times
GRANT ALL PRIVILEGES        ON db_ddrpn.* TO 'ddrpnsadmin' IDENTIFIED BY 'digi5admin';
GRANT INSERT,UPDATE,SELECT  ON db_ddrpn.* TO 'ddrpnadmin' IDENTIFIED BY 'dig1admin';
GRANT INSERT,UPDATE,SELECT  ON db_ddrpn.* TO 'orcadcisadmin' IDENTIFIED BY 'www.DDR.hu';
GRANT SELECT                ON db_ddrpn.* TO 'ddrpnuser' IDENTIFIED BY 'www.ddr.hu';
GRANT SELECT                ON db_ddrpn.* TO 'orcadcisuser' IDENTIFIED BY 'www.ddr.hu';
FLUSH PRIVILEGES;
*/

USE db_ddrpn;

-- -----------------------------------------------------
-- Table for part number groups
-- -----------------------------------------------------
CREATE TABLE tb_group (
    id      INT(3) UNSIGNED ZEROFILL NOT NULL,
    -- table name
    tname   VARCHAR(32) NOT NULL,           
    status  SET('active','obsolete','deleted','tmp'),
    -- OrCAD TYPE definition
    type    VARCHAR(16) NULL DEFAULT NULL,  
    descrip VARCHAR(64) NULL DEFAULT NULL,
    PRIMARY KEY (id) )
ENGINE = InnoDB
-- comment string used in database editor table selector
COMMENT = 'PartNumber Groups';

-- -----------------------------------------------------
-- PN tables
-- tb_[0-6] tables hold the PartNumbers (same table structure)
-- -----------------------------------------------------

-- partnumber: 0xx group table
CREATE TABLE tb_0xx (
    grp       INT(3) UNSIGNED ZEROFILL NOT NULL,
    pn        INT(5) UNSIGNED ZEROFILL NOT NULL,
    rev       INT(2) UNSIGNED ZEROFILL DEFAULT 0,
    -- OrCAD table reference
    id_ecad   INT UNSIGNED DEFAULT 1,         
    stat      SET('active','not4new','obsolete','deleted','tmp') NULL DEFAULT 'active',
    value     VARCHAR(16) NULL DEFAULT NULL,
    param     VARCHAR(16) NULL DEFAULT NULL,
    rohs      SET('yes','no','na') NULL DEFAULT 'yes',
    descrip   VARCHAR(32) NULL DEFAULT NULL,
    datasheet VARCHAR(64) NULL DEFAULT NULL,
    PRIMARY KEY (grp, pn, rev) )
ENGINE = InnoDB
COMMENT = '[0xx] Products';

-- partnumber: 1xx group table
CREATE TABLE tb_1xx (
    grp       INT(3) UNSIGNED ZEROFILL NOT NULL,
    pn        INT(5) UNSIGNED ZEROFILL NOT NULL,
    rev       INT(2) UNSIGNED ZEROFILL DEFAULT 0,
    id_ecad   INT UNSIGNED,
    stat      SET('active','not4new','obsolete','deleted','tmp') NULL DEFAULT 'active',
    value     VARCHAR(16) NULL DEFAULT NULL,
    param     VARCHAR(16) NULL DEFAULT NULL,
    rohs      SET('yes','no','na') NULL DEFAULT 'yes',
    descrip   VARCHAR(32) NULL DEFAULT NULL,
    datasheet VARCHAR(64) NULL DEFAULT NULL,
    PRIMARY KEY (grp, pn, rev) )
ENGINE = InnoDB
COMMENT = '[1xx] Resistors';

-- partnumber: 2xx group table
CREATE TABLE tb_2xx (
     grp       INT(3) UNSIGNED ZEROFILL NOT NULL,
    pn        INT(5) UNSIGNED ZEROFILL NOT NULL,
    rev       INT(2) UNSIGNED ZEROFILL DEFAULT 0,
    id_ecad   INT UNSIGNED,
    stat      SET('active','not4new','obsolete','deleted','tmp') NULL DEFAULT 'active',
    value     VARCHAR(16) NULL DEFAULT NULL,
    param     VARCHAR(16) NULL DEFAULT NULL,
    rohs      SET('yes','no','na') NULL DEFAULT 'yes',
    descrip   VARCHAR(32) NULL DEFAULT NULL,
    datasheet VARCHAR(64) NULL DEFAULT NULL,
    PRIMARY KEY (grp, pn, rev) )
ENGINE = InnoDB
COMMENT = '[2xx] Capacitors';

-- partnumber: 3xx group table
CREATE TABLE tb_3xx (
    grp       INT(3) UNSIGNED ZEROFILL NOT NULL,
    pn        INT(5) UNSIGNED ZEROFILL NOT NULL,
    rev       INT(2) UNSIGNED ZEROFILL DEFAULT 0,
    id_ecad   INT UNSIGNED,
    stat      SET('active','not4new','obsolete','deleted','tmp') NULL DEFAULT 'active',
    value     VARCHAR(16) NULL DEFAULT NULL,
    param     VARCHAR(16) NULL DEFAULT NULL,
    rohs      SET('yes','no','na') NULL DEFAULT 'yes',
    descrip   VARCHAR(32) NULL DEFAULT NULL,
    datasheet VARCHAR(64) NULL DEFAULT NULL,
    PRIMARY KEY (grp, pn, rev) )
ENGINE = InnoDB
COMMENT = '[3xx] Passive Parts';

-- partnumber: 4xx group table
CREATE TABLE tb_4xx (
    grp       INT(3) UNSIGNED ZEROFILL NOT NULL,
    pn        INT(5) UNSIGNED ZEROFILL NOT NULL,
    rev       INT(2) UNSIGNED ZEROFILL DEFAULT 0,
    id_ecad   INT UNSIGNED,
    stat      SET('active','not4new','obsolete','deleted','tmp') NULL DEFAULT 'active',
    value     VARCHAR(16) NULL DEFAULT NULL,
    param     VARCHAR(16) NULL DEFAULT NULL,
    rohs      SET('yes','no','na') NULL DEFAULT 'yes',
    descrip   VARCHAR(32) NULL DEFAULT NULL,
    datasheet VARCHAR(64) NULL DEFAULT NULL,
    PRIMARY KEY (grp, pn, rev) )
ENGINE = InnoDB
COMMENT = '[4xx] Active Discreate Parts';

-- partnumber: 5xx group table
CREATE TABLE tb_5xx (
    grp       INT(3) UNSIGNED ZEROFILL NOT NULL,
    pn        INT(5) UNSIGNED ZEROFILL NOT NULL,
    rev       INT(2) UNSIGNED ZEROFILL DEFAULT 0,
    id_ecad   INT UNSIGNED,
    stat      SET('active','not4new','obsolete','deleted','tmp') NULL DEFAULT 'active',
    value     VARCHAR(16) NULL DEFAULT NULL,
    param     VARCHAR(16) NULL DEFAULT NULL,
    rohs      SET('yes','no','na') NULL DEFAULT 'yes',
    descrip   VARCHAR(32) NULL DEFAULT NULL,
    datasheet VARCHAR(64) NULL DEFAULT NULL,
    PRIMARY KEY (grp, pn, rev) )
ENGINE = InnoDB
COMMENT = '[5xx] Integrated Circuits';

-- this table holds all other groups from 600
CREATE TABLE tb_6pp (
    grp       INT(3) UNSIGNED ZEROFILL NOT NULL,
    pn        INT(5) UNSIGNED ZEROFILL NOT NULL,
    rev       INT(2) UNSIGNED ZEROFILL DEFAULT 0,
    id_ecad   INT UNSIGNED,
    stat      SET('active','not4new','obsolete','deleted','tmp') NULL DEFAULT 'active',
    value     VARCHAR(16) NULL DEFAULT NULL,
    param     VARCHAR(16) NULL DEFAULT NULL,
    rohs      SET('yes','no','na') NULL DEFAULT 'yes',
    descrip   VARCHAR(32) NULL DEFAULT NULL,
    datasheet VARCHAR(64) NULL DEFAULT NULL,
    PRIMARY KEY (grp, pn, rev) )
ENGINE = InnoDB
COMMENT = '[6++] Other PartNumbers';

-- -----------------------------------------------------
-- Table tb_avl
-- -----------------------------------------------------
-- Table collects Approved Vendor List and related info
CREATE  TABLE tb_avl (
    id        INT UNSIGNED NOT NULL AUTO_INCREMENT,
    
    name      VARCHAR(64) NOT NULL,
    type      SET('oem','dist','tbd') DEFAULT 'oem',
    status    VARCHAR(10) NOT NULL,
    web       VARCHAR(64) NULL DEFAULT NULL,
    PRIMARY KEY (id) )
ENGINE = InnoDB
COMMENT = '[AVL] Approved Vendor List';

-- -----------------------------------------------------
-- Table tb_ecad
-- -----------------------------------------------------
CREATE  TABLE tb_ecad (
    id        INT UNSIGNED NOT NULL AUTO_INCREMENT,
    symbol    VARCHAR(32) NULL DEFAULT NULL,
    footprint VARCHAR(64) NULL DEFAULT NULL,
    3d_model  VARCHAR(64) NULL DEFAULT NULL,
    status    SET('active','tmp','not4new','deteled','na') NULL DEFAULT 'active',
    pkgtype   VARCHAR(64) NULL DEFAULT NULL,
    PRIMARY KEY (id) )
ENGINE = InnoDB
COMMENT = '[ECAD] Informations';

-- -----------------------------------------------------
-- Table tb_source
-- -----------------------------------------------------
CREATE  TABLE tb_source (
    id        INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_pn     VARCHAR(16)  NOT NULL,
    id_avl    INT UNSIGNED NOT NULL,
    partnum   VARCHAR(64)  NOT NULL,
    cost_unit DECIMAL(5,4) UNSIGNED DEFAULT 0,
    cost_1k   DECIMAL(5,4) UNSIGNED DEFAULT 0,
    currency  VARCHAR(6)   NULL DEFAULT 'US$',
    date      DATE NULL,
    status    SET('preferred','approved','obsolete','not4new','tbd','na') DEFAULT 'approved',
  PRIMARY KEY (id) )
ENGINE = InnoDB
COMMENT = '[PNS] PartNumber Source';

-- -----------------------------------------------------
-- VIEW orcad
-- -----------------------------------------------------
CREATE VIEW orcad AS
   (SELECT 
        CONCAT(tb_1xx.grp,'-',tb_1xx.pn,'-',tb_1xx.rev) AS PartNumber,
        tb_group.type AS PartType,
        tb_ecad.status AS Status,
        tb_1xx.value AS Value,
        tb_1xx.param AS Param,
        tb_ecad.symbol AS SCHSymbol,
        tb_ecad.footprint AS PCBFootprint,
        IF(tb_ecad.3d_model IS NULL,'',tb_ecad.3d_model) AS 3DModel,
        UCASE(CONCAT(
            IF(tb_group.type IS NULL,'',tb_group.type),
            IF(tb_1xx.value  IS NULL,'',CONCAT(',',tb_1xx.value)),
            IF(tb_1xx.param  IS NULL,'',CONCAT(',',tb_1xx.param)),
            IF(tb_1xx.descrip IS NULL,CONCAT(',',tb_group.descrip),CONCAT(',',tb_1xx.descrip)))) AS Description,
        tb_1xx.datasheet AS Datasheet
   FROM tb_1xx,tb_group,tb_ecad,tb_avl
   WHERE 
        tb_1xx.id_ecad = tb_ecad.id
        AND tb_1xx.grp = tb_group.id
   GROUP BY PartNumber)
   UNION
   (SELECT 
        CONCAT(tb_2xx.grp,'-',tb_2xx.pn,'-',tb_2xx.rev) AS PartNumber,
        tb_group.type AS PartType,
        tb_ecad.status AS Status,
        tb_2xx.value AS Value,
        tb_2xx.param AS Param,
        tb_ecad.symbol AS SCHSymbol,
        tb_ecad.footprint AS PCBFootprint,
        IF(tb_ecad.3d_model IS NULL,'',tb_ecad.3d_model) AS 3DModel,
        UCASE(Concat(
            IF(tb_group.type IS NULL,'',tb_group.type),
            IF(tb_2xx.value  IS NULL,'',CONCAT(',',tb_2xx.value)),
            IF(tb_2xx.param  IS NULL,'',CONCAT(',',tb_2xx.param)),
            IF(tb_2xx.descrip IS NULL,CONCAT(',',tb_group.descrip),CONCAT(',',tb_2xx.descrip)))) AS Description,
        tb_2xx.datasheet AS Datasheet
   FROM tb_2xx,tb_group,tb_ecad,tb_avl
   WHERE 
        tb_2xx.id_ecad = tb_ecad.id AND 
        tb_2xx.grp = tb_group.id
   GROUP BY PartNumber)
   UNION
   (SELECT 
        CONCAT(tb_3xx.grp,'-',tb_3xx.pn,'-',tb_3xx.rev) AS PartNumber,
        tb_group.type AS PartType,
        tb_ecad.status AS Status,
        tb_3xx.value AS Value,
        tb_3xx.param AS Param,
        tb_ecad.symbol AS SCHSymbol,
        tb_ecad.footprint AS PCBFootprint,
        IF(tb_ecad.3d_model IS NULL,'',tb_ecad.3d_model) AS 3DModel,
        UCASE(Concat(
            IF(tb_group.type IS NULL,'',tb_group.type),
            IF(tb_3xx.value  IS NULL,'',CONCAT(',',tb_3xx.value)),
            IF(tb_3xx.param  IS NULL,'',CONCAT(',',tb_3xx.param)),
            IF(tb_3xx.descrip IS NULL,CONCAT(',',tb_group.descrip),CONCAT(',',tb_3xx.descrip)))) AS Description,
        tb_3xx.datasheet AS Datasheet
   FROM tb_3xx,tb_group,tb_ecad,tb_avl
   WHERE 
        tb_3xx.id_ecad = tb_ecad.id AND 
        tb_3xx.grp = tb_group.id
   GROUP BY PartNumber)
   UNION
   (SELECT 
        CONCAT(tb_4xx.grp,'-',tb_4xx.pn,'-',tb_4xx.rev) AS PartNumber,
        tb_group.type AS PartType,
        tb_ecad.status AS Status,
        tb_4xx.value AS Value,
        tb_4xx.param AS Param,
        tb_ecad.symbol AS SCHSymbol,
        tb_ecad.footprint AS PCBFootprint,
        IF(tb_ecad.3d_model IS NULL,'',tb_ecad.3d_model) AS 3DModel,
        UCASE(Concat(
            IF(tb_group.type IS NULL,'',tb_group.type),
            IF(tb_4xx.value  IS NULL,'',CONCAT(',',tb_4xx.value)),
            IF(tb_4xx.param  IS NULL,'',CONCAT(',',tb_4xx.param)),
            IF(tb_4xx.descrip IS NULL,CONCAT(',',tb_group.descrip),CONCAT(',',tb_4xx.descrip)))) AS Description,
        tb_4xx.datasheet AS Datasheet
   FROM tb_4xx,tb_group,tb_ecad,tb_avl
   WHERE 
        tb_4xx.id_ecad = tb_ecad.id AND 
        tb_4xx.grp = tb_group.id
   GROUP BY PartNumber)
   UNION
   (SELECT 
        CONCAT(tb_5xx.grp,'-',tb_5xx.pn,'-',tb_5xx.rev) AS PartNumber,
        tb_group.type AS PartType,
        tb_ecad.status AS Status,
        tb_5xx.value AS Value,
        tb_5xx.param AS Param,
        tb_ecad.symbol AS SCHSymbol,
        tb_ecad.footprint AS PCBFootprint,
        IF(tb_ecad.3d_model IS NULL,'',tb_ecad.3d_model) AS 3DModel,
        UCASE(Concat(
            IF(tb_group.type IS NULL,'',tb_group.type),
            IF(tb_5xx.value  IS NULL,'',CONCAT(',',tb_5xx.value)),
            IF(tb_5xx.param  IS NULL,'',CONCAT(',',tb_5xx.param)),
            IF(tb_5xx.descrip IS NULL,CONCAT(',',tb_group.descrip),CONCAT(',',tb_5xx.descrip)))) AS Description,
        tb_5xx.datasheet AS Datasheet
   FROM tb_5xx,tb_group,tb_ecad,tb_avl
   WHERE 
        tb_5xx.id_ecad = tb_ecad.id AND 
        tb_5xx.grp = tb_group.id
   GROUP BY PartNumber)
   ;

-- -----------------------------------------------------
-- VIEW orcad with source information
--  use this in final version!
-- -----------------------------------------------------
CREATE VIEW orcad1 AS
   (SELECT 
        CONCAT(tb_1xx.grp,'-',tb_1xx.pn,'-',tb_1xx.rev) AS PartNumber,
        tb_group.type AS PartType,
        tb_ecad.status AS Status,
        tb_1xx.value AS Value,
        tb_1xx.param AS Param,
        tb_ecad.symbol AS SCHSymbol,
        tb_ecad.footprint AS PCBFootprint,
        IF(tb_ecad.3d_model IS NULL,'',tb_ecad.3d_model) AS 3DModel,
        UCASE(CONCAT(
            IF(tb_group.type IS NULL,'',tb_group.type),
            IF(tb_1xx.value  IS NULL,'',CONCAT(',',tb_1xx.value)),
            IF(tb_1xx.param  IS NULL,'',CONCAT(',',tb_1xx.param)),
            IF(tb_1xx.descrip IS NULL,CONCAT(',',tb_group.descrip),CONCAT(',',tb_1xx.descrip)))) AS Description,
        tb_1xx.datasheet AS Datasheet
        ,GROUP_CONCAT(
            tb_avl.name,
            '\t',tb_source.partnum,
            '\t',tb_source.status,
            IF(tb_source.cost_1k > 0,
                CONCAT('\t',tb_source.currency,'\t',tb_source.cost_1k),'')
            ORDER BY tb_source.status ASC
            SEPARATOR '\n\t\t\t\t\t') AS Source
   FROM tb_1xx,tb_group,tb_ecad,tb_avl,tb_source
   WHERE 
        Concat(tb_1xx.grp,'-',tb_1xx.pn,'-',tb_1xx.rev) = tb_source.id_pn
        AND tb_1xx.id_ecad = tb_ecad.id
        AND tb_1xx.grp = tb_group.id
        AND tb_avl.id = tb_source.id_avl
   GROUP BY PartNumber)
   UNION
   (SELECT 
        CONCAT(tb_2xx.grp,'-',tb_2xx.pn,'-',tb_2xx.rev) AS PartNumber,
        tb_group.type AS PartType,
        tb_ecad.status AS Status,
        tb_2xx.value AS Value,
        tb_2xx.param AS Param,
        tb_ecad.symbol AS SCHSymbol,
        tb_ecad.footprint AS PCBFootprint,
        IF(tb_ecad.3d_model IS NULL,'',tb_ecad.3d_model) AS 3DModel,
        UCASE(Concat(
            IF(tb_group.type IS NULL,'',tb_group.type),
            IF(tb_2xx.value  IS NULL,'',CONCAT(',',tb_2xx.value)),
            IF(tb_2xx.param  IS NULL,'',CONCAT(',',tb_2xx.param)),
            IF(tb_2xx.descrip IS NULL,CONCAT(',',tb_group.descrip),CONCAT(',',tb_2xx.descrip)))) AS Description,
        tb_2xx.datasheet AS Datasheet,
        GROUP_CONCAT(
            tb_avl.name,
            '\t',tb_source.partnum,
            '\t',tb_source.status,
            IF(tb_source.cost_1k > 0,
                CONCAT('\t',tb_source.currency,'\t',tb_source.cost_1k),'')
            ORDER BY tb_source.status ASC
            SEPARATOR '\n\t\t\t\t\t') AS Source
   FROM tb_2xx,tb_group,tb_ecad,tb_avl,tb_source
   WHERE 
        Concat(tb_2xx.grp,'-',tb_2xx.pn,'-',tb_2xx.rev) = tb_source.id_pn AND
        tb_2xx.id_ecad = tb_ecad.id AND 
        tb_2xx.grp = tb_group.id AND
        tb_avl.id = tb_source.id_avl
   GROUP BY PartNumber)
   UNION
   (SELECT 
        CONCAT(tb_3xx.grp,'-',tb_3xx.pn,'-',tb_3xx.rev) AS PartNumber,
        tb_group.type AS PartType,
        tb_ecad.status AS Status,
        tb_3xx.value AS Value,
        tb_3xx.param AS Param,
        tb_ecad.symbol AS SCHSymbol,
        tb_ecad.footprint AS PCBFootprint,
        IF(tb_ecad.3d_model IS NULL,'',tb_ecad.3d_model) AS 3DModel,
        UCASE(Concat(
            IF(tb_group.type IS NULL,'',tb_group.type),
            IF(tb_3xx.value  IS NULL,'',CONCAT(',',tb_3xx.value)),
            IF(tb_3xx.param  IS NULL,'',CONCAT(',',tb_3xx.param)),
            IF(tb_3xx.descrip IS NULL,CONCAT(',',tb_group.descrip),CONCAT(',',tb_3xx.descrip)))) AS Description,
        tb_3xx.datasheet AS Datasheet,
        GROUP_CONCAT(
            tb_avl.name,
            '\t',tb_source.partnum,
            '\t',tb_source.status,
            IF(tb_source.cost_1k > 0,
                CONCAT('\t',tb_source.currency,'\t',tb_source.cost_1k),'')
            ORDER BY tb_source.status ASC
            SEPARATOR '\n\t\t\t\t\t') AS Source
   FROM tb_3xx,tb_group,tb_ecad,tb_avl,tb_source
   WHERE 
        Concat(tb_3xx.grp,'-',tb_3xx.pn,'-',tb_3xx.rev) = tb_source.id_pn AND
        tb_3xx.id_ecad = tb_ecad.id AND 
        tb_3xx.grp = tb_group.id AND
        tb_avl.id = tb_source.id_avl
   GROUP BY PartNumber)
   UNION
   (SELECT 
        CONCAT(tb_4xx.grp,'-',tb_4xx.pn,'-',tb_4xx.rev) AS PartNumber,
        tb_group.type AS PartType,
        tb_ecad.status AS Status,
        tb_4xx.value AS Value,
        tb_4xx.param AS Param,
        tb_ecad.symbol AS SCHSymbol,
        tb_ecad.footprint AS PCBFootprint,
        IF(tb_ecad.3d_model IS NULL,'',tb_ecad.3d_model) AS 3DModel,
        UCASE(Concat(
            IF(tb_group.type IS NULL,'',tb_group.type),
            IF(tb_4xx.value  IS NULL,'',CONCAT(',',tb_4xx.value)),
            IF(tb_4xx.param  IS NULL,'',CONCAT(',',tb_4xx.param)),
            IF(tb_4xx.descrip IS NULL,CONCAT(',',tb_group.descrip),CONCAT(',',tb_4xx.descrip)))) AS Description,
        tb_4xx.datasheet AS Datasheet,
        GROUP_CONCAT(
            tb_avl.name,
            '\t',tb_source.partnum,
            '\t',tb_source.status,
            IF(tb_source.cost_1k > 0,
                CONCAT('\t',tb_source.currency,'\t',tb_source.cost_1k),'')
            ORDER BY tb_source.status ASC
            SEPARATOR '\n\t\t\t\t\t') AS Source
   FROM tb_4xx,tb_group,tb_ecad,tb_avl,tb_source
   WHERE 
        Concat(tb_4xx.grp,'-',tb_4xx.pn,'-',tb_4xx.rev) = tb_source.id_pn AND
        tb_4xx.id_ecad = tb_ecad.id AND 
        tb_4xx.grp = tb_group.id AND
        tb_avl.id = tb_source.id_avl
   GROUP BY PartNumber)
   UNION
   (SELECT 
        CONCAT(tb_5xx.grp,'-',tb_5xx.pn,'-',tb_5xx.rev) AS PartNumber,
        tb_group.type AS PartType,
        tb_ecad.status AS Status,
        tb_5xx.value AS Value,
        tb_5xx.param AS Param,
        tb_ecad.symbol AS SCHSymbol,
        tb_ecad.footprint AS PCBFootprint,
        IF(tb_ecad.3d_model IS NULL,'',tb_ecad.3d_model) AS 3DModel,
        UCASE(Concat(
            IF(tb_group.type IS NULL,'',tb_group.type),
            IF(tb_5xx.value  IS NULL,'',CONCAT(',',tb_5xx.value)),
            IF(tb_5xx.param  IS NULL,'',CONCAT(',',tb_5xx.param)),
            IF(tb_5xx.descrip IS NULL,CONCAT(',',tb_group.descrip),CONCAT(',',tb_5xx.descrip)))) AS Description,
        tb_5xx.datasheet AS Datasheet,
        GROUP_CONCAT(
            tb_avl.name,
            '\t',tb_source.partnum,
            '\t',tb_source.status,
            IF(tb_source.cost_1k > 0,
                CONCAT('\t',tb_source.currency,'\t',tb_source.cost_1k),'')
            ORDER BY tb_source.status ASC
            SEPARATOR '\n\t\t\t\t\t') AS Source
   FROM tb_5xx,tb_group,tb_ecad,tb_avl,tb_source
   WHERE 
        Concat(tb_5xx.grp,'-',tb_5xx.pn,'-',tb_5xx.rev) = tb_source.id_pn AND
        tb_5xx.id_ecad = tb_ecad.id AND 
        tb_5xx.grp = tb_group.id AND
        tb_avl.id = tb_source.id_avl
   GROUP BY PartNumber)
   ;

-- -----------------------------------------------------
-- Data for table tb_xxx
-- -----------------------------------------------------
CREATE VIEW allpn AS
    (SELECT 
        CONCAT(tb_1xx.grp,'-',tb_1xx.pn,'-',tb_1xx.rev) AS PartNumber,
        tb_1xx.stat AS Status,
        tb_1xx.rohs AS RoHS,
        tb_1xx.value As Value,
        tb_1xx.param AS Parameters,
        tb_1xx.descrip AS Description,
        tb_1xx.datasheet as Datasheet
        FROM tb_1xx) UNION
    (SELECT 
        CONCAT(tb_2xx.grp,'-',tb_2xx.pn,'-',tb_2xx.rev) AS PartNumber,
        tb_2xx.stat AS Status,
        tb_2xx.rohs AS RoHS,
        tb_2xx.value As Value,
        tb_2xx.param AS Parameters,
        tb_2xx.descrip AS Description,
        tb_2xx.datasheet as Datasheet
        FROM tb_2xx) UNION
    (SELECT 
        CONCAT(tb_3xx.grp,'-',tb_3xx.pn,'-',tb_3xx.rev) AS PartNumber,
        tb_3xx.stat AS Status,
        tb_3xx.rohs AS RoHS,
        tb_3xx.value As Value,
        tb_3xx.param AS Parameters,
        tb_3xx.descrip AS Description,
        tb_3xx.datasheet as Datasheet
        FROM tb_3xx) UNION
    (SELECT 
        CONCAT(tb_4xx.grp,'-',tb_4xx.pn,'-',tb_4xx.rev) AS PartNumber,
        tb_4xx.stat AS Status,
        tb_4xx.rohs AS RoHS,
        tb_4xx.value As Value,
        tb_4xx.param AS Parameters,
        tb_4xx.descrip AS Description,
        tb_4xx.datasheet as Datasheet
        FROM tb_4xx) UNION
    (SELECT 
        CONCAT(tb_5xx.grp,'-',tb_5xx.pn,'-',tb_5xx.rev) AS PartNumber,
        tb_5xx.stat AS Status,
        tb_5xx.rohs AS RoHS,
        tb_5xx.value As Value,
        tb_5xx.param AS Parameters,
        tb_5xx.descrip AS Description,
        tb_5xx.datasheet as Datasheet
        FROM tb_5xx) UNION
    (SELECT 
        CONCAT(tb_6pp.grp,'-',tb_6pp.pn,'-',tb_6pp.rev) AS PartNumber,
        tb_6pp.stat AS Status,
        tb_6pp.rohs AS RoHS,
        tb_6pp.value As Value,
        tb_6pp.param AS Parameters,
        tb_6pp.descrip AS Description,
        tb_6pp.datasheet as Datasheet
        FROM tb_6pp) UNION
    (SELECT 
        CONCAT(tb_0xx.grp,'-',tb_0xx.pn,'-',tb_0xx.rev) AS PartNumber,
        tb_0xx.stat AS Status,
        tb_0xx.rohs AS RoHS,
        tb_0xx.value As Value,
        tb_0xx.param AS Parameters,
        tb_0xx.descrip AS Description,
        tb_0xx.datasheet as Datasheet
        FROM tb_0xx)
    ;

-- -----------------------------------------------------
-- Data for table tb_group
-- -----------------------------------------------------
INSERT INTO tb_group VALUES (050,'tb_0xx','active','int,product',    'internal partnumbers');
INSERT INTO tb_group VALUES (070,'tb_0xx','active','sales,product',  'sales partnumbers');

INSERT INTO tb_group VALUES (100,'tb_1xx','active','res,smd,0201',   'smd 0201');
INSERT INTO tb_group VALUES (101,'tb_1xx','active','res,smd,0402',   'smd 0402');
INSERT INTO tb_group VALUES (102,'tb_1xx','active','res,smd,0603',   'smd 0603');
INSERT INTO tb_group VALUES (103,'tb_1xx','active','res,smd,0805',   'smd 0805');
INSERT INTO tb_group VALUES (104,'tb_1xx','active','res,smd,1206',   'smd 1206');
INSERT INTO tb_group VALUES (105,'tb_1xx','active','res,smd,1206+',  'smd 1206+');
INSERT INTO tb_group VALUES (150,'tb_1xx','active','res,smd,array',  'smd array');
INSERT INTO tb_group VALUES (170,'tb_1xx','active','res,th',         'through hole');

INSERT INTO tb_group VALUES (200,'tb_2xx','active','cap,smd,0201',   'smd 0201');
INSERT INTO tb_group VALUES (201,'tb_2xx','active','cap,smd,0402',   'smd 0402');
INSERT INTO tb_group VALUES (202,'tb_2xx','active','cap,smd,0603',   'smd 0603');
INSERT INTO tb_group VALUES (203,'tb_2xx','active','cap,smd,0805',   'smd 0805');
INSERT INTO tb_group VALUES (204,'tb_2xx','active','cap,smd,1206',   'smd 1206');
INSERT INTO tb_group VALUES (205,'tb_2xx','active','cap,smd,1206+',  'smd 1206+');
INSERT INTO tb_group VALUES (250,'tb_2xx','active','cap,smd,array',  'smd array');
INSERT INTO tb_group VALUES (270,'tb_2xx','active','cap,th',         'through hole');

INSERT INTO tb_group VALUES (300,'tb_3xx','active','ind,smd',        'inductor');
INSERT INTO tb_group VALUES (301,'tb_3xx','active','fb,smd',         'ferrite bead');
INSERT INTO tb_group VALUES (310,'tb_3xx','active','cr,smd',         'crystals');
INSERT INTO tb_group VALUES (315,'tb_3xx','active','cr,th',          'through hole package');
INSERT INTO tb_group VALUES (320,'tb_3xx','active','osc,smd',        'oscillators');
INSERT INTO tb_group VALUES (325,'tb_3xx','active','osc,th',         'throupg hole package');
INSERT INTO tb_group VALUES (350,'tb_3xx','active','conn,smd',       'connectors');
INSERT INTO tb_group VALUES (370,'tb_3xx','active','conn,th',        'through hole package');

INSERT INTO tb_group VALUES (400,'tb_4xx','active','tr,bip,n',       'npn tarnsistors');
INSERT INTO tb_group VALUES (410,'tb_4xx','active','tr,bip,p',       'pnp tarnsistors');
INSERT INTO tb_group VALUES (420,'tb_4xx','active','tr,mosfet,n',    'n channel mosfets');
INSERT INTO tb_group VALUES (430,'tb_4xx','active','tr,mosfet,p',    'p channel mosfets');
INSERT INTO tb_group VALUES (440,'tb_4xx','active','diode,smd',      'smd diobe');
INSERT INTO tb_group VALUES (450,'tb_4xx','active','led,smd',        'smd led');
INSERT INTO tb_group VALUES (470,'tb_4xx','active','diode,th',       'through hole');
INSERT INTO tb_group VALUES (480,'tb_4xx','active','led,th',         'through hole');

INSERT INTO tb_group VALUES (500,'tb_5xx','active','ic,lsi',         'lsi');
INSERT INTO tb_group VALUES (510,'tb_5xx','active','ic,clk',         'clock');
INSERT INTO tb_group VALUES (520,'tb_5xx','active','ic,pwd',         'power');
INSERT INTO tb_group VALUES (530,'tb_5xx','active','ic,mem',         'memory');
INSERT INTO tb_group VALUES (540,'tb_5xx','active','ic,io',          'io');
INSERT INTO tb_group VALUES (550,'tb_5xx','active','ic,vlsi',        'vlsi');

INSERT INTO tb_group VALUES (600,'tb_6pp','active','sw,source',      'software sources');
INSERT INTO tb_group VALUES (650,'tb_6pp','active','sw,bin',         'sowftware binaries');
INSERT INTO tb_group VALUES (700,'tb_6pp','active','cad',            'cad files, drawings');
INSERT INTO tb_group VALUES (710,'tb_6pp','active','pcb',            'printed circuit boards');
INSERT INTO tb_group VALUES (720,'tb_6pp','active','assy',           'partially assambled parts');
INSERT INTO tb_group VALUES (800,'tb_6pp','active','man',            'manufacturing materials');
INSERT INTO tb_group VALUES (900,'tb_6pp','active','market',         'marketing materials');
INSERT INTO tb_group VALUES (950,'tb_6pp','active','doc',            'other documents');

-- -----------------------------------------------------
-- Data for table ecad
-- -----------------------------------------------------
INSERT INTO tb_ecad VALUES (NULL,'na','na','na','na','na');
INSERT INTO tb_ecad VALUES (NULL,'res,resh,ress,ressh','r0201',    '3d_r0201','active','smd');
INSERT INTO tb_ecad VALUES (NULL,'res,resh,ress,ressh','r0402',    '3d_r0402','active','smd');
INSERT INTO tb_ecad VALUES (NULL,'res,resh,ress,ressh','r0603',    '3d_r0603','active','smd');
INSERT INTO tb_ecad VALUES (NULL,'res,resh,ress,ressh','r0805',    '3d_r0805','active','smd');
INSERT INTO tb_ecad VALUES (NULL,'res,resh,ress,ressh','r1206',    '3d_r1206','active','smd');
INSERT INTO tb_ecad VALUES (NULL,'cap,caph,caps,capsh','c0201',    '3d_c0201','active','smd');
INSERT INTO tb_ecad VALUES (NULL,'cap,caph,caps,capsh','c0401',    '3d_c0402','active','smd');
INSERT INTO tb_ecad VALUES (NULL,'cap,caph,caps,capsh','c0603',    '3d_c0603','active','smd');
INSERT INTO tb_ecad VALUES (NULL,'cap,caph,caps,capsh','c0805',    '3d_c0805','active','smd');
INSERT INTO tb_ecad VALUES (NULL,'cap,caph,caps,capsh','c1206',    '3d_c1206','active','smd');
INSERT INTO tb_ecad VALUES (NULL,'ttl74',   'soic08',   NULL,   'active','smd');

-- -----------------------------------------------------
-- Data for table tb_avl
-- -----------------------------------------------------
INSERT INTO tb_avl VALUES(NULL,'tbd',       'tbd',  'tbd',   'tbd');
INSERT INTO tb_avl VALUES(NULL,'Intel',     'OEM',  'active','www.intel.com');
INSERT INTO tb_avl VALUES(NULL,'DigiKey',   'Dist', 'active','www.digikey.com');
INSERT INTO tb_avl VALUES(NULL,'Samsung',   'OEM',  'active','www.samsung.com');


/* example only for testing */

-- -----------------------------------------------------
-- Data for table tb_xxx
-- -----------------------------------------------------

INSERT INTO tb_1xx VALUES (100,1,0,2,    'active','0R',       NULL,  'yes','',       'erj_ge.pdf');
INSERT INTO tb_1xx VALUES (101,1,0,3,    'active','0R',       NULL,  'yes','',       'erj_ge.pdf');
INSERT INTO tb_1xx VALUES (102,1,0,4,    'active','0R',       NULL,  'yes','',       'erj_ge.pdf');
INSERT INTO tb_1xx VALUES (103,1,0,5,    'active','0R',       NULL,  'yes','',       'erj_ge.pdf');
INSERT INTO tb_1xx VALUES (104,1,0,6,    'active','0R',       NULL,  'yes','',       'erj_ge.pdf');

INSERT INTO tb_1xx VALUES (100,2,0,2,    'active','1K',       '5%',  'yes','1/16W',  'erj_ge.pdf');
INSERT INTO tb_1xx VALUES (101,2,0,3,    'active','1K',       '5%',  'yes','1/16W',  'erj_ge.pdf');
INSERT INTO tb_1xx VALUES (102,2,0,4,    'active','1K',       '5%',  'yes','1/16W',  'erj_ge.pdf');
INSERT INTO tb_1xx VALUES (103,2,0,5,    'active','1K',       '5%',  'yes','1/16W',  'erj_ge.pdf');
INSERT INTO tb_1xx VALUES (104,2,0,6,    'active','1K',       '5%',  'yes','1/16W',  'erj_ge.pdf');

INSERT INTO tb_2xx VALUES (200,1,0,7,    'active','1.0uF',   '25V',  'yes','5%',     'f3102.pdf');
INSERT INTO tb_2xx VALUES (201,1,0,8,    'active','1.0uF',   '25V',  'yes','',       'f3102.pdf');
INSERT INTO tb_2xx VALUES (202,1,0,9,    'active','1.0uF',   '25V',  'yes','',       'f3102.pdf');
INSERT INTO tb_2xx VALUES (203,1,0,11,   'active','1.0uF',   '25V',  'yes','',       'f3102.pdf');

INSERT INTO tb_5xx VALUES (500,1,0,12,   'active','value',  'param','yes','desc',   'datasheet_link');



-- -----------------------------------------------------
-- Table tb_source
-- -----------------------------------------------------

INSERT INTO tb_source VALUE(NULL,'100-00001-00',1,'',0,0,'US$',NULL,'tbd');
INSERT INTO tb_source VALUE(NULL,'101-00001-00',2,'test_only_123',1,0.99,'US$',NULL,'preferred');
INSERT INTO tb_source VALUE(NULL,'101-00001-00',3,'test-111111-00',0.12,0.012,'US$',NULL,'approved');
INSERT INTO tb_source VALUE(NULL,'101-00001-00',3,'test-xxxxxx-xx',0.1,0.01,'US$',NULL,'tbd');
INSERT INTO tb_source VALUE(NULL,'101-00002-00',1,'TBD         ',0,0,'US$',NULL,'tbd');
INSERT INTO tb_source VALUE(NULL,'102-00001-00',1,'test-222222-00',0,0,'',NULL,'not4new');
INSERT INTO tb_source VALUE(NULL,'200-00001-00',1,'TBD         ',0,0,'',NULL,'tbd');
INSERT INTO tb_source VALUE(NULL,'201-00001-00',1,'TBD         ',0,0,'',NULL,'tbd');
INSERT INTO tb_source VALUE(NULL,'202-00001-00',1,'TBD         ',0,0,'',NULL,'tbd');
INSERT INTO tb_source VALUE(NULL,'203-00001-00',1,'TBD         ',0,0,'',NULL,'tbd');
INSERT INTO tb_source VALUE(NULL,'500-00001-00',1,'test-333333-00',0,0,'',NULL,'obsolete');



-- Show debug info
-- SELECT * FROM tb_0xx;
-- SELECT * FROM tb_1xx;
-- SELECT * FROM tb_2xx;
-- SELECT * FROM tb_5xx;
-- SELECT * FROM tb_6pp;
-- SELECT * FROM tb_group;
-- SELECT * FROM tb_avl;
-- SELECT * FROM tb_ecad;
-- SELECT * FROM orcad;
-- SELECT * FROM pnall;

/*
-- FIXME: tried to have an integrated solution where table name is a parameter but failed so far!

-- -----------------------------------------------------
-- Procedure build_orcad V1
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE test()
BEGIN
DECLARE tname VARCHAR(25);
SET @tname='tb_pn1xx';

SET @dyn_sql=CONCAT('
    SELECT
        CONCAT(',@tname,'.grp,\'-\',',@tname,'.pn,\'-\',',@tname,'.rev) AS PartNumber,
        tb_group.type AS PartType,
        tb_ecad.status AS Status,
        ',@tname,'.value AS Value,
        ',@tname,'.param AS Param,
        tb_ecad.symbol AS SCHSymbol,
        tb_ecad.footprint AS PCBFootprint,
        IF(tb_ecad.3d_model IS NULL,\'\',tb_ecad.3d_model) AS 3DModel,
        UCASE(Concat(
            IF(tb_group.type IS NULL,\'\',tb_group.type),
            IF(',@tname,'.value  IS NULL,\'\',CONCAT(\',\',',@tname,'.value)),
            IF(',@tname,'.param  IS NULL,\'\',CONCAT(\',\',',@tname,'.param)),
            IF(',@tname,'.descrip IS NULL,\'\',CONCAT(\',\',',@tname,'.descrip)))) AS Description,
        ',@tname,'.datasheet AS Datasheet,
        GROUP_CONCAT(
            tb_avl.name,
            "\\t",tb_source.partnum,
            "\\t",tb_source.status,
            IF(tb_source.cost_1k > 0,
                CONCAT("\\t",tb_source.currency,"\\t",tb_source.cost_1k),\'\')
            ORDER BY tb_source.status ASC
            SEPARATOR "\\n\\t\\t\\t\\t\\t") AS Source
   FROM ',@tname,',tb_group,tb_ecad,tb_avl,tb_source
   WHERE 
        Concat(',@tname,'.grp,\'-\',',@tname,'.pn,\'-\',',@tname,'.rev) = tb_source.id_pn AND
        ',@tname,'.id_ecad = tb_ecad.id AND 
        ',@tname,'.grp = tb_group.id AND
        tb_avl.id = tb_source.id_avl
   GROUP BY PartNumber
    ') ;
PREPARE s1 FROM @dyn_sql ;
EXECUTE s1 ;
DEALLOCATE PREPARE s1 ;
END ;
//
DELIMITER ;

-- -----------------------------------------------------
-- Procedure build_orcad V2
-- -----------------------------------------------------
DELIMITER //
CREATE PROCEDURE test2(IN tname VARCHAR(25))
BEGIN
SET @dyn_sql2=CONCAT('
    SELECT
        CONCAT(',tname,'.grp,\'-\',',tname,'.pn,\'-\',',tname,'.rev) AS PartNumber,
        tb_group.type AS PartType,
        tb_ecad.status AS Status,
        ',tname,'.value AS Value,
        ',tname,'.param AS Param,
        tb_ecad.symbol AS SCHSymbol,
        tb_ecad.footprint AS PCBFootprint,
        IF(tb_ecad.3d_model IS NULL,\'\',tb_ecad.3d_model) AS 3DModel,
        UCASE(Concat(
            IF(tb_group.type IS NULL,\'\',tb_group.type),
            IF(',tname,'.value  IS NULL,\'\',CONCAT(\',\',',tname,'.value)),
            IF(',tname,'.param  IS NULL,\'\',CONCAT(\',\',',tname,'.param)),
            IF(',tname,'.descrip IS NULL,\'\',CONCAT(\',\',',tname,'.descrip)))) AS Description,
        ',tname,'.datasheet AS Datasheet,
        GROUP_CONCAT(
            tb_avl.name,
            "\\t",tb_source.partnum,
            "\\t",tb_source.status,
            IF(tb_source.cost_1k > 0,
                CONCAT("\\t",tb_source.currency,"\\t",tb_source.cost_1k),\'\')
            ORDER BY tb_source.status ASC
            SEPARATOR "\\n\\t\\t\\t\\t\\t") AS Source
   FROM ',tname,',tb_group,tb_ecad,tb_avl,tb_source
   WHERE 
        Concat(',tname,'.grp,\'-\',',tname,'.pn,\'-\',',tname,'.rev) = tb_source.id_pn AND
        ',tname,'.id_ecad = tb_ecad.id AND 
        ',tname,'.grp = tb_group.id AND
        tb_avl.id = tb_source.id_avl
   GROUP BY PartNumber
    ') ;
PREPARE s2 FROM @dyn_sql2 ;
EXECUTE s2 ;
DEALLOCATE PREPARE s2 ;
END ;
//
DELIMITER ;

/*
-- -----------------------------------------------------
-- Function f_orcad
-- -----------------------------------------------------
DELIMITER //
CREATE FUNCTION test3(tname VARCHAR(25))
RETURNS INT
BEGIN
    SELECT
        CONCAT(tname.grp,'-',tname.pn,'-',tname.rev) AS PartNumber,
        tb_group.type AS PartType,
        tb_ecad.status AS Status,
        tname.value AS Value,
        tname.param AS Param,
        tb_ecad.symbol AS SCHSymbol,
        tb_ecad.footprint AS PCBFootprint,
        IF(tb_ecad.3d_model IS NULL,'',tb_ecad.3d_model) AS 3DModel,
        UCASE(Concat(
            IF(tb_group.type IS NULL,'',tb_group.type),
            IF(tname.value  IS NULL,'',CONCAT(',',tname.value)),
            IF(tname.param  IS NULL,'',CONCAT(',',tname.param)),
            IF(tname.descrip IS NULL,'',CONCAT(',',tname.descrip)))) AS Description,
        tname.datasheet AS Datasheet,
        GROUP_CONCAT(
            tb_avl.name,
            "\\t",tb_source.partnum,
            "\\t",tb_source.status,
            IF(tb_source.cost_1k > 0,
                CONCAT("\\t",tb_source.currency,"\\t",tb_source.cost_1k),'')
            ORDER BY tb_source.status ASC
            SEPARATOR "\\n\\t\\t\\t\\t\\t") AS Source
   FROM tname,tb_group,tb_ecad,tb_avl,tb_source
   WHERE 
        Concat(tname.grp,'-',tname.pn,'-',tname.rev) = tb_source.id_pn AND
        tname.id_ecad = tb_ecad.id AND 
        tname.grp = tb_group.id AND
        tb_avl.id = tb_source.id_avl
   GROUP BY PartNumber;
RETURN 0;
END ;
//
DELIMITER ;
*/
