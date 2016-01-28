//
//  KMGradientView.swift
//  Komikan
//
//  Created by Seth on 2016-01-28.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KMGradientView: NSView {

    // The color for the start of the gradiebt
    var startColor : NSColor = NSColor(calibratedRed: 0, green: 0, blue: 0, alpha: 0.5);
    
    // The color for the end of the gradient
    var endColor : NSColor = NSColor.clearColor();
    
    // The angle of the gradient
    var angle : CGFloat = 90;
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
        // Set the view to have a core animation layer
        self.wantsLayer = true;
        
        // Draw the gradient
        redrawGradient();
    }
    
    func redrawGradient() {
        // Create the gradient
        let gradient : NSGradient = NSGradient(startingColor: startColor, endingColor: endColor)!;
        
        // Draw it in the views rect
        gradient.drawInRect(self.bounds, angle: angle);
    }
}
