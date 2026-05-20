<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="xsl xlink mods">

  <xsl:import href="xslImport:solr-document:ubo-mws-solr.xsl" />

  <xsl:template match="mycoreobject">
    <xsl:apply-imports />
  </xsl:template>

  <xsl:template match="mods:mods" mode="solrField" priority="1" >
    <xsl:apply-templates select="mods:titleInfo" mode="solrField" />
    <xsl:apply-templates select="descendant::mods:name[@type='personal']/mods:role/mods:roleTerm[@type='code']" mode="solrField" />
    <xsl:apply-templates select="descendant::mods:name/mods:nameIdentifier" mode="solrField" />
    <xsl:apply-templates select="descendant::mods:name[mods:nameIdentifier[@type='lsf']]" mode="solrField.lsf" />
    <xsl:apply-templates select="mods:name[@type='personal'][mods:role/mods:roleTerm[@type='code'][contains('aut cre tch pht prg edt',text())]]/mods:nameIdentifier[@type='lsf']" mode="solrField.ae" />
    <xsl:apply-templates select="mods:name[@type='personal'][mods:role/mods:roleTerm[@type='code'][contains('aut cre tch pht prg edt ivr ive hnr',text())]]/mods:nameIdentifier[@type='lsf']" mode="solrField.aeplus" />
    <xsl:apply-templates select="mods:name[@type='personal'][mods:role/mods:roleTerm[@type='code'][contains('aut cre tch pht prg edt',text())]]/mods:nameIdentifier[@type='orcid']" mode="solrField.ae" />
    <xsl:apply-templates select="mods:name[@type='personal'][mods:role/mods:roleTerm[@type='code'][contains('aut cre tch pht prg edt',text())]]/mods:nameIdentifier[@type='connection']" mode="solrField.ae" />
    <xsl:apply-templates select="mods:name[@type='personal'][mods:role/mods:roleTerm[contains(@authorityURI,'author_roles')]]" mode="solrField.ar" />
    <xsl:apply-templates select="descendant::mods:name[@type='personal']" mode="child" />
    <xsl:apply-templates select="mods:genre[@type='intern']" mode="solrField" />
    <xsl:apply-templates select="mods:accessCondition[@xlink:href]" mode="solrField" />
    <xsl:apply-templates select="mods:relatedItem[@type='host']/mods:genre[@type='intern']" mode="solrField" />
    <xsl:apply-templates select="mods:classification[contains(@authorityURI,'ORIGIN')]" mode="solrField" />
    <xsl:apply-templates select="mods:classification[contains(@authorityURI,'fachreferate')]" mode="solrField" />
    <xsl:apply-templates select="mods:classification[contains(@authorityURI,'project')]" mode="solrField" />
    <xsl:apply-templates select="mods:classification[contains(@authorityURI,'fundingType')]" mode="solrField" />
    <xsl:apply-templates select="mods:classification[contains(@authorityURI,'accessrights')]" mode="solrField" />
    <xsl:apply-templates select="mods:classification[contains(@authorityURI,'peerreviewed')]" mode="solrField" />
    <xsl:apply-templates select="mods:classification[contains(@authorityURI,'mediaType')]" mode="solrField" />
    <xsl:apply-templates select="mods:classification[contains(@authorityURI,'kdsfPublicationType')]" mode="solrField" />
    <xsl:apply-templates select="mods:relatedItem[@type='host']/mods:titleInfo[not(@type)]" mode="solrField.host" />
    <xsl:apply-templates select="mods:relatedItem[@type='host'][substring-after(mods:genre/@valueURI, '#') = 'journal']/mods:titleInfo" mode="solrField" />
    <xsl:apply-templates select="mods:relatedItem[@type='host']/mods:part" mode="solrField" />
    <xsl:apply-templates select="mods:location/mods:url|mods:relatedItem[@type='host']/mods:location/mods:url" mode="solrField" />
    <xsl:apply-templates select="descendant::mods:originInfo" mode="solrField" />
    <xsl:apply-templates select="descendant::mods:relatedItem[@type='series']/mods:titleInfo" mode="solrField" />
    <xsl:apply-templates select="descendant::mods:name[@type='conference'][not(ancestor::mods:relatedItem[@type='references'])][1]" mode="solrField" />
    <xsl:apply-templates select="descendant::mods:dateIssued[1]" mode="solrField" />
    <xsl:apply-templates select="mods:relatedItem[@type='host']/mods:originInfo/mods:dateIssued[1]" mode="solrField.host" />
    <xsl:apply-templates select="descendant::mods:identifier[@type]" mode="solrField" />
    <xsl:apply-templates select="descendant::mods:shelfLocator" mode="solrField" />
    <xsl:apply-templates select="mods:subject" mode="solrField" />
    <xsl:apply-templates select="mods:note" mode="solrField" />
    <xsl:apply-templates select="mods:abstract" mode="solrField" />
    <xsl:apply-templates select="mods:language/mods:languageTerm[@type='code']" mode="solrField" />
    <xsl:apply-templates select="mods:extension/tag" mode="solrField" />
    <xsl:apply-templates select="mods:extension/dedup" mode="solrField" />
    <xsl:call-template name="sortby_person" />
    <xsl:call-template name="oa" />
    <xsl:call-template name="partOf" />
    <xsl:call-template name="destatis" />
  </xsl:template>

  <xsl:template match="mods:dateIssued" mode="solrField" priority="1">
    <xsl:variable name="yearIssued">
      <xsl:choose>
        <xsl:when test="contains(.,'-')">
          <xsl:value-of select="substring-before(.,'-')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="translate($yearIssued,'1234567890','YYYYYYYYYY')='YYYY'">
      <field name="year">
        <xsl:value-of select="$yearIssued" />
      </field>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mods:relatedItem[@type='host']/mods:originInfo/mods:dateIssued" mode="solrField.host"  priority="1">
    <xsl:variable name="yearIssued">
      <xsl:choose>
        <xsl:when test="contains(.,'-')">
          <xsl:value-of select="substring-before(.,'-')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="translate($yearIssued,'1234567890','YYYYYYYYYY')='YYYY'">
      <field name="host_year">
        <xsl:value-of select="$yearIssued" />
      </field>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>