import processing.core.*; 
import processing.xml.*; 

import org.json.*; 
import processing.serial.*; 

import org.json.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class glitchLearning extends PApplet {




String baseURL = "http://api.glitch.com/simple/skills.listLearning?oauth_token=cD0yOTczMiZzYz1yZWFkJnQ9MTMxMzE3MjAzOCZ1PTI5NzgzJmg9ODQ3ZjI5MDhkNjhmOTY0Yw";

Serial arduino;  // Create object from Serial class

Boolean newReport = true;

String lastName;
public void setup() {
  String listDev = Serial.list()[0];
  arduino = new Serial(this, listDev, 115200);

}

public void draw() {

 println("Am I learning anything? " + isLearning());
  if (isLearning()){
    getGlitchData();
  }

delay(1000);
}



public boolean isLearning() {
  String request = baseURL;
  try {
    JSONObject fullResults = new JSONObject(join(loadStrings(request), ""));
    JSONObject learning = fullResults.getJSONObject("learning");
    arduino.write("^");
    return true;
  }
  catch (JSONException e) {
    arduino.write("_");
    newReport =true;
    return false;
  }
}

public void getGlitchData() {
  
  String request = baseURL;
  try {
    JSONObject fullResults = new JSONObject(join(loadStrings(request), ""));
    JSONObject learning = fullResults.getJSONObject("learning");
    JSONObject skill = learning.getJSONObject(fullResults.getNames(learning)[0]);
    arduino.write('|');  
    println("You are currently learning: ");
    println(skill.getString("name"));



    arduino.write('~'); 
    arduino.write(skill.getString("name")+"      ");
    lastName = skill.getString("name");
    
    println(lastName);
    
    int timeleft = skill.getInt("time_remaining");
    int minleft = timeleft/60;
    println("Time left: "+minleft/60 + " Hours " + (minleft - 60*(minleft/60)) + " Minutes");
    arduino.write('}'); arduino.write('}');arduino.write('}');arduino.write('}');
    
    arduino.write("Time Left: "+minleft/60 + " H " + (minleft - 60*(minleft/60)) + " M              "); 
    //arduino.write('|'); 
    
    if (fullResults.getNames(learning)[0].matches("tinkering_4")) {
      println("YESSS");
    }
  }

  catch (JSONException e) {
    println ("There was an error parsing the JSONObject.");
  }
};

  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "glitchLearning" });
  }
}
