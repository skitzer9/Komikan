//
//  KMReaderPageJumpCollectionItem.swift
//  Komikan
//
//  Created by Seth on 2016-03-20.
//  Copyright © 2016 DrabWeb. All rights reserved.
//

import Cocoa

class KMReaderPageJumpCollectionItem: NSCollectionViewItem {

    /// The image view for the thumbnail
    @IBOutlet var thumbnailImageView: KMRasterizedImageView!
    
    override func mouseDown(theEvent: NSEvent) {
        // Jump to this page
        (self.representedObject as! KMReaderPageJumpGridItem).readerViewController.jumpToPage((self.representedObject as! KMReaderPageJumpGridItem).page, round: false);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        // Do view setup here.
        
        // Bind the alpha value of the thumbnail to if it is the current page
        self.thumbnailImageView.bind("alphaValue", toObject: self, withKeyPath: "representedObject.alpha", options: nil);
    }
}