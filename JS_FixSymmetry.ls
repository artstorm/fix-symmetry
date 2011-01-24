// ******************************
// Modeler LScript: Fix Symmetry problems in the object
// Version: 1.1
// Author: Johan Steen
// Date: 08 Sep 2008
// Modified: 12 Sep 2008
// Description: Corrects Symmetry on the selected points, or finds symmetry problems if nothing is selected.
//
// http://www.artstorm.net
// ******************************

@version 2.4
@warnings
@script modeler
@name "JS_FixSymmetry"

// global values go here
c1,c2;
reqTitle = "Fix Symmetry v1.1";

main
{
    selmode(DIRECT);
    pnt = pointcount();     // Get number of selected points

    // Decide which funtion to perform
    switch (pnt)
    {
        case 0:
            FindErrors();
            break;
        case 1:
            info ("Nothing to perform with just one selected point.");
            break;
        case 2:             // 2 points selected, enter Quick Mode
            QuickMode();
            break;
        default:            // More than 2 points selected, enter Tolerance Mode.
            ToleranceMode();
            break;
    }
}

/*
** Function to find Symmetry Errors (When no points are selected)
**
** @returns     Nothing 
*/
FindErrors
{
    totPnts = 0;
    selPnts = nil;
    selmode(USER);
    editbegin();
    // Create an array of all existing points
    foreach(p, points)
    {
        totPnts++;
        selPnts[totPnts] = p;
    }
    editend();

    // Loop through all points and leave does without a syncing symmetry point selected
    selpoint(SET);
    moninit(totPnts, "processing...");
    for(i=1; i <= totPnts; i++)
    {
        for (j=i; j <= totPnts; j++)
        {
            curPnt = selPnts[i];
            if (curPnt.x == -selPnts[j].x && curPnt.y == selPnts[j].y && curPnt.z == selPnts[j].z && i != j || curPnt.x == 0)
            {
                selpoint(CLEAR, POINTID, selPnts[i]);
                selpoint(CLEAR, POINTID, selPnts[j]);
                j = totPnts;
            }
        } // Next
        if (monstep()) {
            //editend(ABORT);
            return;
        } // End If
    } // Next
    monend();
}


/*
** Function when ToleranceMode is detected (Correct all selected points)
**
** @returns     Nothing 
*/
ToleranceMode
{
    //
    // Setup the requester
    // --------------------------------------------------------------------------------
    val = 0.001;
    side2Correct = 1;

    reqbegin(reqTitle);
    reqsize(240,146);
    c3 = ctltext("","Tolerance Mode (Multiple points selected)");
    ctlposition(c3,10,10,200,13);
    s1 = ctlsep();
    ctlposition(s1,-1,37);
    c1 = ctlpercent("", val);
    c2 = ctldistance("Symmetry Tolerance", val);
    xPos = 10;
    ctlposition(c2, xPos, 53, 192);
    ctlposition(c1, xPos+179, 53, 10, 19);
    c3 = ctlchoice("Side to correct",side2Correct,@"    - X     ","    + X     "@);
    ctlposition(c3,37,80);

    ctlrefresh(c1,"refresh_c2");
    ctlrefresh(c2,"refresh_c1");

    return if !reqpost();

    tolerance = getvalue(c2);
    side2Correct = getvalue(c3);

    reqend();


    //
    // Create an array with all selected points
    // --------------------------------------------------------------------------------
    totPnts = 0;
    selPnts = nil;
    selmode(DIRECT);
    editbegin();
    foreach(p, points)
    {
        totPnts++;
        selPnts[totPnts] = p;
    }   

    //
    // Process the correction of the selected points
    // --------------------------------------------------------------------------------
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
}

sqr: num
{
    return num * num;
}

/*
** Function when QuickMode is detected (Correct one point, 2 points selected)
**
** @returns     Nothing 
*/
QuickMode
{
    //
    // Setup the requester
    // --------------------------------------------------------------------------------
    side2Correct = 1;

    reqbegin(reqTitle);
    reqsize(240,130);               // X,Y


    c2 = ctltext("","Quick Mode (2 points selected)");
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
** Functions to update the distance when the slider is dragged.
**
** @returns     Nothing 
*/
refresh_c2: value
{
    if( value != getvalue(c2) )
        setvalue(c2, value);
}

refresh_c1: value
{
    if( value != getvalue(c1) )
        setvalue(c1, value);
}



