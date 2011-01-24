--------------------------------------------------------------------------------
 Fix Symmetry - README

 Fix Symmetry takes care of symmetry problems in a non destructive way
 by helping you move the points back to a symmetric position, keeping
 all vertex maps are intact.

 Website:      http://www.artstorm.net/plugins/fix-symmetry/
 Project:      http://code.google.com/p/js-lightwave-lscripts/
 Feeds:        http://code.google.com/p/js-lightwave-lscripts/feeds
 
 Contents:
 
 * Installation
 * Usage
 * Source Code
 * Changelog
 * Credits

--------------------------------------------------------------------------------
 Installation
 
 General installation steps:

 * Copy the JS_FixSymmetry.lsc to LightWave's plug-in folder.
 * If "Autoscan Plugins"
   is enabled, just restart LightWave and it's installed.
 * Else locate the "Add Plugins" button in LightWave and add it manually.

--------------------------------------------------------------------------------
 Usage

 Fix Symmetry can operate in three different modes; Symmetry Check, Quick
 Fix and Tolerance Fix.  Which mode it operates in is automatically decided
 depending on how many points you have selected before running the plugin.

 Symmetry Check:
 If no points in the object are selected, the Symmetry Check mode will be 
 invoked. The plugin then examines all points to find those that are not in
 a symmetric sync with a point on the opposite x axis. Points that aren't in
 sync will be set in a selected state, so they can be fixed. Either manually
 or by using the Quick or Tolerance modes of this plugin. Pressing the ESC 
 key aborts the check when the progress bar is running.

 Quick Fix:
 The Quick Fix mode is started if you have 2 points selected. This is a fast
 and reliable way to make an exact adjustment if you have one stray point 
 that has got out of hand.

 Select the point that has gone on a wild detour somewhere in your object
 and then the point on the other side that you want to sync the symmetry
 to, and run the plugin.

 You will get presented with the Quick Mode window, which let’s you select
 which side you want the correction (the point to be moved into position)
 to occur on. And that’s it. This mode just moves a single point so it
 doesn’t matter how far off it is, it will always be put back in sync with
 the other point you have selected to have the symmetry restored on that
 selection.

 Tolerance Fix:
 The Tolerance Fix mode is started when you have more than two points selected.
 This is useful when a group of points are playing tricks on you and have
 lost their symmetry.

 Select a bunch of points on one side of the object, and then select the
 corresponding points on the other side. You don’t have to be completely
 exact in your selection here, if you select some points that’s already in
 symmetry, they will be skipped during the processing of the correction.

 When your selection is done, run the plugin and you will be presented with
 the Tolerance Fix window.

 * Symmetry Tolerance: Sets the distance the plugin will search for a point
   on the other side to move into symmetry. 
 * Side to correct: Switches between the +/- sides of the x-axis to perform
   the correction on.
 * Interactive: Toggles the interactive mode on/off. On larger selections 
   the interactive mode might be to slow to use, so then it's better to have
   it disabled. It can then be used as a preview button to see what effect your
   current tolerance setting have on the selection, before committing to the
   changes.

 If the Symmetry is too distorted it might be easier to take a few points at
 a time to prevent the plugin from making mistakes. The more points that are
 selected, the longer the calculation to process the correction will be. If
 you find it takes too long time, press the ESC key to abort the processing
 and make a smaller point selection to work with.

 Misc:
 I'd recommend to add the tool to a convenient spot in your modeler's
 menu, so all you have to do is press the Fix Symmetry button when you
 need to use the tool.

--------------------------------------------------------------------------------
 Source Code
 
 Download the source code:
 
   http://code.google.com/p/js-lightwave-lscripts/source/checkout

 You can check out the latest trunk or any previous tagged version via svn
 or explore the repository directly in your browser.
 
 Note that the default checkout path includes all my available LScripts, you
 might want to browse the repository first to get the path to the specific
 script's trunk or tag to download if you don't want to get them all.
 
--------------------------------------------------------------------------------
 Changelog

 * v1.2 - 14 Sep 2008
   * Implemented an interactive option for the Tolereance Fix.
   * Implemented an information window at the end of a Symmetry Check to report the
     result of the check.
   * Optimized the Symmetry Check mode to speed it up on denser meshes.
   * Renamed the modes to Symmetry Check, Quick Fix and Tolerance Fix.
   * Implemented handling if the plugin is run on an empty layer. Notifies the
     user instead of an illegal error message.
 * v1.1 - 12 Sep 2008
   * Implemented a Find Errors Mode to locate symmetry errors. 
     Invoked when the tool is started with no points selected.
 * v1.0 - 8 Sep 2008:
   * Release of version 1.0.

--------------------------------------------------------------------------------
 Credits

 Johan Steen, http://www.artstorm.net/
 * Original author
 
