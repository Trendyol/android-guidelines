
# Gradle Rules  

 * Status: accepted  
 * Date: 2021-06-22  

## Decision

In the context of modularizing facing concern of duplicated resources we decided for putting all resources(drawables, strings, styles etc.) in a common module and neglected putting resources in their feature modules, to achieve smaller app size, accepting to create dependency between feature modules and common resource dependency, because merging all resources prevented future duplications and easier to manage.
