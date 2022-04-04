
# Gradle Rules  

 * Status: updated
 * Date: 2022-04-04

## Decision

 * In the context of modularizing facing concern of duplicated resources we decided for resources(drawables, strings, styles etc.) in a common module.
 * If duplicated resource related with multiple channel, we should put in the trendyol:base module.
 * Otherwise we should putting resources in their feature modules.