<!DOCTYPE qgis PUBLIC 'http://mrcc.com/qgis.dtd' 'SYSTEM'>
<qgis simplifyAlgorithm="0" hasScaleBasedVisibilityFlag="0" simplifyDrawingTol="1" simplifyLocal="1" labelsEnabled="0" readOnly="0" simplifyMaxScale="1" minScale="1e+8" version="3.0.0-Girona" simplifyDrawingHints="1" maxScale="0">
  <renderer-v2 type="invertedPolygonRenderer" forceraster="0" enableorderby="0" preprocessing="0">
    <renderer-v2 type="singleSymbol" forceraster="0" enableorderby="0" symbollevels="0">
      <symbols>
        <symbol clip_to_extent="1" type="fill" name="0" alpha="1">
          <layer locked="0" pass="0" class="SimpleFill" enabled="1">
            <prop k="border_width_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="color" v="255,255,255,255"/>
            <prop k="joinstyle" v="bevel"/>
            <prop k="offset" v="0,0"/>
            <prop k="offset_map_unit_scale" v="3x:0,0,0,0,0,0"/>
            <prop k="offset_unit" v="MM"/>
            <prop k="outline_color" v="228,26,28,255"/>
            <prop k="outline_style" v="no"/>
            <prop k="outline_width" v="0.96"/>
            <prop k="outline_width_unit" v="MM"/>
            <prop k="style" v="solid"/>
            <effect type="effectStack" enabled="0">
              <effect type="dropShadow">
                <prop k="blend_mode" v="13"/>
                <prop k="blur_level" v="10"/>
                <prop k="color" v="0,0,0,255"/>
                <prop k="draw_mode" v="2"/>
                <prop k="enabled" v="0"/>
                <prop k="offset_angle" v="135"/>
                <prop k="offset_distance" v="2"/>
                <prop k="offset_unit" v="MM"/>
                <prop k="offset_unit_scale" v="3x:0,0,0,0,0,0"/>
                <prop k="opacity" v="1"/>
              </effect>
              <effect type="outerGlow">
                <prop k="blend_mode" v="0"/>
                <prop k="blur_level" v="3"/>
                <prop k="color1" v="0,0,255,255"/>
                <prop k="color2" v="0,255,0,255"/>
                <prop k="color_type" v="0"/>
                <prop k="discrete" v="0"/>
                <prop k="draw_mode" v="2"/>
                <prop k="enabled" v="0"/>
                <prop k="opacity" v="0.5"/>
                <prop k="rampType" v="gradient"/>
                <prop k="single_color" v="255,255,255,255"/>
                <prop k="spread" v="2"/>
                <prop k="spread_unit" v="MM"/>
                <prop k="spread_unit_scale" v="3x:0,0,0,0,0,0"/>
              </effect>
              <effect type="blur">
                <prop k="blend_mode" v="0"/>
                <prop k="blur_level" v="10"/>
                <prop k="blur_method" v="0"/>
                <prop k="draw_mode" v="2"/>
                <prop k="enabled" v="1"/>
                <prop k="opacity" v="1"/>
              </effect>
              <effect type="innerShadow">
                <prop k="blend_mode" v="13"/>
                <prop k="blur_level" v="10"/>
                <prop k="color" v="0,0,0,255"/>
                <prop k="draw_mode" v="2"/>
                <prop k="enabled" v="0"/>
                <prop k="offset_angle" v="135"/>
                <prop k="offset_distance" v="2"/>
                <prop k="offset_unit" v="MM"/>
                <prop k="offset_unit_scale" v="3x:0,0,0,0,0,0"/>
                <prop k="opacity" v="1"/>
              </effect>
              <effect type="innerGlow">
                <prop k="blend_mode" v="0"/>
                <prop k="blur_level" v="3"/>
                <prop k="color1" v="0,0,255,255"/>
                <prop k="color2" v="0,255,0,255"/>
                <prop k="color_type" v="0"/>
                <prop k="discrete" v="0"/>
                <prop k="draw_mode" v="2"/>
                <prop k="enabled" v="0"/>
                <prop k="opacity" v="0.5"/>
                <prop k="rampType" v="gradient"/>
                <prop k="single_color" v="255,255,255,255"/>
                <prop k="spread" v="2"/>
                <prop k="spread_unit" v="MM"/>
                <prop k="spread_unit_scale" v="3x:0,0,0,0,0,0"/>
              </effect>
            </effect>
            <data_defined_properties>
              <Option type="Map">
                <Option type="QString" name="name" value=""/>
                <Option name="properties"/>
                <Option type="QString" name="type" value="collection"/>
              </Option>
            </data_defined_properties>
          </layer>
        </symbol>
      </symbols>
      <rotation/>
      <sizescale/>
    </renderer-v2>
  </renderer-v2>
  <customproperties>
    <property value="0" key="embeddedWidgets/count"/>
    <property key="variableNames"/>
    <property key="variableValues"/>
  </customproperties>
  <blendMode>0</blendMode>
  <featureBlendMode>0</featureBlendMode>
  <layerOpacity>1</layerOpacity>
  <SingleCategoryDiagramRenderer diagramType="Histogram" attributeLegend="1">
    <DiagramCategory penColor="#000000" scaleDependency="Area" scaleBasedVisibility="0" barWidth="5" sizeType="MM" rotationOffset="270" opacity="1" diagramOrientation="Up" enabled="0" backgroundAlpha="255" penWidth="0" lineSizeType="MM" minScaleDenominator="0" sizeScale="3x:0,0,0,0,0,0" backgroundColor="#ffffff" lineSizeScale="3x:0,0,0,0,0,0" width="15" height="15" minimumSize="0" labelPlacementMethod="XHeight" maxScaleDenominator="1e+8" penAlpha="255">
      <fontProperties description="MS Shell Dlg 2,8.25,-1,5,50,0,0,0,0,0" style=""/>
      <attribute field="" color="#000000" label=""/>
    </DiagramCategory>
  </SingleCategoryDiagramRenderer>
  <DiagramLayerSettings dist="0" showAll="1" placement="0" priority="0" zIndex="0" linePlacementFlags="18" obstacle="0">
    <properties>
      <Option type="Map">
        <Option type="QString" name="name" value=""/>
        <Option name="properties"/>
        <Option type="QString" name="type" value="collection"/>
      </Option>
    </properties>
  </DiagramLayerSettings>
  <fieldConfiguration>
    <field name="id">
      <editWidget type="Range">
        <config>
          <Option/>
        </config>
      </editWidget>
    </field>
  </fieldConfiguration>
  <aliases>
    <alias field="id" name="" index="0"/>
  </aliases>
  <excludeAttributesWMS/>
  <excludeAttributesWFS/>
  <defaults>
    <default field="id" expression="" applyOnUpdate="0"/>
  </defaults>
  <constraints>
    <constraint field="id" unique_strength="1" constraints="3" notnull_strength="1" exp_strength="0"/>
  </constraints>
  <constraintExpressions>
    <constraint field="id" exp="" desc=""/>
  </constraintExpressions>
  <attributeactions>
    <defaultAction value="{00000000-0000-0000-0000-000000000000}" key="Canvas"/>
  </attributeactions>
  <attributetableconfig actionWidgetStyle="dropDown" sortOrder="0" sortExpression="">
    <columns>
      <column type="actions" width="-1" hidden="1"/>
      <column type="field" name="id" width="-1" hidden="0"/>
    </columns>
  </attributetableconfig>
  <editform>E:/Hayden_Elza/Requests/2018-07-02_Pine_Lake_Data_Request</editform>
  <editforminit/>
  <editforminitcodesource>0</editforminitcodesource>
  <editforminitfilepath></editforminitfilepath>
  <editforminitcode><![CDATA[# -*- coding: utf-8 -*-
"""
QGIS forms can have a Python function that is called when the form is
opened.

Use this function to add extra logic to your forms.

Enter the name of the function in the "Python Init function"
field.
An example follows:
"""
from qgis.PyQt.QtWidgets import QWidget

def my_form_open(dialog, layer, feature):
	geom = feature.geometry()
	control = dialog.findChild(QWidget, "MyLineEdit")
]]></editforminitcode>
  <featformsuppress>0</featformsuppress>
  <editorlayout>generatedlayout</editorlayout>
  <editable>
    <field editable="1" name="id"/>
    <field editable="1" name="params"/>
  </editable>
  <labelOnTop>
    <field labelOnTop="0" name="id"/>
    <field labelOnTop="0" name="params"/>
  </labelOnTop>
  <widgets/>
  <conditionalstyles>
    <rowstyles/>
    <fieldstyles/>
  </conditionalstyles>
  <expressionfields/>
  <previewExpression>params</previewExpression>
  <mapTip></mapTip>
  <layerGeometryType>2</layerGeometryType>
</qgis>
