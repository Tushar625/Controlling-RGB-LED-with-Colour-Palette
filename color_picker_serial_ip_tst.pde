import processing.serial.*;


Serial arduino;

PImage colorPalatte;


// data used for sampling

boolean sample = false;

color c;

int x, y;

String colorStr;


/*
    this function runs before setup and it is necessary if we need to set size of the
    window according to some variable
    
    https://processing.org/reference/settings_.html
    
    https://processing.org/reference/size_.html
*/

public void settings()
{
    colorPalatte = loadImage("hsv.jpg");
    
    size(colorPalatte.width, colorPalatte.height);
}

/*
    same as setup in arduino
*/

public void setup()
{
    /*
        creating the serial object to communicate with arduino
        
        I am using Serial.list()[0] as the name of the serial port because it works for
        me, if it fails just replace it with the name of the serial port you wanna access
    */
    
    arduino = new Serial(this, Serial.list()[0], 9600);
}

/*
    same as loop in arduino
*/

public void draw()
{
    // https://processing.org/reference/background_.html
    
    background(0);  // clear the screen before rendering the image
    
    // https://processing.org/reference/image_.html
    
    image(colorPalatte, 0, 0);  // rendering the image
    
    /*
        If sample is true, the RGB color value of the pixel under the mouse pointer in the image
        is retrieved
    */
    
    if(sample)
    {
        if(x != mouseX || y != mouseY)
        {
            // if mouse is moved, update x, y and c (colour of the pixel) according to the mouse pointer position
            
            x = mouseX; y = mouseY;
          
            c = colorPalatte.get(x, y);
          
            colorStr = int(red(c)) + "," + int(green(c)) + "," + int(blue(c));
            
            arduino.write(colorStr + "\n");
        }
        
        // drawing a circle with no filler but a thick outline with colour of the pixel, around the sample point
        
        noFill();
        
        stroke(c);
        
        strokeWeight(8);
        
        ellipse(x, y, 30, 30);
        
        // writing the rgb value of sample point
        
        fill(255);
        
        textSize(20);
        
        text(colorStr, x + 35, y + 5);
    }
}

/*
    this function gets executed when a mouse button is pressed
    
    https://processing.org/reference/mousePressed_.html
*/

void mousePressed()
{
    /*
        start or stop sampling image pixel rgb value
    */
    
    sample = !sample;
    
    if(!sample)
    {
        // sample is now false so we stop sampling and turn off the led
        
        arduino.write("0,0,0\n");
    }
}





//=====================================================
// Arduino Code
//=====================================================

/*

// connect the red, green and blue pins of the RGB LED (common cathod) to the
// following PWM pins, the pin no. may vary according to arduino type 

#define RED_PIN 5
#define GREEN_PIN 6 
#define BLUE_PIN 9

void setup() {
    // put your setup code here, to run once:

    pinMode( RED_PIN, OUTPUT );

    pinMode( GREEN_PIN, OUTPUT);
    
    pinMode( BLUE_PIN, OUTPUT);

    Serial.begin(9600);
}

void loop() {
    // put your main code here, to run repeatedly:

    if(Serial.available())
    {
        // parsing a string that looks like "255,255,255\n"
        
        uint8_t red = Serial.parseInt();
        
        uint8_t green = Serial.parseInt();
        
        uint8_t blue = Serial.parseInt();

        if(Serial.read() == '\n')
        {
            analogWrite( RED_PIN, red );

            analogWrite( GREEN_PIN, green );
    
            analogWrite( BLUE_PIN, blue );
        }
    }
}

*/
