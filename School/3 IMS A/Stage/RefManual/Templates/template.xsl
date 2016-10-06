<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
	<html>
	<head>
		<link href="CSS/xml.css" type="text/css" rel="stylesheet"/>
	</head>
	<body>
		<xsl:for-each select="artikel/paragraaf">
        <span class="titelklein"><xsl:value-of select="titel"/></span><br/><br/>
        <span class="tekst"><xsl:value-of select="tekst"/></span><br/><br/>
		</xsl:for-each>
	</body>
	</html>
</xsl:template>

</xsl:stylesheet>