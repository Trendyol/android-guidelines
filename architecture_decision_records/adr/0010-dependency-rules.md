
# Gradle Rules  

 * Status: accepted  
 * Date: 2021-06-22  

## Context and Problem Statement

Number of module count has been increased because of new features and new channels. Dependencies between modules were getting hard to comprehend.

## Decision

Channels should not depend on other channel's features. Only common modules can be used between channels.

Check our [module guideline](../../module_guideline/module_guideline.md) to understand more about build dependency management.
