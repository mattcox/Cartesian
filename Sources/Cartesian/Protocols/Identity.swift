//
//  Identity.swift
//  Cartesian
//
//  Created by Matt Cox on 17/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A type that can be set to identity.
///
public protocol Identity {
/// Get this object set to identity.
///
	static var identity: Self { get }

/// Tests if the object is identity.
///
	var isIdentity: Bool { get }
	
/// Set the object to identity.
///
	mutating func toIdentity()
}
