package ${packageName}

<#assign targetClassName = target>

<#assign source1ClassName = source1>
<#assign source1FieldName = source1ClassName?substring(0,1)?lower_case + source1ClassName?substring(1)>

<#if addDataSource1>
<#assign source2ClassName = source2>
<#assign source2FieldName = source2ClassName?substring(0,1)?lower_case + source2ClassName?substring(1)>
</#if>

<#if addDataSource2>
<#assign source3ClassName = source3>
<#assign source3FieldName = source3ClassName?substring(0,1)?lower_case + source3ClassName?substring(1)>
</#if>

<#if addDataSource3>
<#assign source4ClassName = source4>
<#assign source4FieldName = source4ClassName?substring(0,1)?lower_case + source4ClassName?substring(1)>
</#if>

import javax.inject.Inject

class ${className} @Inject constructor() {

    <#if addDataSource3>
    fun mapFrom(
        ${source1FieldName}: ${source1ClassName},
        ${source2FieldName}: ${source2ClassName},
        ${source3FieldName}: ${source3ClassName},
        ${source4FieldName}: ${source4ClassName}
    ): ${targetClassName} {
    <#elseif addDataSource2>
    fun mapFrom(
        ${source1FieldName}: ${source1ClassName},
        ${source2FieldName}: ${source2ClassName},
        ${source3FieldName}: ${source3ClassName}
    ): ${targetClassName} {
    <#elseif addDataSource1>
    fun mapFrom(
        ${source1FieldName}: ${source1ClassName},
        ${source2FieldName}: ${source2ClassName}
    ): ${targetClassName} {
    <#else>
    fun mapFrom(${source1FieldName}: ${source1ClassName}): ${targetClassName} {
    </#if>
        return ${targetClassName}(
            
        )
    }
    
}
