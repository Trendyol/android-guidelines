# NDK Usage and Obfuscation Guidelines

* Status: accepted
* Date: 2024-12-12

## Context and Problem Statement

The usage of the Native Development Kit (NDK) within the project introduces both performance benefits and new security considerations. To ensure consistency and maintainability, as well as to mitigate reverse engineering risks, we need a clear set of guidelines for naming conventions, code structuring, and obfuscation strategies.

In previous ADRs, we established conventions for readability, and code organization. This ADR extends those principles to our native integration layer, emphasizing security and comprehensibility where possible, while preserving the obfuscation strategies critical for protecting native code.

## Decision

#### TLDR
- Use non-descriptive names for native methods, classes, and libraries, combined with `@JvmName`, to hinder attackers.  
- Keep classes in a dedicated `ndk` package and provide KDoc documentation for clarity.  
- Use `dagger.Lazy` for lazy injection, ensuring native functionalities are only initialized when required.  
- Avoid `try-catch` around `System.loadLibrary` to prevent trivial bypasses.  
- Add `-fvisibility=hidden` to `cppFlags` to strip symbols, reducing the ease of reverse engineering.  
- Set `release.ndk.debugSymbolLevel = FULL` to allow internal debugging without leaking unnecessary information.  
- Obfuscate plain text strings before compilation to prevent easy extraction of sensitive information.

---

1. **Non-Descriptive Naming for Native Methods and Classes**:  
   - Use the `@JvmName` annotation and assign non-descriptive names (e.g., `a0`) to native methods exposed to the JVM.  
   - Use non-descriptive library names (e.g., `native-library-1`), and non-descriptive class names (e.g., `A0`).
   - Keep these classes in a dedicated root `ndk` package.

   *Rationale*: By using non-descriptive naming, we discourage attackers from easily deducing method purposes from method names. This aligns with our obfuscation strategies, making reverse engineering more challenging.

2. **Class Documentation and Injection**:  
   - Add clear KDoc comments to classes containing native methods, explaining their functionality at a high level, without revealing sensitive details.  
   - Use `dagger.Lazy` for lazy injection, ensuring they are only initialized when needed.

   *Rationale*: While classes remain non-descriptive by name, KDoc keep the codebase understandable for developers, while still obscuring intent for malicious third parties.

3. **System.loadLibrary Handling**:  
   - Do not wrap `System.loadLibrary` in a try-catch block. Rely on the native library’s presence as expected.  
   
   *Rationale*: Wrapping `System.loadLibrary` in try-catch blocks can be bypassed by removing the native library.

4. **Obfuscation and Stripping Symbols**:  
   - Add `-fvisibility=hidden` to `cppFlags` to strip dynamic symbols and further obfuscate the native library.  
   - For example:  
     ```kotlin
     android {
         buildTypes {
             release {
                 externalNativeBuild {
                     cmake {
                         cppFlags.add("-fvisibility=hidden")
                     }
                 }
             }
         }
     }
     ```

   *Rationale*: Symbol stripping removes identifiable information from native binaries, complicating reverse engineering efforts.

5. **Debug Symbols Handling**:  
   - Set `release.ndk.debugSymbolLevel = FULL` to ensure native debug symbols are automatically included in the App Bundle, aiding internal debugging without leaking unnecessary information to attackers.

   *Rationale*: This balances the need for internal troubleshooting with the principle of minimal leakage.

6. **Avoid Including Plain Texts Directly in Native Code**:  
   - Do not store sensitive plain text strings directly in native binaries.  
   - Obfuscate strings before compilation to reduce their discoverability by attackers.

   *Rationale*: Keeping sensitive information in plain text within the binary is a common weakness. By obfuscating strings at build time, we reduce the likelihood of information disclosure.
