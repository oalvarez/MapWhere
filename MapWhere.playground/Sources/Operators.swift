import Foundation

precedencegroup ForwardApplication {
  associativity: left
}

infix operator |>: ForwardApplication
public func |> <A, B>(a: A,
                      f: (A) -> B) -> B {
  return f(a)
}

precedencegroup ForwardComposition {
  associativity: left
  higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition

public func >>> <A, B, C>(f: @escaping (A) -> B,
                          g: @escaping (B) -> C) -> ((A) -> C) {
  return { a in
    g(f(a))
  }
}

public func map<A, B>(_ f: @escaping (A) -> B) -> ([A]) -> [B] {
  return { xs in xs.map(f) }
}

public func filter<A>(_ p: @escaping (A) -> Bool) -> ([A]) -> [A] {
  return { $0.filter(p) }
}

public func prop<Root, Value>(_ kp: WritableKeyPath<Root, Value>)
  -> (@escaping (Value) -> Value)
  -> (Root) -> Root {

    return { update in
      { root in
        var copy = root
        copy[keyPath: kp] = update(copy[keyPath: kp])
        return copy
      }
    }
}

func get<Root, Value>(_ kp: KeyPath<Root, Value>) -> (Root) -> Value {
  return { root in
    root[keyPath: kp]
  }
}

public typealias Setter<S, T, A, B> = (@escaping (A) -> B) -> (S) -> T

public func over<S, T, A, B>(
  _ setter: Setter<S, T, A, B>,
  _ f: @escaping (A) -> B
  ) -> (S) -> T {
  return setter(f)
}

public func set<S, T, A, B>(
  _ setter: Setter<S, T, A, B>,
  _ value: B
  ) -> (S) -> T {
  return over(setter, { _ in value })
}

prefix operator ^
public prefix func ^ <Root, Value>(kp: KeyPath<Root, Value>) -> (Root) -> Value {
  return get(kp)
}

public prefix func ^ <Root, Value>(_ kp: WritableKeyPath<Root, Value>)
  -> (@escaping (Value) -> Value)
  -> (Root) -> Root {
    return prop(kp)
}
