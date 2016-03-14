//
//  AppDelegate.swift
//  Komikan
//
//  Created by Seth on 2015-12-31.
//  Copyright © 2015 DrabWeb. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSUserNotificationCenterDelegate {

    /// The File/Open Selected menu item
    @IBOutlet weak var openMenuItem: NSMenuItem!
    
    /// The Manga/Next Page menu item
    @IBOutlet weak var nextPageMenubarItem: NSMenuItem!
    
    /// The Manga/Previous Page menu item
    @IBOutlet weak var previousPageMenubarItem: NSMenuItem!
    
    /// The Manga/Jump to Page menu item
    @IBOutlet weak var jumpToPageMenuItem: NSMenuItem!
    
    /// The Manga/Bookmark menu item
    @IBOutlet weak var bookmarkCurrentPageMenuItem: NSMenuItem!
    
    /// The Manga/Dual Page menu item
    @IBOutlet weak var dualPageMenuItem: NSMenuItem!
    
    /// The Manga/Switch Dual Page Direction menu item
    @IBOutlet weak var switchDualPageDirectionMenuItem: NSMenuItem!
    
    /// The Manga/Fit Window to Page menu item
    @IBOutlet weak var fitWindowToPageMenuItem: NSMenuItem!
    
    /// The Komikan/Delete All Manga menu item
    @IBOutlet weak var deleteAllMangaMenuItem: NSMenuItem!
    
    /// The Collection/Add From E-Hentai menu item
    @IBOutlet weak var addFromEHMenuItem: NSMenuItem!
    
    /// The Komikan/Toggle Background Darken menu item
    @IBOutlet weak var toggleBackgroundDarkenMenuItem: NSMenuItem!
    
    /// The menu item that lets you toggle the info bar in the main window
    @IBOutlet weak var toggleInfoBarMenuItem: NSMenuItem!
    
    /// The Collection/Manage/Delete Selected menu item
    @IBOutlet weak var deleteSelectedMangaMenuItem: NSMenuItem!
    
    /// The Collection/Manage/Mark Selected as Read menu item
    @IBOutlet weak var markSelectedAsReadMenuItem: NSMenuItem!
    
    /// The Collection/Manage/Mark Selected as Unread menu item
    @IBOutlet weak var markSelectedAsUnreadMenuItem: NSMenuItem!
    
    /// The Collection/Manage/Set Selected Items Properties Menu Items
    @IBOutlet weak var setSelectedItemsPropertiesMenuItems: NSMenuItem!
    
    /// The File/Import / Add menu item
    @IBOutlet weak var importAddMenuItem: NSMenuItem!
    
    /// The Collection/Export Metadata for all Manga menu item
    @IBOutlet weak var exportJsonForAllMangaMenuItem: NSMenuItem!
    
    /// The Komikan/Export Metadata for all Manga for Migration menu item
    @IBOutlet weak var exportJsonForAllMangaForMigrationMenuItem: NSMenuItem!
    
    /// The Manga/Magnification/Zoom In menu item
    @IBOutlet weak var readerZoomInMenuItem: NSMenuItem!
    
    /// The Manga/Magnification/Zoom Out menu item
    @IBOutlet weak var readerZoomOutMenuItem: NSMenuItem!
    
    /// The Manga/Magnification/Reset Zoom menu item
    @IBOutlet weak var readerResetZoomMenuItem: NSMenuItem!
    
    /// The Manga/Rotation/Rotate 90° Left menu item
    @IBOutlet weak var readerRotateNinetyDegressLeftMenuItem: NSMenuItem!
    
    /// The Manga/Rotation/Rotate 90° Right menu item
    @IBOutlet weak var readerRotateNinetyDegressRightMenuItem: NSMenuItem!
    
    /// The Manga/Rotation/Reset Rotation menu item
    @IBOutlet weak var readerResetRotationMenuItem: NSMenuItem!
    
    /// The Collection/Manage/Fetch Metadata For Selected menu item
    @IBOutlet weak var fetchMetadataForSelectedMenuItem: NSMenuItem!
    
    /// The Collection/Toggle List View menu item
    @IBOutlet weak var toggleListViewMenuItem: NSMenuItem!
    
    /// The Manga/Notes/View Notes menu item
    @IBOutlet weak var readerOpenNotesMenuItem: NSMenuItem!
    
    /// The Manga/Notes/Toggle Edit Bar menu item
    @IBOutlet weak var readerToggleNotesEditBarMenuItem: NSMenuItem!
    
    /// The Window/Select Search Field menu item
    @IBOutlet weak var selectSearchFieldMenuItem: NSMenuItem!
    
    /// The Manga/Notes/Open in External Editor menu item
    @IBOutlet weak var openInExternalEditorMenuItem: NSMenuItem!
    
    /// The File/Edit Selected menu item
    @IBOutlet weak var editSelectedMenuItem: NSMenuItem!
    
    /// The Window/Select Manga View menu item
    @IBOutlet weak var selectMangaViewMenuItem: NSMenuItem!
    
    /// The Collection/Import... menu item
    @IBOutlet weak var importMenuItem: NSMenuItem!
    
    /// The view controller we will load for the reader
    var mangaReaderViewController: KMReaderViewController?;
    
    /// The File/Hide Komikan Folders menu item
    @IBOutlet weak var hideKomikanFoldersMenuItem: NSMenuItem!
    
    /// The File/Show Komikan Folders menu item
    @IBOutlet weak var showKomikanFoldersMenuItem: NSMenuItem!
    
    /// The grid controller for the manga grid
    var mangaGridController : KMMangaGridController = KMMangaGridController();
    
    /// The search text field in the main window
    var searchTextField : NSTextField = NSTextField();
    
    /// The controller for the reader window
    var mangaReaderWindowController : NSWindowController!;
    
    /// The preferences keeper(Kept in app delegate because it should be globally accesable)
    var preferencesKepper : KMPreferencesKeeper = KMPreferencesKeeper();
    
    /// The window controller that lets the user darken everything behind the window
    var darkenBackgroundWindowController : NSWindowController!;
    
    /// The download controller for downloading from E-Hentai and ExHentai
    var ehDownloadController : KMEHDownloadController = KMEHDownloadController();
    
    /// An Int that indicates what modifier keys are being held(These are defined by NSEvent, not me)
    var modifierValue : Int = 0;
    
    // Opens the specified manga in the reader at the specified page
    func openManga(manga : KMManga, page : Int) {
        // Get the main storyboard
        let storyboard = NSStoryboard(name: "Main", bundle: nil);
        
        // Instanstiate the view controller for the reader
        mangaReaderWindowController = storyboard.instantiateControllerWithIdentifier("reader") as? NSWindowController;
        
        // Get the view controller from the window
        mangaReaderViewController = (mangaReaderWindowController.contentViewController as? KMReaderViewController);
        
        // Tell the view controller to open the manga we passed at the page we passed
        mangaReaderViewController?.openManga(manga, page: page);
        
        // Present mangaReaderWindowController
        mangaReaderWindowController.showWindow(self);
    }
    
    func savePreferences() {
        // Create a string to store our preferences values
        var preferencesString : String = "";
        
        // Add the l-lewd... mode enabled bool to the end of it
        preferencesString.appendContentsOf(String(preferencesKepper.llewdModeEnabled));
        
        // Add the l-lewd... mode delete when removing enabled bool to the end of it
        preferencesString.appendContentsOf("\n" + String(preferencesKepper.deleteLLewdMangaWhenRemovingFromTheGrid));
        
        // Add mark as read when completed in reader bool to the end of it
        preferencesString.appendContentsOf("\n" + String(preferencesKepper.markAsReadWhenCompletedInReader));
        
        // Add hide cursor in distraction free mode bool to the end of it
        preferencesString.appendContentsOf("\n" + String(preferencesKepper.hideCursorInDistractionFreeMode));
        
        // Add the distraction free mode dim amount float to the end of it
        preferencesString.appendContentsOf("\n" + String(preferencesKepper.distractionFreeModeDimAmount));
        
        // Add the drag reader window by background without holding alt bool to the end of it
        preferencesString.appendContentsOf("\n" + String(preferencesKepper.dragReaderWindowByBackgroundWithoutHoldingAlt));
        
        // Add the manga grid scale to the end of it
        preferencesString.appendContentsOf("\n" + String(preferencesKepper.mangaGridScale));
        
        // Add the page ignore regex to the end of it
        preferencesString.appendContentsOf("\n" + String(preferencesKepper.pageIgnoreRegex));
        
        // Add the reader window background color to the end of it
        preferencesString.appendContentsOf("\n" + String(preferencesKepper.readerWindowBackgroundColor.redComponent) + ", " + String(preferencesKepper.readerWindowBackgroundColor.blueComponent) + ", " + String(preferencesKepper.readerWindowBackgroundColor.greenComponent));
        
        // Write the preferences to the preferences file in Komikan's application support
        do {
            // Try to write to the preferences file in Komikan's application support directory
            try preferencesString.writeToFile(NSHomeDirectory() + "/Library/Application Support/Komikan/preferences", atomically: true, encoding: NSUTF8StringEncoding);
            // If there is an error...
        } catch let error as NSError {
            // Print the error description to the log
            print(error.description);
        }
    }
    
    func loadPreferences() {
        // Make sure the preferences file exists
        if(NSFileManager.defaultManager().fileExistsAtPath(NSHomeDirectory() + "/Library/Application Support/Komikan/preferences")) {
            // Create a variable to hold the preferences
            var preferencesString : String = "";
            
            // Try to get the contents of the preferences file in our application support folder
            preferencesString = String(data: NSFileManager.defaultManager().contentsAtPath(NSHomeDirectory() + "/Library/Application Support/Komikan/preferences")!, encoding: NSUTF8StringEncoding)!;
            
            // For every line in the preferences string
            for (currentIndex, currentElement) in preferencesString.componentsSeparatedByString("\n").enumerate() {
                // If this is the first line...
                if(currentIndex == 0) {
                    // Set the l-lewd... mode enabled bool to be this lines value
                    preferencesKepper.llewdModeEnabled = KMFileUtilities().stringToBool(currentElement);
                }
                // If this is the second line...
                else if(currentIndex == 1) {
                    // Set the l-lewd... mode delete when removing enabled bool to be this lines value
                    preferencesKepper.deleteLLewdMangaWhenRemovingFromTheGrid = KMFileUtilities().stringToBool(currentElement);
                }
                // If this is the third line...
                else if(currentIndex == 2) {
                    // Set if we want to mark manga as read when we finish them in the reader to be this lines value
                    preferencesKepper.markAsReadWhenCompletedInReader = KMFileUtilities().stringToBool(currentElement);
                }
                // If this is the fourth line...
                else if(currentIndex == 3) {
                    // Set if we want to hide the cursor in distraction free mode to be this lines value
                    preferencesKepper.hideCursorInDistractionFreeMode = KMFileUtilities().stringToBool(currentElement);
                }
                // If this is the fifth line...
                else if(currentIndex == 4) {
                    // Set the dsitaction free mode dim amount to be this lines value
                    preferencesKepper.distractionFreeModeDimAmount = CGFloat(NSString(string: currentElement).floatValue);
                }
                // If this is the sixth line...
                else if(currentIndex == 5) {
                    // Set the drag reader window by background without holding alt to be this lines value
                    preferencesKepper.dragReaderWindowByBackgroundWithoutHoldingAlt = KMFileUtilities().stringToBool(currentElement);
                }
                // If this is the seventh line...
                else if(currentIndex == 6) {
                    // Set the manga grid's scale to be this lines value
                    preferencesKepper.mangaGridScale = NSString(string: currentElement).integerValue;
                }
                // If this is the eigth line...
                else if(currentIndex == 7) {
                    // Set the page ignore regex to be this lines value
                    preferencesKepper.pageIgnoreRegex = currentElement;
                }
                // If this is the ninth line...
                else if(currentIndex == 8) {
                    /// The red component of the reader window background color
                    var red : CGFloat = 0;
                    
                    /// The blue component of the reader window background color
                    var blue : CGFloat = 0;
                    
                    /// The green component of the reader window background color
                    var green : CGFloat = 0;
                    
                    // For every value in the current line split at every ", "...
                    for(currentIndex, currentString) in currentElement.componentsSeparatedByString(", ").enumerate() {
                        // If this is the first element...
                        if(currentIndex == 0) {
                            // Set the red value to this line
                            red = CGFloat(NSString(string: currentString).floatValue);
                        }
                        // If this is the second element...
                        else if(currentIndex == 1) {
                            // Set the blue value to this line
                            blue = CGFloat(NSString(string: currentString).floatValue);
                        }
                        // If this is the third element...
                        else if(currentIndex == 2) {
                            // Set the green value to this line
                            green = CGFloat(NSString(string: currentString).floatValue);
                        }
                    }
                    
                    // Set the reader window background color
                    preferencesKepper.readerWindowBackgroundColor = NSColor(red: red, green: green, blue: blue, alpha: 1);
                }
            }
        }
        
        // Post the notification saying the preferences have been loaded
        NSNotificationCenter.defaultCenter().postNotificationName("Application.PreferencesLoaded", object: nil);
    }
    
    // Clears the cache
    func clearCache() {
        // Get everything in /tmp/komikan and delete it
        do {
            // Get all files in /tmp/komikan
            let files = try NSFileManager.defaultManager().contentsOfDirectoryAtPath("/tmp/komikan");
            
            // Delete all of them
            for (_, currentFile) in files.enumerate() {
                // Print to the log what we are removing
                print("Deleting /tmp/komikan/" + currentFile);
                
                // Try to remove it
                try NSFileManager.defaultManager().removeItemAtPath("/tmp/komikan/" + currentFile);
            }
            
            // If there is an error...
        } catch _ as NSError {
            // Print to the log that the cache is already cleared
            print("Cache is already cleared");
        }
    }
    
    func actOnPreferences() {
        // Print to the log that we are acting upon preferences
        print("Acting On Preferences");
        
        // Hide/show the Add From EH Menu Item depending on if we have l-lewd... mode enabled
        addFromEHMenuItem.hidden = !preferencesKepper.llewdModeEnabled;
        
        // Set the distraction free mode dim amount
        backgroundDarkenAmount = preferencesKepper.distractionFreeModeDimAmount;
        
        // If we are in distraction free mode...
        if(backgroundDarkened) {
            // Double toggle distraction free mode so it matches the new darken amount
            toggleDarken();
            toggleDarken();
        }
        
        // Post the notification saying the preferences have been saved
        NSNotificationCenter.defaultCenter().postNotificationName("Application.PreferencesSaved", object: nil);
    }
    
    // How much to darken the background
    var backgroundDarkenAmount : CGFloat = 0.4;
    
    // Do we have the background darkened?
    var backgroundDarkened = false;
    
    func setupBackgroundDarkenWindow() {
        // Get the main storyboard
        let storyboard = NSStoryboard(name: "Main", bundle: nil);
        
        // Instantiate the window controller for darkening the background
        darkenBackgroundWindowController = storyboard.instantiateControllerWithIdentifier("backgroundDarkenWindow") as? NSWindowController;
        
        // Set the darken background windows frame to be the same as the srceens frame
        darkenBackgroundWindowController.window?.setFrame(NSRect(x: 0, y: 0, width: (NSScreen.mainScreen()?.frame.width)!, height: (NSScreen.mainScreen()?.frame.height)!), display: false);
        
        // Allow the window to be transparent
        darkenBackgroundWindowController.window?.opaque = false;
        
        // Set the background color to black
        darkenBackgroundWindowController.window?.backgroundColor = NSColor.blackColor();
        
        // Set the transpareny to something /comfy/
        darkenBackgroundWindowController.window?.alphaValue = backgroundDarkenAmount;
        
        // Make the window borderless
        darkenBackgroundWindowController.window?.styleMask |= NSBorderlessWindowMask;
        
        // Make it so you cant click the window
        darkenBackgroundWindowController.window?.ignoresMouseEvents = true;
        
        // Set the windows level
        darkenBackgroundWindowController.window?.level--;
        
        // Fade out the darken. If you dont do this, the first time you toggle distraction free mode it will only show and not fade in
        // Make the darken window clear
        darkenBackgroundWindowController.window?.alphaValue = 0;
        
        // Close the darken window
        closeDarkenWindow();
    }
    
    func fadeInDarken() {
        // Order the window to show but not steal focus
        darkenBackgroundWindowController.window?.orderFrontRegardless();
        
        // Animate the window in
        darkenBackgroundWindowController.window?.animator().alphaValue = backgroundDarkenAmount;
        
        // If we said to hide the cursor in distraction free mode...
        if(preferencesKepper.hideCursorInDistractionFreeMode) {
            // Hide the cursor
            NSCursor.hide();
        }
    }
    
    func fadeOutDarken() {
        // Animate out the window
        darkenBackgroundWindowController.window?.animator().alphaValue = 0;
        
        // Wait for the animation to finish and hide the window
        NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(0.2), target: self, selector: Selector("closeDarkenWindow"), userInfo: nil, repeats:false);
        
        // If we said to hide the cursor in distraction free mode...
        if(preferencesKepper.hideCursorInDistractionFreeMode) {
            // Show the cursor
            NSCursor.unhide();
        }
    }
    
    func toggleDarken() {
        // Toggle backgroundDarkened
        backgroundDarkened = !backgroundDarkened;
        
        // If the background is now darkened...
        if(backgroundDarkened) {
            // Fade in the darken
            fadeInDarken();
        }
        // If the background is now not darkened...
        else if(!backgroundDarkened) {
            // Fade out the darken
            fadeOutDarken();
        }
    }
    
    func closeDarkenWindow() {
        // Order out the window
        darkenBackgroundWindowController.window?.orderBack(self);
    }
    
    func modifierKeyEventHandler(theEvent : NSEvent) -> NSEvent {
        // Set modifierValue to the raw modifier key values
        self.modifierValue = Int(theEvent.modifierFlags.rawValue);
        
        // Return the event(Required for some reason)
        return theEvent;
    }
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        // Make sure we have an application support folder
        KMCommandUtilities().runCommand("/bin/mkdir", arguments: [NSHomeDirectory() + "/Library/Application Support/Komikan"], waitUntilExit: true);
        
        // Clear the cache on load
        clearCache();
        
        // Load the preferences
        loadPreferences();
        
        // Act upon the loaded preferences
        actOnPreferences();
        
        // Setup the window thats lets us dim the background
        setupBackgroundDarkenWindow();
        
        // Setup the darken background menu items action
        toggleBackgroundDarkenMenuItem.action = Selector("toggleDarken");
        
        // Get the default notification center
        let nc = NSUserNotificationCenter.defaultUserNotificationCenter();
        
        // Set its delegate to this class
        nc.delegate = self;
        
        // Subscribe to the modifier key changed event
        NSEvent.addLocalMonitorForEventsMatchingMask(NSEventMask.FlagsChangedMask, handler: modifierKeyEventHandler);
    }
    
    internal func userNotificationCenter(center: NSUserNotificationCenter, shouldPresentNotification notification: NSUserNotification) -> Bool {
        // Always show notifications from this app, even if it is frontmost
        return true
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
        // Post the notification saying the app will quit
        NSNotificationCenter.defaultCenter().postNotificationName("Application.WillQuit", object: nil);
        
        // Save the preferences
        savePreferences();
    }
}

