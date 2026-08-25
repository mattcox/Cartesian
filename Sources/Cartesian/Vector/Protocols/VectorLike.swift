//
//  VectorLike.swift
//  Cartesian
//
//  Created by Matt Cox on 02/07/2026.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

/// A vector that can act as a Vector2.
///
public protocol Vector2Like: VectorProtocol {
	
}

extension Vector2Like {
	static var count: Int {
		2
	}
}

/// A vector that can act as a Vector3.
///
public protocol Vector3Like: VectorProtocol {

}

extension Vector3Like {
	static var count: Int {
		3
	}
}

/// A vector that can act as a Vector4.
///
public protocol Vector4Like: VectorProtocol {

}

extension Vector4Like {
	static var count: Int {
		4
	}
}
