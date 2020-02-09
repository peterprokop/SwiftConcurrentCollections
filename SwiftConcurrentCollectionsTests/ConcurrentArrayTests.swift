import XCTest
@testable import SwiftConcurrentCollections

class ConcurrentArrayTests: XCTestCase {

    func testConcurrentReadingAndWriting() {
        let startDate = Date().timeIntervalSince1970
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
        print("\(#function) took \(Date().timeIntervalSince1970 - startDate) seconds")
    }

    func testSingleThreadReadingAndWriting() {
        let value = 667

        let concurrentArray = ConcurrentArray<Int>()

        XCTAssertEqual(concurrentArray.count, 0)

        concurrentArray.append(value)

        XCTAssertEqual(concurrentArray.count, 1)
        XCTAssertEqual(concurrentArray[0], value)
    }

    func testMutateValue() {
        let array = ConcurrentArray<Int>()
        let value = 999

        array.append(value)

        array.mutateValue(at: 0) { $0 * 2 }

        XCTAssertEqual(array[0], value * 2)
    }

    func testSafeSubscript() {
        let array = ConcurrentArray<Int>()
        let value = 999

        array.append(value)

        XCTAssertEqual(array[safe: 0], value)
        XCTAssertNil(array[safe: 1])
        XCTAssertNil(array[safe: -999])
        XCTAssertNil(array[safe: 999])

    }
}
