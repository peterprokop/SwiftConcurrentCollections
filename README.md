# SwiftConcurrentCollections

# Intro

Swift Concurrent Collections is a library providing concurrent (thread-safe) implementations of some of default Swift collections. Similar to ones found in `java.util.concurrent` for Java.

# Installation

## Carthage
In your Xcode project folder do:
- `echo "github \"peterprokop/SwiftConcurrentCollections\" ~> 1.2.1" >> Cartfile` (or use `nano`)
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

Safe array subscript: for atomicity of checking if specified index is in the array and getting element with that index use
```swift
if let element = concurrentArray[safe: index] {
    // ...
}
```
instead of 
```swift
if index < concurrentArray.count {
    let element = concurrentArray[index]
    // ...
}
```
