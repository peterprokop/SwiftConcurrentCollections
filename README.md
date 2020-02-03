# SwiftConcurrentCollections

======

# Intro

Swift Concurrent Collections is a library providing concurrent (thread-safe) implementations of some of default Swift collections. Similar to ones found in `java.util.concurrent` for Java.

# Installation

## Carthage
In your Xcode project folder do:
- `touch Cartfile`
- `nano Cartfile`
- Put `github "peterprokop/SwiftConcurrentCollections" == 1.0.0` into Cartfile
- Save it: `ctrl-x`, `y`, `enter`
- Run `carthage update`
- Add `SwiftConcurrentCollections` to your carthage [copy-frameworks phase](https://github.com/Carthage/Carthage#quick-start)
- Add `import SwiftConcurrentCollections` in files where you plan to use it 

# Usage
Do `import SwiftConcurrentCollections`

Then you can use concurrent collections from different threads without fear of crashes or data corruption
```swift
let concurrentArray = ConcurrentArray<Int>()
concurrentArray.append(value)
print(concurrentArray[0])
```
```swift
let concurrentDictionary = ConcurrentDictionary<String, Int>()
concurrentDictionary[key] = value
print(concurrentDictionary[key])
```
