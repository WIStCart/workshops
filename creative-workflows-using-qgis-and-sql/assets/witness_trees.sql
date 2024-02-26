WITH variables (scale) AS (
    values(10)
),
aoi AS (
    SELECT 0 AS id, ST_Union(geom) AS aoigeom
    FROM sections
    WHERE dir=4 AND twp=23 AND rng=8
), 
trees AS (
    SELECT wt.*,o.ptype,co.geom AS corner_geom,
        CASE
            WHEN wt.sp IN ('LO','RO','WO','BO') THEN 'Oak'
            WHEN wt.sp IN ('PI','RP','HP','WP','JP') THEN 'Pine'
            WHEN wt.sp IN ('FI','SP','HE','WC','CE','TA') THEN 'Other Coniferous'
            WHEN wt.sp IN ('BA','RE','SU','WB','BI','LI','WA','MA','AS','EL','BU','IR','AH','YB') THEN 'Hardwood'
        END AS sp_class,
        CASE
            WHEN wt.diam<=5                 THEN  4.0
            WHEN wt.diam> 5 AND wt.diam<=10 THEN  7.5
            WHEN wt.diam>10 AND wt.diam<=15 THEN 11.0
            WHEN wt.diam>15 AND wt.diam<=20 THEN 14.5
            WHEN wt.diam>20                 THEN 18.0
        END AS diam_class,
        CASE
            WHEN az IS NULL THEN 45
            WHEN length(az)=1 THEN
                CASE
                    WHEN az='N' THEN  45
                    WHEN az='E' THEN 135
                    WHEN az='S' THEN 225
                    WHEN az='W' THEN 315
                END
            WHEN length(az)=2 THEN
                CASE
                    WHEN az='NE' THEN  45
                    WHEN az='SE' THEN 135
                    WHEN az='SW' THEN 225
                    WHEN az='NW' THEN 315
                END
            ELSE 
                CASE
                    WHEN substr(az, 1, 1)='N' THEN
                        CASE
                            WHEN substr(az, -1)='W' THEN 315
                            WHEN substr(az, -1)='E' THEN  45
                        END
                    WHEN substr(az, 1, 1)='S' THEN
                        CASE
                            WHEN substr(az, -1)='W' THEN 225
                            WHEN substr(az, -1)='E' THEN 135
                        END
                END
        END AS display_az
    FROM witness_trees AS wt
    JOIN aoi ON ST_Within(wt.geom,aoi.aoigeom)
    LEFT JOIN observations AS o ON o.dtrsco=wt.dtrsco
    LEFT JOIN corner_obs AS co ON wt.dtrsco/100=co.dtrsc
    WHERE o.ptype='P'
)
SELECT *, ST_Buffer(ST_Project(corner_geom, diam_class*sqrt(2)*scale, radians(display_az)),diam_class*scale) AS display_geom
FROM trees, variables
