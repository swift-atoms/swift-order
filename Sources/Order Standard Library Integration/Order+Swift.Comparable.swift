public import Order_Orderable
public import Property

extension Swift.Comparable where Self: Copyable {

    @_disfavoredOverload
    public var order: Property::Property<Order, Self>.Inout {
        mutating _read {
            yield Property::Property<Order, Self>.Inout(&self)
        }
    }
}
