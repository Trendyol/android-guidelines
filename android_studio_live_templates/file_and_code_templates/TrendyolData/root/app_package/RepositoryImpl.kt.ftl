package ${packageName}.repository

<#assign camelCaseClassName = className?substring(0,1)?lower_case + className?substring(1)>
import ${packageName}.source.${className}DataSource
import javax.inject.Inject

class ${className}RepositoryImpl @Inject constructor(
	<#if includeLocalDataSource>
    private val ${camelCaseClassName}LocalDataSource: ${className}DataSource.Local,
    </#if>
	private val ${camelCaseClassName}RemoteDataSource: ${className}DataSource.Remote
) : ${className}Repository {

}
