CREATE VIEW relocations_count AS
SELECT
  animals.perm_id,
  count(relocations.animal_id) AS relocations,
  count(relocations.geom) AS valid_relocations
FROM animals
  INNER JOIN relocations ON animals.id = relocations.animal_id
GROUP BY animals.perm_id
ORDER BY animals.perm_id;
