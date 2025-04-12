//
//  Matrix4x4.swift
//  Cartesian
//
//  Created by Matt Cox on 09/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A type that represents a 4x4 ``Matrix``.
///
public protocol Matrix4x4: Matrix, SquareMatrix {

}

extension Matrix4x4 {
	public static var columns: Int {
		4
	}

	public static var rows: Int {
		4
	}
}
