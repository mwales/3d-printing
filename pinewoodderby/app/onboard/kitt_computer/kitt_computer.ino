

#include <Arduino.h>
#include <SPI.h>
#include "Adafruit_BLE.h"
#include "Adafruit_BluefruitLE_SPI.h"
#include "Adafruit_BluefruitLE_UART.h"

#include <Adafruit_NeoPixel.h>

#include "BluefruitConfig.h"

#if SOFTWARE_SERIAL_AVAILABLE
  #include <SoftwareSerial.h>
#endif

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
}

void printHelpToPhone()
{
  ble.println("Help Menu");
  ble.println("? = This help");
  ble.println("k = KITT Scanner Mode");
  ble.println("p = Police State");
  ble.println("i = Idle State");
}

int currentState = 0;
#define IDLE_STATE 0
#define KITT_SCANNER_STATE 1
#define POLICE_SCANNER_STATE 2

int stateCounter = 0;


void shutOffScannerLeds()
{
  // Set all scanner LEDs to off
  for(int i = 0; i < 8; i++)
  {
    pixels.setPixelColor(i, pixels.Color(0,0,0)); // off
  }

  pixels.show(); // This sends the updated pixel color to the hardware.
}

void shutOffAllLeds()
{
  // Set all scanner LEDs to off
  for(int i = 0; i < 20; i++)
  {
    pixels.setPixelColor(i, pixels.Color(0,0,0)); // off
  }

  pixels.show(); // This sends the updated pixel color to the hardware.
}

//***************************************************
// KITT functions
//***************************************************

void stopKittState()
{
  shutOffScannerLeds();
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
  for(int i = 0; i < 8; i++)
  {
    pixels.setPixelColor(i, pixels.Color(0,0,0)); // off
  }

  // Set current LED on
  pixels.setPixelColor(ledPosition, pixels.Color(255, 0, 0));
  
  switch(ledPosition)
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
void stopPoliceState()
{
  shutOffAllLeds();
}

void doPoliceState()
{
  // 4 Scanner states.
  //   White + Blue
  //   Red + White
  //   Blue + White
  //   White + Red
  
  int ledPosition = stateCounter & 0x03;

  switch(ledPosition)
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
    for(int i = 8; i < 20; i++)
    {
      pixels.setPixelColor(i, pixels.Color(RED_NP));
    }
  }
  else
  {
    // Blue Jet LEDs
    for(int i = 8; i < 20; i++)
    {
      pixels.setPixelColor(i, pixels.Color(BLUE_NP));
    }
  }

  pixels.show(); // This sends the updated pixel color to the hardware.
}

void stopState()
{
  switch(currentState)
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
  
  stateCounter = 0;
  
  switch(stateNum)
  {
    case KITT_SCANNER_STATE:
      ble.println("Starting KITT");
      break;

    case POLICE_SCANNER_STATE:
      ble.println("Starting Police State");
      break;

    default:
      ble.print("Starting state #");
      ble.println(stateNum);
  }

  currentState = stateNum;  
}



void doStateFunctions()
{
  Serial.print("Doing state functions (counter = ");
  Serial.print(stateCounter);
  Serial.println(")");

  switch(currentState)
  {
    case KITT_SCANNER_STATE:
      doKittScannerState();
      break;

    case POLICE_SCANNER_STATE:
      doPoliceState();
      break;
      
    default:
    Serial.println("Unknown state");
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
  char n, inputs[BUFSIZE+1];

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
  }

  doStateFunctions();
}
