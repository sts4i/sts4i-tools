<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:isosts="http://www.iso.org/ns/isosts"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:sc="http://transpect.io/schematron-config"
  xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:file="http://expath.org/ns/file" exclude-result-prefixes="sc xs isosts" version="2.0">

  <xsl:import href="identity.xsl"/>
  <xsl:import href="../NISOSTS_lib.xsl"/>


  <xsl:template mode="create_media_folder" match="/*">
    <xsl:variable name="target" select="concat(file:parent(base-uri(/*)), '/media')"/>
    <xsl:message select="'############## created media folder', file:create-dir($target)"/>
    <xsl:copy>
      <xsl:apply-templates select="@*, node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>



  <xsl:template mode="move_files" match="/*">
    <xsl:variable name="base" select="replace(replace(base-uri(/*), '\.fixed\.xml$', '.xml'), '^.*/', '')"/>
    <xsl:variable name="target" select="concat(file:parent(base-uri(/*)), 'media')"/>
    <xsl:variable name="files"
      select="file:list(file:parent(base-uri(/*)), true())[not(matches(., concat('^', $base, '$')) or ends-with(., '/'))]"/>
    <xsl:variable name="dirs"
      select="file:list(file:parent(base-uri(/*)), true())[not(matches(., '\.\d?[A-z].*$') or . = 'media/')]"/>
    <xsl:variable name="paths"
      select="
        for $f
        in $files
        return
          resolve-uri($f, base-uri(/*))"/>
    <xsl:variable name="del-paths"
      select="
        for $f
        in $dirs
        return
          resolve-uri($f, base-uri(/*))"/>
    <xsl:message
      select="
        '############## moved files:', string-join($files[not(matches(., 'media/[^/]+\.\d?[A-z].*$'))], ', '), 'to media folder',
        for $p in $paths
        return
          if (not(matches($p, 'media/[^/]+\.\d?[A-z].*$')))
          then
            file:move($p, $target)
          else
            ''"/>
    <xsl:if test="not(empty($dirs))">
      <xsl:message
        select="
          '############## deleted empty directories:', string-join($dirs, ', '),
          for $p in reverse($del-paths)
          return
            file:delete($p, true())"
      />
    </xsl:if>
    <xsl:copy>
      <xsl:apply-templates select="@*, node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>


  <xsl:template match="(graphic | inline-graphic)[@xlink:href]" mode="change_href">
    <xsl:variable name="files"
      select="file:list(file:parent(base-uri(/*)), true())[matches(., isosts:basename-to-regex(current()/@xlink:href))]"/>
    <xsl:variable name="paths"
      select="
        for $f
        in $files
        return
          resolve-uri($f, base-uri(/*))"/>
    <xsl:copy>
      <xsl:apply-templates select="@* except @xlink:href" mode="#current"/>
      <xsl:choose>
        <xsl:when test="
            some $p in $paths
              satisfies exists($p)">
          <xsl:attribute name="xlink:href"
            select="
              if ($files[matches(., '\.png$')])
              then
                $files[matches(., '\.png$')]
              else
                $files[1]"
          />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="@xlink:href" mode="#current"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="change_img_file_extensions" match="/*">
    <xsl:variable name="img_regEx" select="'\.(png|jpe?g|gif|svg|tiff?)$'"/>
    <xsl:variable name="base" select="replace(replace(base-uri(/*), '\.fixed\.xml$', '.xml'), '^.*/', '')"/>
    <xsl:variable name="files"
      select="file:list(file:parent(base-uri(/*)), true())[not(matches(., concat('^', $base, '$')) or ends-with(., '/'))][matches(., $img_regEx, 'i')]"/>
    <xsl:variable name="wrong_file_extension" select="$files[not(matches(., $image_file_extension_regEx))]"/>
    <xsl:variable name="old-paths"
      select="
        for $w
        in $wrong_file_extension
        return
          resolve-uri($w, base-uri(/*))"/>
    <xsl:variable name="fixed_extensions"
      select="$wrong_file_extension ! replace(replace(lower-case(replace(., 'media/.+\.?.+\.', '')), 'jpeg$', 'jpg', 'i'), 'tiff$', 'tif')"/>
    <xsl:variable name="new-paths"
      select="
        for $o
        in $old-paths
        return
          replace($o, $img_regEx, $fixed_extensions[index-of($old-paths, $o)], 'i')"/>
    <xsl:message
      select="
        '############## changed file extensions',
        for $o in $old-paths
        return
          file:move($old-paths[index-of($old-paths, $o)], $new-paths[index-of($old-paths, $o)])
        , 'renamed files:', string-join($wrong_file_extension, ', '), 'to:', string-join($new-paths ! replace(., substring-before(., 'media'), ''), ', ')"/>
    <xsl:copy>
      <xsl:apply-templates select="@*, node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>


</xsl:stylesheet>
