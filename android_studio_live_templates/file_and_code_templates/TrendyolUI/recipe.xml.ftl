<?xml version="1.0"?>
<#import "root://activities/common/kotlin_macros.ftl" as kt>
<recipe>
    <@kt.addAllKotlinDependencies />
    <instantiate from="src/app_package/Fragment.kt.ftl"
                   to="${escapeXmlAttribute(srcOut)}/${className}Fragment.kt" />

    <instantiate from="src/app_package/FragmentBuilderModule.kt.ftl"
                  to="${escapeXmlAttribute(srcOut)}/${className}FragmentBuilderModule.kt" />

    <instantiate from="src/app_package/ViewModel.kt.ftl"
                  to="${escapeXmlAttribute(srcOut)}/${className}ViewModel.kt" />

    <instantiate from="src/app_package/ViewModelModule.kt.ftl"
                  to="${escapeXmlAttribute(srcOut)}/${className}ViewModelModule.kt" />

    <#if generatePageViewState>
        <instantiate from="src/app_package/PageViewState.kt.ftl"
                  to="${escapeXmlAttribute(srcOut)}/${className}PageViewState.kt" />
    </#if>

    <instantiate from="res/layout/fragment.xml"
                 to="${escapeXmlAttribute(resOut)}/layout/${layout}.xml" />

    <open file="${srcOut}/${className}Fragment.kt"/>
    <open file="${escapeXmlAttribute(resOut)}/layout/${layout}.xml" />
    
</recipe>
