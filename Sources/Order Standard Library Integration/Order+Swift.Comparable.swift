public import Order_Orderable
internal import Property
public import Property_Inout

extension Swift.Comparable where Self: Copyable {

    @_disfavoredOverload
    public var order: Property::Property<Order, Self>.Inout {
        mutating _read {
            yield Property::Property<Order, Self>.Inout(&self)
        }
    }
}
