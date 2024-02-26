---
layout: default
title: Exercise 2
nav_order: 2
description: "Exercise 1: Create Tree Map Using SQL and PostGIS"
parent: Creative Workflows Using QGIS and SQL
---

# Exercise 2: Create Tree Map Using SQL and PostGIS

Did I just have you go through all of exercise one when the smae thing can be done way easier if you just ditch the geopackage/geodatabase and instead use a PostGIS database? Yes, oops.

{: .note}
For this section I used QGIS 3.28.15, but things should be similar in other versions.

Let's add a new database connection, create a new layer using a single
query, then apply some saved styles.

## Add New Database Connection
1. In the top menu go to *Layer* > *Data Source Manager* > *PostgreSQL*
2. Under *Connection* click *New*
	- Use the following inputs:
		<dl>
			<dt>Name</dt><dd>WIGLOSR</dd>
			<dt>Host</dt><dd>rds-ue2-d-glo.cdrcfbhucsdp.us-east-2.rds.amazonaws.com</dd>
			<dt>Database</dt><dd>glo</dd>
		</dl>
	- Under *Authentication* click the *Basic* tab and use the following:
		<dl>
			<dt>User name</dt><dd>publicreadonly</dd>
			<dt>Password</dt><dd>publicreadonly</dd>
		</dl>
	- Select *Store* for both the username and password. 
	- Click *OK* to finish and add the connection
	- Click *OK* if it warns you about saving passwords
3. Click *Close* to exit the Data Source Manager window

You can now find your newly added database connection in the *Browser* pane under *PostGIS*.

![](../images/create-new-postgis-connection.png){: .d-block .mx-auto}

## Add Townships

Starting out with something simple and familiar:

1. Drag and drop the townships layer from the PostGIS connection
2. Right-click on the *townships* layer and select *Filter*.
	- For the expression enter `"dtr"=42308`
	- Click *OK*
3. Right-click on the *townships* layer and select *Zoom to layer*

## Add Witness Trees

Now for something new. You can add layers from the database by dragging and dropping, but let's
look at adding based on a query. 

1. In the top menu go to *Database* > *DB Manager*. 
2. Expand *PostGIS*, then expand your database. 
3. With your database selected, you can now click on the *SQL Window* button that looks like a page with a wrench on it (or go to *Database* > *SQL Window*). In the query section add the following:
	```sql
	WITH variables (scale) AS (
		values(10)
	),
	aoi AS (
		SELECT 0 AS id, ST_Union(geom) AS aoigeom
		FROM sections
		WHERE dir=4 AND twp=23 AND rng=8
	), trees AS (
		SELECT wt.*,o.ptype,lc.geog AS corner_geog,
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
						WHEN left(az, 1)='N' THEN
							CASE
								WHEN right(az, 1)='W' THEN 315
								WHEN right(az, 1)='E' THEN  45
							END
						WHEN left(az, 1)='S' THEN
							CASE
								WHEN right(az, 1)='W' THEN 225
								WHEN right(az, 1)='E' THEN 135
							END
					END
			END AS display_az
		FROM witness_trees AS wt
		JOIN aoi ON ST_Within(wt.geom,aoi.aoigeom)
		LEFT JOIN observations AS o ON o.dtrsco=wt.dtrsco
		LEFT JOIN landnet_corners AS lc ON wt.dtrsco/100=lc.dtrsc
		WHERE o.ptype='P'
	)
	SELECT *, ST_Buffer(ST_Project(corner_geog, diam_class*sqrt(2)*scale, radians(display_az)),diam_class*scale) AS display_geog
	FROM trees, variables
	```

	{: .note-title}
	> Optional
	>
	> - Change the breakpoints in the *diam_class* block if you would like. 
	> - If you change the values after the `THEN` in that block, it will change the size of the symbols relative to each other. 
	> - If you change the *scale* variable at the top, it will make all the symbols larger or smaller at a give scale.

4. Click *Execute* to run the query, you will see the results in a table
below after it completes.
5. Check *Load as new layer*
6. Check *Column(s) with unique values*
7. Select both *dtrsco* and *tree_id*
8. For *Geometry column* select *display_geog*. 
9. For *Layer name* enter something like *witness_trees_42308*
10. Click *Load* and once it completes you can close out of the DB Manager window.

You should now have something that looks like this:

![](../images/add-witness-trees.png)

## Add Styles

### Trees
1. Download [the trees.qml style](../assets/trees.qml)
2. Right-click on the *witness_trees_42308* layer and choose *Properties*
3. Go to *Symbology* in the left menu
4. At the bottom left there is a button *Style*, click it and choose *Load Style* > *Load from File*. Choose the file you downloaded in step one (trees.qml)
5. You should see that the style has been updated after loading from file. Click *OK*.

### AOI Mask
Apply [the aoi.qml style](../assets/aoi.qml) to the *townships* layer to create a mask if you would like. Add in a base layer and sections and you're good to go.

![](../images/styled-tree-map.png)

## Conclusion
This was much easier than exercise one, no? So why did we even do exercise one? Because not everyone is familiar with relational databases and SQL. But if you are willing to learn, a whole lot more is possible and often a whole lot easier.

[Return to Workshop Page](../){: .btn}