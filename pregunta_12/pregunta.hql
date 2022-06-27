DROP TABLE IF EXISTS t0;

CREATE TABLE t0 (
    c1 STRING,
    c2 ARRAY<CHAR(1)>, 
    c3 MAP<STRING, INT>
    )
    ROW FORMAT DELIMITED 
        FIELDS TERMINATED BY '\t'
        COLLECTION ITEMS TERMINATED BY ','
        MAP KEYS TERMINATED BY '#'
        LINES TERMINATED BY '\n';
LOAD DATA LOCAL INPATH 'data.tsv' INTO TABLE t0;

INSERT OVERWRITE DIRECTORY 'output'
ROW FORMAT DELIMITED FIELDS TERMINATED BY ','
SELECT letra, clave, COUNT(*) AS conteo
FROM t0 LATERAL VIEW EXPLODE(c2) c2_exploded AS letra
        LATERAL VIEW EXPLODE(c3) c3_exploded AS clave,valor     
GROUP BY letra, clave;
