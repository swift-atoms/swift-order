import Order
import Testing

@Suite
struct `Order Pair Tests` {
    @Test
    func `Value pairs monotonicity with a payload`() {
        let value: Order.Monotonicity.Value<Int> = Pair(.increasing, 3)

        #expect(value.first == .increasing)
        #expect(value.second == 3)
    }

    @Test
    func `Value preserves every monotonicity case`() {
        let increasing: Order.Monotonicity.Value<String> = Pair(.increasing, "up")
        let decreasing: Order.Monotonicity.Value<String> = Pair(.decreasing, "down")
        let constant: Order.Monotonicity.Value<String> = Pair(.constant, "same")

        #expect(increasing.first.isIncreasing)
        #expect(decreasing.first.isDecreasing)
        #expect(constant.first.isConstant)
    }

    @Test
    func `Value is the corresponding Pair type`() {
        let value: Order.Monotonicity.Value<Bool> = Pair(.constant, true)
        let pair: Pair<Order.Monotonicity, Bool> = value

        #expect(pair.first == .constant)
        #expect(pair.second)
    }

    @Test
    func `Value preserves Pair noncopyable payload support`() {
        struct Payload: ~Copyable {
            let value: Int
        }

        let labelled: Order.Monotonicity.Value<Payload> = Pair(.decreasing, Payload(value: 7))
        #expect(labelled.first == .decreasing)
        #expect(labelled.second.value == 7)
    }
}
