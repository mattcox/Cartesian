//
//  SIMDConvertible.swift
//  Cartesian
//
//  Created by Matt Cox on 09/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A protocol allowing clients to convert to and from values in a SIMD
/// compatible form.
///
public protocol SIMDConvertible {
/// The SIMD type that it can be converted between.
///
	associatedtype SIMDRepresentation
	
/// Initialize with a SIMD compatible object.
///
/// - Parameters:
///   - simd: The SIMD object compatible with this type.
///
	init(_ simd: SIMDRepresentation)

/// The value as a SIMD compatible object.
///
	var simd: SIMDRepresentation { get set }
}
