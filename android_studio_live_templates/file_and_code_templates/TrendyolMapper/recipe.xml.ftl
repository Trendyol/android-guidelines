<?xml version="1.0"?>
<#import "root://activities/common/kotlin_macros.ftl" as kt>
<recipe>
    <@kt.addAllKotlinDependencies />
    
    <instantiate from="src/app_package/Mapper.kt.ftl"
                   to="${escapeXmlAttribute(srcOut)}/${className}.kt" />

    <open file="${srcOut}/${className}.kt"/>
    
</recipe>
