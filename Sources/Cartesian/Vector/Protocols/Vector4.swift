//
//  Vector4.swift
//  Cartesian
//
//  Created by Matt Cox on 02/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A four dimensional ``Vector``.
///
public protocol Vector4: Vector {
/// Initializes the vector with four component values.
///
/// - Parameters:
///   - first: The value of the first component.
///   - second: The value of the second component.
///   - third: The value of the third component.
///   - fourth: The value of the fourth component.
///
	init(_ first: Component, _ second: Component, _ third: Component, _ fourth: Component)
}

extension Vector4 {
	public init(_ first: Component, _ second: Component, _ third: Component, _ fourth: Component) {
		self = Self([first, second, third, fourth])
	}

	public static var count: Int {
		4
	}
}

extension Vector4 {
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
	
/// The fourth component of the vector.
///
	public var fourth: Component {
		get {
			self[3]
		}
		set {
			self[3] = newValue
		}
	}
}
