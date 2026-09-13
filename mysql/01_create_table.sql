
-- 01_create_table.sql
-- Table definition for the beverage distribution dataset


CREATE TABLE beverage_distribution (
    row_id                  INT AUTO_INCREMENT PRIMARY KEY,
    txn_date                DATE            NOT NULL,
    week_number             SMALLINT        NOT NULL,
    sku_id                  VARCHAR(10)     NOT NULL,
    sku_name                VARCHAR(50)     NOT NULL,
    category                VARCHAR(30)     NOT NULL,
    warehouse_id            VARCHAR(10)     NOT NULL,
    warehouse_name          VARCHAR(50)     NOT NULL,
    unit_price              DECIMAL(10,2)   NOT NULL,
    lead_time_days          SMALLINT        NOT NULL,
    festival_flag           TINYINT(1)      NOT NULL,
    promo_flag              TINYINT(1)      NOT NULL,
    demand_units            INT             NOT NULL,
    available_stock_units   INT             NOT NULL,
    fulfilled_units         INT             NOT NULL,
    stockout_flag           TINYINT(1)      NOT NULL,

    INDEX idx_sku (sku_id),
    INDEX idx_warehouse (warehouse_id),
    INDEX idx_date (txn_date)
);


