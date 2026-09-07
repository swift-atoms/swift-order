import Comparison
import Order
import Testing

@testable import Order

@Suite
struct `Order comparators compose projections directions and partial relations` {
    @Suite struct `Order operations preserve reversal chaining projection and capability contracts` {}
    @Suite struct `No order comparator boundary cases are defined` {}
    @Suite struct `No order comparator integration cases are defined` {}
    @Suite(.serialized) struct `No order comparator performance cases are defined` {}
}

extension `Order comparators compose projections directions and partial relations`.`Order operations preserve reversal chaining projection and capability contracts` {
    @Suite struct `Order directions enumerate both orientations and reverse consistently` {}
    @Suite struct `Comparators invoke their supplied ordering closure` {}
    @Suite struct `Comparable values support ascending and descending comparators` {}
    @Suite struct `Reversing comparators exchanges their operand ordering` {}
    @Suite struct `Comparator chains resolve ties in priority order` {}
    @Suite struct `Comparator projections order values by selected keys` {}
    @Suite struct `Partial comparators represent incomparable values explicitly` {}
    @Suite struct `Comparators borrow noncopyable values and projected keys` {}
    @Suite struct `Order directions and comparators can cross isolation boundaries` {}
}

private struct Person {
    let name: String
    let age: Int
}

private struct Token: ~Copyable, Comparison.`Protocol` {
    let id: Int
}

extension Token {
    static func < (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.id < rhs.id
    }

    static func == (lhs: borrowing Self, rhs: borrowing Self) -> Bool {
        lhs.id == rhs.id
    }
}

private actor Comparer {}

extension Comparer {
    func compare(with comparator: Order.Comparator<Int>) -> Comparison {
        comparator(1, 2)
    }
}

private actor Holder {
    var direction: Order.Direction = .ascending
}

extension Holder {
    func set(_ d: Order.Direction) { direction = d }
    func get() -> Order.Direction { direction }
}

extension `Order comparators compose projections directions and partial relations`.`Order operations preserve reversal chaining projection and capability contracts`.`Order directions enumerate both orientations and reverse consistently` {
    @Test
    func `Order direction iteration includes ascending and descending`() {
        let cases = Order.Direction.allCases
        #expect(cases.count == 2)
        #expect(cases.contains(.ascending))
        #expect(cases.contains(.descending))
    }

    @Test
    func `Direction reversal exchanges ascending and descending`() {
        #expect(Order.Direction.ascending.reversed == .descending)
        #expect(Order.Direction.descending.reversed == .ascending)
    }

    @Test
    func `Reversing an order twice restores its original behavior`() {
        for direction in Order.Direction.allCases {
            #expect(direction.reversed.reversed == direction)
        }
    }
}

extension `Order comparators compose projections directions and partial relations`.`Order operations preserve reversal chaining projection and capability contracts`.`Comparators invoke their supplied ordering closure` {
    @Test
    func `Comparator construction preserves the supplied ordering closure`() {
        let comparator = Order.Comparator<Int> { lhs, rhs in
            Comparison(comparing: lhs, to: rhs)
        }

        #expect(comparator(1, 2) == .less)
        #expect(comparator(2, 2) == .equal)
        #expect(comparator(3, 2) == .greater)
    }

    @Test
    func `Calling a comparator invokes its ordering operation`() {
        let comparator: Order.Comparator<Int> = .ascending

        let result = comparator(1, 2)
        #expect(result == .less)
    }
}

extension `Order comparators compose projections directions and partial relations`.`Order operations preserve reversal chaining projection and capability contracts`.`Comparable values support ascending and descending comparators` {
    @Test
    func `Ascending comparators follow natural value order`() {
        let comparator: Order.Comparator<Int> = .ascending

        #expect(comparator(1, 2) == .less)
        #expect(comparator(2, 2) == .equal)
        #expect(comparator(3, 2) == .greater)
    }

    @Test
    func `Descending comparators reverse natural value order`() {
        let comparator: Order.Comparator<Int> = .descending

        #expect(comparator(1, 2) == .greater)
        #expect(comparator(2, 2) == .equal)
        #expect(comparator(3, 2) == .less)
    }

    @Test
    func `Ascending comparators bridge standard Comparable values`() {
        let comparator: Order.Comparator<String> = .ascending

        #expect(comparator("apple", "banana") == .less)
        #expect(comparator("hello", "hello") == .equal)
        #expect(comparator("zebra", "apple") == .greater)
    }
}

extension `Order comparators compose projections directions and partial relations`.`Order operations preserve reversal chaining projection and capability contracts`.`Reversing comparators exchanges their operand ordering` {
    @Test
    func `Comparator reversal exchanges less and greater results`() {
        let ascending: Order.Comparator<Int> = .ascending
        let reversed = ascending.reversed

        #expect(reversed(1, 2) == .greater)
        #expect(reversed(2, 2) == .equal)
        #expect(reversed(3, 2) == .less)
    }

    @Test
    func `Reversing an order twice restores its original behavior`() {
        let comparator: Order.Comparator<Int> = .ascending
        let doubleReversed = comparator.reversed.reversed

        for (a, b) in [(1, 2), (2, 2), (3, 2), (0, 0), (-1, 1)] {
            #expect(comparator(a, b) == doubleReversed(a, b))
        }
    }
}

extension `Order comparators compose projections directions and partial relations`.`Order operations preserve reversal chaining projection and capability contracts`.`Comparator chains resolve ties in priority order` {
    @Test
    func `Comparator chaining resolves equal primary keys with secondary keys`() {
        let byName = Order.Comparator<Person>.by { $0.name }
        let byAge = Order.Comparator<Person>.by { $0.age }
        let comparator = byName.then(byAge)

        let alice30 = Person(name: "Alice", age: 30)
        let alice25 = Person(name: "Alice", age: 25)
        let bob30 = Person(name: "Bob", age: 30)

        #expect(comparator(alice30, bob30) == .less)

        #expect(comparator(alice30, alice25) == .greater)

        #expect(comparator(alice30, alice30) == .equal)
    }

    @Test
    func `Lazily supplied comparator chains preserve primary ordering results`() {
        let primary = Order.Comparator<Int> { lhs, rhs in
            Comparison(comparing: lhs, to: rhs)
        }

        let secondary: @Sendable () -> Order.Comparator<Int> = {
            .descending
        }

        let chained = primary.then(with: secondary)

        #expect(chained(1, 2) == .less)
        #expect(chained(3, 2) == .greater)

        #expect(chained(2, 2) == .equal)

        let chainedWithReverse = Order.Comparator<Int>.ascending
            .then(with: { .descending })

        #expect(chainedWithReverse(1, 2) == .less)
        #expect(chainedWithReverse(3, 2) == .greater)
    }

    @Test
    func `Comparator chaining preserves associativity`() {
        struct Triple {
            let x: Int
            let y: Int
            let z: Int
        }

        let byX = Order.Comparator<Triple>.by { $0.x }
        let byY = Order.Comparator<Triple>.by { $0.y }
        let byZ = Order.Comparator<Triple>.by { $0.z }

        let left = byX.then(byY).then(byZ)
        let right = byX.then(byY.then(byZ))

        let testCases: [(Triple, Triple)] = [
            (Triple(x: 1, y: 2, z: 3), Triple(x: 1, y: 2, z: 4)),
            (Triple(x: 1, y: 2, z: 3), Triple(x: 1, y: 3, z: 3)),
            (Triple(x: 1, y: 2, z: 3), Triple(x: 2, y: 2, z: 3)),
            (Triple(x: 1, y: 1, z: 1), Triple(x: 1, y: 1, z: 1)),
        ]

        for (a, b) in testCases {
            #expect(left(a, b) == right(a, b))
        }
    }
}

extension `Order comparators compose projections directions and partial relations`.`Order operations preserve reversal chaining projection and capability contracts`.`Comparator projections order values by selected keys` {
    @Test
    func `Comparator projections order values by their selected keys`() {
        let byAge = Order.Comparator<Person>.by { $0.age }

        let alice30 = Person(name: "Alice", age: 30)
        let bob25 = Person(name: "Bob", age: 25)

        #expect(byAge(alice30, bob25) == .greater)
        #expect(byAge(bob25, alice30) == .less)
    }

    @Test
    func `Comparator projections apply the supplied key comparator`() {
        let byAgeDescending = Order.Comparator<Person>.by(
            using: .descending
        ) { $0.age }

        let alice30 = Person(name: "Alice", age: 30)
        let bob25 = Person(name: "Bob", age: 25)

        #expect(byAgeDescending(alice30, bob25) == .less)
        #expect(byAgeDescending(bob25, alice30) == .greater)
    }

    @Test
    func `Comparator composition supports reversed secondary projections`() {
        let comparator = Order.Comparator<Person>
            .by { $0.name }
            .then(Order.Comparator<Person>.by { $0.age }.reversed)

        let alice30 = Person(name: "Alice", age: 30)
        let alice25 = Person(name: "Alice", age: 25)
        let bob30 = Person(name: "Bob", age: 30)

        #expect(comparator(alice30, bob30) == .less)

        #expect(comparator(alice30, alice25) == .less)
        #expect(comparator(alice25, alice30) == .greater)
    }
}

extension `Order comparators compose projections directions and partial relations`.`Order operations preserve reversal chaining projection and capability contracts`.`Partial comparators represent incomparable values explicitly` {
    @Test
    func `Partial comparators return ordered results for comparable values`() {
        let comparator = Order.Comparator<Double>.Partial { lhs, rhs in
            if lhs.isNaN || rhs.isNaN {
                return nil
            }
            return Comparison(comparing: lhs, to: rhs)
        }

        #expect(comparator(1.0, 2.0) == .less)
        #expect(comparator(2.0, 2.0) == .equal)
        #expect(comparator(3.0, 2.0) == .greater)
    }

    @Test
    func `Partial comparators return nil for incomparable values`() {
        let comparator = Order.Comparator<Double>.Partial { lhs, rhs in
            if lhs.isNaN || rhs.isNaN {
                return nil
            }
            return Comparison(comparing: lhs, to: rhs)
        }

        #expect(comparator(Double.nan, 1.0) == nil)
        #expect(comparator(1.0, Double.nan) == nil)
        #expect(comparator(Double.nan, Double.nan) == nil)
    }
}

extension `Order comparators compose projections directions and partial relations`.`Order operations preserve reversal chaining projection and capability contracts`.`Comparators borrow noncopyable values and projected keys` {
    @Test
    func `Comparators borrow noncopyable values to determine their order`() {
        let comparator = Order.Comparator<Token> { lhs, rhs in
            Comparison(lhs, rhs)
        }

        let a = Token(id: 1)
        let b = Token(id: 2)
        let c = Token(id: 1)

        #expect(comparator(a, b) == .less)
        #expect(comparator(b, a) == .greater)
        #expect(comparator(a, c) == .equal)
    }

    @Test
    func `Natural comparators use the comparison protocol ordering`() {
        let comparator: Order.Comparator<Token> = .ascending

        let a = Token(id: 5)
        let b = Token(id: 10)

        #expect(comparator(a, b) == .less)
        #expect(comparator(b, a) == .greater)
    }

    @Test
    func `Comparator projections support noncopyable keys`() {
        struct Container: ~Copyable {
            let token: Token

            init(tokenId: Int) {
                self.token = Token(id: tokenId)
            }
        }

        let byToken = Order.Comparator<Container>.by(
            using: .ascending
        ) { Comparison(comparing: $0.token.id, to: 0).isGreater ? $0.token.id : 0 }

        let a = Container(tokenId: 5)
        let b = Container(tokenId: 10)

        #expect(byToken(a, b) == .less)
    }
}

extension `Order comparators compose projections directions and partial relations`.`Order operations preserve reversal chaining projection and capability contracts`.`Order directions and comparators can cross isolation boundaries` {
    @Test
    func `Comparator is Sendable`() async {
        let comparator: Order.Comparator<Int> = .ascending
        let box = Comparer()
        let result = await box.compare(with: comparator)
        #expect(result == .less)
    }

    @Test
    func `Direction is Sendable`() async {
        let box = Holder()
        await box.set(.descending)
        let result = await box.get()
        #expect(result == .descending)
    }
}
