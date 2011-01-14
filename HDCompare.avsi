function HDCompare(clip mainclip, int "nw", int "nh") {

    c1=mainclip
    nw=default(nw,1280)
    nh=default(nh,720)

    c1w=c1.width
    c1h=c1.height
    c2=mainclip.spline36resize(nw,nh).spline36resize(c1w,c1h)

    orig=c1.mt_edge(thY1=0,thY2=255).mt_expand()
    res=c2.mt_edge(thY1=0,thY2=255).mt_expand()

    final = Subtract(res,orig).Tweak(cont=2).Invert()
    
    return final

}
