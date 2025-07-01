//
//  Axis2.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A type representing an Axis in 2D space.
///
public enum Axis2 {
/// The U axis.
///
/// - Parameters:
///   - negative: The axis is -U.
///
	case u(negative: Bool = false)

/// The V axis.
///
/// - Parameters:
///   - negative: The axis is -V.
///
	case v(negative: Bool = false)
	
/// The U axis.
///
	static var U: Self {
		.u(negative: false)
	}

/// The V axis.
///
	static var V: Self {
		.v(negative: false)
	}
	
/// Returns the Axis as an index, where y is 0 and v is 1.
///
	var index: Int {
		switch self {
			case .u:
				return 0
			case .v:
				return 1
		}
	}
	
/// Initialize an Axis from an index in the range 0...1.
///
/// - Parameters:
///   - index: The index used to initialize the Axis, in the range 0...1.
///   - negative: Specifies whether the axis is negative, for example -U.
///
	init(_ index: Int, negative: Bool = false) {
		if index == 0 {
			self = .u(negative: negative)
		}
		else {
			self = .v(negative: negative)
		}
	}
}

extension Axis2 {
	public var inverse: Self {
		switch self {
			case .u(let negative):
				return .u(negative: negative == false)

			case .v(let negative):
				return .v(negative: negative == false)
		}
	}
	
	public mutating func invert() {
		switch self {
			case .u(let negative):
				self = .u(negative: negative == false)

			case .v(let negative):
				self = .v(negative: negative == false)
		}
	}
}

extension Axis2: Equatable {
	
}

extension Axis2: Sendable {
	
}


