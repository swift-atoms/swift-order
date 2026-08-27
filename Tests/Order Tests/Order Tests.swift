import Testing

@testable import Order

@Suite
struct `Order Tests` {
    @Suite struct Unit {}
    @Suite struct `Edge Case` {}
    @Suite struct Integration {}
    @Suite(.serialized) struct Performance {}
}

extension `Order Tests`.Unit {
    @Suite struct Direction {}
    @Suite struct Monotonicity {}
    @Suite struct Sendability {}
}

private actor Holder {
    var direction: Order.Direction = .ascending
}

extension Holder {
    func set(_ d: Order.Direction) { direction = d }
    func get() -> Order.Direction { direction }
}

extension `Order Tests`.Unit.Direction {
    @Test
    func `All cases exist`() {
        let cases = Order.Direction.allCases
        #expect(cases.count == 2)
        #expect(cases.contains(.ascending))
        #expect(cases.contains(.descending))
    }

    @Test
    func `Reversal`() {
        #expect(Order.Direction.ascending.reversed == .descending)
        #expect(Order.Direction.descending.reversed == .ascending)
    }

    @Test
    func `Reversal is involution`() {
        for direction in Order.Direction.allCases {
            #expect(direction.reversed.reversed == direction)
        }
    }
}

extension `Order Tests`.Unit.Monotonicity {
    @Test
    func `All cases exist`() {
        let cases = Order.Monotonicity.allCases
        #expect(cases.count == 3)
        #expect(cases.contains(.increasing))
        #expect(cases.contains(.decreasing))
        #expect(cases.contains(.constant))
    }

    @Test
    func `Reversal is involution`() {
        for monotonicity in Order.Monotonicity.allCases {
            #expect(monotonicity.reversed.reversed == monotonicity)
        }
    }

    @Test
    func `Composition with constant is constant`() {
        for monotonicity in Order.Monotonicity.allCases {
            #expect(monotonicity.composing(.constant) == .constant)
            #expect(Order.Monotonicity.constant.composing(monotonicity) == .constant)
        }
    }
}

extension `Order Tests`.Unit.Sendability {
    @Test
    func `Direction is Sendable`() async {
        let box = Holder()
        await box.set(.descending)
        let result = await box.get()
        #expect(result == .descending)
    }
}
