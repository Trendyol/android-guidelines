
# Module Naming and Module Package Naming Rules

* Status: accepted
* Date: 2021-06-21

## Context and Problem Statement

Number of module count has been increased with new channels and features in Trendyol Android Application. This problem can lead misunderstandings among team.

## Decision

In the context of creating new modules should follow this rules:

 - Package name cannot contain architectural layer name unless feature has multiple modules for different layers e.g. *data, domain, ui*.
 - Do not use nested module groups except channel groups and channel names. Prefer **kebab-case** for feature module name.
- Trendyol feature modules should not repeat trendyol in package names and paths.

Module Path: *:channel-group*:channel-name:feature-name-*architectural-level*
Package Name: com.trendyol.*channelgroup*.channelname.featurename

| module name | package name |
|--|--|
| :trendyol:home | com.trendyol.home |
| :common:price | com.trendyol.common.price |
| :mlbs:setup | com.trendyol.mlbs.setup |
| :trendyol:checkout-ui | com.trendyol.checkout |
