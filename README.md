# swift-order

Use this package when you need a total order as a value: to sort or rank by a key, break ties with a second key, flip a direction, or compare `~Copyable` values by borrowing them. Start from `Order.Comparator<T>`, built from a closure, from a `Swift.Comparable` value as `ascending` or `descending`, or from a key with `by`. Use `Order.Comparator<T>.Partial` when some pairs are incomparable, `Order.Projection` when the key and its `Order.Direction` must be stored together, and `Order.Monotonicity` to describe how a function preserves or reverses an order.

## Laws

- `then` is lexicographic: the first comparator that does not answer `.equal` decides, and `.equal` comes back only when every comparator in the chain answers it. Chaining is associative.
- `then(with:)` builds its secondary comparator only when the primary answers `.equal`, and builds it again on every such tie. The result is never cached.
- `reversed` swaps `.less` and `.greater` and keeps `.equal`. Reversing twice gives back the original, on `Order.Comparison`, `Order.Comparator`, `Order.Direction` and `Order.Monotonicity`.
- `Order.Comparison(lhs, rhs)`, and with it every comparator built from `Swift.Comparable` (`ascending`, `descending`, `by`, `Order.Projection`), stops the program when the two values are unordered, as with a NaN `Double`. Such values belong in an `Order.Comparator<T>.Partial`, which answers `nil` for an incomparable pair.
- `isBefore`, `isAfter` and `isEquivalent(to:)` mean `.less`, `.greater` and `.equal` under the given comparator. Equivalence is the comparator's tie, not `==`: two values with different fields but the same key are equivalent. Without a comparator they use `ascending`.
- `Order.Monotonicity.composing` works like multiplying signs: `.constant` absorbs everything, matching directions give `.increasing`, and opposite directions give `.decreasing`. Prefix `!` is `reversed`.
- With the `Finite` trait, ordinals follow declaration order: `.less`, `.equal`, `.greater` are 0, 1, 2, and `.increasing`, `.decreasing`, `.constant` are 0, 1, 2. `init(_unchecked:ordinal:)` does not check its input: any ordinal of 2 or more becomes the last case.
