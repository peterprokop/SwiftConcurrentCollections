import XCTest
@testable import SwiftConcurrentCollections

class ConcurrentArrayTests: XCTestCase {

    func testConcurrentReadingAndWriting() {
        let concurrentArray = ConcurrentArray<Int>()
        // Unsafe version:
        // var concurrentArray = Array<Int>()

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
                concurrentArray.append(i)
                writeExpectation.fulfill()
            }

            readingQueue.async {
                let count = concurrentArray.count
                guard count > 0 else {
                    return
                }

                let value = concurrentArray[
                    Int.random(in: 0 ..< count)
                ]
                print(value as Any)
                readExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testSingleThreadReadingAndWriting() {
        let value = 667

        let concurrentArray = ConcurrentArray<Int>()

        XCTAssertEqual(concurrentArray.count, 0)

        concurrentArray.append(value)

        XCTAssertEqual(concurrentArray.count, 1)
        XCTAssertEqual(concurrentArray[0], value)
    }

}
