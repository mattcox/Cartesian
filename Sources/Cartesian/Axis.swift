//
//  Axis.swift
//  Cartesian
//
//  Created by Matt Cox on 09/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A type representing an Axis in 3D euclidean space.
///
public enum Axis {
/// The X axis.
///
/// - Parameters:
///   - negative: The axis is -X.
///
	case x(negative: Bool = false)

/// The Y axis.
///
/// - Parameters:
///   - negative: The axis is -Y.
///
	case y(negative: Bool = false)

/// The Z axis.
///
/// - Parameters:
///   - negative: The axis is -Z.
///
	case z(negative: Bool = false)
	
/// The X axis.
///
	static var X: Axis {
		.x(negative: false)
	}

/// The Y axis.
///
	static var Y: Axis {
		.y(negative: false)
	}

/// The Z axis.
///
	static var Z: Axis {
		.z(negative: false)
	}
	
/// Returns the Axis as an index, where x is 0, y is 1, and z is 2.
///
	var index: Int {
		switch self {
			case .x:
				return 0
			case .y:
				return 1
			case .z:
				return 2
		}
	}
	
/// Initialize an Axis from an index in the range 0...2.
///
/// - Parameters:
///   - index: The index used to initialize the Axis, in the range 0...2.
///   - negative: Specifies whether the axis is negative, for example -X.
///
	init(_ index: Int, negative: Bool = false) {
		switch index {
			case 0:
				self = .x(negative: negative)
			case 1:
				self = .y(negative: negative)
			default:
				self = .z(negative: negative)
		}
	}
}

extension Axis {
	public var inverse: Self {
		switch self {
			case .x(let negative):
				return .x(negative: negative == false)

			case .y(let negative):
				return .y(negative: negative == false)

			case .z(let negative):
				return .z(negative: negative == false)
		}
	}
	
	public mutating func invert() {
		switch self {
			case .x(let negative):
				self = .x(negative: negative == false)

			case .y(let negative):
				self = .y(negative: negative == false)

			case .z(let negative):
				self = .z(negative: negative == false)
		}
	}
}

extension Axis: Equatable {
	
}

extension Axis: Sendable {
	
}
