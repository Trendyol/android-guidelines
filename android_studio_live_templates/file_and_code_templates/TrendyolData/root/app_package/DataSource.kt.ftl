package ${packageName}.source

interface ${className}DataSource {
    
    interface Remote {
        
    }
	<#if includeLocalDataSource>

    interface Local {
        
    }
    </#if>

}