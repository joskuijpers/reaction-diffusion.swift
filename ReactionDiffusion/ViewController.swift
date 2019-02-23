//
//  ViewController.swift
//  ReactionDiffusion
//
//  Created by Jos Kuijpers on 22/02/2019.
//  Copyright © 2019 Jos Kuijpers. All rights reserved.
//

import Cocoa
import MetalKit

class ViewController: NSViewController {
    private var renderer: Renderer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let metalView = self.view as? MTKView {
            metalView.device = MTLCreateSystemDefaultDevice()
            if metalView.device == nil {
                print("Metal is not supported on this device")
                return
            }
            
            renderer = Renderer(view: metalView)
            if renderer == nil {
                print("Failed to initialize renderer")
                return
            }
            
            // Initialize renderer with view size
            renderer?.mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
            
            metalView.delegate = renderer
            metalView.clearColor = MTLClearColor(red: 0.1, green: 0.57, blue: 0.25, alpha: 1)
        }
    }

}

