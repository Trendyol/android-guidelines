<?xml version="1.0"?>
<recipe>

	<instantiate from="app_package/Module.kt.ftl"
                  to="${escapeXmlAttribute(srcOut)}/${className}Module.kt" />

    <instantiate from="app_package/Repository.kt.ftl"
                   to="${escapeXmlAttribute(srcOut)}/repository/${className}Repository.kt" />

    <instantiate from="app_package/RepositoryImpl.kt.ftl"
                  to="${escapeXmlAttribute(srcOut)}/repository/${className}RepositoryImpl.kt" />

    <instantiate from="app_package/DataSource.kt.ftl"
                  to="${escapeXmlAttribute(srcOut)}/source/${className}DataSource.kt" />

	<instantiate from="app_package/RemoteDataSource.kt.ftl"
                  to="${escapeXmlAttribute(srcOut)}/source/remote/${className}RemoteDataSource.kt" />

	<instantiate from="app_package/Service.kt.ftl"
                  to="${escapeXmlAttribute(srcOut)}/source/remote/${className}Service.kt" />

  <#if includeLocalDataSource>
    <instantiate from="app_package/LocalDataSource.kt.ftl"
                  to="${escapeXmlAttribute(srcOut)}/source/local/${className}LocalDataSource.kt" />
  </#if>

    <open file="${srcOut}/source/remote/${className}Service.kt"/>
    <open file="${srcOut}/source/remote/${className}Repository.kt"/>
    <open file="${srcOut}/source/remote/${className}RemoteDataSource.kt"/>

</recipe>
