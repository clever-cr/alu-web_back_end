-- Title: Time Together
SELECT
    band_name,
    CASE
        WHEN split IS NULL THEN 2020 - COALESCE(formed, YEAR(curdate()))
        ELSE COALESCE(split, YEAR(curdate())) - COALESCE(formed, YEAR(curdate()))
    END AS lifespan
FROM metal_bands
WHERE style LIKE '%Glam rock%'
ORDER BY lifespan DESC;