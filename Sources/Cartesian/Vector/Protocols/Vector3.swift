//
//  Vector3.swift
//  Cartesian
//
//  Created by Matt Cox on 02/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A three dimensional ``Vector``.
///
public protocol Vector3: Vector {
/// Initializes the vector with three component values.
///
/// - Parameters:
///   - first: The value of the first component.
///   - second: The value of the second component.
///   - third: The value of the third component.
///
	init(_ first: Component, _ second: Component, _ third: Component)
}

extension Vector3 {
	public init(_ first: Component, _ second: Component, _ third: Component) {
		self = Self([first, second, third])
	}

	public static var dimensions: Int {
		3
	}
}

extension Vector3 {
/// The first component of the vector.
///
	public var first: Component {
		get {
			self[0]
		}
		set {
			self[0] = newValue
		}
	}
	
/// The second component of the vector.
///
	public var second: Component {
		get {
			self[1]
		}
		set {
			self[1] = newValue
		}
	}
	
/// The third component of the vector.
///
	public var third: Component {
		get {
			self[2]
		}
		set {
			self[2] = newValue
		}
	}
}
