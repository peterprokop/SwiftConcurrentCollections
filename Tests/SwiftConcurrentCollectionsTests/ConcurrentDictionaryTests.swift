import XCTest
@testable import SwiftConcurrentCollections

class ConcurrentDictionaryTests: XCTestCase {

    func testConcurrentReadingAndWriting() {
        let startDate = Date().timeIntervalSince1970
        let key = "testKey"
        let concurrentDictionary = ConcurrentDictionary<String, Int>()
        // Note that if we change this to following:
        // var concurrentDictionary = Dictionary<String, Int>()
        // Cycle in the end crashes almost instantly with `EXC_BAD_INSTRUCTION`/`SIGABRT`

        let readingQueue = DispatchQueue(
            label: "ThreadSafeDictionaryTests.readingQueue",
            qos: .userInteractive,
            attributes: .concurrent
        )

        let writingQueue = DispatchQueue(
            label: "ThreadSafeDictionaryTests.writingQueue",
            qos: .userInteractive,
            attributes: .concurrent
        )

        // 2_000 seems to be small enough not to cause performance problems
        for i in 0 ..< 2_000 {
            let writeExpectation = expectation(description: "Write expectation")
            let readExpectation = expectation(description: "Read expectation")

            writingQueue.async {
                concurrentDictionary[key] = i
                writeExpectation.fulfill()
            }

            readingQueue.async {
                let value = concurrentDictionary[key]
                print(value as Any)
                readExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
        print("\(#function) took \(Date().timeIntervalSince1970 - startDate) seconds")
    }

    func testSingleThreadReadingAndWriting() {
        let key = "testKey"
        let value = 667

        let concurrentDictionary = ConcurrentDictionary<String, Int>()

        XCTAssertNil(concurrentDictionary[key])

        concurrentDictionary[key] = value

        XCTAssertEqual(concurrentDictionary[key], value)
    }

    func testMutateValue() {
        let concurrentDictionary = ConcurrentDictionary<String, Int>()
        let key = "testKey"
        let value = 999

        concurrentDictionary[key] = 999
        concurrentDictionary.mutateValue(forKey: key) { $0 * 2 }

        XCTAssertEqual(concurrentDictionary[key], value * 2)
    }

    func testAssigningNilDoesUnlock() {
        let concurrentDictionary = ConcurrentDictionary<String, Int>()
        let key = "testKey"
        let value = 999

        concurrentDictionary[key] = value

        let queue = DispatchQueue(
            label: "ThreadSafeDictionaryTests.queue",
            qos: .userInteractive,
            attributes: []
        )

        let expectationOne = expectation(description: "Assigning `nil` first time")
        let expectationTwo = expectation(description: "Assigning `nil` second time")

        queue.async {
            concurrentDictionary[key] = nil
            expectationOne.fulfill()
        }

        queue.sync {
            concurrentDictionary[key] = nil
            expectationTwo.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

        concurrentDictionary[key] = value
        XCTAssertEqual(concurrentDictionary[key], value)
    }

}


