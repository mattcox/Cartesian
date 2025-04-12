//
//  Matrix3x3.swift
//  Cartesian
//
//  Created by Matt Cox on 09/04/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

/// A type that represents a 3x3 ``Matrix``.
///
public protocol Matrix3x3: Matrix, SquareMatrix {

}

extension Matrix3x3 {
	public static var columns: Int {
		3
	}

	public static var rows: Int {
		3
	}
}
