//
//  Invertible.swift
//  Cartesian
//
//  Created by Matt Cox on 11/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A type that can be inverted to the opposite form of itself.
///
public protocol Invertible {
/// An inverted version of itself.
///
	var inverse: Self { get }
	
/// Inverts the value.
///
	mutating func invert()
}
