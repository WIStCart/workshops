---
layout: default
title: Exercise 1
nav_order: 1
description: "Exercise 1: Create Tree Map Manually"
parent: Creative Workflows Using QGIS and SQL
---

# Exercise 1: Create Tree Map Manually

## Download Data

Start out by downloading the [WIGLOSR database](https://uwmadison.box.com/shared/static/3iy9yt003vr99dshvkq1hqy79puz2amg.zip){: target="_blank"}. Unzip it and you will find a geopackage and the database documentation. For this walk through I will use QGIS version 3.28.15, but you can just as easily use ArcPro.

## Add Data

Let's start out by opening QGIS and adding data from our geopackage (gpkg) to our map. 

In the *Browser* pane, right click *GeoPackage* and select *New Connection*. Select the geopackage you downloaded and click *Open*.

We'll add the *townships*, *corner_obs*, and *witness_trees* datasets. 

![image](../images/add-data-browser.png) ![image](../images/add-data-layers.png){: .ml-8 .v-align-top}
{: style="width:fit-content" class="d-block mx-auto"}

## Zoom to Township

Choose the township you would like to make a witness tree map for; in my case I will select T23N R08E.

We can filter our layer to only show the township we are interested in by right-clicking on the layer in the *Layers* pane and selecting *Filter*. In the section labeled *Provider specific filter expression* enter `dtr=42308`.

![](../images/zoom-to-township-query-builder.png){: .d-block .mx-auto}

Click okay, then right-click on your layer and select *Zoom to Layer*.

## Township Buffer

In order to select the needed witness tree points, we need a slightly fuzzy search since many points lie right near the border of the township. We'll add a 100m buffer to assist in this.

We'll use a virtual layer to store this buffered township as it is ephemeral. Go to *Layer* > *Add Layer* > *Add/Edit Virtual Layer*.

We can change the *Layer name* to something like *42308_100m_buffer*, then click the *Import* button and select *townships*. For the *Query* we'll enter the query below. Note that we do not specify the township number because we already filtered the *townships* layer.

```sql
SELECT ST_Buffer(geometry, 100)
FROM townships
```

![](../images/township-buffer-virtual-layer.png){: .d-block .mx-auto}

Click *Add* then *Close*.

## Extract by Location

Open up the toolbox by selecting *Processing* in the top menu then *Toolbox*. In the *Processing Toolbox* search *Extract by location* and select the tool.

We will extract features from *witness_trees*, where the features *intersect*, by comparing to features from *42308_100m_buffer*. Keep the *Extracted (location)* blank. Click *Run* then *Close*.

![](../images/extract-by-location.png){: .d-block .mx-auto}

Rename the new layer, *Extracted (location)*, to something like *witness_trees_42308*.

## Witness Trees

Before we view the witness trees as polygons we'll need to add some additional fields, and for that we'll need to add another layer to the map that we can use in a join. Find the *observations* table in the geopackage and add it to the map as a layer.

### Vector Join
First let's join the *observations* table on *dtrsco*, adding only the *ptype* field with no *Custom field name prefix*. Right-click on the *witness_trees_42308* layer and select *Properties*, then select *Joins* from the left menu. Click the plus button near the bottom to add a join. Fill it out as mentioned before and as seen below and click *OK*.

![](../images/witness-trees-add-vector-join.png){: .d-block .mx-auto}

### Add Fields
Second, we'll add some additional fields that we'll use later as variables in the symbology. 

Select *Fields* from the left menu and click *Field Calculator* button at the top that looks like an abacus.

#### sp_class
1. Check the *Create virtual field* box
2. Use the following inputs:
    <dl>
      <dt>Output field name</dt><dd><i>sp_class</i></dd>
      <dt>Output field type</dt><dd>Text (string)</dd>
    </dl>
3. *Expression*:
  ```sql
CASE 
  WHEN sp IN ('OA','LO','RO','WO','BO','SO') THEN 'Oak'
  WHEN sp IN ('PI','RP','HP','WP','JP') THEN 'Pine'
  WHEN sp IN ('FI','SP','HE','WC','CE','TA') THEN 'Other Coniferous'
  WHEN sp IN ('BA','RE','SU','WB','BI','LI','WA','MA','AS','EL','BU','IR','AH','YB','AL','WM','HA','HI','BB') THEN 'Hardwood'
END
  ```
4. Click *OK*

![](../images/witness-trees-field-calculator-sp.png){: .d-block .mx-auto}

Use the field calculator to add a couple of more fields in a similar fashion:

#### diam_class
1. Check the *Create virtual field* box
2. Use the following inputs:
    <dl>
      <dt>Output field name</dt><dd><i>diam_class</i></dd>
      <dt>Output field type</dt><dd>Decimal (double)</dd>
    </dl>
3. *Expression*:
  ```sql
CASE 
  WHEN diam<=5              THEN 4.0
  WHEN diam> 5 AND diam<=10 THEN 7.5
  WHEN diam>10 AND diam<=15 THEN 11.0
  WHEN diam>15 AND diam<=20 THEN 14.5
  WHEN diam>20              THEN 18.0
END
  ```
4. Click *OK*

![](../images/witness-trees-field-calculator-diam.png){: .d-block .mx-auto}

#### display_az
1. Check the *Create virtual field* box
2. Use the following inputs:
    <dl>
      <dt>Output field name</dt><dd><i>display_az</i></dd>
      <dt>Output field type</dt><dd>Integer (32 bit)</dd>
      <dt>Output field length</dt><dd>10</dd>
    </dl>
3. *Expression*:
  ```sql
CASE
  WHEN az IS NULL THEN 45
  WHEN length(az)=1 THEN
    CASE
      WHEN az='N' THEN 45
      WHEN az='E' THEN 135
      WHEN az='S' THEN 225
      WHEN az='W' THEN 315
    END
  WHEN length(az)=2 THEN
    CASE
      WHEN az='NE' THEN 45
      WHEN az='SE' THEN 135
      WHEN az='SW' THEN 225
      WHEN az='NW' THEN 315
    END
  ELSE
    CASE
      WHEN substr(az, 1, 1)='N' THEN
        CASE
          WHEN substr(az, -1, 1)='W' THEN 315
          WHEN substr(az, -1, 1)='E' THEN 45
        END
      WHEN substr(az, 1, 1)='S' THEN
        CASE
          WHEN substr(az, -1, 1)='W' THEN 225
          WHEN substr(az, -1, 1)='E' THEN 135
        END
    END
END
  ```
4. Click *OK*

![](../images/witness-trees-field-calculator-az.png){: .d-block .mx-auto}

#### dtrsc
1. This time, do **not** check the *Create virtual field* box
2. Use the following inputs:
    <dl>
      <dt>Output field name</dt><dd><i>dtrsc</i></dd>
      <dt>Output field type</dt><dd>Whole number (integer - 64bit)</dd>
    </dl>

    {: .note }
    Depending on your QGIS version you may not see *integer - 64bit* unless you deselect virtual field. This will enter editing mode and add the field. You will need to save edits and exit editing mode after creating the field.

3. *Expression*:
  ```bash
  to_int(dtrsco/100)
  ```
4. Click *OK*

![](../images/witness-trees-field-calculator-dtrsc.png){: .d-block .mx-auto}

Click *OK* to close the properties.

### Join Fields
Now that we have the needed fields, we'll actually join *witness_trees_42308* to *corner_obs*.

Open the *Processing Toolbox* and search for and open *Join attributes by field value*:
1. Use the following inputs:
    <dl>
      <dt>Input layer</dt><dd>corner_obs</dd>
      <dt>Table field</dt><dd>dtrsc</dd>
      <dt>Input layer 2</dt><dd>witness_trees_42308</dd>
      <dt>Table field 2</dt><dd>dtrsc</dd>
      <dt>Join type</dt><dd>one-to-many</dd>
    </dl>
2. Check the box for *Discard records which could not be joined*
3. Click *Run in Background*, wait for it to run, then click *Close*.

![](../images/witness-trees-join-attributes-by-field-value.png){: .d-block .mx-auto}

Rename the newly created layer to something like *witness_trees_42308_cartographic*. Then add a filter by right-clicking on the layer and selecting *Filter*. For the *filter expression* use `"observations_ptype" = 'P'`.

![](../images/witness-trees-filter.png){: .d-block .mx-auto}

### Symbology
Next open the *Properties* for *witness_trees_42308_cartographic* and go to the *Symbology* tab:  
1. At the top change *Single Symbol* to *Categorized.*
2. For *Value* select *sp_class*.
3. Edit the *Symbol* by clicking on it.
  - Select *Simple marker* in the top box, then
  - under *Symbol layer type* select *Geometry generator*. 
  - With *Polygon* selected as the *Geometry type*, enter the following in the box.
    ```bash
    buffer(project($geometry, diam_class*sqrt(2)*10, radians(display_az)), diam_class*10)
    ```
  - Click *OK* to close.
  ![](../images/symbology-geometry-generator.png){: .d-block .mx-auto}
4. Click *Classify* and five categories should appear.
  - Select the null category and click the minus button to remove it. 
  - Right-click on the *Hardwood* record and select *Change Color*, then enter *#bebada* under *HTML notation*. 
  - Change the colors for *Oak*, *Other Coniferous*, and *Pine* to *#ffffb3*, *#8dd3c7*, and *#fb8072* respectively. Click *Apply* to save progress.
  ![](../images/symbology-classes.png){: .d-block .mx-auto}

### Labels
To add labels, go to the *Labels* tab in the left menu. Change *No labels* to *Rule-based labeling*. Use the plus button at the bottom to add the following rules:

#### NE
1. Use the following inputs:
    <dl>
      <dt>Description</dt><dd>NE</dd>
      <dt>Filter</dt><dd>display_az = 45</dd>
      <dt>Label with</dt><dd>sp</dd>
    </dl>
2. Select the *Text* section and change the *Size* to *6*
3. Select the *Placement* section on the left
  - Select *Offset from point*
  - Then for *Offset X,Y* click the button on the far right and select *Edit*.
  - For the expression enter the query from below.
    ```sql
    CASE 
      WHEN "diam_class" = 4    THEN '1.7,-1.7'
      WHEN "diam_class" = 7.5  THEN '2,-2'
      WHEN "diam_class" = 11.0 THEN '2.5,-2.5'
      WHEN "diam_class" = 14.5 THEN '3.4,-3.4'
      WHEN "diam_class" = 18.0 THEN '4.3,-4.3'
    END
    ```
  - Click *OK* to close *Expression String Builder*
4. Click *OK* to close *Edit Rule*

#### NW
1. Use the following inputs:
    <dl>
      <dt>Description</dt><dd>NW</dd>
      <dt>Filter</dt><dd>display_az = 315</dd>
      <dt>Label with</dt><dd>sp</dd>
    </dl>
2. Select the *Text* section and change the *Size* to *6*
3. Select the *Placement* section on the left
  - Select *Offset from point*
  - Then for *Offset X,Y* click the button on the far right and select *Edit*.
  - For the expression enter the query from below.
    ```sql
    CASE 
      WHEN "diam_class" = 4    THEN '-1.7,-1.7'
      WHEN "diam_class" = 7.5  THEN '-2,-2'
      WHEN "diam_class" = 11.0 THEN '-2.5,-2.5'
      WHEN "diam_class" = 14.5 THEN '-3.4,-3.4'
      WHEN "diam_class" = 18.0 THEN '-4.3,-4.3'
    END 
    ```
  - Click *OK* to close *Expression String Builder*
4. Click *OK* to close *Edit Rule*

#### SE
1. Use the following inputs:
    <dl>
      <dt>Description</dt><dd>SE</dd>
      <dt>Filter</dt><dd>display_az = 135</dd>
      <dt>Label with</dt><dd>sp</dd>
    </dl>
2. Select the *Text* section and change the *Size* to *6*
3. Select the *Placement* section on the left
  - Select *Offset from point*
  - Then for *Offset X,Y* click the button on the far right and select *Edit*.
  - For the expression enter the query from below.
    ```sql
    CASE
      WHEN "diam_class" = 4    THEN '1.7,1.7'
      WHEN "diam_class" = 7.5  THEN '2,2'
      WHEN "diam_class" = 11.0 THEN '2.5,2.5'
      WHEN "diam_class" = 14.5 THEN '3.4,3.4'
      WHEN "diam_class" = 18.0 THEN '4.3,4.3'
    END
    ```
  - Click *OK* to close *Expression String Builder*
4. Click *OK* to close *Edit Rule*

#### SW
1. Use the following inputs:
    <dl>
      <dt>Description</dt><dd>SW</dd>
      <dt>Filter</dt><dd>display_az = 225</dd>
      <dt>Label with</dt><dd>sp</dd>
    </dl>
2. Select the *Text* section and change the *Size* to *6*
3. Select the *Placement* section on the left
  - Select *Offset from point*
  - Then for *Offset X,Y* click the button on the far right and select *Edit*.
  - For the expression enter the query from below.
    ```sql
    CASE
      WHEN "diam_class" = 4    THEN '-1.7,1.7'
      WHEN "diam_class" = 7.5  THEN '-2,2'
      WHEN "diam_class" = 11.0 THEN '-2.5,2.5'
      WHEN "diam_class" = 14.5 THEN '-3.4,3.4'
      WHEN "diam_class" = 18.0 THEN '-4.3,4.3'
    END 
    ```
  - Click *OK* to close *Expression String Builder*
4. Click *OK* to close *Edit Rule*

![](../images/witness-trees-edit-rule.png){: .d-block .mx-auto}

Click *Apply* and then *OK* to close out of properties.

## Final Styling

1. Move the *townships* layer to just below *witness_trees_42308_cartographic* but above all the other visible layers. 
2. Open its properties and go to the symbology tab: 
  - Change *Single symbol* to *Inverted polygons*
  - Set *Fill Color* to white.
  - Click *OK*.
3. From the geopackage, add the *sections* layer below *townships* and change the symbology to *Fill style*: *No Brush*.
4. Add an appropriate base layer.

    {: .note-title}
    > Optional
    > 
    > This could be a georeferenced original plat map or a map service, etc. For this example I used *Quick Map Services* (this is a plugin you can add; if you do, go to settings > more services > get contributed pack) and chose *ESRI Gray (light)*.

Your map should now look like something like what is below. The labels look
messy, but should look better when we add the map to a print layout.

![](../images/final-styling.png){: .d-block .mx-auto}

## Print Layout

1. In the main menu click *Project* > *New Print Layout*. Click *OK*.
2. Right-click on page and select *Page Properties*. In the bottom right of the window under *Item Properties*:
  - Change *Size* to *Letter*
  - Change Orientation* to *Portrait*
3. Use the *Add new map* button on the left to add your map. 
  - Drag the edges of your map to meet the edges of the page on the left, right, and bottom. 
  - Leave room on the top making your map box square.
4. With your map selected, go to *Item Properties* and change the *Scale* to *55000*.
5. From there you can add a legend, title, scalebar etc. Adding a legend depicting diameter size classes will have to be done manually. I usually do it in Adobe Illustrator but there are many other options including free software such as [inkscape](https://inkscape.org/){: target="_blank"}. You can download [this legend template](https://uwmadison.box.com/s/sbevzznbde60fzdkme0j2j90kuoqlpr7) to give you a head start.

Check out [this complete tree map](https://www.sco.wisc.edu/wp-content/uploads/2021/11/Pine_Lake_PLS_Tree_Map_v4.pdf){: target="_blank"} for an example of a finished product.

![](../images/presettlement-witness-trees-pine-lake.png){: .d-block .mx-auto}

[Return to Workshop Page](../){: .btn}