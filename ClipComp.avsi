#
# Syntaxe :
#
# Function ClipComp(clip a, clip b, string "mode", bool "showSubs", \
#                   string "aSub", string "bSub", int "swapFreq")
# 
# a,b : clips to be compared, must be same height and width, with at least div4 values
#
# mode : Comparison mode, syntaxe is "Nb_Of_Lignes x Nb_Of_Columns x separate"
#        available modes : 1x1
#                          2x1x0 , 2x1x1(Default) , 1x2x0 , 1x2x1 , 2x2x0 , 2x2x1
#                          4x1x0 , 4x1x1          , 1x4x0 , 1x4x1 , 4x4x0 , 4x4x1
#                          8x1x0 , 8x1x1          , 1x8x0 , 1x8x1
#
# showSubs [ True (Default) / False ] : Display clip subtitle on each segment
#
# aSub : User string to use as subtitle of clip a segments, Default = "1"
# bSub : User string to use as subtitle of clip b segments, Default = "    2"
#
# swapFreq : This determines the number of frames to be displayed
#            before swapping occurs, Default = 1
#


Function ClipComp(clip a, clip b, string "mode", bool "showSubs", \
                  string "aSub", string "bSub", int "swapFreq")
{
### -= VARIABLES =- ###
mode = default( mode, "2x1x1" )
showSubs = Default( showSubs, true )
aSub = showSubs ? Default( aSub, "1" ) : ""
bSub = showSubs ? Default( bSub, "    2" ) : ""
global swapFreq = Default( swapFreq, 1 )

global swapParam = 0
global frameParam = 1
global frameParamNext = 1

### -= SCRIPT =- ###
ConditionalFilter(a,ClipComp2( a, b, mode, aSub, bSub ), \
                    ClipComp2( b, a, mode, bSub, aSub ), \
                    "swapParam", "=", "1")
                           
FrameEvaluate("""(frameParam == 1) ? Eval("swapParam = (swapParam == 1) ? 0 : 1") : NOP()""")
FrameEvaluate("""global frameParamNext = ((frameParam / swapFreq) < 1) ? (frameParam + 1) : 1""")
FrameEvaluate("frameParam = true ? frameParamNext : 0")
}


Function ClipComp2(clip a, clip b, string "mode", string "aSub", string "bSub" )
{
hClip = a.height()
wClip = a.width()

(mode == "1x1") ? a.subtitle(aSub) \
\
: (mode == "2x1x0") ? stackvertical(a.crop(0,0*hClip/2,-0,-1*hClip/2).subtitle(aSub), \
                                    b.crop(0,1*hClip/2,-0,-0*hClip/2).subtitle(bSub)) \
\
: (mode == "2x1x1") ? stackvertical(a.converttoyuy2.crop(0,0*hClip/2,-0,-1*hClip/2).subtitle(aSub).addborders(0,0,0,1), \
                                    b.converttoyuy2.crop(0,1*hClip/2,-0,-0*hClip/2).subtitle(bSub).addborders(0,0,0,1)).converttoyv12 \
\
: (mode == "1x2x0") ? stackhorizontal(a.crop(0*wClip/2,0,-1*wClip/2,-0).subtitle(aSub), \
                                      b.crop(1*wClip/2,0,-0*wClip/2,-0).subtitle(bSub)) \
\
: (mode == "1x2x1") ? stackhorizontal(a.converttoyuy2.crop(0*wClip/2,0,-1*wClip/2,-0).subtitle(aSub).addborders(0,0,1,0), \
                                      b.converttoyuy2.crop(1*wClip/2,0,-0*wClip/2,-0).subtitle(bSub).addborders(0,0,1,0)).converttoyv12 \
\
: (mode == "2x2x0") ? stackvertical(stackhorizontal(a.crop(0*wClip/2,0*hClip/2,-1*wClip/2,-1*hClip/2).subtitle(aSub), \
                                                    b.crop(1*wClip/2,0*hClip/2,-0*wClip/2,-1*hClip/2).subtitle(bSub)), \
                                    stackhorizontal(b.crop(0*wClip/2,1*hClip/2,-1*wClip/2,-0*hClip/2).subtitle(bSub), \
                                                    a.crop(1*wClip/2,1*hClip/2,-0*wClip/2,-0*hClip/2).subtitle(aSub))) \
\
: (mode == "2x2x1") ? stackvertical(stackhorizontal(a.crop(0*wClip/2,0*hClip/2,-1*wClip/2,-1*hClip/2).subtitle(aSub).addborders(0,0,2,2), \
                                                    b.crop(1*wClip/2,0*hClip/2,-0*wClip/2,-1*hClip/2).subtitle(bSub).addborders(0,0,2,2)), \
                                    stackhorizontal(b.crop(0*wClip/2,1*hClip/2,-1*wClip/2,-0*hClip/2).subtitle(bSub).addborders(0,0,2,2), \
                                                    a.crop(1*wClip/2,1*hClip/2,-0*wClip/2,-0*hClip/2).subtitle(aSub).addborders(0,0,2,2))) \
\
: (mode == "4x1x0") ? stackvertical(a.crop(0,0*hClip/4,-0,-3*hClip/4).subtitle(aSub), \
                                    b.crop(0,1*hClip/4,-0,-2*hClip/4).subtitle(bSub), \
                                    a.crop(0,2*hClip/4,-0,-1*hClip/4).subtitle(aSub), \
                                    b.crop(0,3*hClip/4,-0,-0*hClip/4).subtitle(bSub)) \
\
: (mode == "4x1x1") ? stackvertical(a.converttoyuy2.crop(0,0*hClip/4,-0,-3*hClip/4).subtitle(aSub).addborders(0,0,0,1), \
                                    b.converttoyuy2.crop(0,1*hClip/4,-0,-2*hClip/4).subtitle(bSub).addborders(0,0,0,1), \
                                    a.converttoyuy2.crop(0,2*hClip/4,-0,-1*hClip/4).subtitle(aSub).addborders(0,0,0,1), \
                                    b.converttoyuy2.crop(0,3*hClip/4,-0,-0*hClip/4).subtitle(bSub).addborders(0,0,0,1)).converttoyv12 \
\
: (mode == "1x4x0") ? stackhorizontal(a.crop(0*wClip/4,0,-3*wClip/4,-0).subtitle(aSub), \
                                      b.crop(1*wClip/4,0,-2*wClip/4,-0).subtitle(bSub), \
                                      a.crop(2*wClip/4,0,-1*wClip/4,-0).subtitle(aSub), \
                                      b.crop(3*wClip/4,0,-0*wClip/4,-0).subtitle(bSub)) \
\
: (mode == "1x4x1") ? stackhorizontal(a.converttoyuy2.crop(0*wClip/4,0,-3*wClip/4,-0).subtitle(aSub).addborders(0,0,1,0), \
                                      b.converttoyuy2.crop(1*wClip/4,0,-2*wClip/4,-0).subtitle(bSub).addborders(0,0,1,0), \
                                      a.converttoyuy2.crop(2*wClip/4,0,-1*wClip/4,-0).subtitle(aSub).addborders(0,0,1,0), \
                                      b.converttoyuy2.crop(3*wClip/4,0,-0*wClip/4,-0).subtitle(bSub).addborders(0,0,1,0)).converttoyv12 \
\
: (mode == "8x1x0") ? stackvertical(a.crop(0,0*hClip/8,-0,-7*hClip/8).subtitle(aSub), \
                                    b.crop(0,1*hClip/8,-0,-6*hClip/8).subtitle(bSub), \
                                    a.crop(0,2*hClip/8,-0,-5*hClip/8).subtitle(aSub), \
                                    b.crop(0,3*hClip/8,-0,-4*hClip/8).subtitle(bSub), \
                                    a.crop(0,4*hClip/8,-0,-3*hClip/8).subtitle(aSub), \
                                    b.crop(0,5*hClip/8,-0,-2*hClip/8).subtitle(bSub), \
                                    a.crop(0,6*hClip/8,-0,-1*hClip/8).subtitle(aSub), \
                                    b.crop(0,7*hClip/8,-0,-0*hClip/8).subtitle(bSub)) \
\
: (mode == "8x1x1") ? stackvertical(a.converttoyuy2.crop(0,0*hClip/8,-0,-7*hClip/8).subtitle(aSub).addborders(0,0,0,1), \
                                    b.converttoyuy2.crop(0,1*hClip/8,-0,-6*hClip/8).subtitle(bSub).addborders(0,0,0,1), \
                                    a.converttoyuy2.crop(0,2*hClip/8,-0,-5*hClip/8).subtitle(aSub).addborders(0,0,0,1), \
                                    b.converttoyuy2.crop(0,3*hClip/8,-0,-4*hClip/8).subtitle(bSub).addborders(0,0,0,1), \
                                    a.converttoyuy2.crop(0,4*hClip/8,-0,-3*hClip/8).subtitle(aSub).addborders(0,0,0,1), \
                                    b.converttoyuy2.crop(0,5*hClip/8,-0,-2*hClip/8).subtitle(bSub).addborders(0,0,0,1), \
                                    a.converttoyuy2.crop(0,6*hClip/8,-0,-1*hClip/8).subtitle(aSub).addborders(0,0,0,1), \
                                    b.converttoyuy2.crop(0,7*hClip/8,-0,-0*hClip/8).subtitle(bSub).addborders(0,0,0,1)).converttoyv12 \
\
: (mode == "1x8x0") ? stackhorizontal(a.crop(0*wClip/8,0,-7*wClip/8,-0).subtitle(aSub), \
                                      b.crop(1*wClip/8,0,-6*wClip/8,-0).subtitle(bSub), \
                                      a.crop(2*wClip/8,0,-5*wClip/8,-0).subtitle(aSub), \
                                      b.crop(3*wClip/8,0,-4*wClip/8,-0).subtitle(bSub), \
                                      a.crop(4*wClip/8,0,-3*wClip/8,-0).subtitle(aSub), \
                                      b.crop(5*wClip/8,0,-2*wClip/8,-0).subtitle(bSub), \
                                      a.crop(6*wClip/8,0,-1*wClip/8,-0).subtitle(aSub), \
                                      b.crop(7*wClip/8,0,-0*wClip/8,-0).subtitle(bSub)) \
\
: (mode == "1x8x1") ? stackhorizontal(a.converttoyuy2.crop(0*wClip/8,0,-7*wClip/8,-0).subtitle(aSub).addborders(0,0,1,0), \
                                      b.converttoyuy2.crop(1*wClip/8,0,-6*wClip/8,-0).subtitle(bSub).addborders(0,0,1,0), \
                                      a.converttoyuy2.crop(2*wClip/8,0,-5*wClip/8,-0).subtitle(aSub).addborders(0,0,1,0), \
                                      b.converttoyuy2.crop(3*wClip/8,0,-4*wClip/8,-0).subtitle(bSub).addborders(0,0,1,0), \
                                      a.converttoyuy2.crop(4*wClip/8,0,-3*wClip/8,-0).subtitle(aSub).addborders(0,0,1,0), \
                                      b.converttoyuy2.crop(5*wClip/8,0,-2*wClip/8,-0).subtitle(bSub).addborders(0,0,1,0), \
                                      a.converttoyuy2.crop(6*wClip/8,0,-1*wClip/8,-0).subtitle(aSub).addborders(0,0,1,0), \
                                      b.converttoyuy2.crop(7*wClip/8,0,-0*wClip/8,-0).subtitle(bSub).addborders(0,0,1,0)).converttoyv12 \
\
: (mode == "4x4x0") ? stackvertical(stackhorizontal(a.crop(0*wClip/4,0*hClip/4,-3*wClip/4,-3*hClip/4).subtitle(aSub), \
                                                    b.crop(1*wClip/4,0*hClip/4,-2*wClip/4,-3*hClip/4).subtitle(bSub), \
                                                    a.crop(2*wClip/4,0*hClip/4,-1*wClip/4,-3*hClip/4).subtitle(aSub), \
                                                    b.crop(3*wClip/4,0*hClip/4,-0*wClip/4,-3*hClip/4).subtitle(bSub)), \
                                    stackhorizontal(b.crop(0*wClip/4,1*hClip/4,-3*wClip/4,-2*hClip/4).subtitle(bSub), \
                                                    a.crop(1*wClip/4,1*hClip/4,-2*wClip/4,-2*hClip/4).subtitle(aSub), \
                                                    b.crop(2*wClip/4,1*hClip/4,-1*wClip/4,-2*hClip/4).subtitle(bSub), \
                                                    a.crop(3*wClip/4,1*hClip/4,-0*wClip/4,-2*hClip/4).subtitle(aSub)), \
                                    stackhorizontal(a.crop(0*wClip/4,2*hClip/4,-3*wClip/4,-1*hClip/4).subtitle(aSub), \
                                                    b.crop(1*wClip/4,2*hClip/4,-2*wClip/4,-1*hClip/4).subtitle(bSub), \
                                                    a.crop(2*wClip/4,2*hClip/4,-1*wClip/4,-1*hClip/4).subtitle(aSub), \
                                                    b.crop(3*wClip/4,2*hClip/4,-0*wClip/4,-1*hClip/4).subtitle(bSub)), \
                                    stackhorizontal(b.crop(0*wClip/4,3*hClip/4,-3*wClip/4,-0*hClip/4).subtitle(bSub), \
                                                    a.crop(1*wClip/4,3*hClip/4,-2*wClip/4,-0*hClip/4).subtitle(aSub), \
                                                    b.crop(2*wClip/4,3*hClip/4,-1*wClip/4,-0*hClip/4).subtitle(bSub), \
                                                    a.crop(3*wClip/4,3*hClip/4,-0*wClip/4,-0*hClip/4).subtitle(aSub))) \
\
: (mode == "4x4x1") ? stackvertical(stackhorizontal(a.converttoyuy2.crop(0*wClip/4,0*hClip/4,-3*wClip/4,-3*hClip/4).addborders(0,0,1,1).subtitle(aSub), \
                                                    b.converttoyuy2.crop(1*wClip/4,0*hClip/4,-2*wClip/4,-3*hClip/4).addborders(0,0,1,1).subtitle(bSub), \
                                                    a.converttoyuy2.crop(2*wClip/4,0*hClip/4,-1*wClip/4,-3*hClip/4).addborders(0,0,1,1).subtitle(aSub), \
                                                    b.converttoyuy2.crop(3*wClip/4,0*hClip/4,-0*wClip/4,-3*hClip/4).addborders(0,0,1,1).subtitle(bSub)), \
                                    stackhorizontal(b.converttoyuy2.crop(0*wClip/4,1*hClip/4,-3*wClip/4,-2*hClip/4).addborders(0,0,1,1).subtitle(bSub), \
                                                    a.converttoyuy2.crop(1*wClip/4,1*hClip/4,-2*wClip/4,-2*hClip/4).addborders(0,0,1,1).subtitle(aSub), \
                                                    b.converttoyuy2.crop(2*wClip/4,1*hClip/4,-1*wClip/4,-2*hClip/4).addborders(0,0,1,1).subtitle(bSub), \
                                                    a.converttoyuy2.crop(3*wClip/4,1*hClip/4,-0*wClip/4,-2*hClip/4).addborders(0,0,1,1).subtitle(aSub)), \
                                    stackhorizontal(a.converttoyuy2.crop(0*wClip/4,2*hClip/4,-3*wClip/4,-1*hClip/4).addborders(0,0,1,1).subtitle(aSub), \
                                                    b.converttoyuy2.crop(1*wClip/4,2*hClip/4,-2*wClip/4,-1*hClip/4).addborders(0,0,1,1).subtitle(bSub), \
                                                    a.converttoyuy2.crop(2*wClip/4,2*hClip/4,-1*wClip/4,-1*hClip/4).addborders(0,0,1,1).subtitle(aSub), \
                                                    b.converttoyuy2.crop(3*wClip/4,2*hClip/4,-0*wClip/4,-1*hClip/4).addborders(0,0,1,1).subtitle(bSub)), \
                                    stackhorizontal(b.converttoyuy2.crop(0*wClip/4,3*hClip/4,-3*wClip/4,-0*hClip/4).addborders(0,0,1,0).subtitle(bSub), \
                                                    a.converttoyuy2.crop(1*wClip/4,3*hClip/4,-2*wClip/4,-0*hClip/4).addborders(0,0,1,0).subtitle(aSub), \
                                                    b.converttoyuy2.crop(2*wClip/4,3*hClip/4,-1*wClip/4,-0*hClip/4).addborders(0,0,1,0).subtitle(bSub), \
                                                    a.converttoyuy2.crop(3*wClip/4,3*hClip/4,-0*wClip/4,-0*hClip/4).addborders(0,0,1,0).subtitle(aSub))).converttoyv12 \
\
: Eval("""return a.subtitle("This mode doesn't exit")""")
}
