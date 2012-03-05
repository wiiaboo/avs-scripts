function InsertSignXYFade(clip mainclip, clip overlayclip, int "startframe", int "endframe", int "x", int "y", int "fad1", int "fad2", int "offset", int "offset2", float "opacity", int "nw", int "nh") {

    x           = default(x,0)                # X position of overlayclip
    y           = default(y,0)                # Y position of overlayclip
    fad1        = default(fad1,0)             # Number of frames to fade in
    fad2        = default(fad2,0)             # Number of frames to fade out
    offset      = default(offset,0)           # Offset of the start and end frames
    offset2     = default(offset2,0)          # Offset of the start of overlayclip
    startframe  = default(startframe,0)       # Mainclip startframe from whence to apply the overlay
    opacity     = default(opacity,1.0)        # Set opacity of overlayclip
    nw          = default(nw,mainclip.width)  # Set overlay's width in case it's not the same mainclip's
    nh          = default(nh,mainclip.height) # Set overlay's height in case it's not the same mainclip's
    startframe  = startframe+offset           # Apply offset to startframe

    # make the endframe parameter optional (defaulting to where the overlay clip ends)
    endframe = default(endframe,startframe+overlayclip.framecount()-1) # is endframe not specified?
    endframe = (endframe == 0) ? startframe+overlayclip.framecount()-1 : endframe+offset # is it specified but zero?
    # is it specified but >= the main clip's last frame? (may have been caused by the previous line or specified by the user)
    # in that case make it equal to the last frame of the main clip (this is important later)
    endframe = (endframe >= mainclip.framecount()-1) ? mainclip.framecount()-1 : endframe 

    # make sure the special case startframe=1 is dealt with correctly
    # (needed because trim(0,0) returns the entire clip, which is obviously not what we want)
    # note that the first frame of the clip is zero, NOT one!
    begin  = (startframe == 1) ? mainclip.trim(0,-1) : mainclip.trim(0,startframe-1)
    middle = mainclip.trim(startframe,endframe)
    # make sure the special case endframe = last frame of the clip is handled properly.
    end    = (endframe == mainclip.framecount()-1) ? blankclip(mainclip,length=0) : mainclip.trim(endframe+1,0)

    middleoverlay = Overlay(middle, overlayclip.spline36resize(nw,nh).trim(offset2,0),x,y,overlayclip.spline36resize(nw,nh).trim(offset2,endframe-startframe+offset2).ConvertToRGB32.showalpha.FadeIn0(fad1).FadeOut0(fad2),opacity)

    # deal with the special case startframe=0 (in which case we don't have anything before the overlay)
    # note that trim(-1,0) does nothing (it returns the same as trim(0,0)...)
    final = (startframe == 0) ? middleoverlay ++ end : begin ++ middleoverlay ++ end
    return final

}
