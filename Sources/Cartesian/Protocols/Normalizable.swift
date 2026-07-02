//
//  Normalizable.swift
//  Cartesian
//
//  Created by Matt Cox on 14/04/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

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
