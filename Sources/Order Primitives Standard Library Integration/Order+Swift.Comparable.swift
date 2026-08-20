// This source file is part of the Swift Institute open source project
//
// Copyright (c) 2025 Swift Institute and the Swift project authors
// Licensed under Apache License v2.0
//
// See LICENSE.md for license information
//
// SPDX-License-Identifier: Apache-2.0

public import Order_Orderable_Primitives
internal import Property_Primitives

// MARK: - .order Property for Swift.Comparable

/// Provides the `.order` property to all `Swift.Comparable` types.
///
/// This extension enables fluent ordering APIs for standard library types
/// like `String`, `Double`, `Float`, and `Character`.
///
/// ```swift
/// var name = "alice"
/// name.order.isBefore("bob")  // true
/// name.order.isAfter("bob")   // false
/// ```
///
/// Note: Marked `@_disfavoredOverload` so types that also conform to
/// `Order.Orderable` use the `Orderable` extension.
extension Swift.Comparable where Self: Copyable {
    /// Access fluent ordering APIs.
    ///
    /// Returns a `Property.Inout` that provides ordering methods like
    /// `.isBefore(_:)`, `.isAfter(_:)`, `.isEquivalent(to:)`.
    @_disfavoredOverload
    public var order: Property<Order, Self>.Inout {
        mutating _read {
            yield Property<Order, Self>.Inout(&self)
        }
    }
}
