## Kotlin Rules

- 4 spaces for indentation
- No semicolons (unless used to separate multiple statements on the same line)
- No wildcard / unused `import`s
- No consecutive blank lines
- No blank lines before `}`
- No trailing whitespaces
- No `Unit` returns (`fun fn {}` instead of `fun fn: Unit {}`)
- No empty (`{}`) class bodies
- No spaces around range (`..`) operator
- No newline before (binary) `+` & `-`, `*`, `/`, `%`, `&&`, `||`
- When wrapping chained calls `.`, `?.` and `?:` should be placed on the next line
- When a line is broken at an assignment (`=`) operator the break comes after the symbol
- When class/function signature doesn't fit on a single line, each parameter must be on a separate line
- Consistent string templates (`$v` instead of `${v}`, `${p.v}` instead of `${p.v.toString()}`)
- Consistent order of modifiers
- Consistent spacing after keywords, commas; around colons, curly braces, parens, infix operators, comments, etc

These are the [default rules for ktlint](https://github.com/shyiko/ktlint/blob/master/README.md#standard-rules)