/*------------------------------------------------------------------------------
 Modeler LScript: Fix Symmetry problems in the object
 Version: 1.2
 Author: Johan Steen
 Author URI: http://www.artstorm.net/
 Date: 08 Sep 2008
 Modified: 14 Sep 2008
 Description: Corrects Symmetry on the selected points, or finds symmetry
              problems if nothing is selected.

 Copyright (c) 2008,  Johan Steen
 All Rights Reserved.
 Use is subject to license terms.
------------------------------------------------------------------------------*/

@version 2.4
@warnings
@script modeler
@name "JS_FixSymmetry"

// global values go here
reqTitle = "Fix Symmetry v1.2";
// For Tolerance Fix
c1,c2,c3,c4;
totPnts = 0;
selPnts = nil;
toleranceDefault = 0.001;
tolerance = 0.0;
side2Correct = 1;
interactiveMode = true;
changesMade = false;        // To keep track of if an undo is necessary

main
{
    //
    // Check so geometry exists in the current layer.
    // --------------------------------------------------------------------------------
    selmode(USER);
    if(pointcount() == 0)
        error("There is no geometry in this layer.");


    selmode(DIRECT);
    pnt = pointcount();     // Get number of selected points

    // Decide which funtion to perform
    switch (pnt)
    {
        case 0:
            SymmetryCheck();
            break;
        case 1:
            info ("Nothing to perform with just one selected point.");
            break;
        case 2:             // 2 points selected, enter Quick Mode
            QuickFix();
            break;
        default:            // More than 2 points selected, enter Tolerance Mode.
            ToleranceFix();
            break;
    }
}

/*
** Function to find Symmetry Errors (When no points are selected)
**
** @returns     Nothing 
*/
SymmetryCheck
{
    totPnts = 0;
    allPnts = nil;
    selmode(USER);
    editbegin();
    // Create an array of all existing points
    foreach(p, points)
    {
        totPnts++;
        allPnts[totPnts] = p;
    }
    editend();

    // Loop through all points and leave does without a syncing symmetry point selected
    selpoint(SET);
    selpolygon(CLEAR);                  // Switch to polygon mode, to speed up drawing of point selections
    moninit(totPnts, "processing...");
    for(i=1; i <= totPnts; i++)
    {
        curPnt = allPnts[i];
        for (j=i; j <= totPnts; j++)
        {
            if (allPnts[j].x <= 0) // Optimization
            {
                if (curPnt.x == -allPnts[j].x && curPnt.y == allPnts[j].y && curPnt.z == allPnts[j].z && i != j || curPnt.x == 0)
                { 
                    selpoint(CLEAR, POINTID, allPnts[i]);
                    selpoint(CLEAR, POINTID, allPnts[j]);
                    j = totPnts;
                }
            } // End If
        } // Next
        if (monstep()) {
            //editend(ABORT);
            return;
        } // End If
    } // Next
    monend();
    selpoint(SET,NPEQ,1000);        // Switch back to point selection mode (Dummy selection value to keep current selection)

    //
    // Show a requester and report the result of the operation
    // --------------------------------------------------------------------------------
    selmode(DIRECT);
    reqbegin(reqTitle);
    reqsize(240,130);
    if (pointcount() == 0) 
        check_str = "All points are in symmetry.";
    if (pointcount() == 1) 
        check_str = "" + pointcount() + " asymmetric point found.";
    if (pointcount() > 1)
        check_str = "" + pointcount() + " asymmetric points found.";
    c3 = ctltext("","Symmetry Check");
    ctlposition(c3,10,10,200,13);
    s1 = ctlsep();
    ctlposition(s1,-1,37);
    c2 = ctltext("",check_str);
    ctlposition(c2,10,53,200,13);
    return if !reqpost();
    reqend();
}

/*
** Function when Quick Fix is detected (Correct one point, 2 points selected)
**
** @returns     Nothing 
*/
QuickFix
{
    //
    // Setup the requester
    // --------------------------------------------------------------------------------
    side2Correct = 1;

    reqbegin(reqTitle);
    reqsize(240,130);               // X,Y
    c2 = ctltext("","Quick Fix (2 points selected)");
    ctlposition(c2,10,10,200,13);
    s1 = ctlsep();
    ctlposition(s1,-1,37);
    c1 = ctlchoice("Side to correct",side2Correct,@"      - X       ","      + X       "@);
    ctlposition(c1,10,53);
    return if !reqpost();

    side2Correct = getvalue(c1);

    reqend();

    //
    // Perform the Correction
    // --------------------------------------------------------------------------------
    selmode(DIRECT);
    editbegin();
    // Store the Positions
    if (points[1].x > points[2].x) {        // Determine which side was corrected first
        pntPos1 = points[1];
        pntPos2 = points[2];
    } else {
        pntPos1 = points[2];
        pntPos2 = points[1];
    }
    // Move the point to correct into position
    if (side2Correct == 1) {
        pointmove(pntPos2, <-pntPos1.x, pntPos1.y, pntPos1.z>);
    } else {
        pointmove(pntPos1, <-pntPos2.x, pntPos2.y, pntPos2.z>);
    }
    editend();
}

/*
** Function when Tolerance Fix is detected (Correct all selected points)
**
** @returns     Nothing 
*/
ToleranceFix
{
    storeSelPnts();

    //
    // Setup the requester
    // --------------------------------------------------------------------------------
    reqbegin(reqTitle);
    reqsize(240,168);
    c5 = ctltext("","Tolerance Fix (Multiple points selected)");
    s1 = ctlsep();
    c1 = ctlpercent("", toleranceDefault);
    c2 = ctldistance("Symmetry Tolerance", toleranceDefault);
    c3 = ctlchoice("Side to correct",side2Correct,@"    - X     ","    + X     "@);
    c4 = ctlcheckbox("Interactive", interactiveMode);
    xPos = 10;
    ctlposition(c1, xPos+179, 53, 10, 19);
    ctlposition(s1,-1,37);
    ctlposition(c2, xPos, 53, 192);
    ctlposition(c5,10,10,200,13);
    ctlposition(c3,37,80);
    ctlposition(c4,112,108);

    ctlrefresh(c1,"refresh_c2");
    ctlrefresh(c2,"refresh_c1");
    ctlrefresh(c3,"sideSwitch");
    ctlrefresh(c4,"interactiveSwitch");

    // Handle closing of the window (OK, Abort, with undo or non interactive mode)
    if (!reqpost())
    {
        if (changesMade == true) { undo(); }
        return;
    } else {
        if (interactiveMode == false) { correctPoints(); }
        reqend();
    }
}

// Refreshment function for the numeric input field
refresh_c2: value
{
    if( value != getvalue(c2) )
    {
        setvalue(c2, value);
        tolerance = getvalue(c2);
        interactive_adjust();
    }  
}

// Refreshment function for the minislider
refresh_c1: value
{
    if( value != getvalue(c1) )
    {
        setvalue(c1, value);
        tolerance = getvalue(c2);
        interactive_adjust();
    }
}

// Function to update which side to correct
sideSwitch: value
{
    side2Correct = getvalue(c3);
    interactive_adjust();
}

// Function to enable/disable interactive functionality
interactiveSwitch: value
{
    interactiveMode = getvalue(c4);
    if (interactiveMode == false && changesMade == true)
    {
        undo();
        changesMade = false;
    }
    if (interactiveMode == true)
    {
        interactive_adjust();
    }
}

// Function to call the correction function
interactive_adjust
{
    if (interactiveMode == true)
    {
        correctPoints();
    }
}



//
// Function to store all selected Point ID's in an array
// --------------------------------------------------------------------------------
storeSelPnts
{
    selmode(DIRECT);
    editbegin();
    foreach(p, points)
    {
        totPnts++;
        selPnts[totPnts] = p;
    }
    editend();
}


//
// Function to store all selected Point ID's in an array
// --------------------------------------------------------------------------------
correctPoints
{
    if (changesMade == true)
    {
        undo();
        changesMade = false;
    }
    undogroupbegin();
    //
    // Process the correction of the selected points
    // --------------------------------------------------------------------------------
    editbegin();
    moninit(totPnts, "processing...");

    for(ind=1; ind <= totPnts; ind++)       // Loop through all selected points
    {
        refpos = pointinfo(selPnts[ind]);   // Get the position of the point to check
        doCheck = false;
        if (side2Correct == 1) {    // If correcting on -X
            if (refpos.x > 0.0) { doCheck = true; }
        } else {                    // If correctiong on +X
            if (refpos.x < 0.0) { doCheck = true; }
        }
        if (doCheck == true)                 // Only try to correct, if point located on opposite correction axis
        {
            for (j = 1; j <= totPnts; j++)
            {
                pos = pointinfo(selPnts[j]);
                doCheck = false;
                if (side2Correct == 1) {    // If correcting on -X
                    if (refpos.x > 0.0) { doCheck = true; }
                } else {                    // If correcting on +X
                    if (refpos.x < 0.0) { doCheck = true; }
                }
                if (selPnts[j] != selPnts[ind] && doCheck == true)
                {
                    x = pos.x + refpos.x;
                    y = pos.y - refpos.y;
                    z = pos.z - refpos.z;
                    if (sqr(x) + sqr(y) + sqr(z) <= sqr(tolerance))
                    {
                        pointmove(selPnts[j], <-refpos.x, refpos.y, refpos.z>);
                    } // End If
                } // End If
            } // Next
        } // End If
        if (monstep()) {
            editend(ABORT);
            return;
        } // End If
    } // Next
    editend();
    monend();

    undogroupend();
    changesMade = true;
}

sqr: num
{
    return num * num;
}

