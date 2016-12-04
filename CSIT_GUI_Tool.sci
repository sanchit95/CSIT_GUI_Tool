global margin_x margin_y;
global frame_w frame_h plot_w plot_h;
// Window Parameters initialization
frame_w = 200+500; frame_h = 580;// Frame width and height
plot_w = 150; plot_h = frame_h;// Plot width and heigh
margin_x = 5; margin_y = 5;// Horizontal and vertical margin
//for elements
defaultfont = "arial"; // Default Font
//axes_w = 2*margin_x + frame_w + plot_w;// axes width
//axes_h = 2*margin_y + frame_h; // axes height (100 =>
//toolbar height)
demo_lhy = scf(100001);// Create window with id=100001 and make
//it the current one
// Background and text
demo_lhy.background = -2;
demo_lhy.figure_position = [100 0];
demo_lhy.figure_name = gettext("Control System");
// Change dimensions of the figure
demo_lhy.axes_size = [1100 610]; 

//demo_lhy.axes_size = [1320 600];
//demo_lhy.figure_size = [-1 -1];
// Remove Scilab graphics menus & toolbar
delmenu(demo_lhy.figure_id,gettext("&File"));
delmenu(demo_lhy.figure_id,gettext("&Tools"));
delmenu(demo_lhy.figure_id,gettext("&Edit"));
delmenu(demo_lhy.figure_id,gettext("&?"));
toolbar(demo_lhy.figure_id,"off");
// New menu
h1 = uimenu("parent",demo_lhy, "label",gettext("File"));
h5 = uimenu("parent",demo_lhy, "label",gettext("Stability Analysis"));
h3 = uimenu("parent",demo_lhy, "label",gettext("Time domain"));
h4 = uimenu("parent",demo_lhy, "label",gettext("Frequency Domain"));
h2 = uimenu("parent",demo_lhy, "label",gettext("About"));

// Populate menu: file
uimenu(h1, "label",gettext("Close"), 'callback',"demo_lhy=get_figure_handle(100001);delete(demo_lhy);");
uimenu(h2, "label",gettext("About"),"callback","About();");
popul1=uimenu(h3, "label",gettext("Parameters"),"callback","param();");
popul2=uimenu(h3, "label",gettext("Response"),"callback","plt();");
popul3=uimenu(h4,"label",gettext("Parameters"),"callback","param_freq();");
popul4=uimenu(h4,"label",gettext("Response"),"callback","resp();");
uimenu(h5,"label",gettext("Nyquist plot"),"callback","nyq();");
uimenu(h5,"label",gettext("Pole-zero plot"),"callback","pzp();");
uimenu(h5,"label",gettext("Root locus"),"callback","rlc();");
//sleep(500);

//--------------------------------------outer- dhacha uptill here--------------------------------------------------------------//


my_frame = uicontrol("parent",demo_lhy, "relief","groove","style","frame", "units","pixels","position",[5 5 500 600],"horizontalalignment","center", "background",[1 1 1],"tag","frame_control");
//_______________outer box frame LHS-----------//////////

//my_frame_title = uicontrol("parent",demo_lhy, "style","text","string","System", "units","pixels","position",[70+margin_x margin_y+frame_h-10 frame_w-60 20],"fontname",defaultfont, "fontunits","points","fontsize",16, "horizontalalignment","center","background",[1 1 1], "tag","title_frame_control"); 

///////----------numerator & den ka edit box---------////////////
textsys1 = uicontrol("parent",demo_lhy,"relief","groove","style","edit","units","pixels","position",[margin_x+100 500 400-70 30],"tag","nter1");
textsys2 = uicontrol("parent",demo_lhy,"relief","groove","style","edit","units","pixels","position",[margin_x+100 450 400-70 30],"tag","nter2");

//////////-----numerator & denominator ka text------------//
dispnum = uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Numerator","position",[margin_x+3 500 95 30]);
dispden = uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Denominator","position",[margin_x+3 450 95 30]);


//________________________________system attributes left ----------------------//

//____________text boxes left attributes____________________//
dispsys = uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","System","position",[margin_x+3 400-50-50 95 60]);
disppol = uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Poles","position",[margin_x+3 350-50-50 95 30]);
dispzer = uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Zeros","position",[margin_x+3 300-50-50 95 30]);
dispgain = uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Gain","position",[margin_x+3 250-50-50 95 30]);
dispstab = uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Stability","position",[margin_x+3 200-50-50 95 30]);
dispsysa = uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+100 400-50-50 400-70 60],"fontsize",14,"background",[1 1 1],"foreground",[0.3,0.2,0.8],"tag","sysa");
disppola = uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+100 350-50-50 400-70 30],"fontsize",14,"background",[1 1 1],"foreground",[0.3,0.2,0.8],"tag","pola");
dispzera = uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+100 300-50-50 400-70 30],"fontsize",14,"background",[1 1 1],"foreground",[0.3,0.2,0.8],"tag","zera");
dispgaina = uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+100 250-50-50 400-70 30],"fontsize",14,"background",[1 1 1],"foreground",[0.3,0.2,0.8],"tag","gaina");
dispstaba = uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+100 200-50-50 400-70 30],"fontsize",14,"background",[1 1 1],"foreground",[0.3,0.2,0.8],"tag","staba");

//__________________________________________________________________________________________________________________________________________________//



//_____________Button to enter to kae action_______________//
enter = uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+100+330+5 450 60 80],"string","ENTER","callback","enter();"); 

//______________________________________________________________________//



function About()
     messagebox([
"The GUI is developed by the FOSSEE control systems toolbox team (IIT Bombay)."
"FOSSEE (Free and Open Software in Education) project promotes the use of FOSS tools to improve the quality of education in our country. We aim to reduce dependency on proprietary software in educational institutions."
"The FOSSEE project is part of the National Mission on Education through Information and Communication Technology (ICT), Ministry of Human Resources and Development, Government of India."
"AUTHORS:" 
"Ashutosh Bhargava"
"        Inderpreet Arora"
"        Paresh Yeole"
"        Rutuja Moharil"
"        Sanchit Gupta"
 ], "About")
endfunction

function enter()

    sysnum = findobj("tag","nter1");
    sysden = findobj("tag","nter2");
    syst =(sysnum.string+"/"+sysden.string);
    s=%s;
    sys=evstr(sysnum.string)/evstr(sysden.string);


    sys=syslin('c',sys);
    aa=sys;
    textsys = findobj("tag","sysa");textsys.string=string(syst);
    hh=(pole(sys))
    hh=cell2mat(hh)
    a=real(hh)
    b=imag(hh)
    textsys = findobj("tag","pola");
    x=size(hh,'r');
    //if b<0 then
    sts=" ";
    for k=1:x
        if b(k)<0 then
            sts=string(string(sts)+" "+string(string(a(k))+string(b(k))+" i"+"  "));
        elseif b(k)==0
            sts=string(string(sts)+" "+string(string(a(k))+"  "));
        else
            sts=string(string(sts)+" "+string(string(a(k))+"+"+string(b(k))+" i"+"  "));           
        end  
    end
    textsys.string=sts;

    [uu,vv]=zero(sys,1)

    uu=cell2mat(uu)
    a=real(uu)
    b=imag(uu)
    textsys = findobj("tag","zera");
    x=size(uu,'r');
    sts=" ";
    for k=1:x
        if b(k)<0 then
            if a(k)==0 then
                sts=string(string(sts)+" "+string(string(b(k))+" i"+"  "));
            else
                sts=string(string(sts)+" "+string(string(a(k))+string(b(k))+" i"+"  "));
            end
        elseif b(k)==0
            sts=string(string(sts)+" "+string(string(a(k))+"  "));
        else
            if a(k)==0 then
                sts=string(string(sts)+" "+"+"+string(string(b(k))+" i"+"  ")); 
            else
                sts=string(string(sts)+" "+string(string(a(k))+"+"+string(b(k))+" i"+"  "));           
            end
        end  
    end
    textsys.string=sts;
    //  disp(typeof(sys1))
    textsys = findobj("tag","gaina");textsys.string=string(string(vv));
    aa=isStable(sys)
    if aa==%t then
        textsys = findobj("tag","staba");textsys.string=string("STABLE");
    else
        textsys = findobj("tag","staba");textsys.string=string("UNSTABLE");   
    end

endfunction 

//left layout ends here-_____________________//


//Right layout______________________________________________________________
//--------------------time domain-----------------------------------------------------------------------------------------------//
function plt()
    hh=gce();
    //hh.visible="off";
    delete(hh);
    tag_off();
     tag3 = findobj("tag","gc");
    tag3.visible="off"
    tag4 = findobj("tag","pc");
    tag4.visible="off"
    tag5 = findobj("tag","pcro");
    tag5.visible="off"
    tag6 = findobj("tag","gcro");
    tag6.visible="off"
    tag7 = findobj("tag","gm11");
    tag7.visible="off"
    tag8 = findobj("tag","gm");
    tag8.visible="off"
    tag9 = findobj("tag","pm11");
    tag9.visible="off"
    tag10 = findobj("tag","pm");
    tag10.visible="off"
    x=0:5;
    plot2d(sin(x));
    xgrid(5,1,7)
    plot1 = gca();
    plot1.grid = color("lightgrey")*ones(1, 3)
    plot1.margins = [0.5,0.05,0.125,0.3]; 
    delete();


  uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 100 330 40],"tag","impuls","string","impulse","callback","impuls();");


    uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 100 20 40],"tag","impulsi","string","?","callback","knowimpulse();");

    uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 40 330 40],"tag","step","string","step-plot","callback","stepp();");

   uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 40 20 40],"tag","steppi","string","?","callback","knowstep();");

    //initali=uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 80 20 40],"tag","impuls1i","string","?","callback","knowsigma();");
    ////    iopi= uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 140 20 40],"tag","impuls2i","string","?","callback","knowiopz();");
endfunction


function param()        
    hh=gce();
    delete(hh);    
    tag_off();
     
    //define the stepinfo and the steasy state error//-------------------------------------------------------------------------------------
    uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 100 330 40],"tag","step1","string","Stepinfo","callback","stepinfo1();");   
    uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 100 20 40],"tag","stepi","string","?","callback","knowstepinfo();");
    //    uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 40 330 40],"tag","steady1","string","Steady state error","callback","steady();");   
    //  uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 40 20 40],"tag","steadyi","string","?","callback","knowsteady();");



endfunction
//// time domain ends /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



//--------------------freq domain-----------------------------------------------------------------------------------------------------------//
function resp()
    hh=gce();
    delete(hh);

    tag_off();
     tag3 = findobj("tag","gc");
    tag3.visible="off"
    tag4 = findobj("tag","pc");
    tag4.visible="off"
    tag5 = findobj("tag","pcro");
    tag5.visible="off"
    tag6 = findobj("tag","gcro");
    tag6.visible="off"
    tag7 = findobj("tag","gm11");
    tag7.visible="off"
    tag8 = findobj("tag","gm");
    tag8.visible="off"
    tag9 = findobj("tag","pm11");
    tag9.visible="off"
    tag10 = findobj("tag","pm");
    tag10.visible="off"
    uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 100 330 40],"tag","margin1","string","Margin","callback","mgin();");
    uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 100 20 40],"tag","margini","string","?","callback","knowmargin();");

    uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 40 330 40],"tag","bode1","string","Bode","callback","bde();");
    uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 40 20 40],"tag","bodei","string","?","callback","knowbode();");
endfunction

function param_freq()
    hh=gce();
    delete(hh);

    tag_off();
    uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 40 330 40],"tag","marg","string","Margins","callback","margin_frp();");
    uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 40 20 40],"tag","margi","string","?","callback","knowmarg();");

    uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 160 330 40],"tag","p6","string","Bandwidth","callback","bandwidth1();");
    uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 160 20 40],"tag","p6i","string","?","callback","knowbwidth();");

    uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 100 330 40],"tag","p7","string","Dc Gain","callback","dcgain1();");
    uicontrol("parent",demo_lhy,"relief","groove","style","pushbutton","units","pixels","position",[margin_x+600 100 20 40],"tag","p7i","string","?","callback","knowdc();");
endfunction

//-------functions-----------------------------------------------------------------//


//time domain response plots----------------------------------------------------------------------------------------//
function impuls()  


    sysnum = findobj("tag","nter1");
    sysden = findobj("tag","nter2");
    syst =(sysnum.string+"/"+sysden.string);
    s=%s;
    sys=evstr(sysnum.string)/evstr(sysden.string);
    sys=syslin('c',sys);
    plot1 = gca();
    plot1.margins = [0.5,0.05,0.125,0.3]; 
    impulse(sys);
    plot1.title.font_size = 3; 
    plot1.title.text=("IMPULSE PLOT")
    plot1.auto_clear="on"

endfunction
function knowimpulse()
messagebox([
"In control systems, the impulse response of a dynamic system is its output when presented with a brief input signal, "
"called an impulse. More generally, an impulse response is the reaction of any dynamic system in response to some external " 
"change. In both cases, the impulse response describes the reaction of the system as a function of time (or possibly as a "
"function of some other independent variable that parameterizes the dynamic behavior of the system)."
""
"For further reading, you may visit the link below:-"
"Reference : https://en.wikipedia.org/wiki/Impulse_response"
 ], "Impulse Response")
endfunction

function knowstep()
    messagebox([
"The step response of a system in a given initial state consists of the time evolution of its outputs when its control"
"inputs are unit step functions. In electronic engineering and control theory, step response is the time behaviour"
"of the outputs of a general system when its inputs change from zero to one in a very short time. The concept can be "
"extended to the abstract mathematical notion of a dynamical system using an evolution parameter."
""
"For further reading, you may visit the link below:-"
"Reference : https://en.wikipedia.org/wiki/Step_response"
 ], "Step Response")
endfunction
function stepp()
    sysnum = findobj("tag","nter1");
    sysden = findobj("tag","nter2");
    syst =(sysnum.string+"/"+sysden.string);
    s=%s;
    sys=evstr(sysnum.string)/evstr(sysden.string);
    sys=syslin('c',sys);
    plot1 = gca();
    plot1.margins = [0.5,0.05,0.125,0.3]; 
    stepplot(sys)
    plot1.title.font_size = 3; 
    plot1.title.text=("STEP PLOT")
    plot1.auto_clear="on"

endfunction
//-----------------------------------------------------------------------------------------------------------------------------------------//

//-----------time domain parameters--------------------------------------------------------------------------------------------------------//
function knowstepinfo()
    messagebox([
"This function computes system characteristics when unit step input is given to the system. "
"  RiseTime:     The time taken by the system to reach from 10% to 90% of its steady state value"
"  SettlingTime: The time taken by the system to reach within 2% of its final value"
"  SettlingMin:  Minimum value of amplitude once the response has risen "
"  SettlingMax:  Maximum value of amplitude once the response has risen "
"  Overshoot:    Percentage overshoot (relative to steady state value) "
"  Undershoot:   Percentage undershoot (related to steady state value) "
"  Peak:         Maximum absolute value of the amplitude of the system "
"  PeakTime:     The time at which peak absolute value is reached"
""
"For further reading, you may visit the link below:-"
"Reference : https://upload.wikimedia.org/wikipedia/commons/e/e4/Control_Systems.pdf"
 ], "Stepinfo")
endfunction

function stepinfo1()
    hh=gca()
    delete(hh);
    tag_off();
    tag1 = findobj("tag","stepi");
    tag1.visible="on"
    tag1 = findobj("tag","step1");
    tag1.visible="on"
    
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Peak time","position",[margin_x+600 250 150 30],"fontsize",14,"tag","l1");
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+600+150+10 250 150 30],"fontsize",14,"background",[1 1 1],"foreground",[0.8,0.2,0.1],"tag","peakt");

    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Peak","position",[margin_x+600 290 150 30],"fontsize",14,"tag","l2");
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+600+150+10 290 150 30],"fontsize",14,"background",[1 1 1],"foreground",[0.8,0.2,0.1],"tag","peak");

    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Undershoot","position",[margin_x+600 320 150 30],"fontsize",14,"tag","l3");
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+600+150+10 320 150 30],"fontsize",14,"background",[1 1 1],"foreground",[0.8,0.2,0.1],"tag","under");

    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Overshoot","position",[margin_x+600 360 150 30],"fontsize",14,"tag","l4");
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+600+150+10 360 150 30],"fontsize",14,"background",[1 1 1],"foreground",[0.8,0.2,0.1],"tag","over");


    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Settling MaX","position",[margin_x+600 400 150 30],"fontsize",14,"tag","l5");
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+600+150+10 400 150 30],"fontsize",14,"background",[1 1 1],"foreground",[0.8,0.2,0.1],"tag","setmax");


    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Settling Min","position",[margin_x+600 440 150 30],"fontsize",14,"tag","l6");
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+600+150+10 440 150 30],"fontsize",14,"background",[1 1 1],"foreground",[0.8,0.2,0.1],"tag","setmin");


    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Settling time","position",[margin_x+600 480 150 30],"fontsize",14,"tag","l7");
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+600+150+10 480 150 30],"fontsize",14,"background",[1 1 1],"foreground",[0.8,0.2,0.1],"tag","set");


    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Rise Time","position",[margin_x+600 520 150 30],"fontsize",14,"tag","l8");
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+600+150+10 520 150 30],"fontsize",14,"background",[1 1 1],"foreground",[0.8,0.2,0.1],"tag","rise");

    sysnum = findobj("tag","nter1");
    sysden = findobj("tag","nter2");
    syst =(sysnum.string+"/"+sysden.string);
    s=%s;
    sys=evstr(sysnum.string)/evstr(sysden.string);
    sys=syslin('c',sys);

    aa=sys;

    [x1 x2 x3 x4 x5 x6 x7 x8]=stepinfo(aa);
    textsys = findobj("tag","peakt");textsys.string=string(x8);
    textsys = findobj("tag","peak");textsys.string=string(x7);
    textsys = findobj("tag","under");textsys.string=string(x6);
    textsys = findobj("tag","over");textsys.string=string(x5);
    textsys = findobj("tag","setmax");textsys.string=string(x4);
    textsys = findobj("tag","setmin");textsys.string=string(x3);
    textsys = findobj("tag","set");textsys.string=string(x2);
    textsys = findobj("tag","rise");textsys.string=string(x1);



endfunction

//----------------freq domain response-----------------------------------------------------------------------------------------------//
function knowmargin()
    messagebox([
"Margin plot is a Bode Plot where we show Gain margin and Phase margin inside the plot. It helps us to find"
"the corresponding Gain Crossover frequency and Phase Crossover frequency."
""
"Gain Margin"
"It is the factor by which the gain of the system can be increased to drive it to the verge of instability."
"Phase Margin"
"The phase margin can be defined as the amount of additional phase lag at the gain crossover frequency to bring"
"the system on the verge of instability."
"Gain Crossover frequency"
"The frequency at which the gain of the system reaches unity is called Gain crossover frequency."
"Phase Crossover Frequency"
"The frequency at which the phase shift of the system is equal to -180 degrees is called phase crossover frequency."
""
""
"For further reading, you may visit the link below:-"
"Reference : https://upload.wikimedia.org/wikipedia/commons/e/e4/Control_Systems.pdf"
], "Margins Plot")
endfunction

function mgin()
    
    sysnum = findobj("tag","nter1");
    sysden = findobj("tag","nter2");
    syst =(sysnum.string+"/"+sysden.string);
    s=%s;
    sys=evstr(sysnum.string)/evstr(sysden.string);
    sys=syslin('c',sys);
    //    plot1 = gca();
    //    plot1.margins = [0.5,0.125,0.125,0.5]; 

    plot1 = scf(100002);
    plot1.background = -2;
    plot1.figure_position = [650 80];
    plot1.axes_size = [500 320];
    demo_lhy1.figure_name = gettext("SHOW MARGIN");
    show_margins(sys);
    hh=gca();
    hh.auto_clear="on"

endfunction





function knowbode()
     //Bode Plot messagebox
messagebox([
"Bode Gain Plots, or Bode Magnitude Plots display the ratio of the system gain at each input frequency."
"Bode Gain Plot"
"Bode gain plot is the plot of the magnitude in decibels and frequency in decades."
"Bode Phase Plot"
"Bode phase plots are plots of the phase shift to an input waveform dependent on the frequency characteristics" 
"of the system input. The plot is between phase in degrees and frequency in decades."
""
"For further reading, you may visit the link below:-"
"Reference : https://upload.wikimedia.org/wikipedia/commons/e/e4/Control_Systems.pdf"
], "Bode Plot")
endfunction
function bde()
    
    sysnum = findobj("tag","nter1");
    sysden = findobj("tag","nter2");
    syst =(sysnum.string+"/"+sysden.string);
    s=%s;
    sys=evstr(sysnum.string)/evstr(sysden.string);
    sys=syslin('c',sys);

    plot1 = scf(100002);
    plot1.background = -2;
    plot1.figure_position = [650 80];
    plot1.axes_size = [500 320];
    demo_lhy1.figure_name = gettext("BODE");
    bode(sys);
    hh=gca();
    hh.auto_clear="on"

endfunction
//---------------------------------------------------------------------------------------------------------------------------------------------//


//---freq domain parameters---------------------------//
function knowmarg()
messagebox([
"Gain Margin"
"It is the factor by which the gain of the system can be increased to drive it to the verge of instability."
"Phase Margin"
"The phase margin can be defined as the amount of additional phase lag at the gain crossover frequency to bring"
"the system on the verge of instability."
"Gain Crossover frequency"
"The frequency at which the gain of the system reaches unity is called Gain crossover frequency."
"Phase Crossover Frequency"
"The frequency at which the phase shift of the system is equal to -180 degrees is called phase crossover frequency."
""
"For further reading, you may visit the link below:-"
"Reference : https://upload.wikimedia.org/wikipedia/commons/e/e4/Control_Systems.pdf"
 ], "Margins")

endfunction
function  margin_frp()

    hh=gce();
    delete(hh);
    tag_off();
   tag46 = findobj("tag","marg");
    tag46.visible="on"
    tag47= findobj("tag","margi");
    tag47.visible="on"
    tag41 = findobj("tag","p7");
    tag41.visible="on"
    tag42 = findobj("tag","p7i");
    tag42.visible="on"
    tag43 = findobj("tag","p6");
    tag43.visible="on"
    tag44 = findobj("tag","p6i");
    tag44.visible="on"
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Gain Margin","position",[margin_x+600 500 150 30],"fontsize",14,"tag","gm11");
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+600+150+10 500 200 30],"fontsize",14,"background",[1 1 1],"foreground",[0.8,0.2,0.1],"tag","gm");
  uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Phase Margin","position",[margin_x+600 450 150 30],"fontsize",14,"tag","pm11");
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+600+150+10 450 200 30],"fontsize",14,"background",[1 1 1],"foreground",[0.8,0.2,0.1],"tag","pm");
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Gain crossover frequency","position",[margin_x+600 370 200 30],"fontsize",14,"tag","gcro");
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+600+200+10 370 150 30],"fontsize",14,"background",[1 1 1],"foreground",[0.8,0.2,0.1],"tag","gc");
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Phase crossover frequency","position",[margin_x+600 320 200 30],"fontsize",14,"tag","pcro");
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+600+200+10 320 150 30],"fontsize",14,"background",[1 1 1],"foreground",[0.8,0.2,0.1],"tag","pc");
    sysnum = findobj("tag","nter1");
    sysden = findobj("tag","nter2");
    syst =(sysnum.string+"/"+sysden.string);
    s=%s;
    sys=evstr(sysnum.string)/evstr(sysden.string);
    sys=syslin('c',sys);
    [g_1 pp]=g_margin(sys);
    [p_1 gg]=p_margin(sys);
    textsys = findobj("tag","gm");textsys.string=string(string(g_1));
    textsys = findobj("tag","pc");textsys.string=string(string(pp));
    textsys = findobj("tag","pm");textsys.string=string(string(p_1));
    textsys = findobj("tag","gc");textsys.string=string(string(gg));

endfunction
function knowbwidth()
    messagebox([
"Bandwidth is often defined relative to the maximum value, and is most commonly the 3dB-point,that is"
"the point where the spectral density is half its maximum value (or the spectral amplitude, in V or V/Hz,"
"is more than 70.7% of its maximum)."
""
"For further reading, you may visit the link below:-"
"Reference : https://en.wikipedia.org/wiki/Bandwidth_(signal_processing)"
 ], "Bandwidth")
endfunction
function bandwidth1() 
//    hh=gca()
//    delete(hh)
tag_off();
     tag46 = findobj("tag","marg");
    tag46.visible="on"
    tag47= findobj("tag","margi");
    tag47.visible="on"
    tag41 = findobj("tag","p7");
    tag41.visible="on"
    tag42 = findobj("tag","p7i");
    tag42.visible="on"
    tag43 = findobj("tag","p6");
    tag43.visible="on"
    tag44 = findobj("tag","p6i");
    tag44.visible="on"
uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Bandwidth","position",[margin_x+600 500 150 30],"fontsize",14,"tag","bd1");
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+600+150+10 500 150 30],"fontsize",14,"background",[1 1 1],"foreground",[0.8,0.2,0.1],"tag","bd");
  
    sysnum = findobj("tag","nter1");
    sysden = findobj("tag","nter2");
    syst =(sysnum.string+"/"+sysden.string);
    s=%s;
    sys=evstr(sysnum.string)/evstr(sysden.string);
    sys=syslin('c',sys);
    aa=bandwidth(sys);
    textsys = findobj("tag","bd");textsys.string=string(aa);

endfunction   

function knowdc()
    messagebox([
"This gives th gain constant (K) of the Linear Time invariant system."
""
"For further reading, you may visit the link below:-"
"Reference : https://upload.wikimedia.org/wikipedia/commons/e/e4/Control_Systems.pdf"
 ], "DC Gain")
endfunction
function dcgain1()
 tag_off();
    tag46 = findobj("tag","marg");
    tag46.visible="on"
    tag47= findobj("tag","margi");
    tag47.visible="on"
    tag41 = findobj("tag","p7");
    tag41.visible="on"
    tag42 = findobj("tag","p7i");
    tag42.visible="on"
    tag43 = findobj("tag","p6");
    tag43.visible="on"
    tag44 = findobj("tag","p6i");
    tag44.visible="on"
   
uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","string","Dc Gain","position",[margin_x+600 500 150 30],"fontsize",14,"tag","dc11");
    uicontrol("parent",demo_lhy,"relief","groove","style","text","units","pixels","position",[margin_x+600+150+10 500 150 30],"fontsize",14,"background",[1 1 1],"foreground",[0.8,0.2,0.1],"tag","dc");
    sysnum = findobj("tag","nter1");
    sysden = findobj("tag","nter2");
    syst =(sysnum.string+"/"+sysden.string);
    s=%s;
    sys=evstr(sysnum.string)/evstr(sysden.string);
    sys=syslin('c',sys);
    aa=dcgain(sys);
    textsys = findobj("tag","dc");textsys.string=string(aa);
endfunction   

//--------------------------stability--------------------//
function nyq()
    tag_off();
    hh=gca()
    delete(hh.children)
    sysnum = findobj("tag","nter1");
    sysden = findobj("tag","nter2");
    syst =(sysnum.string+"/"+sysden.string);
    s=%s;
    sys=evstr(sysnum.string)/evstr(sysden.string);
    sys=syslin('c',sys);
    plot1 = gca();
    plot1.margins = [0.55,0.05,0.125,0.125]                                  //[0.6,0.125,0.125,0.125]; 
    nyquist(sys)

endfunction

function pzp()
    hh=gca()
    delete(hh.children)
    tag_off();
    sysnum = findobj("tag","nter1");
    sysden = findobj("tag","nter2");
    syst =(sysnum.string+"/"+sysden.string);
    s=%s;
    sys=evstr(sysnum.string)/evstr(sysden.string);
    sys=syslin('c',sys);
    plot1 = gca();
    plot1.margins = [0.55,0.05,0.125,0.125]; 
    plzr(sys)

endfunction

function rlc()
    hh=gca()
    delete(hh.children)
    tag_off();
    sysnum = findobj("tag","nter1");
    sysden = findobj("tag","nter2");
    syst =(sysnum.string+"/"+sysden.string);
    s=%s;
    sys=evstr(sysnum.string)/evstr(sysden.string);
    sys=syslin('c',sys);
    plot1 = gca();
    plot1.margins = [0.55,0.05,0.125,0.125]; 
    evans(sys)

endfunction
//Please put left hand attributes function below this-------------------//


function tag_off()
    
   
    tag1 = findobj("tag","bd11");
    tag1.visible="off"
    tag2 = findobj("tag","bd");
    tag2.visible="off"
    tag3 = findobj("tag","gc");
    tag3.visible="off"
    tag4 = findobj("tag","pc");
    tag4.visible="off"
    tag5 = findobj("tag","pcro");
    tag5.visible="off"
    tag6 = findobj("tag","gcro");
    tag6.visible="off"
    tag7 = findobj("tag","gm11");
    tag7.visible="off"
    tag8 = findobj("tag","gm");
    tag8.visible="off"
    tag9 = findobj("tag","pm11");
    tag9.visible="off"
    tag10 = findobj("tag","pm");
    tag10.visible="off"
    tag11 = findobj("tag","dc1l");
    tag11.visible="off"
    tag12 = findobj("tag","dc");
    tag12.visible="off"
    tag13 = findobj("tag","bd1l");
    tag13.visible="off"
    tag14 = findobj("tag","bd");
    tag14.visible="off"
    tag15 = findobj("tag","impuls");
    tag15.visible="off"
    tag16 = findobj("tag","impulsi");
    tag16.visible="off"
     tag17 = findobj("tag","step");
    tag17.visible="off"
    tag18 = findobj("tag","steppi");
    tag18.visible="off"
     tag19 = findobj("tag","stepi");
    tag19.visible="off"
    tag20 = findobj("tag","step1");
    tag20.visible="off"
    tag21 = findobj("tag","margin1");
    tag21.visible="off"
    tag22 = findobj("tag","margini");
    tag22.visible="off"
    tag23 = findobj("tag","bode1");
    tag23.visible="off"
    tag24 = findobj("tag","bodei");
    tag24.visible="off"
    tag25 = findobj("tag","l1");
    tag25.visible="off"
    tag26 = findobj("tag","l2");
    tag26.visible="off"
    tag27 = findobj("tag","l3");
    tag27.visible="off"
    tag28= findobj("tag","l4");
    tag28.visible="off"
    tag29 = findobj("tag","l5");
    tag29.visible="off"
    tag30 = findobj("tag","l6");
    tag30.visible="off"
    tag31 = findobj("tag","l7");
    tag31.visible="off"
    tag32 = findobj("tag","l8");
    tag32.visible="off"
    tag33 = findobj("tag","peakt");
    tag33.visible="off"
    tag34 = findobj("tag","peak");
    tag34.visible="off"
    tag35 = findobj("tag","under");
    tag35.visible="off"
    tag36 = findobj("tag","over");
    tag36.visible="off"
    tag37 = findobj("tag","setmax");
    tag37.visible="off"
    tag38 = findobj("tag","setmin");
    tag38.visible="off"
    tag39 = findobj("tag","set");
    tag39.visible="off"
    tag40 = findobj("tag","rise");
    tag40.visible="off"
    tag41 = findobj("tag","p7");
    tag41.visible="off"
    tag42 = findobj("tag","p7i");
    tag42.visible="off"
    tag43 = findobj("tag","p6");
    tag43.visible="off"
    tag44 = findobj("tag","p6i");
    tag44.visible="off"
    tag45= findobj("tag","margin1");
    tag45.visible="off"
    tag46 = findobj("tag","marg");
    tag46.visible="off"
    tag47= findobj("tag","margi");
    tag47.visible="off"

endfunction
















