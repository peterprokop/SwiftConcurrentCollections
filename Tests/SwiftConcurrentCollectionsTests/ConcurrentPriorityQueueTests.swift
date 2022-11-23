import XCTest
@testable import SwiftConcurrentCollections

class ConcurrentPriorityQueueTests: XCTestCase {

    func testConcurrentReadingAndWriting() {
        let startDate = Date().timeIntervalSince1970
        let concurrentPriorityQueue = ConcurrentPriorityQueue<Int>(<)
        // Unsafe version:
        // var concurrentPriorityQueue = PriorityQueue<Int>(<)

        let readingQueue = DispatchQueue(
            label: "ConcurrentArrayTests.readingQueue",
            qos: .userInteractive,
            attributes: .concurrent
        )

        let writingQueue = DispatchQueue(
            label: "ConcurrentArrayTests.writingQueue",
            qos: .userInteractive,
            attributes: .concurrent
        )

        // 100 seems to be small enough not to cause performance problems
        for i in 0 ..< 100 {
            let writeExpectation = expectation(description: "Write expectation")
            let readExpectation = expectation(description: "Read expectation")

            writingQueue.async {
                concurrentPriorityQueue.insert(i)
                writeExpectation.fulfill()
            }

            readingQueue.async {
                let count = concurrentPriorityQueue.count
                guard count > 0 else {
                    return
                }

                let value = concurrentPriorityQueue.peek()
                print(value)
                readExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
        print("\(#function) took \(Date().timeIntervalSince1970 - startDate) seconds")
    }

    func testPop() {
        let concurrentPriorityQueue = ConcurrentPriorityQueue<Int>(<)

        concurrentPriorityQueue.insert(1)
        XCTAssertEqual(concurrentPriorityQueue.count, 1)
        XCTAssertEqual(concurrentPriorityQueue.peek(), 1)
        XCTAssertEqual(concurrentPriorityQueue.pop(), 1)
        XCTAssertEqual(concurrentPriorityQueue.count, 0)
    }

    func testSafePop() {
        let concurrentPriorityQueue = ConcurrentPriorityQueue<Int>(<)

        XCTAssertEqual(concurrentPriorityQueue.safePop(), nil)
        concurrentPriorityQueue.insert(1)
        XCTAssertEqual(concurrentPriorityQueue.safePop(), 1)
        XCTAssertEqual(concurrentPriorityQueue.count, 0)
    }

    func testSafePeek() {
        let concurrentPriorityQueue = ConcurrentPriorityQueue<Int>(<)

        XCTAssertEqual(concurrentPriorityQueue.safePeek(), nil)
        concurrentPriorityQueue.insert(1)
        XCTAssertEqual(concurrentPriorityQueue.safePeek(), 1)
        XCTAssertEqual(concurrentPriorityQueue.count, 1)
    }

}
