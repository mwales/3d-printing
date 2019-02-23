

#include <Arduino.h>
#include <SPI.h>
#include "Adafruit_BLE.h"
#include "Adafruit_BluefruitLE_SPI.h"
#include "Adafruit_BluefruitLE_UART.h"

#include <Adafruit_NeoPixel.h>

#include "BluefruitConfig.h"

#include <SoftwareSerial.h>

#include <Wire.h>
#include <Adafruit_MotorShield.h>
/*=========================================================================
    APPLICATION SETTINGS

      FACTORYRESET_ENABLE       Perform a factory reset when running this sketch
     
                                Enabling this will put your Bluefruit LE module
                              in a 'known good' state and clear any config
                              data set in previous sketches or projects, so
                                running this at least once is a good idea.
     
                                When deploying your project, however, you will
                              want to disable factory reset by setting this
                              value to 0.  If you are making changes to your
                                Bluefruit LE device via AT commands, and those
                              changes aren't persisting across resets, this
                              is the reason why.  Factory reset will erase
                              the non-volatile memory where config data is
                              stored, setting it back to factory default
                              values.
         
                                Some sketches that require you to bond to a
                              central device (HID mouse, keyboard, etc.)
                              won't work at all with this feature enabled
                              since the factory reset will clear all of the
                              bonding data stored on the chip, meaning the
                              central device won't be able to reconnect.
    MINIMUM_FIRMWARE_VERSION  Minimum firmware version to have some new features
    MODE_LED_BEHAVIOUR        LED activity, valid options are
                              "DISABLE" or "MODE" or "BLEUART" or
                              "HWUART"  or "SPI"  or "MANUAL"
    -----------------------------------------------------------------------*/
#define FACTORYRESET_ENABLE         0
#define MINIMUM_FIRMWARE_VERSION    "0.6.6"
#define MODE_LED_BEHAVIOUR          "MODE"
/*=========================================================================*/

// Create the bluefruit object hardware SPI, using SCK/MOSI/MISO hardware SPI pins and then user selected CS/IRQ/RST */
Adafruit_BluefruitLE_SPI ble(BLUEFRUIT_SPI_CS, BLUEFRUIT_SPI_IRQ, BLUEFRUIT_SPI_RST);

// Which pin on the Arduino is connected to the NeoPixels?
// On a Trinket or Gemma we suggest changing this to 1
#define NEO_PIXEL_PIN            20

// How many NeoPixels are attached to the Arduino?
#define NUMPIXELS      20

// When we setup the NeoPixel library, we tell it how many pixels, and which pin to use to send signals.
// Note that for older NeoPixel strips you might need to change the third parameter--see the strandtest
// example for more information on possible values.
Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, NEO_PIXEL_PIN, NEO_GRB + NEO_KHZ800);

// A small helper
void error(const __FlashStringHelper*err) {
  Serial.println(err);
  while (1);
}

/**************************************************************************/
/* MP3 Library
/**************************************************************************/

#define ARDUINO_RX 19  //should connect to TX of the Serial MP3 Player module
#define ARDUINO_TX 18  //connect to RX of the module

SoftwareSerial mp3(ARDUINO_RX, ARDUINO_TX);
//#define mp3 Serial3    // Connect the MP3 Serial Player to the Arduino MEGA Serial3 (14 TX3 -> RX, 15 RX3 -> TX)

static int8_t Send_buf[8] = {0}; // Buffer for Send commands.  // BETTER LOCALLY
static uint8_t ansbuf[10] = {0}; // Buffer for the answers.    // BETTER LOCALLY

String mp3Answer;           // Answer from the MP3.

/************ Command byte **************************/
#define CMD_NEXT_SONG     0X01  // Play next song.
#define CMD_PREV_SONG     0X02  // Play previous song.
#define CMD_PLAY_W_INDEX  0X03
#define CMD_VOLUME_UP     0X04
#define CMD_VOLUME_DOWN   0X05
#define CMD_SET_VOLUME    0X06

#define CMD_SNG_CYCL_PLAY 0X08  // Single Cycle Play.
#define CMD_SEL_DEV       0X09
#define CMD_SLEEP_MODE    0X0A
#define CMD_WAKE_UP       0X0B
#define CMD_RESET         0X0C
#define CMD_PLAY          0X0D
#define CMD_PAUSE         0X0E
#define CMD_PLAY_FOLDER_FILE 0X0F

#define CMD_STOP_PLAY     0X16
#define CMD_FOLDER_CYCLE  0X17
#define CMD_SHUFFLE_PLAY  0x18 //
#define CMD_SET_SNGL_CYCL 0X19 // Set single cycle.

#define CMD_SET_DAC 0X1A
#define DAC_ON  0X00
#define DAC_OFF 0X01

#define CMD_PLAY_W_VOL    0X22
#define CMD_PLAYING_N     0x4C
#define CMD_QUERY_STATUS      0x42
#define CMD_QUERY_VOLUME      0x43
#define CMD_QUERY_FLDR_TRACKS 0x4e
#define CMD_QUERY_TOT_TRACKS  0x48
#define CMD_QUERY_FLDR_COUNT  0x4f

/************ Opitons **************************/
#define DEV_TF            0X02


///*********************************************************************/
//
//void setup()
//{
//  Serial.begin(9600);
//  mp3.begin(9600);
//  delay(500);
//
//  sendCommand(CMD_SEL_DEV, DEV_TF);
//  delay(500);
//}
//
//
//void loop()
//{
//  char c = ' ';
//
//  // If there a char on Serial call sendMP3Command to sendCommand
//  if ( Serial.available() )
//  {
//    c = Serial.read();
//    sendMP3Command(c);
//  }
//
//  // Check for the answer.
//  if (mp3.available())
//  {
//    Serial.println(decodeMP3Answer());
//  }
//  delay(100);
//}


/********************************************************************************/
/*Function sendMP3Command: seek for a 'c' command and send it to MP3  */
/*Parameter: c. Code for the MP3 Command, 'h' for help.                                                                                                         */
/*Return:  void                                                                */

//void sendMP3Command(char c) {
//  switch (c) {
//    case '?':
//    case 'h':
//      Serial.println("HELP  ");
//      Serial.println(" p = Play");
//      Serial.println(" P = Pause");
//      Serial.println(" > = Next");
//      Serial.println(" < = Previous");
//      Serial.println(" + = Volume UP");
//      Serial.println(" - = Volume DOWN");
//      Serial.println(" c = Query current file");
//      Serial.println(" q = Query status");
//      Serial.println(" v = Query volume");
//      Serial.println(" x = Query folder count");
//      Serial.println(" t = Query total file count");
//      Serial.println(" 1 = Play folder 1");
//      Serial.println(" 2 = Play folder 2");
//      Serial.println(" 3 = Play folder 3");
//      Serial.println(" 4 = Play folder 4");
//      Serial.println(" 5 = Play folder 5");
//      Serial.println(" S = Sleep");
//      Serial.println(" W = Wake up");
//      Serial.println(" r = Reset");
//      break;
//
//
//    case 'p':
//      Serial.println("Play ");
//      sendCommand(CMD_PLAY, 0);
//      break;
//
//    case 'P':
//      Serial.println("Pause");
//      sendCommand(CMD_PAUSE, 0);
//      break;
//
//    case '>':
//      Serial.println("Next");
//      sendCommand(CMD_NEXT_SONG, 0);
//      sendCommand(CMD_PLAYING_N, 0x0000); // ask for the number of file is playing
//      break;
//
//    case '<':
//      Serial.println("Previous");
//      sendCommand(CMD_PREV_SONG, 0);
//      sendCommand(CMD_PLAYING_N, 0x0000); // ask for the number of file is playing
//      break;
//
//    case '+':
//      Serial.println("Volume Up");
//      sendCommand(CMD_VOLUME_UP, 0);
//      break;
//
//    case '-':
//      Serial.println("Volume Down");
//      sendCommand(CMD_VOLUME_DOWN, 0);
//      break;
//
//    case 'c':
//      Serial.println("Query current file");
//      sendCommand(CMD_PLAYING_N, 0);
//      break;
//
//    case 'q':
//      Serial.println("Query status");
//      sendCommand(CMD_QUERY_STATUS, 0);
//      break;
//
//    case 'v':
//      Serial.println("Query volume");
//      sendCommand(CMD_QUERY_VOLUME, 0);
//      break;
//
//    case 'x':
//      Serial.println("Query folder count");
//      sendCommand(CMD_QUERY_FLDR_COUNT, 0);
//      break;
//
//    case 't':
//      Serial.println("Query total file count");
//      sendCommand(CMD_QUERY_TOT_TRACKS, 0);
//      break;
//
//    case '1':
//      Serial.println("Play folder 1");
//      sendCommand(CMD_FOLDER_CYCLE, 0x0101);
//      break;
//
//    case '2':
//      Serial.println("Play folder 2");
//      sendCommand(CMD_FOLDER_CYCLE, 0x0201);
//      break;
//
//    case '3':
//      Serial.println("Play folder 3");
//      sendCommand(CMD_FOLDER_CYCLE, 0x0301);
//      break;
//
//    case '4':
//      Serial.println("Play folder 4");
//      sendCommand(CMD_FOLDER_CYCLE, 0x0401);
//      break;
//
//    case '5':
//      Serial.println("Play folder 5");
//      sendCommand(CMD_FOLDER_CYCLE, 0x0501);
//      break;
//
//    case 'S':
//      Serial.println("Sleep");
//      sendCommand(CMD_SLEEP_MODE, 0x00);
//      break;
//
//    case 'W':
//      Serial.println("Wake up");
//      sendCommand(CMD_WAKE_UP, 0x00);
//      break;
//
//    case 'r':
//      Serial.println("Reset");
//      sendCommand(CMD_RESET, 0x00);
//      break;
//  }
//}
//
//
//
///********************************************************************************/
///*Function decodeMP3Answer: Decode MP3 answer.                                  */
///*Parameter:-void                                                               */
///*Return: The                                                  */
//
//String decodeMP3Answer() {
//  String decodedMP3Answer = "";
//
//  decodedMP3Answer += sanswer();
//
//  switch (ansbuf[3]) {
//    case 0x3A:
//      decodedMP3Answer += " -> Memory card inserted.";
//      break;
//
//    case 0x3D:
//      decodedMP3Answer += " -> Completed play num " + String(ansbuf[6], DEC);
//      break;
//
//    case 0x40:
//      decodedMP3Answer += " -> Error";
//      break;
//
//    case 0x41:
//      decodedMP3Answer += " -> Data recived correctly. ";
//      break;
//
//    case 0x42:
//      decodedMP3Answer += " -> Status playing: " + String(ansbuf[6], DEC);
//      break;
//
//    case 0x48:
//      decodedMP3Answer += " -> File count: " + String(ansbuf[6], DEC);
//      break;
//
//    case 0x4C:
//      decodedMP3Answer += " -> Playing: " + String(ansbuf[6], DEC);
//      break;
//
//    case 0x4E:
//      decodedMP3Answer += " -> Folder file count: " + String(ansbuf[6], DEC);
//      break;
//
//    case 0x4F:
//      decodedMP3Answer += " -> Folder count: " + String(ansbuf[6], DEC);
//      break;
//  }
//
//  return decodedMP3Answer;
//}






/********************************************************************************/
/*Function: Send command to the MP3                                         */
/*Parameter:-int8_t command                                                     */
/*Parameter:-int16_ dat  parameter for the command                              */

void sendMp3Command(int8_t command, int16_t dat)
{
  delay(20);
  Send_buf[0] = 0x7e;   //
  Send_buf[1] = 0xff;   //
  Send_buf[2] = 0x06;   // Len
  Send_buf[3] = command;//
  Send_buf[4] = 0x01;   // 0x00 NO, 0x01 feedback
  Send_buf[5] = (int8_t)(dat >> 8);  //datah
  Send_buf[6] = (int8_t)(dat);       //datal
  Send_buf[7] = 0xef;   //
  Serial.print("Sending: ");
  for (uint8_t i = 0; i < 8; i++)
  {
    mp3.write(Send_buf[i]) ;
    Serial.print(sbyte2hex(Send_buf[i]));
  }
  Serial.println();
}



/********************************************************************************/
/*Function: sbyte2hex. Returns a byte data in HEX format.                 */
/*Parameter:- uint8_t b. Byte to convert to HEX.                                */
/*Return: String                                                                */


String sbyte2hex(uint8_t b)
{
  String shex;

  shex = "0X";

  if (b < 16) shex += "0";
  shex += String(b, HEX);
  shex += " ";
  return shex;
}




/********************************************************************************/
/*Function: sanswer. Returns a String answer from mp3 UART module.          */
/*Parameter:- uint8_t b. void.                                                  */
/*Return: String. If the answer is well formated answer.                        */

String sanswer(void)
{
  uint8_t i = 0;
  String mp3answer = "";

  // Get only 10 Bytes
  while (mp3.available() && (i < 10))
  {
    uint8_t b = mp3.read();
    ansbuf[i] = b;
    i++;

    mp3answer += sbyte2hex(b);
  }

  // if the answer format is correct.
  if ((ansbuf[0] == 0x7E) && (ansbuf[9] == 0xEF))
  {
    return mp3answer;
  }

  return "???: " + mp3answer;
}

/**************************************************************************/
/* Motor Shield Setup */
/**************************************************************************/

// Create the motor shield object with the default I2C address
Adafruit_MotorShield AFMS = Adafruit_MotorShield(); 
// Or, create it with a different I2C address (say for stacking)
// Adafruit_MotorShield AFMS = Adafruit_MotorShield(0x61); 

// Select which 'port' M1, M2, M3 or M4. In this case, M1
Adafruit_DCMotor *myMotor = AFMS.getMotor(1);

/**************************************************************************/
/*!
    @brief  Sets up the HW an the BLE module (this function is called
            automatically on startup)
*/
/**************************************************************************/
void setup(void)
{
  while (!Serial);  // required for Flora & Micro
  delay(500);

  Serial.begin(115200);
  Serial.println(F("Adafruit Bluefruit Command <-> Data Mode Example"));
  Serial.println(F("------------------------------------------------"));

  /* Initialise the module */
  Serial.print(F("Initialising the Bluefruit LE module: "));

  if ( !ble.begin(VERBOSE_MODE) )
  {
    error(F("Couldn't find Bluefruit, make sure it's in CoMmanD mode & check wiring?"));
  }
  Serial.println( F("OK!") );

  /* Disable command echo from Bluefruit */
  ble.echo(false);

  Serial.println("Requesting Bluefruit info:");
  /* Print Bluefruit information */
  ble.info();

  Serial.println(F("Please use Adafruit Bluefruit LE app to connect in UART mode"));
  Serial.println(F("Then Enter characters to send to Bluefruit"));
  Serial.println();

  ble.verbose(false);  // debug info is a little annoying after this point!

  pixels.begin(); // This initializes the NeoPixel library.

  /* Wait for connection */
  while (! ble.isConnected()) {
    delay(500);
  }

  Serial.println(F("******************************"));

  // LED Activity command is only supported from 0.6.6
  if ( ble.isVersionAtLeast(MINIMUM_FIRMWARE_VERSION) )
  {
    // Change Mode LED Activity
    Serial.println(F("Change LED activity to " MODE_LED_BEHAVIOUR));
    ble.sendCommandCheckOK("AT+HWModeLED=" MODE_LED_BEHAVIOUR);
  }

  // Set module to DATA mode
  Serial.println( F("Switching to DATA mode!") );
  ble.setMode(BLUEFRUIT_MODE_DATA);

  Serial.println(F("******************************"));

  // MP3 Setup
  mp3.begin(9600);
  delay(500);

  sendMp3Command(CMD_RESET, 0);

  sendMp3Command(CMD_SEL_DEV, DEV_TF);
  delay(500);

  AFMS.begin();  // create with the default frequency 1.6KHz

  myMotor->setSpeed(0);
  myMotor->run(FORWARD);
  // turn on motor
  myMotor->run(RELEASE);
}

float readBatteryVoltage()
{
#define VBATPIN A9

  float measuredvbat = 0;
  for (int i = 0; i < 4; i++)
  {
    // Average 4 readings
    measuredvbat += analogRead(VBATPIN);
  }

  // Normally voltage is * 2 * 3.3 / 1024.0.  Since we already implied a * 4, our formula is going to be * 1.65 / 1024.0,
  // or more simply... /= 620.6
  //measuredvbat *= 2;    // we divided by 2, so multiply back
  //measuredvbat *= 3.3;  // Multiply by 3.3V, our reference voltage
  //measuredvbat /= 1024; // convert to voltage
  measuredvbat /= 620.6;
  return measuredvbat;
}

void printHelpToPhone()
{
  ble.print("Help Menu [");
  ble.print(readBatteryVoltage() , 3);
  ble.println("V]");

  ble.println("? = This help");
  ble.println("k = KITT Scanner Mode");
  ble.println("p = Police State");
  ble.println("i = Idle State");
  ble.println("r = Reverse Motor");
  ble.println("0-9 = Motor Speed");
  
}

int currentState = 0;
#define IDLE_STATE 0
#define KITT_SCANNER_STATE 1
#define POLICE_SCANNER_STATE 2

int stateCounter = 0;

int currentSpeed = 0;
int directionFlag = 0;

void reverseMotorDirection()
{
  int originalSpeed = currentSpeed;

  setMotorSpeed(0);

  delay(200);

  if (directionFlag)
  {
    ble.println("Motor changed to forward");
    directionFlag = 0;
  }
  else
  {
    ble.println("Motor changed to backward");
    directionFlag = 1;
  }

  setMotorSpeed(originalSpeed);
}

void setMotorSpeed(int speed)
{
  ble.print("Setting motor speed to ");
  ble.print(speed);
  ble.print("...  ");

  if (directionFlag)
  {
    myMotor->run(BACKWARD);  
  }
  else
  {
    myMotor->run(FORWARD);
  }

  int step;
  if (speed == currentSpeed)
  {
    return;
  }

  if (speed > currentSpeed)
  {
    step = 1;
  }
  else
  {
    step = -1;
  }

  while(speed != currentSpeed)
  {
    currentSpeed += step;
    Serial.print("Speed = ");
    Serial.println(currentSpeed);
    myMotor->setSpeed(currentSpeed);
    delay(25);
  }
  
  myMotor->setSpeed(speed);  

  if (speed == 0)
  {
    myMotor->run(RELEASE);
  }

  ble.println("Done!");
}


void shutOffScannerLeds()
{
  // Set all scanner LEDs to off
  for (int i = 0; i < 8; i++)
  {
    pixels.setPixelColor(i, pixels.Color(0, 0, 0)); // off
  }

  pixels.show(); // This sends the updated pixel color to the hardware.
}

void shutOffAllLeds()
{
  // Set all scanner LEDs to off
  for (int i = 0; i < 20; i++)
  {
    pixels.setPixelColor(i, pixels.Color(0, 0, 0)); // off
  }

  pixels.show(); // This sends the updated pixel color to the hardware.
}

//***************************************************
// KITT functions
//***************************************************
void startKittState()
{
  // Start Knight Rider Music
  sendMp3Command(CMD_SET_VOLUME, 30);
  sendMp3Command(CMD_SNG_CYCL_PLAY, 1);
}

void stopKittState()
{
  shutOffScannerLeds();

  sendMp3Command(CMD_STOP_PLAY, 0);
}

void doKittScannerState()
{
  // 16 Scanner states.  0 - 7 lit scanning up, 0-7  lit scanning down
  int ledPosition = stateCounter & 0x0f;

  if (ledPosition >= 8)
  {
    // scanning back down states!
    ledPosition = 15 - ledPosition;
  }

  // Set all LEDs to off
  for (int i = 0; i < 8; i++)
  {
    pixels.setPixelColor(i, pixels.Color(0, 0, 0)); // off
  }

  // Set current LED on
  pixels.setPixelColor(ledPosition, pixels.Color(255, 0, 0));

  switch (ledPosition)
  {
    case 0:
      //pixels.setPixelColor(ledPosition - 2, pixels.Color(5, 0, 0));
      //pixels.setPixelColor(ledPosition - 1, pixels.Color(50, 0, 0));
      pixels.setPixelColor(ledPosition + 1, pixels.Color(50, 0, 0));
      pixels.setPixelColor(ledPosition + 2, pixels.Color(5, 0, 0));
      break;

    case 1:
      //pixels.setPixelColor(ledPosition - 2, pixels.Color(5, 0, 0));
      pixels.setPixelColor(ledPosition - 1, pixels.Color(50, 0, 0));
      pixels.setPixelColor(ledPosition + 1, pixels.Color(50, 0, 0));
      pixels.setPixelColor(ledPosition + 2, pixels.Color(5, 0, 0));
      break;

    case 2:
    case 3:
    case 4:
    case 5:
      // Simple, non-edge cases
      pixels.setPixelColor(ledPosition - 2, pixels.Color(5, 0, 0));
      pixels.setPixelColor(ledPosition - 1, pixels.Color(50, 0, 0));
      pixels.setPixelColor(ledPosition + 1, pixels.Color(50, 0, 0));
      pixels.setPixelColor(ledPosition + 2, pixels.Color(5, 0, 0));
      break;

    case 6:
      pixels.setPixelColor(ledPosition - 2, pixels.Color(5, 0, 0));
      pixels.setPixelColor(ledPosition - 1, pixels.Color(50, 0, 0));
      pixels.setPixelColor(ledPosition + 1, pixels.Color(50, 0, 0));
      //pixels.setPixelColor(ledPosition + 2, pixels.Color(5, 0, 0));
      break;

    case 7:
      pixels.setPixelColor(ledPosition - 2, pixels.Color(5, 0, 0));
      pixels.setPixelColor(ledPosition - 1, pixels.Color(50, 0, 0));
      //pixels.setPixelColor(ledPosition + 1, pixels.Color(50, 0, 0));
      //pixels.setPixelColor(ledPosition + 2, pixels.Color(5, 0, 0));
      break;
  }

  pixels.show(); // This sends the updated pixel color to the hardware.
}

//***************************************************
// Police Mode functions
//***************************************************

#define RED_NP   255, 0,   0
#define BLUE_NP  0,   0,   255
#define WHITE_NP 255, 255, 255

void startPoliceState()
{
  // Songs 2 and 3 are both cop songs, pick 1 at random
  if (stateCounter & 1)
  {
    Serial.println("Playing song 2 - Sound of da Police");
    sendMp3Command(CMD_SET_VOLUME, 30);
    sendMp3Command(CMD_SNG_CYCL_PLAY, 2);
  }
  else
  {
    Serial.println("Plaing song 3 - Bad Boys");
    sendMp3Command(CMD_SET_VOLUME, 27);
    sendMp3Command(CMD_SNG_CYCL_PLAY, 3);
  }
}

void stopPoliceState()
{
  shutOffAllLeds();

  sendMp3Command(CMD_STOP_PLAY, 0);
}

void doPoliceState()
{
  // 4 Scanner states.
  //   White + Blue
  //   Red + White
  //   Blue + White
  //   White + Red

  int ledPosition = stateCounter & 0x03;

  switch (ledPosition)
  {
    case 0:
      pixels.setPixelColor(0, pixels.Color(WHITE_NP));
      pixels.setPixelColor(7, pixels.Color(WHITE_NP));
      pixels.setPixelColor(1, pixels.Color(BLUE_NP));
      pixels.setPixelColor(6, pixels.Color(BLUE_NP));
      pixels.setPixelColor(2, pixels.Color(BLUE_NP));
      pixels.setPixelColor(5, pixels.Color(BLUE_NP));
      break;

    case 1:
      pixels.setPixelColor(0, pixels.Color(RED_NP));
      pixels.setPixelColor(7, pixels.Color(RED_NP));
      pixels.setPixelColor(1, pixels.Color(WHITE_NP));
      pixels.setPixelColor(6, pixels.Color(WHITE_NP));
      pixels.setPixelColor(2, pixels.Color(RED_NP));
      pixels.setPixelColor(5, pixels.Color(RED_NP));
      break;

    case 2:
      pixels.setPixelColor(0, pixels.Color(BLUE_NP));
      pixels.setPixelColor(7, pixels.Color(BLUE_NP));
      pixels.setPixelColor(1, pixels.Color(WHITE_NP));
      pixels.setPixelColor(6, pixels.Color(WHITE_NP));
      pixels.setPixelColor(2, pixels.Color(BLUE_NP));
      pixels.setPixelColor(5, pixels.Color(BLUE_NP));
      break;

    case 3:
      pixels.setPixelColor(0, pixels.Color(WHITE_NP));
      pixels.setPixelColor(7, pixels.Color(WHITE_NP));
      pixels.setPixelColor(1, pixels.Color(RED_NP));
      pixels.setPixelColor(6, pixels.Color(RED_NP));
      pixels.setPixelColor(2, pixels.Color(RED_NP));
      pixels.setPixelColor(5, pixels.Color(RED_NP));
      break;
  }

  // Jet leds will light up too
  if (ledPosition & 0x01)
  {
    // RED Jet LEDs
    for (int i = 8; i < 20; i+=2)
    {
      pixels.setPixelColor(i, pixels.Color(RED_NP));
    }
  }
  else
  {
    // Blue Jet LEDs
    for (int i = 8; i < 20; i+=2)
    {
      pixels.setPixelColor(i, pixels.Color(BLUE_NP));
    }
  }

  pixels.show(); // This sends the updated pixel color to the hardware.
}

void stopState()
{
  switch (currentState)
  {
    case KITT_SCANNER_STATE:
      ble.println("Stopping KITT");
      stopKittState();
      break;

    case POLICE_SCANNER_STATE:
      ble.println("Stopping Police");
      stopPoliceState();
      break;

    default:
      ble.print("Exitting state #");
      ble.println(currentState);
  }
}

void startState(int stateNum)
{
  stopState();



  switch (stateNum)
  {
    case KITT_SCANNER_STATE:
      ble.println("Starting KITT");
      startKittState();
      break;

    case POLICE_SCANNER_STATE:
      ble.println("Starting Police State");
      startPoliceState();
      break;

    default:
      ble.print("Starting state #");
      ble.println(stateNum);
  }

  stateCounter = 0;

  currentState = stateNum;
}



void doStateFunctions()
{
  //Serial.print("Doing state functions (counter = ");
  //Serial.print(stateCounter);
  //Serial.println(")");

  switch (currentState)
  {
    case KITT_SCANNER_STATE:
      doKittScannerState();
      break;

    case POLICE_SCANNER_STATE:
      doPoliceState();
      break;

    //default:
      //Serial.println("Unknown state");
  }

  delay(100);

  stateCounter++;
}

/**************************************************************************/
/*!
    @brief  Constantly poll for new command or response data
*/
/**************************************************************************/
void loop(void)
{
  // Check for user input
  char n, inputs[BUFSIZE + 1];

  if (Serial.available())
  {
    n = Serial.readBytes(inputs, BUFSIZE);
    inputs[n] = 0;
    // Send characters to Bluefruit
    Serial.print("Sending: ");
    Serial.println(inputs);

    // Send input data to host via Bluefruit
    ble.print(inputs);
  }

  // Echo received data
  while ( ble.available() )
  {
    int c = ble.read();

    Serial.print((char)c);

    // Hex output too, helps w/debugging!
    Serial.print(" [0x");
    if (c <= 0xF) Serial.print(F("0"));
    Serial.print(c, HEX);
    Serial.print("] ");

    if (c == '?')
    {
      printHelpToPhone();
    }

    if (c == 'k')
    {
      startState(KITT_SCANNER_STATE);
    }

    if (c == 'p')
    {
      startState(POLICE_SCANNER_STATE);
    }

    if (c == 'i')
    {
      startState(IDLE_STATE);
    }

    if (c == '0')
    {
      setMotorSpeed(0);
    }

    if ( (c >= '1') && (c <= '8') )
    {
      int speedVal = c - '0';
      setMotorSpeed(speedVal * 30);
    }

    if (c == '9')
    {
      setMotorSpeed(255);
    }

    if (c == 'r')
    {
      reverseMotorDirection();
    }
  }

  doStateFunctions();
}
