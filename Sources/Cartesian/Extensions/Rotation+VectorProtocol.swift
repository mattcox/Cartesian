//
//  Rotation+VectorProtocol.swift
//  Cartesian
//
//  Created by Matt Cox on 02/05/2025.
//  Copyright © 2025 Matt Cox. All rights reserved.
//

import Foundation
import RealModule
import Units

extension Rotation: Normalizable {
	
}

extension Rotation: VectorMath {
	
}

extension Rotation: VectorProtocol {
	public static var count: Int {
		Value.scalarCount
	}
	
	public init() {
		self = .zero
	}

	public init<C>(_ collection: C) where C : Collection, Component == C.Element {
		var value: Self = .zero
		for enumerator in collection.prefix(Self.count).enumerated() {
			value[enumerator.offset] = enumerator.element
		}
		self = value
	}

	public mutating func clear() {
		self = .zero
	}
}
