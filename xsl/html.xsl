<?xml version="1.0"?>
<xsl:stylesheet 
    version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" indent="no" omit-xml-declaration="yes" />

    <!-- Normalize white space through document -->
    <!-- More info: http://stackoverflow.com/questions/5737862/xslt-output-formatting-removing-line-breaks-and-blank-output-lines-from-remove -->


    <xsl:template match="div[@class='page-metadata']"></xsl:template>
    <xsl:template match="div[@id='main-header']"></xsl:template>
    <xsl:template match="div[@id='main-content'][@class='pageSection']"></xsl:template>
    <xsl:template match="div[@class='pageSection group']"></xsl:template>
    <xsl:template match="div[@id='footer']"></xsl:template>
    <xsl:template match="div[@class='pageSectionHeader']"></xsl:template>
    <xsl:template match="div[@id='page']"><xsl:apply-templates /></xsl:template>
    <xsl:template match="div[@id='main'][@class='aui-page-panel']"><xsl:apply-templates /></xsl:template>
    <xsl:template match="div[@id='content'][@class='view']"><xsl:apply-templates /></xsl:template>
    <xsl:template match="meta"></xsl:template>
    <xsl:template match="META"></xsl:template>


    <!-- Character escaping -->
    <!--
    <xsl:template match=
        "contains('|code|',
        concat('|', name(), '|'))
        ">
        -->
    <!-- Open up document -->

    <xsl:template match="html"><xsl:apply-templates /></xsl:template>
    <xsl:template match="head"><xsl:apply-templates /></xsl:template>
    <xsl:template match="title">
        <xsl:text>&#10;---&#10;</xsl:text>
        <xsl:text>layout: manpage&#10;</xsl:text>
        <xsl:text>title: </xsl:text>
        <xsl:apply-templates />
        <xsl:text>&#10;</xsl:text>
        <xsl:text>---&#10;</xsl:text>
        </xsl:template>
    <xsl:template match="link"></xsl:template>
    <xsl:template match="body"><xsl:apply-templates /></xsl:template>


    <!-- Tables -->

    <xsl:template match="map"></xsl:template>

    <xsl:template match="div[@id='main-content'][@class='wiki-content group']">
        <xsl:apply-templates select="node()" />
    </xsl:template>
    <xsl:template match="div[@class='columnMacro' or @class='sectionMacro' or @class='sectionMacroRow' or @class='sectionColumnWrapper']">
        <xsl:apply-templates select="node()" />
    </xsl:template>


    <xsl:template match="pre[@class='latex']">
        <xsl:text>\[ </xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text> \]&#xa;</xsl:text>
    </xsl:template>
    <xsl:template match="pre[@class='latex']/p">
        <xsl:apply-templates select="node()" />
    </xsl:template>


    <xsl:template match="pre[@class='spin']/pre"><xsl:apply-templates select="node()" /></xsl:template>
    <xsl:template match="pre[@class='pasm']/pre"><xsl:apply-templates select="node()" /></xsl:template>

    <xsl:template match="pre[@class='spin']">
        <pre>
        <xsl:copy-of select="pre/text()" />
        </pre>
    </xsl:template>

    <xsl:template match="pre[@class='pasm']">
        <pre>
        <xsl:copy-of select="pre/text()" />
        </pre>
    </xsl:template>



    <xsl:template match="span">
        <xsl:apply-templates select="node()" />
    </xsl:template>





    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>


</xsl:stylesheet>