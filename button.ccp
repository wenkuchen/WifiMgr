/*
  Debounce

  https://www.arduino.cc/en/Tutorial/BuiltInExamples/Debounce
*/

// constants won't change. They're used here to set pin numbers:
const int buttonPin = 15;  // the number of the pushbutton pin GPIO15
//All GPIO pins (except GPIO36, GPIO39, GPIO34, and GPIO35 pins) 
//have these two circuits internally in the ESP32.

const unsigned long holdThreshold = 5000; // if holding exceeds this, it is a HOLD event
const unsigned int debounceDelay = 30; // the debounce time; increase if the output flickers

typedef enum  { // enum of button events
  CLICK, // 0
  DBLCLICK, // 1
  HOLD, // 2
} BTN_EVENTS;

typedef enum  { // enum of button Finite State Machine states
  RELEASED, // 0
  PRESSED, // 1
  DEBOUNCE1, // 2
  DEBOUNCE2 // 3
} BTN_FSM;

unsigned long lastClickTime = 0 ; // for check of double clicks
unsigned long lastPressTime = 0 ; // for holding counter

BTN_FSM state = RELEASED; // initial state of the button
BTN_EVENTS event;

void eventHandler(BTN_EVENTS event){
  switch(event){
    case CLICK: 
      // do something here
      break;
    case DBLCLICK: 
      // do something here
      break;
    case HOLD: 
      // do something here
      break;

    delay(30); // igonre button input
    lastClickTime = millis(); // reset
  }
}

void setup() {
  pinMode(buttonPin, INPUT_PULLUP);

}

void loop() { 

    switch(state) { // Finite State Machine 

      case RELEASED: 
        while(digitalRead(buttonPin)==LOW); // wait until button pressed
        state = DEBOUNCE1;
        break; 

      case PRESSED: 
        lastPressTime = millis();
        while(digitalRead(buttonPin)==HIGH); // wait until button released
        state = DEBOUNCE2;
        break;

      case DEBOUNCE1: 
        delay(debounceDelay);
        if (digitalRead(buttonPin)==HIGH) 
            state = PRESSED;
          else 
            state = RELEASED; // bounce back to RELEASED
        break;

      case DEBOUNCE2: 
        delay(debounceDelay);

        if (digitalRead(buttonPin)==LOW) {
          if ((lastPressTime-millis())>holdThreshold) 
            eventHandler(HOLD);
          else if ((lastClickTime-millis())<300)
            eventHandler(CLICK);
          else
            eventHandler(DBLCLICK);
          state = RELEASED;
        }
        else 
          state = PRESSED;  // bounce back to PRESSED

        break;
  }
}
