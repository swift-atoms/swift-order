#if Finite
import Cardinal
import Order
import Ordinal
import Testing

extension Order.Monotonicity {
    @Suite struct Tests {
        @Suite struct Unit {}
            }
}

extension Order.Monotonicity.Tests.Unit {
    @Test
    func `count is three`() {
        #expect(Order.Monotonicity.count == Cardinal(UInt(3)))
    }

    @Test
    func `increasing has ordinal zero`() {
        let value = Order.Monotonicity.increasing
        #expect(value.ordinal == Ordinal(UInt(0)))
    }

    @Test
    func `decreasing has ordinal one`() {
        let value = Order.Monotonicity.decreasing
        #expect(value.ordinal == Ordinal(UInt(1)))
    }

    @Test
    func `constant has ordinal two`() {
        let value = Order.Monotonicity.constant
        #expect(value.ordinal == Ordinal(UInt(2)))
    }

    @Test
    func `increasing round-trips through ordinal`() {
        let ordinal = Order.Monotonicity.increasing.ordinal
        #expect(Order.Monotonicity(_unchecked: (), ordinal: ordinal).ordinal == ordinal)
    }

    @Test
    func `decreasing round-trips through ordinal`() {
        let ordinal = Order.Monotonicity.decreasing.ordinal
        #expect(Order.Monotonicity(_unchecked: (), ordinal: ordinal).ordinal == ordinal)
    }

    @Test
    func `constant round-trips through ordinal`() {
        let ordinal = Order.Monotonicity.constant.ordinal
        #expect(Order.Monotonicity(_unchecked: (), ordinal: ordinal).ordinal == ordinal)
    }
}
#endif
