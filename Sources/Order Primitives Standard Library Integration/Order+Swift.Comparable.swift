public import Order_Orderable_Primitives
internal import Property_Primitives

extension Swift.Comparable where Self: Copyable {

    @_disfavoredOverload
    public var order: Property<Order, Self>.Inout {
        mutating _read {
            yield Property<Order, Self>.Inout(&self)
        }
    }
}
