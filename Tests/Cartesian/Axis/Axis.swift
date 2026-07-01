//
//  Axis.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Foundation
import Testing

@testable import Cartesian
import Units

// MARK: - Axis2

@Suite("Axis2")
struct Axis2Tests {
/// Tests that the cases .u and .v exist and are distinct.
///
	@Test("Cases")
	func cases() async throws {
		let u = Axis2.u()
		let v = Axis2.v()

		#expect(u != v)
	}

/// Tests the index-based initializer for in-range and out-of-range indices.
///
/// - init(0) → .u
/// - init(1) → .v
/// - init(2) → .v (default fallback: anything != 0 becomes .v)
///
	@Test("Index Initializer")
	func indexInitializer() async throws {
		#expect(Axis2(0) == .u())
		#expect(Axis2(1) == .v())
		#expect(Axis2(2) == .v())
	}

/// Tests that .index returns the correct integer for each case.
///
/// - .u.index == 0
/// - .v.index == 1
///
	@Test("Index Property")
	func indexProperty() async throws {
		#expect(Axis2.u().index == 0)
		#expect(Axis2.v().index == 1)
	}

/// Tests the static convenience properties .U and .V are positive axes.
///
	@Test("Static Properties")
	func staticProperties() async throws {
		#expect(Axis2.U == .u(negative: false))
		#expect(Axis2.V == .v(negative: false))
	}

/// Tests that Equatable works for same-case same-polarity comparison.
///
	@Test("Equatable")
	func equatable() async throws {
		#expect(Axis2.u() == Axis2.u())
		#expect(Axis2.v() == Axis2.v())
		#expect(Axis2.u() != Axis2.v())
		#expect(Axis2.u(negative: false) != Axis2.u(negative: true))
	}
}

extension Axis2Tests {
	@Suite("Inverse")
	struct Inverse {
	/// Tests that inverse of a positive axis is the negative axis.
	///
	/// .u(negative: false).inverse == .u(negative: true)
	///
		@Test("positive axis inverse is negative")
		func positiveAxisInverseIsNegative() async throws {
			let axis = Axis2.u(negative: false)
			let inv = axis.inverse

			#expect(inv == .u(negative: true))
		}

	/// Tests that inverse of a negative axis is the positive axis.
	///
	/// .u(negative: true).inverse == .u(negative: false)
	///
		@Test("negative axis inverse is positive")
		func negativeAxisInverseIsPositive() async throws {
			let axis = Axis2.u(negative: true)
			let inv = axis.inverse

			#expect(inv == .u(negative: false))
		}

	/// Tests that inverse works correctly for the .v case.
	///
		@Test("v axis inverse")
		func vAxisInverse() async throws {
			#expect(Axis2.v(negative: false).inverse == .v(negative: true))
			#expect(Axis2.v(negative: true).inverse == .v(negative: false))
		}
	}
}

extension Axis2Tests {
	@Suite("Invert")
	struct Invert {
	/// Tests that invert() mutates a positive axis to negative.
	///
		@Test("positive becomes negative")
		func positiveBecomeNegative() async throws {
			var axis = Axis2.u(negative: false)
			axis.invert()

			#expect(axis == .u(negative: true))
		}

	/// Tests that invert() mutates a negative axis to positive.
	///
		@Test("negative becomes positive")
		func negativeBecomePositive() async throws {
			var axis = Axis2.v(negative: true)
			axis.invert()

			#expect(axis == .v(negative: false))
		}

	/// Tests that calling invert() twice returns to the original axis.
	///
		@Test("double invert is identity")
		func doubleInvertIsIdentity() async throws {
			let original = Axis2.u(negative: false)
			var axis = original
			axis.invert()
			axis.invert()

			#expect(axis == original)
		}
	}
}

// MARK: - Axis3

@Suite("Axis3")
struct Axis3Tests {
/// Tests that the cases .x, .y, and .z exist and are distinct.
///
	@Test("Cases")
	func cases() async throws {
		let x = Axis3.x()
		let y = Axis3.y()
		let z = Axis3.z()

		#expect(x != y)
		#expect(y != z)
		#expect(x != z)
	}

/// Tests the index-based initializer.
///
/// - init(0) → .x
/// - init(1) → .y
/// - init(2+) → .z (default fallback)
///
	@Test("Index Initializer")
	func indexInitializer() async throws {
		#expect(Axis3(0) == .x())
		#expect(Axis3(1) == .y())
		#expect(Axis3(2) == .z())
		#expect(Axis3(99) == .z())
	}

/// Tests that .index returns the correct integer for each case.
///
/// - .x.index == 0
/// - .y.index == 1
/// - .z.index == 2
///
	@Test("Index Property")
	func indexProperty() async throws {
		#expect(Axis3.x().index == 0)
		#expect(Axis3.y().index == 1)
		#expect(Axis3.z().index == 2)
	}

/// Tests the static convenience properties .X, .Y, and .Z are positive axes.
///
	@Test("Static Properties")
	func staticProperties() async throws {
		#expect(Axis3.X == .x(negative: false))
		#expect(Axis3.Y == .y(negative: false))
		#expect(Axis3.Z == .z(negative: false))
	}

/// Tests that Equatable works for same-case same-polarity comparison.
///
	@Test("Equatable")
	func equatable() async throws {
		#expect(Axis3.x() == Axis3.x())
		#expect(Axis3.y() == Axis3.y())
		#expect(Axis3.z() == Axis3.z())
		#expect(Axis3.x() != Axis3.y())
		#expect(Axis3.y() != Axis3.z())
		#expect(Axis3.x(negative: false) != Axis3.x(negative: true))
	}
}

extension Axis3Tests {
	@Suite("Inverse")
	struct Inverse {
	/// Tests that inverse of a positive X axis is the negative X axis.
	///
		@Test("positive x inverse is negative x")
		func positiveXInverseIsNegativeX() async throws {
			let axis = Axis3.x(negative: false)
			let inv = axis.inverse

			#expect(inv == .x(negative: true))
		}

	/// Tests that inverse of a negative X axis is the positive X axis.
	///
		@Test("negative x inverse is positive x")
		func negativeXInverseIsPositiveX() async throws {
			let axis = Axis3.x(negative: true)
			let inv = axis.inverse

			#expect(inv == .x(negative: false))
		}

	/// Tests that inverse works correctly for the .y case.
	///
		@Test("y axis inverse")
		func yAxisInverse() async throws {
			#expect(Axis3.y(negative: false).inverse == .y(negative: true))
			#expect(Axis3.y(negative: true).inverse == .y(negative: false))
		}

	/// Tests that inverse works correctly for the .z case.
	///
		@Test("z axis inverse")
		func zAxisInverse() async throws {
			#expect(Axis3.z(negative: false).inverse == .z(negative: true))
			#expect(Axis3.z(negative: true).inverse == .z(negative: false))
		}
	}
}

extension Axis3Tests {
	@Suite("Invert")
	struct Invert {
	/// Tests that invert() mutates a positive axis to negative.
	///
		@Test("positive becomes negative")
		func positiveBecomeNegative() async throws {
			var axis = Axis3.x(negative: false)
			axis.invert()

			#expect(axis == .x(negative: true))
		}

	/// Tests that invert() mutates a negative axis to positive.
	///
		@Test("negative becomes positive")
		func negativeBecomePositive() async throws {
			var axis = Axis3.z(negative: true)
			axis.invert()

			#expect(axis == .z(negative: false))
		}

	/// Tests that calling invert() twice returns to the original axis.
	///
		@Test("double invert is identity")
		func doubleInvertIsIdentity() async throws {
			let original = Axis3.y(negative: false)
			var axis = original
			axis.invert()
			axis.invert()

			#expect(axis == original)
		}
	}
}
