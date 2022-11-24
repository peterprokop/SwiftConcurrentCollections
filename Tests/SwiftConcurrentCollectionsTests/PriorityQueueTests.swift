import XCTest
@testable import SwiftConcurrentCollections

class PriorityQueueTests: XCTestCase {

    func testOrderingMin() {
        var x = PriorityQueue<Int>(<)

        x.insert(6)
        x.insert(5)
        x.insert(4)

        XCTAssertEqual(x.pop(), 4)

        x.insert(3)
        x.insert(2)
        x.insert(1)

        XCTAssertEqual(x.count, 5)

        XCTAssertEqual(x.peek(), 1)
        XCTAssertEqual(x.pop(), 1)
        XCTAssertEqual(x.pop(), 2)
        XCTAssertEqual(x.pop(), 3)
        XCTAssertEqual(x.pop(), 5)
        XCTAssertEqual(x.peek(), 6)
        XCTAssertEqual(x.pop(), 6)

        XCTAssertEqual(x.count, 0)
    }

    func testOrderingMax() {
        var x = PriorityQueue<Int>(>)

        x.insert(6)
        x.insert(5)
        x.insert(4)

        XCTAssertEqual(x.pop(), 6)

        x.insert(3)
        x.insert(2)
        x.insert(1)

        XCTAssertEqual(x.count, 5)

        XCTAssertEqual(x.peek(), 5)
        XCTAssertEqual(x.pop(), 5)
        XCTAssertEqual(x.pop(), 4)
        XCTAssertEqual(x.pop(), 3)
        XCTAssertEqual(x.pop(), 2)
        XCTAssertEqual(x.peek(), 1)
        XCTAssertEqual(x.pop(), 1)

        XCTAssertEqual(x.count, 0)
    }

    func testOrderingMinWithCapacity() {
        var x = PriorityQueue<Int>(capacity: 1024, comparator: <)

        x.insert(3)
        x.insert(2)
        x.insert(1)

        XCTAssertEqual(x.count, 3)

        XCTAssertEqual(x.peek(), 1)
        XCTAssertEqual(x.pop(), 1)
        XCTAssertEqual(x.pop(), 2)
        XCTAssertEqual(x.pop(), 3)
    }

}
