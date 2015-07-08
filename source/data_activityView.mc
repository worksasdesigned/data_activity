using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.System as Sys;
using Toybox.Graphics as Gfx;


// TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST
// TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST
// first TEST for DATAFIELD
// !!!!!!!!!!!!!!!!!!!!!!!!!!!!DO NOT USE IT !!!!!!!!!!!!
// TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST
// TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST
// TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST
// TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST TEST
 
class data_activityView extends Ui.DataField {
    
    var device_settings; //basics for bluetooth indicator
    // Variables for Arc
    var deg2rad = Math.PI/180;
    var CLOCKWISE = -1;
    var COUNTERCLOCKWISE = 1;
    hidden var COLORS = [
        Gfx.COLOR_DK_RED,
        Gfx.COLOR_RED,
        Gfx.COLOR_ORANGE,
        Gfx.COLOR_PINK,
        Gfx.COLOR_PURPLE,
        Gfx.COLOR_YELLOW,
        Gfx.COLOR_BLUE,
        Gfx.COLOR_DK_BLUE,
        0x5500AA,    // Fenix purple
        Gfx.COLOR_GREEN,
        Gfx.COLOR_DK_GREEN,
        Gfx.COLOR_TRANSPARENT
        ];
        
    
       function initialize() {
        }

    function compute(info) {
        if (info.currentSpeed != null) {
            // es geht was
         }
    }
    
    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        drawActivity(dc);
        
    } // ende onUpdate


	function drawActivity(dc) {
	  var activity = ActivityMonitor.getInfo();
	  var stepsGoal = activity.stepGoal;
	  var stepsLive = activity.steps;
	  var activproz;
	  var activgewichtet;
	  var i; 
	  activproz =  100 *  activity.steps / activity.stepGoal ;
	  	  
	  if      (activproz < 10)   {i = 0;}
	  else if (activproz < 20)   {i = 1;}
	  else if (activproz < 30)   {i = 2;}
	  else if (activproz < 40)   {i = 3;}
	  else if (activproz < 50)   {i = 4;}
	  else if (activproz < 60)   {i = 5;}
	  else if (activproz < 70)   {i = 6;} 
	  else if (activproz < 80)   {i = 7;}
	  else if (activproz < 90)   {i = 8;}
	  else if (activproz < 100)  {i = 9;}
	  else {i = 10;} 
	  
	  activgewichtet =  (activproz.toFloat() / 100 ) * 176;
	  if ( activgewichtet > 176 ) { activgewichtet = 176;}    
	  
	  dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);       
	  
	  if ( stepsLive <1000){  // keliner ARC
	  //              x    y  radius    dicke    angel   offin  color                                direction
	   drawArc(dc, 114-5, 95, 114-5, 38, activgewichtet.toNumber(), -88, [COLORS[i], Gfx.COLOR_BLACK], CLOCKWISE); // grüner balken drüberlegen
	  }
	  else if (stepsLive <10000){ // mittlerer ARC
	   drawArc(dc, 114-5, 85, 114-5, 50, activgewichtet.toNumber(), -88, [COLORS[i], Gfx.COLOR_BLACK], CLOCKWISE); // grüner balken drüberlegen
      }
      else{  // fetter ARC
        drawArc(dc, 114-5, 75, 114-5, 62, activgewichtet.toNumber() + 18, -88 -9, [COLORS[i], Gfx.COLOR_BLACK], CLOCKWISE); // grüner balken drüberlegen
      }  
      
	  // Show steps and stepsGoal als numbers
	  dc.setColor( Gfx.COLOR_WHITE, COLORS[i]);
	  dc.drawText(2, 80 , Gfx.FONT_MEDIUM,stepsLive.toString() , Gfx.TEXT_JUSTIFY_LEFT);
	  if (i<10){
	       dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	  }else{dc.setColor( Gfx.COLOR_WHITE, COLORS[i]);}
	  
	  if (( stepsLive >= 1000 ) && (stepsGoal <= 10000) ) {stepsGoal = " " + stepsGoal.toString();} // zur not auch 5 stellig machen
	      
	  dc.drawText(217, 80 , Gfx.FONT_MEDIUM, stepsGoal.toString() , Gfx.TEXT_JUSTIFY_RIGHT ); // steps Goal schreiben
	  dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	  activproz = activproz.toNumber() + "%";    
	  dc.drawText(114, 0 , Gfx.FONT_MEDIUM, activproz.toString() , Gfx.TEXT_JUSTIFY_CENTER );  
	  
	  // Großer Wert anzeigen.
      var delta =  stepsGoal - stepsLive;
       dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
      if (delta >= 0){  
         dc.drawText(110, 90 , Gfx.FONT_TINY, "to GO" , Gfx.TEXT_JUSTIFY_CENTER ); 
      } else {
         dc.drawText(110, 90 , Gfx.FONT_TINY, "!!GOAL!!" , Gfx.TEXT_JUSTIFY_CENTER );
      }
      
      delta = delta.abs();  
      if  (delta < 1000 ) {
        dc.drawText(110, 20 , Gfx.FONT_NUMBER_HOT, delta.toString() , Gfx.TEXT_JUSTIFY_CENTER );
      } else{
        dc.drawText(110, 40 , Gfx.FONT_NUMBER_MEDIUM, delta.toString() , Gfx.TEXT_JUSTIFY_CENTER );
      }
      
	  // 1,2 (unten oder oben?) 
	  var test = getObscurityFlags();
	  //if (test == 7) {dc.drawText(114, 50 , Gfx.FONT_MEDIUM, "oben" , Gfx.TEXT_JUSTIFY_CENTER );}
	  //if (test == 13){dc.drawText(114, 50 , Gfx.FONT_MEDIUM, "unten" , Gfx.TEXT_JUSTIFY_CENTER );}
	  //if (test == 15){dc.drawText(114, 50 , Gfx.FONT_MEDIUM, "nur 1 feld" , Gfx.TEXT_JUSTIFY_CENTER );}  
	  
	}// Ende draw Activity

function drawArc(dc, x, y, radius, thickness, angle, offsetIn, colors, direction){
    var color = colors[0];
    var bg = colors[1];
    var curAngle;
        if(angle > 0){
            dc.setColor(color,color);
            dc.fillCircle(x,y,radius);
            
            dc.setColor(bg,bg);      
            dc.fillCircle(x,y,radius-thickness);

            if(angle < 360){
            var pts = new [33];
            pts[0] = [x,y];

            angle = 360-angle;
            var radiusClip = radius + 2;
            var offset = 90*direction+offsetIn;

            for(var i=1,dec=angle/30f; i <= 31; angle-=dec){
                curAngle = direction*(angle-offset)*deg2rad;
                pts[i] = [x+radiusClip*Math.cos(curAngle), y+radiusClip*Math.sin(curAngle)];
                i++;
            }
            pts[32] = [x,y];
            dc.setColor(bg,bg);
            dc.fillPolygon(pts);
            }
        }else{
            dc.setColor(bg,bg);
            dc.fillCircle(x,y,radius);
        }
        if(colors.size() == 3){
            var border = colors[2];
            dc.setColor(border, Gfx.COLOR_TRANSPARENT);
            dc.drawCircle(x, y, radius);
            dc.drawCircle(x, y, radius-thickness);
        }
    }   // Edne draw arc
} // ende Class
class activityDataField extends App.AppBase {
    function onStart() {
        return false;
    }

    function getInitialView() {
        return [new data_activityView()];
    }

    function onStop() {
        return false;
    }
}