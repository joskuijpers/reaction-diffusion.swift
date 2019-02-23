//
//  Renderer.swift
//  ReactionDiffusion
//
//  Created by Jos Kuijpers on 22/02/2019.
//  Copyright © 2019 Jos Kuijpers. All rights reserved.
//

import Foundation
import MetalKit
import Metal

struct Vertex2 {
    var position: float2
    var uv: float2
}

struct Vertex3 {
    var position: float3
    var color: float4
}

class Renderer : NSObject, MTKViewDelegate {
    let device: MTLDevice
//    let texture: MTLTexture?
    
    let vertexBuffer: MTLBuffer?
    var vertices: [Vertex3] = [
        Vertex3(position: float3(0,1,0), color: float4(1,0,0,1)),
        Vertex3(position: float3(-1,-1,0), color: float4(0,1,0,1)),
        Vertex3(position: float3(1,-1,0), color: float4(0,0,1,1))
    ]
//    let vertices: [Vertex] = [
//        Vertex(position: float2(250, -250), uv: float2(1, 0)),
//        Vertex(position: float2(-250, -250), uv: float2(0, 0)),
//        Vertex(position: float2(-250, 250), uv: float2(0, 1)),
//
//        Vertex(position: float2(250, -250), uv: float2(1, 0)),
//        Vertex(position: float2(-250, 250), uv: float2(0, 1)),
//        Vertex(position: float2(250, 250), uv: float2(1, 1)),
//        ]
    
    let renderPipelineState: MTLRenderPipelineState
    let commandQueue: MTLCommandQueue?
    
//    var viewportSize: vector_uint2
    
    init?(view: MTKView) {
        guard let d = view.device else {
            return nil
        }
        device = d
        
        
        
        
        
        
        /////////////////////////////////////////////////////////////// BEGIN OCPY
        
        guard let imageFileLocation = Bundle.main.url(forResource: "Image", withExtension: "tga") else {
            print("Could not find image in bundle")
            return nil
        }
        
        let image = Image(url: imageFileLocation)
//        if image == nil {
//            print("Could not load image")
//            return nil
//        }

        
        let textureDescriptor = MTLTextureDescriptor()
        
        // Indicate that each pixel has a blue, green, red, and alpha channel, where each channel is
        // an 8-bit unsigned normalized value (i.e. 0 maps to 0.0 and 255 maps to 1.0)
        textureDescriptor.pixelFormat = .bgra8Unorm

        // Set the pixel dimensions of the texture
        textureDescriptor.width = image.width
        textureDescriptor.height = image.height
        
        // Create the texture from the device by using the descriptor
//        texture = device.makeTexture(descriptor: textureDescriptor)

        // Calculate the number of bytes per row of our image.
//        let bytesPerRow = 4 * image.width
        
//        let region = MTLRegion(origin: MTLOriginMake(0, 0, 0), size: MTLSize(width: image.width, height: image.height, depth: 1))


        // Copy the bytes from our data object into the texture
//        texture?.replace(region: region, mipmapLevel: 0, withBytes: image.data.bytes, bytesPerRow: bytesPerRow)

////// CREATE BUFFERS
        
        // Create our vertex buffer, and initialize it with our quadVertices array
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex3>.stride * vertices.count, options: .storageModeShared)

        /// Create our render pipeline

////// CREATE PIPELINE STATE
        
        // Load all the shader files with a .metal file extension in the project
        let defaultLibrary = device.makeDefaultLibrary()

        // Load the vertex function from the library
        let vertexFunction = defaultLibrary?.makeFunction(name: "basic_vertex_function")

        // Load the fragment function from the library
        let fragmentFunction = defaultLibrary?.makeFunction(name: "basic_fragment_function")


        // Set up a descriptor for creating a pipeline state object
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.label = "Texturing Pipeline"
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat

        do {
            renderPipelineState = try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            print(error.localizedDescription)
            return nil
        }

////// CREATE COMMAND QUEUE
        commandQueue = device.makeCommandQueue()

        
        //////////////////////////////////// END
        
    }
    
    
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
//        viewportSize.x = size.width
//        viewportSize.y = size.height
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable, let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        // Create a byffer from the queue
        let commandBuffer = commandQueue?.makeCommandBuffer()
        commandBuffer?.label = "MyCommand"

        let commandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        commandEncoder?.label = "MyRenderEncoder"
        
            // Set the region of the drawable to which we'll draw.
//            [renderEncoder setViewport:(MTLViewport){0.0, 0.0, _viewportSize.x, _viewportSize.y, -1.0, 1.0 }];
        
        commandEncoder?.setRenderPipelineState(renderPipelineState)
        
        // Pass vertexbuffer at index 0
        commandEncoder?.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        
        // Draw primitive
        commandEncoder?.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        commandEncoder?.endEncoding()
        
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
//            [renderEncoder setVertexBuffer:_vertices
//                offset:0
//                atIndex:AAPLVertexInputIndexVertices];
//
//            [renderEncoder setVertexBytes:&_viewportSize
//                length:sizeof(_viewportSize)
//                atIndex:AAPLVertexInputIndexViewportSize];
        
            // Set the texture object.  The AAPLTextureIndexBaseColor enum value corresponds
            ///  to the 'colorMap' argument in our 'samplingShader' function because its
            //   texture attribute qualifier also uses AAPLTextureIndexBaseColor for its index
//            [renderEncoder setFragmentTexture:_texture
//                atIndex:AAPLTextureIndexBaseColor];
        
            // Draw the vertices of our triangles
//            [renderEncoder drawPrimitives:MTLPrimitiveTypeTriangle
//                vertexStart:0
//                vertexCount:_numVertices];
        
    }
    
}
