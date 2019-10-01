package ${packageName}.source.local

<#assign camelCaseClassName = className?substring(0,1)?lower_case + className?substring(1)>
import ${packageName}.source.${className}DataSource
import javax.inject.Inject

class ${className}LocalDataSource @Inject
constructor() : ${className}DataSource.Local {

}
