import org.json.*;
import processing.serial.*;

String baseURL = "http://api.glitch.com/simple/skills.listLearning?oauth_token=XXXXXXXXXXX"

Serial arduino;  // Create object from Serial class

void setup() {
  String listDev = Serial.list()[0];
  arduino = new Serial(this, listDev, 9600);

}

void draw() {

 println("Am I learning anything? " + isLearning());
  if (isLearning()){
    getGlitchData();
  }
delay(5000);
}



boolean isLearning() {
  String request = baseURL;
  try {
    JSONObject fullResults = new JSONObject(join(loadStrings(request), ""));
    JSONObject learning = fullResults.getJSONObject("learning");
    arduino.write('Y');              
    return true;

  }
  catch (JSONException e) {
    arduino.write('N');              
    return false;
  }
}

void getGlitchData() {
  String request = baseURL;
  try {
    JSONObject fullResults = new JSONObject(join(loadStrings(request), ""));
    JSONObject learning = fullResults.getJSONObject("learning");
    JSONObject skill = learning.getJSONObject(fullResults.getNames(learning)[0]);

    println("You are currently learning: ");
    println(skill.getString("name"));

    int timeleft = skill.getInt("time_remaining");
    int minleft = timeleft/60;
    println("Time left: "+minleft/60 + " Hours " + (minleft - 60*(minleft/60)) + " Minutes");

    if (fullResults.getNames(learning)[0].matches("tinkering_4")) {
      println("YESSS");
    }
  }

  catch (JSONException e) {
    println ("There was an error parsing the JSONObject.");
  }
};

