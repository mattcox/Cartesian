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
/// If the type cannot be normalized, returns nil.
///
	var normalized: Self? { get }

/// Normalizes the type.
///
/// - Returns: A boolean indicating if the normalization was successful.
///
	@discardableResult
	mutating func normalize() -> Bool
}

extension Normalizable where Self: VectorProtocol {
/// Normalizes the vector, but in case the magnitude of the vector is zero,
/// returns zero.
///
	@inlinable
	public var normalizedOrZero: Self {
		normalized ?? .zero
	}
}
