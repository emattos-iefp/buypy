/*
       Script SQL de criação do banco-de-dados do Projeto BuyPy.
Está configurado conforme a lógica de eliminar somente inteirativamente.
Durante a fase de desenvolvimento e de preparação, o banco-de-dados será
reconstruído várias vezes até alcançar o nível de produção.   O ciclo de
desenvolvimento será:  testar o esquema no MySQL,  melhorar este script,
excluir interativamente o esquema,  executar este script novamente e ve-
rificar o resultado no MySQL até a perfeita adequação ao projeto.
*/

CREATE DATABASE IF NOT EXISTS `buypy` ;

USE `buypy`;

--
-- Table structure for table `author`
--
CREATE TABLE IF NOT EXISTS `author`(
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL COMMENT 'Author''s literary/pseudo name, for which he is known',
  `fullname` varchar(100) DEFAULT NULL COMMENT 'Author''s real full name',
  `birthdate` date DEFAULT NULL,
  PRIMARY KEY (`id`)
);

--
-- Table structure for table `product`
--

CREATE TABLE IF NOT EXISTS `product`(
  `id` char(10) NOT NULL,
  `quantity` int unsigned NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `vat` double NOT NULL,
  `score` smallint DEFAULT NULL,
  `product_image` varchar(100) DEFAULT NULL,
  `reason` varchar(500) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `product_chk_1` CHECK ((`price` >= 0)),
  CONSTRAINT `product_chk_2` CHECK (((`vat` >= 0) and (`vat` <= 100))),
  CONSTRAINT `product_chk_3` CHECK ((`score` in (1,2,3,4,5)))
);

--
-- Table structure for table `book`
--

CREATE TABLE IF NOT EXISTS `book`(
  `product_id` char(10) NOT NULL,
  `isbn13` char(20) NOT NULL,
  `title` varchar(50) NOT NULL,
  `genre` varchar(50) NOT NULL,
  `publisher` varchar(100) NOT NULL,
  `publication_date` date NOT NULL,
  UNIQUE KEY `product_id_UNIQUE` (`product_id`),
  UNIQUE KEY `isbn13_UNIQUE` (`isbn13`),
  CONSTRAINT `FK_book_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `book_chk_1` CHECK (regexp_like(`isbn13`,_utf8mb4'[A-Z0-9]{13}'))
);

--
-- Table structure for table `bookauthor`
--

CREATE TABLE IF NOT EXISTS `bookauthor`(
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` char(10) NOT NULL,
  `author_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_bookauthor_book_idx` (`product_id`),
  KEY `FK_bookauthor_author_idx` (`author_id`),
  CONSTRAINT `FK_bookauthor_author` FOREIGN KEY (`author_id`) REFERENCES `author` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_bookauthor_book` FOREIGN KEY (`product_id`) REFERENCES `book` (`product_id`) ON DELETE CASCADE ON UPDATE CASCADE
);

--
-- Table structure for table `client`
--

CREATE TABLE IF NOT EXISTS `client`(
  `id` int NOT NULL AUTO_INCREMENT,
  `firstname` varchar(250) NOT NULL,
  `surname` varchar(250) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(64) NOT NULL,
  `address` varchar(100) NOT NULL,
  `zip_code` int NOT NULL,
  `city` varchar(30) NOT NULL,
  `country` varchar(30) NOT NULL DEFAULT 'Portugal',
  `phone_number` varchar(15) DEFAULT NULL,
  `last_login` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `birthdate` date NOT NULL,
  `is_active` bit(1) DEFAULT True,
  PRIMARY KEY (`id`),
--  CONSTRAINT `client_chk_1` CHECK (regexp_like(`email`,_utf8mb4'(?:[a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*|"(?:[x01-x08x0bx0cx0e-x1fx21x23-x5bx5d-x7f]|\\[x01-x09x0bx0cx0e-x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[x01-x08x0bx0cx0e-x1fx21-x5ax53-x7f]|\\[x01-x09x0bx0cx0e-x7f])+)])')),
  CONSTRAINT `client_chk_1` CHECK (regexp_like(`email`, "^[a-zA-Z0-9][a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]*?[a-zA-Z0-9._-]?@[a-zA-Z0-9][a-zA-Z0-9._-]*?[a-zA-Z0-9]?\\.[a-zA-Z]{2,63}$")),
  CONSTRAINT `client_chk_2` CHECK (regexp_like(`phone_number`,_utf8mb4'[0-9-]{6,}'))
);

--
-- Table structure for table `electronic`
--

CREATE TABLE IF NOT EXISTS `electronic`(
  `product_id` char(10) NOT NULL,
  `serial_num` bigint NOT NULL,
  `brand` varchar(20) NOT NULL,
  `model` varchar(40) NOT NULL,
  `spec_tec` longtext,
  `type` varchar(20) NOT NULL,
  UNIQUE KEY `product_id_UNIQUE` (`product_id`),
  UNIQUE KEY `serial_num_UNIQUE` (`serial_num`),
  CONSTRAINT `FK_electronic_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
);


--
-- Table structure for table `order`
--

CREATE TABLE IF NOT EXISTS `order`(
  `id` int NOT NULL AUTO_INCREMENT,
  `date_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `delivery_method` varchar(10) DEFAULT 'regular',
  `status` varchar(10) DEFAULT 'open',
  `payment_card_number` bigint NOT NULL,
  `payment_card_name` varchar(20) NOT NULL,
  `payment_card_expiration` date NOT NULL,
  `client_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_order_client_idx` (`client_id`),
  CONSTRAINT `FK_order_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `order_chk_1` CHECK ((`delivery_method` in (_utf8mb4'regular',_utf8mb4'urgent'))),
  CONSTRAINT `order_chk_2` CHECK ((`status` in (_utf8mb4'open',_utf8mb4'processing',_utf8mb4'pending',_utf8mb4'closed',_utf8mb4'cancelled')))
);

--
-- Table structure for table `ordered_item`
--

CREATE TABLE IF NOT EXISTS `ordered_item`(
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` char(10) NOT NULL,
  `quantity` varchar(45) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `vat_amount` decimal(10,2) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_ordered_item_order_idx` (`order_id`),
  KEY `FK_ordered_item_product_idx` (`product_id`),
  CONSTRAINT `FK_ordered_item_order` FOREIGN KEY (`order_id`) REFERENCES `order` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_ordered_item_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `ordered_item_chk_1` CHECK ((`quantity` >= 0)),
  CONSTRAINT `ordered_item_chk_2` CHECK ((`price` >= 0)),
  CONSTRAINT `ordered_item_chk_3` CHECK ((`vat_amount` >= 0))
);

--
-- Table structure for table `recommendation`
--

CREATE TABLE IF NOT EXISTS `recommendation`(
  `id` int NOT NULL AUTO_INCREMENT,
  `reason` varchar(500) DEFAULT NULL,
  `start_date` date DEFAULT NULL,
  `client_id` int DEFAULT NULL,
  `product_id` char(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_recommendation_client_idx` (`client_id`),
  KEY `FK_recommendation_product_idx` (`product_id`),
  CONSTRAINT `FK_recommendation_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_recommendation_product` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`)
);

--
-- Table structure for table `operator`
--

CREATE TABLE IF NOT EXISTS `operator`(
  `id` int NOT NULL AUTO_INCREMENT,
  `firstname` varchar(250) NOT NULL,
  `surname` varchar(250) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` char(64) NOT NULL,
  PRIMARY KEY (`id`),
--  CONSTRAINT `operator_chk_1` CHECK (regexp_like(`email`,_utf8mb4'(?:[a-z0-9!#$%&\'*+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&\'*+/=?^_`{|}~-]+)*|"(?:[x01-x08x0bx0cx0e-x1fx21x23-x5bx5d-x7f]|\\[x01-x09x0bx0cx0e-x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?).){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[x01-x08x0bx0cx0e-x1fx21-x5ax53-x7f]|\\[x01-x09x0bx0cx0e-x7f])+)])'))
--  CONSTRAINT `operator_chk_1` CHECK (regexp_like(`email`, "[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?"
  CONSTRAINT `operator_chk_1` CHECK (regexp_like(`email`, "^[a-zA-Z0-9][a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]*?[a-zA-Z0-9._-]?@[a-zA-Z0-9][a-zA-Z0-9._-]*?[a-zA-Z0-9]?\\.[a-zA-Z]{2,63}$"))
);

-- STORED PROCEDURES AND TRIGGERS

DELIMITER //

-- SET FOREIGN_KEY_CHECKS = 0 //

/*
 * See https://en.wikipedia.org/wiki/ISBN#ISBN-13_check_digit_calculation
 */
CREATE FUNCTION IF NOT EXISTS ValidISBN13(isbn13 VARCHAR(20))
RETURNS BOOL
DETERMINISTIC
BEGIN
    DECLARE i TINYINT UNSIGNED DEFAULT 1;
    DECLARE s SMALLINT UNSIGNED DEFAULT 0;

    SET isbn13 = REPLACE(isbn13, '-', '');
    -- SET isbn13 = REPLACE(isbn13, ' ', '');
    -- SET isbn13 = REPLACE(isbn13, '_', '');

    IF isbn13 NOT RLIKE '^[0-9]{13}$' THEN
        RETURN FALSE;
    END IF;

    WHILE i < 14 DO
        SET s = s + SUBSTRING(isbn13, i, 1) * IF(i % 2 = 1, 1, 3);
        SET i = i + 1;
    END WHILE;

    RETURN s % 10 = 0;
END//

CREATE PROCEDURE IF NOT EXISTS AuthenticateOperator(
    IN operator_email       VARCHAR(50),
    IN operator_passwd      CHAR(64)
)
BEGIN
    SELECT *
    FROM `operator`
    WHERE email = operator_email
    AND  `password` = operator_passwd;
END//

CREATE PROCEDURE IF NOT EXISTS `BlockUser`(
    IN user_id       INT
)
BEGIN
    UPDATE `client`
        SET `is_active` = 0
        WHERE `id` = user_id;
END//

CREATE PROCEDURE IF NOT EXISTS `UnblockUser`(
    IN user_id       INT
)
BEGIN
    UPDATE `client`
        SET `is_active` = 1
        WHERE `id` = user_id;
END//

CREATE PROCEDURE IF NOT EXISTS `SearchUserBlocked`()
BEGIN
    SELECT *
        FROM `client`
        WHERE NOT `is_active`;
END//

CREATE PROCEDURE IF NOT EXISTS `ListBooks`()
BEGIN
    SELECT 'Livro' AS category, quantity, price, title
        FROM `product`
        INNER JOIN `book` ON `product`.`id` = `book`.`product_id`;
END//

CREATE PROCEDURE IF NOT EXISTS `ListElectronics`()
BEGIN
    SELECT 'Consumível' AS category, quantity, price, brand, model
        FROM `product`
        INNER JOIN `electronic` ON `product`.`id` = `electronic`.`product_id`;
END//

CREATE PROCEDURE IF NOT EXISTS `SearchUserByID`(
    IN user_id       INT
)
BEGIN
    SELECT *
        FROM `client`
        WHERE `id` = user_id;
END//

CREATE PROCEDURE IF NOT EXISTS `SearchUserByName`(
    IN user_firstname       VARCHAR(250),
    IN user_surname       VARCHAR(250)
)
BEGIN
    SELECT *
        FROM `client`
                WHERE UPPER(`firstname`) LIKE CASE
                                                  WHEN `user_firstname` = '' THEN '%'
                                                  WHEN `user_firstname` IS NULL THEN '%'
                                                  ELSE `user_firstname`
                                              END
                    AND UPPER(`surname`) LIKE CASE
                                                  WHEN `user_surname` = '' THEN '%'
                                                  WHEN `user_surname` IS NULL THEN '%'
                                                  ELSE `user_surname`
                                              END;
END//

CREATE PROCEDURE IF NOT EXISTS `ListPrice`(
    IN minimal       INT,
    IN maximal       INT
)
BEGIN
    SELECT 'Consumível' AS category, quantity, price, brand, model
        FROM `product`
            INNER JOIN `electronic` ON `product`.`id` = `electronic`.`product_id`
        WHERE price >= minimal AND price <= maximal
    UNION
    SELECT 'Livro' AS category, quantity, price, name as brand, title as model
        FROM `product`
            INNER JOIN `book` ON `product`.`id` = `book`.`product_id`
            INNER JOIN `bookauthor` ON `product`.`id` = `bookauthor`.`product_id`
            INNER JOIN `author` ON `bookauthor`.`author_id` = `author`.`id`
        WHERE price >= minimal AND price <= maximal
        ORDER BY 1, 5;
END//

CREATE PROCEDURE IF NOT EXISTS `ListQuantity`(
    IN minimal       INT,
    IN maximal       INT
)
BEGIN
    SELECT 'Consumível' AS category, quantity, price, brand, model
        FROM `product`
            INNER JOIN `electronic` ON `product`.`id` = `electronic`.`product_id`
        WHERE quantity >= minimal AND quantity <= maximal
    UNION
    SELECT 'Livro' AS category, quantity, price, name as brand, title as model
        FROM `product`
            INNER JOIN `book` ON `product`.`id` = `book`.`product_id`
            INNER JOIN `bookauthor` ON `product`.`id` = `bookauthor`.`product_id`
            INNER JOIN `author` ON `bookauthor`.`author_id` = `author`.`id`
        WHERE quantity >= minimal AND quantity <= maximal
        ORDER BY 1, 5;
END//

CREATE PROCEDURE IF NOT EXISTS `ProductByType`(
    IN tipo_prod       VARCHAR(20)
)
BEGIN
        SELECT `product`.`id`, price, score, `recommendation`.`reason`, is_active, product_image,
                        CASE LEFT(`product`.`id`, 1)
                            WHEN 'B' THEN 'Livro'
                            WHEN 'E' THEN 'Consumível'
                        END AS Tipo
                FROM `product`
                    LEFT JOIN `recommendation` ON `product`.`id` = `recommendation`.`product_id`
                HAVING Tipo LIKE CASE
                                  WHEN tipo_prod IS NULL THEN '%'
                                  ELSE tipo_prod
                              END;
END//

CREATE PROCEDURE IF NOT EXISTS `DailyOrders`(
    IN data_pesquisa       VARCHAR(10)
)
BEGIN
        SELECT *
            FROM `order`
            WHERE date( date_time ) = date( data_pesquisa );
END//

CREATE PROCEDURE IF NOT EXISTS `AnnualOrders`(
    IN user_id         INT,
    IN order_ano       VARCHAR(4)
)
BEGIN
        SELECT *
            FROM `order`
            WHERE client_id = user_id
                AND year( date_time ) = order_ano;
END//

CREATE PROCEDURE IF NOT EXISTS `CreateOrder`(
    IN user_id         INT,
    IN deliv_method    VARCHAR(10),
    IN card_number     BIGINT,
    IN card_name       VARCHAR(20),
    IN card_expire     DATE
)
BEGIN
        INSERT INTO `order` ( `delivery_method`, `payment_card_number`, `payment_card_name`, `payment_card_expiration`, `client_id` ) VALUES
        ( user_id, deliv_method, card_number, card_name, card_expire, user_id );
END//

CREATE PROCEDURE IF NOT EXISTS `GetOrderTotal`(
    IN search_order_id         INT
)
BEGIN
	SELECT SUM(price)
            FROM `ordered_item`
            WHERE `ordered_item`.`order_id` = search_order_id;
END//

CREATE PROCEDURE IF NOT EXISTS `AddProductToOrder`(
    IN order_id        INT,
    IN prod_id         INT,
    IN quantidade      INT
)
BEGIN
        INSERT INTO `ordered_item` ( `order_id`, `product_id`, `quantity`, `price`, `vat` )
            SELECT order_id, prod_id, quantidade, quantidade * `product`.`price` AS price, quantidade * `product`.`price` * `product`.`vat` / 100 AS vat
                FROM `product`
                WHERE `product`.`id` = product_id;
END//

CREATE PROCEDURE IF NOT EXISTS `AddBook`(
    IN prod_id                  char(10),
    IN book_isbn13              char(20),
    IN book_title               varchar(50),
    IN book_genre               varchar(50),
    IN book_publisher           varchar(100),
    IN book_publication_date    date,
    IN book_author_id           INT,
    IN book_quantidade          INT,
    IN book_price               INT,
    IN book_vat                 INT
)
BEGIN
        INSERT INTO `product` ( `id`, `quantity`, `price`, `vat` ) VALUES
        ( prod_id, book_quantidade, book_price, book_vat );
        INSERT INTO `book` ( `product_id`, `isbn13`, `title`, `genre`, `publisher`, `publication_date` ) VALUES
        ( prod_id, book_isbn13, book_title, book_genre, book_publisher, book_publication_date );
        INSERT INTO `bookauthor` ( `product_id`, `author_id` ) VALUES
        ( prod_id, book_author_id );
END//

    -- Exemplos de CONSTRAINTs para a password mas que não podem aqui ficar por causa
    -- do hashing da pwd que é feito no trigger

    -- CONSTRAINT PasswdCHK CHECK(`password` RLIKE '(?=.*[a-z])(?=.*[a-z])(?=.*[0-9])(?=.*[!$#?%]).{6,50}')

    -- CONSTRAINT PasswdCHK CHECK(
    --         CHAR_LENGTH(`password`) BETWEEN 6 AND 50
    --     AND `password` RLIKE '[a-z]'
    --     AND `password` RLIKE '[A-Z]'
    --     AND `password` RLIKE '[0-9]'
    --     AND `password` RLIKE '[!$#?%]'
    -- )
CREATE PROCEDURE IF NOT EXISTS ValidateClient(
    IN phone_number     VARCHAR(15),
    IN country          VARCHAR(30),
    INOUT `password`    CHAR(64)
)
BEGIN
    DECLARE INVALID_PASSWORD CONDITION FOR SQLSTATE '45001';
    
    IF `password` NOT RLIKE '(?=.*[a-z])(?=.*[a-z])(?=.*[0-9])(?=.*[!$#?%]).{6,50}' THEN
        SIGNAL INVALID_PASSWORD SET MESSAGE_TEXT = 'Invalid password';
    END IF;

    SET `password` := SHA2(`password`, 256);
END
//

/* Comentado para ser executado após a inserção dos dados gerados pelo
 * ChatGPT que não respeitou as regras das senhas.

DELIMITER //

CREATE TRIGGER IF NOT EXISTS BeforeNewClient BEFORE INSERT ON `client`
FOR EACH ROW
BEGIN
    CALL ValidateClient(NEW.phone_number, NEW.country, NEW.password);
END//


CREATE TRIGGER IF NOT EXISTS BeforeUpdatingClient BEFORE UPDATE ON `client`
FOR EACH ROW
BEGIN
    CALL ValidateClient(NEW.phone_number, NEW.country, NEW.password);
END//

DELIMITER ;
*/

DELIMITER ;

-- SET FOREIGN_KEY_CHECKS = 1;
