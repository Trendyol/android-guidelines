package ${packageName}.source.remote

<#assign camelCaseClassName = className?substring(0,1)?lower_case + className?substring(1)>
import ${packageName}.source.${className}DataSource
import javax.inject.Inject

class ${className}RemoteDataSource @Inject
constructor(private val ${camelCaseClassName}Service: ${className}Service) : ${className}DataSource.Remote {

}
