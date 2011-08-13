#include <NokiaLCD.h>
byte inByte = 0;         // incoming serial byte


// Nokia LCD Setup settings
#define WHITE 0xFFF
#define BLACK 0x000
#define RED 0xF00
#define GREEN 0x0F0
#define BLUE 0x00F
#define CYAN 0x0FF
#define MAGENTA 0xF0F
#define YELLOW 0xFF0
#define BROWN 0xB22
#define ORANGE 0xFA0
#define PINK 0xF6A
NokiaLCD nokiaLcd;

char text [50];
char skill[22];
int wordcount=0;

String skillName;
int up=1;
void setup()
{

  DDRD |= B01111100;   // Set SPI pins as output 
  PORTD |= B01111100;  // Set SPI pins HIGH

  nokiaLcd.lcd_init();
  //delay(500);

  // start serial port at 9600 bps:
  Serial.begin(115200);
  pinMode(12, OUTPUT); 
  pinMode(13, OUTPUT);
 nokiaLcd.lcd_clear(BLACK,0,0,131,131);
  strcpy(text,"Glitch Learning Center");
  nokiaLcd.lcd_draw_text(RED, BLACK, 0, 23, text);
        strcpy(text,"  Created by");
      nokiaLcd.lcd_draw_text(ORANGE, BLACK, 0, 50, text);
       strcpy(text,"        Vlad Cazan");
      nokiaLcd.lcd_draw_text(GREEN, BLACK, 0, 75, text);
}

void loop()
{
  // if we get a valid byte, read analog ins:
  if (Serial.available() > 0) {
                 strcpy(text,"                 ");
      nokiaLcd.lcd_draw_text(ORANGE, BLACK, 0, 50, text);
            strcpy(text," Currently Learning: ");
      nokiaLcd.lcd_draw_text(ORANGE, BLACK, 0, 75, text);
    // get incoming byte:
    inByte = Serial.read(); 
    if (inByte == 94){
      digitalWrite(13, HIGH);
      digitalWrite(12, LOW);
      Serial.flush();
      inByte = 0;
    }    
    if (inByte == 95){
      digitalWrite(13, LOW);
      digitalWrite(12, HIGH);
      Serial.flush(); 
      inByte = 0;
      strcpy(text,"NOT LEARNING ANYTHING");
      nokiaLcd.lcd_draw_text(BLACK, WHITE, 0, 110, text);
            strcpy(text,"                ");
      nokiaLcd.lcd_draw_text(GREEN, BLACK, 0, 95,skill);
    } 
    if (inByte == 126){
      wordcount=0;
      for (int x=0;x<24;x++){
        skill[x] = 0;
      }
      
      nokiaLcd.lcd_draw_text(CYAN, BLACK, 0, 95, skill);
    }
    else{
      skill[wordcount] = inByte;
      if (up == 1){
        nokiaLcd.lcd_draw_text(GREEN, BLACK, 0, 95,skill);
        wordcount++;
        Serial.print(skill);
      }

    }

    if (inByte == 125){
      up = 0;
      wordcount=0;
      for (int x=0;x<24;x++){
        skill[x] = 0;
      }
     // nokiaLcd.lcd_draw_text(CYAN, BLACK, 0, 95, skill);

    }
    else{
      skill[wordcount] = inByte;
      if (up == 0){
        nokiaLcd.lcd_draw_text(BLACK, WHITE, 0, 110, skill);
        wordcount++;
        Serial.print(skill);
   
      }
    }
    if (inByte == 124){
      up = 1;
      wordcount=0;
      for (int x=0;x<24;x++){
        skill[x] = 0;
      }
      //nokiaLcd.lcd_draw_text(CYAN, BLACK, 0, 95, skill);

    }



  }


}







