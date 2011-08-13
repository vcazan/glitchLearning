import org.json.*;
import processing.serial.*;

String baseURL = "http://api.glitch.com/simple/skills.listLearning?oauth_token=cD0yOTczMiZzYz1yZWFkJnQ9MTMxMzE3MjAzOCZ1PTI5NzgzJmg9ODQ3ZjI5MDhkNjhmOTY0Yw";

Serial arduino;  // Create object from Serial class

Boolean newReport = true;

String lastName;
void setup() {
  String listDev = Serial.list()[0];
  arduino = new Serial(this, listDev, 115200);

}

void draw() {

 println("Am I learning anything? " + isLearning());
  if (isLearning()){
    getGlitchData();
  }

delay(1000);
}



boolean isLearning() {
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

void getGlitchData() {
  
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

