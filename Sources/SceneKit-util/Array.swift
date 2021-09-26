//
//  File.swift
//  
//
//  Created by narumij on 2021/09/24.
//

import Metal

extension Array {
    
    public init(of buffer: MTLBuffer ) {
        let pointer = buffer.contents().bindMemory( to: Element.self, capacity: buffer.length )
        let bufferPointer = UnsafeBufferPointer<Element>( start: pointer, count: buffer.length / MemoryLayout<Element>.stride )
        self.init( bufferPointer )
    }
    
    public func buffer( with device: MTLDevice, options: MTLResourceOptions = [] ) -> MTLBuffer? {
        self.isEmpty ? nil : device.makeBuffer(bytes: self,
                                               length: count * MemoryLayout<Element>.size,
                                               options: options )
    }
    
}

