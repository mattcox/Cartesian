//
//  VectorProtocol.swift
//  Cartesian
//
//  Created by Matt Cox on 02/04/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

/// A type that represents a vector of arbitrary size.
///
/// A vector is an ordered collection of scalar values, typically used to 
/// represent quantities such as position, direction, velocity, or other 
/// multidimensional data in mathematical and computational contexts.
///
/// The number of components in the vector is implementation-defined.
///
public protocol VectorProtocol {
/// The scalar type used for specifying the vector components.
///
	associatedtype Component: Numeric

/// The number of components in the vector.
///
	static var count: Int { get }
	
/// An empty vector.
///
	static var zero: Self { get }

/// Initialize an empty vector.
///
	init()
	
/// Initialize the vector, setting all components to the provided value.
///
/// - Parameters:
///   - component: The value to set all components to.
///
	init(repeating component: Component)

/// Initialize the vector with the values in another vector.
///
/// The type of component for the two vectors must be the same, however the
/// number of components in the vectors can be different.
///
/// For example, if the source vector has 2 components, and this vector has
/// four components, the layout would become:
/// ```
/// [source[0], source[1], zero, zero]
/// ```
///
/// - Parameters:
///   - vector: The other vector used to initialize this object.
///
	init<T: VectorProtocol>(from vector: T) where T.Component == Self.Component
	
/// Initialize the vector with the values in another vector, repeating the
/// values from the source vector multiple times to fill the destination
/// vector.
///
/// For example, if the source object has 2 components, and this object has
/// five components, the layout will become:
/// ```
/// [source[0], source[1], source[0], source[1], source[0]]
/// ```
///
/// - Parameters:
///   - vector: The other vector used to initialize this object, repeating
///   the values as necessary.
///
	init<T: VectorProtocol>(repeating vector: T) where T.Component == Self.Component
	
/// Initialize the vector with a collection of component values.
///
/// The type of component for the two vectors must be the same, however the
/// number of components in the vectors can be different.
///
/// For example, if the source object is a collection with 2 components, and
/// this object has four components, the layout will become:
/// ```
/// [source[0], source[1], zero, zero]
/// ```
///
/// - Parameters:
///   - collection: The collection used to initialize this object.
///
	init<C: Collection>(_ collection: C) where C.Element == Component
	
/// Initialize the vector with the values in another vector, repeating the
/// values from the collection multiple times to fill the destination
/// vector.
///
/// For example, if the source object is a collection with 2 components, and
/// this object has five components, the layout will become:
/// ```
/// [source[0], source[1], source[0], source[1], source[0]]
/// ```
///
/// - Parameters:
///   - components: The collection used to initialize this object, repeating
///   the values as necessary.
///
	init<C: Collection>(repeating components: C) where C.Element == Component
	
/// Access a vector component by index.
///
/// - Parameters:
///   - index: The index of the component in the vector.
///
	subscript(_ index: Int) -> Component { get set }
	
/// Clear all components of the vector, setting them to a suitable default.
///
	mutating func clear()
}

extension VectorProtocol {
	static public var zero: Self {
		Self()
	}
	
	public init(repeating component: Component) {
		self = Self(Array(repeating: component, count: Self.count))
	}
	
	public init<T: VectorProtocol>(from vector: T) where T.Component == Self.Component {
		var values = Array(repeating: Component.zero, count: Self.count)
		for i in 0..<min(T.count, Self.count) {
			values[i] = vector[i]
		}
		self = Self(values)
	}
	
	public init<T: VectorProtocol>(repeating vector: T) where T.Component == Self.Component {
		guard T.count > 0 else {
			self = Self()
			return
		}
		
		var values: [Component] = []
		for i in 0..<T.count {
			values.append(vector[i])
		}
		
		self = Self(repeating: values)
	}
	
	public init<C: Collection>(repeating components: C) where C.Element == Component {
		guard components.isEmpty == false else {
			self = Self()
			return
		}
		
		let componentsCount = components.count
		
		let fullRepeats = Self.count / componentsCount
		let remainder = Self.count % componentsCount
		
		var values: [Component] = []
		values.reserveCapacity(Self.count)
		
		for _ in 0..<fullRepeats {
			values.append(contentsOf: components)
		}
		
		if remainder > 0 {
			values.append(contentsOf: components.prefix(remainder))
		}
		
		self = Self(values)
	}
}
