//
//  RotationOrder.swift
//  Cartesian
//
//  Created by Matt Cox on 01/07/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Foundation
import Testing

@testable import Cartesian
import Units

@Suite("RotationOrder")
struct RotationOrderTests {
/// Tests that all six rotation order cases exist.
///
	@Test("All cases exist")
	func allCasesExist() async throws {
		let _ = RotationOrder.XYZ
		let _ = RotationOrder.XZY
		let _ = RotationOrder.YXZ
		let _ = RotationOrder.YZX
		let _ = RotationOrder.ZXY
		let _ = RotationOrder.ZYX
	}

/// Tests that CaseIterable returns exactly six cases.
///
	@Test("CaseIterable count")
	func caseIterableCount() async throws {
		#expect(RotationOrder.allCases.count == 6)
	}

/// Tests that the default rotation order is .ZXY.
///
	@Test("Default is ZXY")
	func defaultIsZXY() async throws {
		#expect(RotationOrder.default == .ZXY)
	}

/// Tests that CustomStringConvertible produces a non-empty string for every
/// case.
///
	@Test("CustomStringConvertible")
	func customStringConvertible() async throws {
		for order in RotationOrder.allCases {
			#expect(order.description.isEmpty == false)
		}
	}

/// Tests the description text matches the enum name for each case.
///
	@Test("Description text")
	func descriptionText() async throws {
		#expect(RotationOrder.XYZ.description == "XYZ")
		#expect(RotationOrder.XZY.description == "XZY")
		#expect(RotationOrder.YXZ.description == "YXZ")
		#expect(RotationOrder.YZX.description == "YZX")
		#expect(RotationOrder.ZXY.description == "ZXY")
		#expect(RotationOrder.ZYX.description == "ZYX")
	}

/// Tests Equatable conformance.
///
	@Test("Equatable")
	func equatable() async throws {
		#expect(RotationOrder.XYZ == .XYZ)
		#expect(RotationOrder.XYZ != .ZXY)
		#expect(RotationOrder.ZXY == .ZXY)
	}
}

extension RotationOrderTests {
	@Suite("Axis Order")
	struct AxisOrder {
	/// Tests that .XYZ returns the correct axes: X first, Y second, Z third.
	///
		@Test("XYZ order")
		func xyzOrder() async throws {
			let order = RotationOrder.XYZ

			#expect(order.first == .X)
			#expect(order.second == .Y)
			#expect(order.third == .Z)
		}

	/// Tests that .XZY returns the correct axes: X first, Z second, Y third.
	///
		@Test("XZY order")
		func xzyOrder() async throws {
			let order = RotationOrder.XZY

			#expect(order.first == .X)
			#expect(order.second == .Z)
			#expect(order.third == .Y)
		}

	/// Tests that .YXZ returns the correct axes: Y first, X second, Z third.
	///
		@Test("YXZ order")
		func yxzOrder() async throws {
			let order = RotationOrder.YXZ

			#expect(order.first == .Y)
			#expect(order.second == .X)
			#expect(order.third == .Z)
		}

	/// Tests that .YZX returns the correct axes: Y first, Z second, X third.
	///
		@Test("YZX order")
		func yzxOrder() async throws {
			let order = RotationOrder.YZX

			#expect(order.first == .Y)
			#expect(order.second == .Z)
			#expect(order.third == .X)
		}

	/// Tests that .ZXY returns the correct axes: Z first, X second, Y third.
	///
		@Test("ZXY order")
		func zxyOrder() async throws {
			let order = RotationOrder.ZXY

			#expect(order.first == .Z)
			#expect(order.second == .X)
			#expect(order.third == .Y)
		}

	/// Tests that .ZYX returns the correct axes: Z first, Y second, X third.
	///
		@Test("ZYX order")
		func zyxOrder() async throws {
			let order = RotationOrder.ZYX

			#expect(order.first == .Z)
			#expect(order.second == .Y)
			#expect(order.third == .X)
		}
	}
}

extension RotationOrderTests {
	@Suite("Subscript")
	struct Subscript {
	/// Tests that the subscript operator at indices 0, 1, 2 matches first,
	/// second, and third for .XYZ.
	///
		@Test("XYZ subscript")
		func xyzSubscript() async throws {
			let order = RotationOrder.XYZ

			#expect(order[0] == .X)
			#expect(order[1] == .Y)
			#expect(order[2] == .Z)
		}

	/// Tests that the subscript operator at indices 0, 1, 2 matches first,
	/// second, and third for .ZXY.
	///
		@Test("ZXY subscript")
		func zxySubscript() async throws {
			let order = RotationOrder.ZXY

			#expect(order[0] == .Z)
			#expect(order[1] == .X)
			#expect(order[2] == .Y)
		}

	/// Tests that subscript is consistent with first/second/third for every
	/// case.
	///
		@Test("Subscript consistency across all cases")
		func subscriptConsistency() async throws {
			for order in RotationOrder.allCases {
				#expect(order[0] == order.first)
				#expect(order[1] == order.second)
				#expect(order[2] == order.third)
			}
		}
	}
}
