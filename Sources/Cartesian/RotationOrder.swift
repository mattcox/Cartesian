//
//  RotationOrder.swift
//  Cartesian
//
//  Created by Matt Cox on 09/04/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

/// A type that defines the order that rotations are applied to a gimbal in 3D
/// space.
///
/// When calculating rotation in 3D space, the order the rotations are applied
/// matters.
///
/// If the rotations represent three nested gimbals:
/// ```
/// |-- Gimbal X
/// 	|-- Gimbal Y
/// 		|-- Gimbal Z
/// ```
/// As `Gimbal X` is rotated, the rotation plane for `Gimbal Y` and `Gimbal Z`
/// are modified, and as `Gimbal Y` is rotated, the rotation plane for
/// `Gimbal Z` is modified.
///
/// For example, with a rotation order of XYZ, and a rotation of X: 45.0°,
/// Y: 15.0°, and Z: 90.0°, the computed matrix will be:
/// ```
/// [[ 0.000, -0.707,  0.707,  0.000],
///  [ 0.966,  0.183,  0.183,  0.000],
///  [-0.259,  0.683,  0.683,  0.000],
///  [ 0.000,  0.000,  0.000,  1.000]]
/// ```
///
/// If the rotation order is modified to ZYX to invert the order, the same
/// rotations produce an entirely different matrix, as each level of the
/// nested gimbal provides a different rotation plane to the subsequent
/// levels.
/// ```
/// [[ 0.183, -0.966,  0.183,  0.000],
///  [ 0.707,  0.000, -0.707,  0.000],
///  [ 0.683,  0.259,  0.683,  0.000],
///  [ 0.000,  0.000,  0.000,  1.000]]
/// ```
///
/// - note: Due to the nature of the nested rotation gimbals, performing
/// some rotations can results in _gimbal lock_, where two rotation planes
/// align, preventing rotation along the third axis. This can be solved by
/// choosing a more suitable rotation order to compute the rotation.
///
public enum RotationOrder: Int, CaseIterable {
	case XYZ
	case XZY
	case YXZ
	case YZX
	case ZXY
	case ZYX
	
/// A default rotation order.
///
	public static let `default`: RotationOrder = .ZXY
	
/// The first element in the rotation order, where X is first, Y is second
/// and Z is third.
///
	@inlinable @usableFromInline
	var first: Axis3 {
		switch(self) {
			case .XYZ, .XZY:
				return .X
			case .YXZ, .YZX:
				return .Y
			case .ZXY, .ZYX:
				return .Z
		}
	}
	
/// The second element in the rotation order, where X is first, Y is second
/// and Z is third.
///
	@inlinable @usableFromInline
	var second: Axis3 {
		switch(self) {
			case .YXZ, .ZXY:
				return .X
			case .XYZ, .ZYX:
				return .Y
			case .XZY, .YZX:
				return .Z
		}
	}

/// The third element in the rotation order, where X is first, Y is second
/// and Z is third.
///
	@inlinable @usableFromInline
	var third: Axis3 {
		switch(self) {
			case .YZX, .ZYX:
				return .X
			case .XZY, .ZXY:
				return .Y
			case .XYZ, .YXZ:
				return .Z
		}
	}
	
/// Returns the element in the rotation order, specified by index.
///
	@inlinable @usableFromInline
	subscript(index: Int) -> Axis3 {
		switch(index) {
			case 0:
				return first
			case 1:
				return second
			case 2:
				return third
			default:
				preconditionFailure("Index out of Bounds")
		}
	}
}

extension RotationOrder: CustomStringConvertible {
	public var description: String {
		switch self {
			case .XYZ:
				"XYZ"
			case .XZY:
				"XZY"
			case .YXZ:
				"YXZ"
			case .YZX:
				"YZX"
			case .ZXY:
				"ZXY"
			case .ZYX:
				"ZYX"
		}
	}
}

extension RotationOrder: Equatable {
	
}

extension RotationOrder: Sendable {
	
}
