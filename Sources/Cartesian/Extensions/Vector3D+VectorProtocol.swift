//
//  Vector3D+VectorProtocol.swift
//  Cartesian
//
//  Created by Matt Cox on 21/04/2025.
//  Copyright © 2026 Matt Cox. All rights reserved.
//

#if canImport(Spatial)
import Spatial
import Units

@available(iOS 16, macOS 13, tvOS 16, visionOS 1.0, macCatalyst 16, *)
extension Vector3D: AngleMeasurable {
	@inlinable
	public static func angle(from: Self, to: Self, by: Self?) -> Angle<Double> {
		let by = by ?? Self.zero
		
		let fromNormalized = (from - by).normalized
		let toNormalized = (to - by).normalized
		
		let dotProduct = fromNormalized.dot(toNormalized)
		
		return Angle(radians: acos(dotProduct))
	}
}

@available(iOS 16, macOS 13, tvOS 16, visionOS 1.0, macCatalyst 16, *)
extension Vector3D: Blendable {
	@inlinable
	public static func blend(from: Vector3D, to: Vector3D, by amount: Double) -> Vector3D {
		Self(simd_mix(from.simd, to.simd, simd_double3(repeating: amount)))
	}
	
	@inlinable
	public mutating func blend(to other: Self, by amount: Double) {
		self.simd = simd_mix(self.simd, other.simd, simd_double3(repeating: amount))
	}
}

@available(iOS 16, macOS 13, tvOS 16, visionOS 1.0, macCatalyst 16, *)
extension Vector3D: CrossProduct {
	
}

@available(iOS 16, macOS 13, tvOS 16, visionOS 1.0, macCatalyst 16, *)
extension Vector3D: DotProduct {
	
}

@available(iOS 16, macOS 13, tvOS 16, visionOS 1.0, macCatalyst 16, *)
extension Vector3D: EuclideanDistanceMeasurable {
	@inlinable
	public func distance(to other: Vector3D) -> Double {
		simd_distance(other.simd, simd)
	}
	
	@inlinable
	public func squaredDistance(to other: Vector3D) -> Double {
		simd_distance_squared(other.simd, simd)
	}
}

@available(iOS 16, macOS 13, tvOS 16, visionOS 1.0, macCatalyst 16, *)
extension Vector3D: MagnitudeMeasurable {

}

@available(iOS 16, macOS 13, tvOS 16, visionOS 1.0, macCatalyst 16, *)
extension Vector3D: MagnitudeAdjustable {
	@inlinable
	public var magnitude: Double {
		get {
			simd_length(simd)
		}
		set {
			var temp = simd_normalize(simd)
			temp *= newValue
			simd = temp
		}
	}
}

@available(iOS 16, macOS 13, tvOS 16, visionOS 1.0, macCatalyst 16, *)
extension Vector3D: Normalizable {
	
}

@available(iOS 16, macOS 13, tvOS 16, visionOS 1.0, macCatalyst 16, *)
extension Vector3D: SIMDConvertible {
	@inlinable
	public init(_ simd: simd_double3) {
		self = Vector3D(vector: simd)
	}
	
	@inlinable
	public var simd: simd_double3 {
		get {
			self.vector
		}
		set {
			self.vector = newValue
		}
	}
}

@available(iOS 16, macOS 13, tvOS 16, visionOS 1.0, macCatalyst 16, *)
extension Vector3D: VectorMath {
	@inlinable
	public func min() -> Double {
		simd.min()
	}
	
	@inlinable
	public func max() -> Double {
		simd.max()
	}
	
	@inlinable
	public func average() -> Double {
		simd.sum() / 3
	}
	
	@inlinable
	public func sum() -> Double {
		simd.sum()
	}
	
	@inlinable
	public static func min(_ a: Self, _ b: Self) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result[i] = Swift.min(a[i], b[i])
		}
		return result
	}

	@inlinable
	public static func max(_ a: Self, _ b: Self) -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result[i] = Swift.max(a[i], b[i])
		}
		return result
	}

	@inlinable
	public func abs() -> Self {
		var result = Self()
		for i in 0..<Self.count {
			result[i] = Swift.abs(self[i])
		}
		return result
	}
	
	@inlinable
	public static func + (lhs: Double, rhs: Vector3D) -> Vector3D {
		Self(simd_double3(repeating: lhs) + rhs.simd)
	}
	
	@inlinable
	public static func + (lhs: Vector3D, rhs: Double) -> Vector3D {
		Self(lhs.simd + simd_double3(repeating: rhs))
	}
	
	@inlinable
	public static func += (lhs: inout Vector3D, rhs: Double) {
		lhs.simd += simd_double3(repeating: rhs)
	}
	
	@inlinable
	public static func - (lhs: Double, rhs: Vector3D) -> Vector3D {
		Self(simd_double3(repeating: lhs) - rhs.simd)
	}
	
	@inlinable
	public static func - (lhs: Vector3D, rhs: Double) -> Vector3D {
		Self(lhs.simd - simd_double3(repeating: rhs))
	}

	@inlinable
	public static func -= (lhs: inout Vector3D, rhs: Double) {
		lhs.simd -= simd_double3(repeating: rhs)
	}
	
	@inlinable
	public static func * (lhs: Vector3D, rhs: Vector3D) -> Vector3D {
		Self(lhs.simd * rhs.simd)
	}
	
	@inlinable
	public static func *= (lhs: inout Vector3D, rhs: Vector3D) {
		lhs.simd *= rhs.simd
	}
	
	@inlinable
	public static func / (lhs: Vector3D, rhs: Vector3D) -> Vector3D {
		Self(lhs.simd / rhs.simd)
	}
	
	@inlinable
	public static func /= (lhs: inout Vector3D, rhs: Vector3D) {
		lhs.simd /= rhs.simd
	}
}

@available(iOS 16, macOS 13, tvOS 16, visionOS 1.0, macCatalyst 16, *)
extension Vector3D: VectorReflectable {
	@inlinable
	public func reflection(withNormal normal: Self) -> Self {
		Self(reflect(self.simd, n: normal.simd))
	}
}

@available(iOS 16, macOS 13, tvOS 16, visionOS 1.0, macCatalyst 16, *)
extension Vector3D: VectorRefractable {
	@inlinable
	public func refraction(withNormal normal: Self, indexOfRefraction: Double) -> Self {
		Self(refract(self.simd, n: normal.simd, eta: indexOfRefraction))
	}
}

@available(iOS 16, macOS 13, tvOS 16, visionOS 1.0, macCatalyst 16, *)
extension Vector3D: VectorProtocol {
	public typealias Component = Double
	
	@inlinable
	public static var count: Int {
		3
	}
	
	@inlinable
	public init<C>(_ collection: C) where C : Collection, Component == C.Element {
		var vector = Self()
		for enumerator in collection.prefix(Self.count).enumerated() {
			vector[enumerator.offset] = enumerator.element
		}
		self = vector
	}
	
	@inlinable
	public mutating func clear() {
		self = .zero
	}
	
	@inlinable
	public subscript(index: Int) -> Double {
		get {
			switch index {
				case 0:
					self.x
				case 1:
					self.y
				case 2:
					self.z
				default:
					fatalError("Index out of bounds")
			}
		}
		set {
			switch index {
				case 0:
					self.x = newValue
				case 1:
					self.y = newValue
				case 2:
					self.z = newValue
				default:
					fatalError("Index out of bounds")
			}
		}
	}
}
#endif
