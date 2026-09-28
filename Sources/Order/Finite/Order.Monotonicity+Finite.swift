#if Finite
public import Cardinal
public import Finite
public import Index
public import Ordinal
public import Tagged

extension Order.Monotonicity: Finite.Enumerable {

    @inlinable
    public static var count: Cardinal { Cardinal(3) }

    @inlinable
    public var ordinal: Ordinal {
        switch self {
        case .increasing: Ordinal(0)
        case .decreasing: Ordinal(1)
        case .constant: Ordinal(2)
        }
    }

    @inlinable
    public init(_unchecked: Void, ordinal: Ordinal) {
        switch ordinal.rawValue {
        case 0: self = .increasing
        case 1: self = .decreasing
        default: self = .constant
        }
    }
}
#endif
