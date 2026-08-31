//
//  Normalizable.swift
//  Cartesian
//
//  Created by Matt Cox on 14/04/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

import RealModule

/// A type that can be normalized.
///
public protocol Normalizable {
/// Normalizes the type.
///
	var normalized: Self { get }

/// Normalizes the type.
///
	mutating func normalize()
}

extension Normalizable where Self: VectorMath & MagnitudeMeasurable, Self.Component: Real, Self.Magnitude == Self.Component {
/// Normalizes the vector, but in case the magnitude of the vector is zero,
/// returns zero.
///
	public var normalizedOrZero: Self {
		let length = self.magnitude
		guard length.isApproximatelyEqual(to: .zero) else {
			return .zero
		}
		return self / length
	}
}
