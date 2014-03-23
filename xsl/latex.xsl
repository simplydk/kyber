<?xml version="1.0"?>
<xsl:stylesheet 
    version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="xml" indent="no" omit-xml-declaration="yes" />

    <!-- Normalize white space through document -->
    <!-- More info: http://stackoverflow.com/questions/5737862/xslt-output-formatting-removing-line-breaks-and-blank-output-lines-from-remove -->

    <xsl:preserve-space elements="div"/>

    <xsl:template match="*/text()[normalize-space()]">
        <xsl:value-of select="normalize-space()"/>
    </xsl:template>

    <xsl:template match="*/text()[not(normalize-space())]" />



    <!-- Character escaping -->
    <!--
    <xsl:template match=
        "contains('|code|',
        concat('|', name(), '|'))
        ">
        -->
    <xsl:template match="a">
        <xsl:variable name="step1" select="replace(text(),'_','\\_')"/>
        <xsl:variable name="step2" select="replace($step1,'&amp;','\\&amp;')"/>
        <xsl:value-of select="replace($step2,'#','\\#')"/>
    </xsl:template>



    <!-- Open up document -->

    <xsl:template match="html"><xsl:apply-templates /></xsl:template>
    <xsl:template match="head"><xsl:apply-templates /></xsl:template>
    <xsl:template match="title"></xsl:template>
    <xsl:template match="body"><xsl:apply-templates /></xsl:template>


    <!-- Tables -->

    <xsl:template match="div[@class='table-wrap']"><xsl:apply-templates /></xsl:template>
    <!--<xsl:template match="table"><table><xsl:apply-templates /></table></xsl:template> -->
    <xsl:template match="table"></xsl:template>
    <xsl:template match="tr"><tr><xsl:apply-templates /></tr></xsl:template>
    <xsl:template match="th"><th><xsl:apply-templates /></th></xsl:template>

    <!--
    <xsl:template match="td"><xsl:apply-templates />
        <xsl:text disable-output-escaping="yes"><![CDATA[ & ]]></xsl:text>
    </xsl:template>
    -->

    <!-- Basic -->

    <xsl:template match="p">
        <xsl:apply-templates select="node()" />
        <xsl:text>&#10;&#10;</xsl:text>
    </xsl:template>
    <!--    <xsl:template match="a">
        <xsl:apply-templates select="node()" />
    </xsl:template>
    -->
    <xsl:template match="strong|b">
        <xsl:text> \textbf{</xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text>} </xsl:text>
    </xsl:template>
    <xsl:template match="em|i">
        <xsl:text> \textit{</xsl:text>
        <xsl:apply-templates />
        <xsl:text>} </xsl:text>
    </xsl:template>
    <xsl:template match="code">
        <xsl:text> \texttt{</xsl:text>
        <xsl:apply-templates />
        <xsl:text>} </xsl:text>
    </xsl:template>


    <!-- Gliffy Diagrams -->

    <xsl:template match="table[@class='gliffy-macro-table']/tr/td/table[@class='gliffy-macro-inner-table']/tr/td/img[@class='gliffy-macro-image']">
        <xsl:text>  \includegraphics[width = 3.5in]{</xsl:text>
        <xsl:value-of select="@src" />
        <xsl:text>}&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="table[@class='gliffy-macro-table']/tr/td/table[@class='gliffy-macro-inner-table']/caption"></xsl:template>

    <xsl:template match="table[@class='gliffy-macro-table']/tr/td/table[@class='gliffy-macro-inner-table']/tr/td"><xsl:apply-templates /></xsl:template>
    <xsl:template match="table[@class='gliffy-macro-table']/tr/td/table[@class='gliffy-macro-inner-table']/tr"><xsl:apply-templates /></xsl:template>
    <xsl:template match="table[@class='gliffy-macro-table']/tr/td/table[@class='gliffy-macro-inner-table']"><xsl:apply-templates /></xsl:template>
    <xsl:template match="table[@class='gliffy-macro-table']/tr/td"><xsl:apply-templates /></xsl:template>
    <xsl:template match="table[@class='gliffy-macro-table']/tr"><xsl:apply-templates /></xsl:template>
    <xsl:template match="table[@class='gliffy-macro-table']"><xsl:apply-templates /></xsl:template>


    <!-- Images -->

    <xsl:template match="img">
        <xsl:text>\begin{figure}&#xa;</xsl:text>
        <xsl:text>  \centering&#xa;</xsl:text>
        <xsl:choose>
            <xsl:when test="@width">
                <xsl:text>  \includegraphics[width = </xsl:text>
                <xsl:value-of select="number(@width) div 2" />
                <xsl:text>px]{</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>  \includegraphics[width = 3in]{</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="@src" />
        <xsl:text>}&#xa;</xsl:text>
        <xsl:if test="@title">
            <xsl:text>  \caption{</xsl:text>
            <xsl:value-of select="@title" />
            <xsl:text>}&#xa;</xsl:text>
        </xsl:if>
        <xsl:text>\end{figure}&#xa;</xsl:text>
    </xsl:template>



    <!-- Lists -->

    <xsl:template match="ol">
        <xsl:text>\begin{enumerate}</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates />
        <xsl:text>\end{enumerate}</xsl:text>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="ul">
        <xsl:text>\begin{itemize}</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:apply-templates />
        <xsl:text>\end{itemize}</xsl:text>
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="li">
        <xsl:text>  \item </xsl:text>
        <xsl:apply-templates />
        <xsl:text>&#xa;</xsl:text>
    </xsl:template>



    <!-- Stupid divs and other dumb content -->

    <xsl:template match="map"></xsl:template>

    <xsl:template match="div[@id='main-content' or @class='wiki-content group']">
        <xsl:apply-templates select="node()" />
    </xsl:template>
    <xsl:template match="div[@class='columnMacro' or @class='sectionMacro' or @class='sectionMacroRow' or @class='sectionColumnWrapper']">
        <xsl:apply-templates select="node()" />
    </xsl:template>

    <!-- TOC -->

    <!-- Haven't figured this one out yet -->

    <xsl:template match="div[@class='toc-macro']">BLIKSJDFOF<xsl:apply-templates /></xsl:template>

    <!-- LaTeX Features -->

    <xsl:template match="pre[@class='latex']">
        <xsl:text>\[ </xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text> \]&#xa;</xsl:text>
    </xsl:template>
    <xsl:template match="pre[@class='latex']/p">
        <xsl:apply-templates select="node()" />
    </xsl:template>

    <xsl:template match="div[@class='figure']">
        <xsl:text>&#xa;\begin{figure}&#xa;</xsl:text>
        <xsl:text>\centering&#xa;</xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text>\end{figure}&#xa;</xsl:text>
    </xsl:template>

    <!-- Block quotes -->

    <xsl:template match="blockquote">
        <xsl:text>&#xa;\begin{quote}</xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text>\end{quote}</xsl:text>
        <xsl:text>&#xa;&#xa;</xsl:text>
    </xsl:template>

    <!-- Panel boxes -->

    <xsl:template match="div[@class='panelContent']"><xsl:apply-templates /></xsl:template>
    <xsl:template match="div[@class='panel']">
        <xsl:text>&#xa;\begin{mdframed}[style=mystyle]</xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text>\end{mdframed}&#xa;&#xa;</xsl:text>
    </xsl:template>

    <!-- Code boxes -->

    <xsl:template match="span[@class='expand-control-text']"></xsl:template>

    <xsl:template match="div[@class='code panel pdl']"><xsl:apply-templates /></xsl:template>
    <xsl:template match="div[@class='codeHeader panelHeader pdl hide-border-bottom']"><xsl:apply-templates /></xsl:template>

    <xsl:template match="div[@class='codeContent panelContent pdl hide-toolbar']/pre">
        <xsl:text>\lstset{style=spin}&#xa;\begin{lstlisting}</xsl:text>
        <xsl:copy-of select="text()" />
        <xsl:text>\end{lstlisting}&#xa;&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="div[@class='codeContent panelContent pdl']/pre">
        <xsl:text>\lstset{style=spin}&#xa;\begin{lstlisting}</xsl:text>
        <xsl:copy-of select="text()" />
        <xsl:text>\end{lstlisting}&#xa;&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="div[@class='codeContent panelContent pdl hide-toolbar']"><xsl:apply-templates /></xsl:template>
    <xsl:template match="div[@class='codeContent panelContent pdl']"><xsl:apply-templates /></xsl:template>

    <!-- Custom code boxes -->

    <xsl:template match="pre[@class='spin']/pre"><xsl:apply-templates select="node()" /></xsl:template>
    <xsl:template match="pre[@class='pasm']/pre"><xsl:apply-templates select="node()" /></xsl:template>

    <xsl:template match="pre[@class='spin']">
        <xsl:text>\lstset{style=spin}&#xa;\begin{lstlisting}</xsl:text>
        <xsl:copy-of select="pre/text()" />
        <xsl:text>\end{lstlisting}&#xa;&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="pre[@class='pasm']">
        <xsl:text>\lstset{style=pasm}&#xa;\begin{lstlisting}</xsl:text>
        <xsl:copy-of select="pre/text()" />
        <xsl:text>\end{lstlisting}&#xa;&#xa;</xsl:text>
    </xsl:template>



    <!-- Friendly box messages -->

    <!--    <xsl:template match="div"><xsl:apply-templates /></xsl:template> -->
    <xsl:template match="div[@class='aui-message problem shadowed information-macro']">
        <xsl:text>\begin{bclogo}[couleur=bgblue, arrondi =0, logo=\bcbombe, barre=none,noborder=true]{}</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:text>\itshape </xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text>\end{bclogo}&#xa;</xsl:text>
    </xsl:template>
    <xsl:template match="div[@class='aui-message problem shadowed information-macro']/span"></xsl:template>
    <xsl:template match="div[@class='aui-message problem shadowed information-macro']/div"><xsl:apply-templates /></xsl:template>

    <xsl:template match="div[@class='aui-message warning shadowed information-macro']">
        <xsl:text>\begin{bclogo}[couleur=bgblue, arrondi =0, logo=\bcbombe, barre=none,noborder=true]{}</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:text>\itshape </xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text>\end{bclogo}&#xa;</xsl:text>
    </xsl:template>
    <xsl:template match="div[@class='aui-message warning shadowed information-macro']/span"></xsl:template>
    <xsl:template match="div[@class='aui-message warning shadowed information-macro']/div"><xsl:apply-templates /></xsl:template>

    <xsl:template match="div[@class='aui-message hint shadowed information-macro']">
        <xsl:text>\begin{bclogo}[couleur=bgblue, arrondi =0, logo=\bcbombe, barre=none,noborder=true]{}</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:text>\itshape </xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text>\end{bclogo}&#xa;</xsl:text>
    </xsl:template>
    <xsl:template match="div[@class='aui-message hint shadowed information-macro']/span"></xsl:template>
    <xsl:template match="div[@class='aui-message hint shadowed information-macro']/div"><xsl:apply-templates /></xsl:template>

    <xsl:template match="div[@class='aui-message success shadowed information-macro']">
        <xsl:text>\begin{bclogo}[couleur=bgblue, arrondi =0, logo=\bcbombe, barre=none,noborder=true]{}</xsl:text>
        <xsl:text>&#xa;\itshape </xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text>\end{bclogo}&#xa;</xsl:text>
    </xsl:template>
    <xsl:template match="div[@class='aui-message success shadowed information-macro']/span"></xsl:template>
    <xsl:template match="div[@class='aui-message success shadowed information-macro']/div"><xsl:apply-templates /></xsl:template>


    <!-- Headers -->

    <xsl:template match="book_section"><xsl:apply-templates /></xsl:template>

    <xsl:template match="h1">
        <xsl:choose>
            <xsl:when test="count(ancestor::book_section) = 0">
                <xsl:text>&#xa;\newpage
\AddToShipoutPicture*{\ChapterBackgroundPic}
\part{</xsl:text>
                <xsl:apply-templates select="node()" />
                <xsl:text>}&#xa;\newpage&#xa;&#xa;</xsl:text>
            </xsl:when>
            <xsl:when test="count(ancestor::book_section) = 1">
                <xsl:text>&#xa;\newpage
\AddToShipoutPicture*{\ChapterBackgroundPic}
\chapter{</xsl:text>
                <xsl:apply-templates select="node()" />
                <xsl:text>}&#xa;\newpage&#xa;&#xa;</xsl:text>
            </xsl:when>
            <xsl:when test="count(ancestor::book_section) = 2">
                <xsl:text>&#xa;\section{</xsl:text>
                <xsl:apply-templates select="node()" />
                <xsl:text>}&#xa;&#xa;</xsl:text>
            </xsl:when>
            <xsl:when test="count(ancestor::book_section) = 3">
                <xsl:text>&#xa;\subsection{</xsl:text>
                <xsl:apply-templates select="node()" />
                <xsl:text>}&#xa;&#xa;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                EVERYTHING SUCKS<xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="h2|h3">
        <xsl:text>&#xa;\subsection{</xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text>}&#xa;&#xa;</xsl:text>
    </xsl:template>

    <xsl:template match="h4|h5">
        <xsl:text>&#xa;\subsubsection{</xsl:text>
        <xsl:apply-templates select="node()" />
        <xsl:text>}&#xa;&#xa;</xsl:text>
    </xsl:template>


    <!-- Miscellaneous stuff -->

    <xsl:template match="span">
        <xsl:apply-templates select="node()" />
    </xsl:template>
    <xsl:template match="div[not(@*)]">
        <xsl:apply-templates select="node()" />
    </xsl:template>
    <xsl:template match="br"></xsl:template>
    <xsl:template match="style"></xsl:template>

    <!-- If nothing else, just copy it -->

    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>


</xsl:stylesheet>