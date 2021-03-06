# SwiftConcurrentCollections

# Intro

Swift Concurrent Collections (or **SCC**) is a library providing concurrent (thread-safe) implementations of some of default Swift collections. Similar to ones found in `java.util.concurrent` for Java.

# Installation

## Carthage
In your Xcode project folder do:
- `echo "github \"peterprokop/SwiftConcurrentCollections\" ~> 1.3.0" >> Cartfile` (or use `nano`)
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

## Safe subscript
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

## Priority queue
**SCC** provides both classical and concurrent priority queues

```swift
var priorityQueue = PriorityQueue<Int>(<)

priorityQueue.insert(3)
priorityQueue.insert(2)
priorityQueue.insert(1)

while priorityQueue.count > 0 {
    print(
        priorityQueue.pop(),
        terminator: " "
    )
    // Will print: 1 2 3
}
```

As you can see `PriorityQueue<Int>(<)` constructs min-queue, with `PriorityQueue<Int>(>)` you can get max-queue.
If you need to reserve capacity right away, use `PriorityQueue<Int>(capacity: 1024, comparator: <)`.
`ConcurrentPriorityQueue<Int>(<)` creates a thread-safe version, with a very similar interface.
