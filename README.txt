Fix Symmetry 1.0
================
LightWave Modeler LScript by Johan Steen.


Description
===========
When modeling in LightWave 3D it still happens that symmetry breaks,
especially when using certain tools that doesn’t respect symmetry or
when sending the object back and forth to other applications.

Fix Symmetry takes care of those problems in a non destructive way
by helping you move the points back to a symmetric position,
so all vertex maps are intact.


Usage
=====
Fix Symmetry can operate in two different modes. Quick Mode or
Tolerance Mode. Which mode it operates in is automatically decided
depending on how many points you have selected before running the plugin.

Quick Mode:
The Quick Mode is automatically started if you have 2 points selected.
This is a fast and reliable way to make an exact adjustment if you have
one stray point that has got out of hand.

Select the point that has gone on a wild detour somewhere in your object
and then the point on the other side that you want to sync the symmetry
to, and run the plugin.

You will get presented with the Quick Mode window, which let’s you select
which side you want the correction (the point to be moved into position)
to occur on. And that’s it. This mode just moves a single point so it
doesn’t matter how far off it is, it will always be put back in sync with
the other point you have selected to have the symmetry restored on that
selection.

Tolerance Mode:
The Tolerance Mode is started when you have more than two points selected.
This is useful when a group of points are playing tricks on you and have
lost their symmetry.

Select a bunch of points on one side of the object, and then select the
corresponding points on the other side. You don’t have to be completely
exact in your selection here, if you select some points that’s already in
symmetry, they will be skipped during the processing of the correction.

When your selection is done, run the plugin and you will be presented with
the Tolerance Mode window. The Symmetry Tolerance setting is the distance
the plugin will search for a point on the other side to move into symmetry.
To speed things up, take a look at your model to see how far off the points
seem to be, and use a number around that distance. If the tolerance is too
low it might not catch all the errors, and if it’s too high it might find
the wrong points to move into position. So sometimes this mode might need
a few trial and error attempts before finding the best value.

If the Symmetry is too distorted it might be easier to take a few points at
a time to prevent the plugin from making mistakes. The more points that are
selected, the longer the calculation to process the correction will be. If
you find it takes too long time, press the ESC key to abort the processing
and make a narrower selection of fewer points to work on.


Misc:
I'd recommend to add the tool to a convenient spot in your modeler's
menu, so all you have to do is press the Fix Symmetry button when you
need to use the tool.


Installation
============
* Copy the JS_FixSymmetry.lsc to LightWave's plug-in folder.
* If "Autoscan Plugins" is enabled, just restart LightWave and it's installed.

* Else locate the "Add Plugins" button in LightWave and add it manually.


Author
======
This tool is written by Johan Steen.
Contact me through http://www.artstorm.net/


History
=======
v1.0 - 8 Sep 2008:
  * Release of version 1.0.


Disclaimer / Legal Stuff
========================
Fix Symmetry is freeware. 
Please do not distribute or re-post this 
tool without the author's permission.

Fix Symmetry is provided "as is" without 
warranty of any kind, either express or implied,
no liability for consequential damages.

By installing and or using this software
you agree to the terms above.

Copyright © 2008 Johan Steen.