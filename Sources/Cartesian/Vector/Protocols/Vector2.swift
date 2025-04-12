//
//  Vector2.swift
//  Cartesian
//
//  Created by Matt Cox on 02/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A two dimensional ``Vector``.
///
public protocol Vector2: Vector {
/// Initializes the vector with two component values.
///
/// - Parameters:
///   - first: The value of the first component.
///   - second: The value of the second component.
///
	init(_ first: Component, _ second: Component)
}

extension Vector2 {
	public init(_ first: Component, _ second: Component) {
		self = Self([first, second])
	}

	public static var dimensions: Int {
		2
	}
}

extension Vector2 {
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
}
