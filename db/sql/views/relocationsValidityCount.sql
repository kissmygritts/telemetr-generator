CREATE VIEW relocations_validity_count AS
SELECT
  validity_codes.code,
  validity_codes.description,
  count(validity_codes.code) AS n
FROM relocations
  INNER JOIN validity_codes ON relocations.validity_code = validity_codes.code
GROUP BY validity_codes.code
ORDER BY validity_codes.code;
