// Light detection on input Digital 2

#define NUM_READINGS 3
unsigned long timerReadings[NUM_READINGS];

long lastReading = 0;

bool readingsReady = false;

int readIndex = 0;

char buffer[50];

const unsigned long MICROSECS_PER_MIN = 60ul * 1000ul * 1000ul;


void myIsr();

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);


  for(int i = 0; i < NUM_READINGS; i++)
  {
    timerReadings[i] = 0;
  }

  lastReading = 0;
  readingsReady = false;
  readIndex = 0;
  
  attachInterrupt(digitalPinToInterrupt(2), myIsr, RISING);
  
}

void loop() {
  // put your main code here, to run repeatedly:

  while(1)
  {
    delay(100);
  
    // for(int i = 0; i < NUM_READINGS; i++)
    // {
    //   sprintf(buffer, "Reading %d = %lu\n", i, timerReadings[i]);
    //   Serial.print(buffer);
    /// }

    // The laser will pulse 3 times for every rotation, so we can just sum up all the timings to get our reading
    unsigned long rotationPeriod = 0;
    for(int i = 0; i < NUM_READINGS; i++)
    {
      rotationPeriod += timerReadings[i];
    }

    unsigned long msSinceBoot = millis();
    int tenths = msSinceBoot / 100 % 10;
    int secs = msSinceBoot / 1000;
    
    int rpm;
    
    if (rotationPeriod == 0)
    {
      rpm = 0;
    }
    else
    {
      rpm = (MICROSECS_PER_MIN / rotationPeriod);
    }
    
    Serial.print(secs);
    Serial.print(".");
    Serial.print(tenths);
    Serial.print(" RPM = ");
    Serial.print(rpm);
    Serial.print("\n");
  }
}

void myIsr()
{
  unsigned long currentTimerVal = micros();

  if (lastReading == 0)
  {
    // We have never read the timer before
    lastReading = currentTimerVal;
    return;
  }  

  unsigned long currentDiff = currentTimerVal - lastReading;
  lastReading = currentTimerVal;

  timerReadings[readIndex] = currentDiff;

  readIndex++;

  if (readIndex >= NUM_READINGS)
  {
    readIndex = 0;

    // Incase this wasn't set yet, set it to true
    readingsReady = true;
    
  }
  
}

