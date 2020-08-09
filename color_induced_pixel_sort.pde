
/*

 Color induced Pixel Sort by AKTracer ver 1.0, 9 Aug 2020
 Built for Processing 3
 Based on ASDF Pixel sort by Kim Asendorf
 
 https://instagram.com/tay.glitch
 https://instagram.com/aktracer
 
  Instructions:
* Put file name and file extension
* Set direction to horizontal or vertical
* Set mode of sorting, black, brightness or white

  Tips
* Set corresponding threshold to control how much area is affected
* Set reverseMode to true to reverse the direction of pull

  How to color the sort
* You can play with the value of "steroids" variable, which induces color in the sorted area
* Some interesting values are provided in the comments
* To find where they are do a ctrl+F(cmd+F for mac) and find three stars "***"
* if in vertical mode, steroids should be adjusted in sortColumn() function
  if in horizontal mode, the steroids in sortRow() must be adjusted
  For no coloration, set steroids to 0
  
 HSB shift
* The colors already boosted can be shifted in hue, sat, bri overall
* Search for four stars to find quickly the variables new_hue, new_sat. new_bri
  and play with them. these are functions of y or x variables depending on row or column mode
 
 Notes
* The direction of sort may change when sorting mode is changed, ex. black, brigheness, white mode
* Because we are operating on one pixel at a time, the "steroids" and the "new_" etc.
  variables cannot be conveniently placed on top, else the pixel cannot be accessed that way
  It is possible to perform a three star or four star find operation to quickly access them
  either within the sortColumn() or sortRow() functions, depending upon the direction
  vertical means column and horizontal means row mode
* File names and file extensions are case sensitive, mistyping them is the most common error
  
* If you have a solution to how the coloration can be done in real time, please write to me at
arjunkhode [at] gmail
 
 */

String imgFileName = "tay"; 
String fileType = "jpg";
PImage img;

int direction = 1; //0 hori 1 vertical
boolean reverseMode = false; //reverse the direction of sort

int mode = 2; 
/* MODE
mode 1 moves inversely to set direction
0 ~ black sort - leaves black pixels alone and sorts the others
1 ~ brightness sort - sorts bright pixels and leaves alone darks, affected brightness depends on the threshold
2 ~ white sort - leaves alone white pixels and sorts the others
*/

int blackValue = -50000000; //mode 0 - pulls whites, bigger the stronger
int brightnessValue = 170; //mode 1 - pulls mids, smaller the stronger
int whiteValue = -8000000; //mode 2 - pulls blacks, smaller the stronger

int row = 0; 
int column = 0;
boolean saved = false;
int loops = 1; 
int steroids = 0; //not the steroids you are looking for

void setup() {
  img = loadImage(imgFileName+"."+fileType);
  size(800,800);
  // load image onto surface - scale to the available width,height for display
  image(img, 0, 0, img.width, img.height);
}

void getDirection(){
  if (direction == 0){
    column = img.width;
    row = 0;
  }
  if (direction == 1){
    row = img.height;
    column = 0;
  }
}

void draw() {
  
   if(reverseMode){
     img.pixels = reverse(img.pixels); 
   }
   
  // loop through columns
  if(direction == 1){
    while(column < img.width) {
      println("Sorting Column " + column);
      img.loadPixels(); 
      sortColumn();
      column++;
      img.updatePixels();
    }
  }
  
  // loop through rows
  if(direction == 0){
    while(row < img.height) {
      println("Sorting Row " + column);
      img.loadPixels(); 
      sortRow();
      row++;
      img.updatePixels();
    }
  }
  
  //reverse it again
  if(reverseMode){
    img.pixels = reverse(img.pixels); 
  }
   
  // load updated image onto surface and scale to fit the display width,height
  image(img, 0, 0, img.width, img.height);
  
  if(!saved && frameCount >= loops) {
    
  // save img
    img.save(imgFileName+"_"+mode+"-"+hour()+second()+".png");
  
    saved = true;
    println("Saved "+frameCount+" Frame(s)");
    
    // exiting here can interrupt file save, wait for user to trigger exit
    println("Click or press any key to exit...");
  }
}

void keyPressed() {
  if(saved)
  {
    System.exit(0);
  }
}


void mouseClicked() {
  getDirection();
  if(reverseMode){
    img.pixels = reverse(img.pixels);
  }
  if(direction==0){
    while(row < img.height-1) {
      println("Sorting Row " + column);
      img.loadPixels(); 
      sortRow();
      row++;
      img.updatePixels();
    }
  }

  //if direction ==1 sortColumn
  if(direction==1){
    while(column < img.width-1) {
      println("Sorting Column " + column);
      img.loadPixels(); 
      sortColumn();
      column++;
      img.updatePixels();
    }
  }

}
  
void sortRow() {
  // current row
  int y = row;
  
  // where to start sorting
  int x = 0;
  
  // where to stop sorting
  int xend = 0;
  
  while(xend < img.width-1) {
    switch(mode) {
      case 0:
        x = getFirstNotBlackX(x, y);
        xend = getNextBlackX(x, y);
        break;
      case 1:
        x = getFirstBrightX(x, y);
        xend = getNextDarkX(x, y);
        break;
      case 2:
        x = getFirstNotWhiteX(x, y);
        xend = getNextWhiteX(x, y);
        break;
      default:
        break;
    }
    
    if(x < 0) break;
    
    int sortLength = xend-x;
    
    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];
    
    for(int i=0; i<sortLength; i++) {
      unsorted[i] = img.pixels[x + i + y * img.width];
    }
    
    sorted = sort(unsorted);
    
    for(int i=0; i<sortLength; i++) {
      //steroids is a function of i, i.e current pixel
      //*** row mode 
      //steroids = 0;
      //steroids = i*Math.round(log(i/3)) + unhex("000C00FF") - unhex("00001100");
      //steroids = Math.round(i+sin(PI*0.75)) + unhex("000000AB");
      //steroids = i*123400000; //wavy boost
      //steroids =  i*Math.round(cos(i/63)/sin(PI*1.5)) + unhex("00000000") - unhex("00000000"); 
      steroids = i + unhex("000C00CC") - unhex("00440000");
     
      img.pixels[x + i + y * img.width] = sorted[i] + steroids; 
      
      
     //HSB Shift 
     int hsb_range = 5500; // maximum range of HSB
     colorMode(HSB,hsb_range); // change the window level of hsb_range above to 5000 or 1000 to get a milder or stronger shift
     float original_hue = hue(img.pixels[ x + img.width*(y+i)]);
     float original_saturation = saturation(img.pixels[ x + img.width*(y+i)]);
     float original_brightness = brightness(img.pixels[ x + img.width*(y+i)]);
     
     //new values are a function of y, i.e current row number
     //****
     float new_hue = original_hue + 0;
     float new_sat = original_saturation - y * 1.5;
     float new_bri = original_brightness - y * 0.7;
     img.pixels[ x + img.width*(y+i)] = color(new_hue, new_sat, new_bri);
     
     colorMode(RGB);  
     
    }
    
    x = xend+1;
  }
}


void sortColumn() {
  // current column
  int x = column;
  
  // where to start sorting
  int y = 0;
  
  // where to stop sorting
  int yend = 0; 
  
  while(yend < img.height- 1) {
    switch(mode) {
      case 0:
        y = getFirstNotBlackY(x, y);
        yend = getNextBlackY(x, y);
        break;
      case 1:
        y = getFirstBrightY(x, y);
        yend = getNextDarkY(x, y);
        break;
      case 2:
        y = getFirstNotWhiteY(x, y);
        yend = getNextWhiteY(x, y);
        break;
      default:
        break;
    }
    
    if(y < 0) break;
    
    int sortLength = yend-y;
    
    color[] unsorted = new color[sortLength];
    color[] sorted = new color[sortLength];
    
    for(int i=0; i<sortLength; i++) {
      unsorted[i] = img.pixels[x + (y+i) * img.width];
    }
    
    sorted = sort(unsorted); // i have no control over the sort swap. thats ok
    

    for(int i=0; i<sortLength; i++) {
      //*** column mode
      //steroids = 0;
      //steroids = i*Math.round(log(i/3)) + unhex("000C00FF") - unhex("00001100");
      //steroids = Math.round(i+sin(PI*0.75)) + unhex("000000AB");
      steroids = i*123400000; //wavy boost
      //steroids =  i*Math.round(cos(i/63)/sin(PI*1.5)) + unhex("00000000") - unhex("00000000"); 
      //steroids = i + unhex("000C00CC") - unhex("00440000");
      img.pixels[x + (y+i) * img.width] = sorted[i] + steroids; 
     
          //HSB Shift 
     int hsb_range = 5500; // maximum range of HSB
     colorMode(HSB,hsb_range); // change the window level of hsb_range above to 5000 or 1000 to get a milder or stronger shift
     float original_hue = hue(img.pixels[ x + img.width*(y+i)]);
     float original_saturation = saturation(img.pixels[ x + img.width*(y+i)]);
     float original_brightness = brightness(img.pixels[ x + img.width*(y+i)]);
     
     //new values are a function of x, i.e current column number
     //****
     float new_hue = original_hue + 0;
     float new_sat = original_saturation + 2000;
     float new_bri = original_brightness + x * 0.7;
     img.pixels[ x + img.width*(y+i)] = color(new_hue, new_sat, new_bri);
     
     colorMode(RGB); 
    }
    
    y = yend+1;
  }
}


// black x
int getFirstNotBlackX(int x, int y) {
  //starts from x offset in row y until row y is fully traversed
  while(img.pixels[x + y * img.width] < blackValue) {
    x++;
    if(x >= img.width) 
      return -1;
  }
  
  return x;
}

int getNextBlackX(int x, int y) {
  x++;
  
  while(img.pixels[x + y * img.width] > blackValue) {
    x++;
    if(x >= img.width) 
      return img.width-1;
  }
  
  return x-1;
}

// brightness x
int getFirstBrightX(int x, int y) {
  
  while(brightness(img.pixels[x + y * img.width]) < brightnessValue) {
    x++;
    if(x >= img.width)
      return -1;
  }
  
  return x;
}

int getNextDarkX(int _x, int _y) {
  int x = _x+1;
  int y = _y;
  
  while(brightness(img.pixels[x + y * img.width]) > brightnessValue) {
    x++;
    if(x >= img.width) return img.width-1;
  }
  return x-1;
}

// white x
int getFirstNotWhiteX(int x, int y) {

  while(img.pixels[x + y * img.width] > whiteValue) {
    x++;
    if(x >= img.width) 
      return -1;
  }
  return x;
}

int getNextWhiteX(int x, int y) {
  x++;

  while(img.pixels[x + y * img.width] < whiteValue) {
    x++;
    if(x >= img.width) 
      return img.width-1;
  }
  return x-1;
}


// black y
int getFirstNotBlackY(int x, int y) {

  if(y < img.height) {
    while(img.pixels[x + y * img.width] < blackValue) {
      y++;
      if(y >= img.height)
        return -1;
    }
  }
  
  return y;
}

int getNextBlackY(int x, int y) {
  y++;

  if(y < img.height) {
    while(img.pixels[x + y * img.width] > blackValue) {
      y++;
      if(y >= img.height)
        return img.height-1;
    }
  }
  
  return y-1;
}

// brightness y
int getFirstBrightY(int x, int y) {

  if(y < img.height) {
    while(brightness(img.pixels[x + y * img.width]) < brightnessValue) {
      y++;
      if(y >= img.height)
        return -1;
    }
  }
  
  return y;
}

int getNextDarkY(int x, int y) {
  y++;

  if(y < img.height) {
    while(brightness(img.pixels[x + y * img.width]) > brightnessValue) {
      y++;
      if(y >= img.height)
        return img.height-1;
    }
  }
  return y-1;
}

// white y
int getFirstNotWhiteY(int x, int y) {

  if(y < img.height) {
    while(img.pixels[x + y * img.width] > whiteValue) {
      y++;
      if(y >= img.height)
        return -1;
    }
  }
  
  return y;
}

int getNextWhiteY(int x, int y) {
  y++;
  
  if(y < img.height) {
    while(img.pixels[x + y * img.width] < whiteValue) {
      y++;
      if(y >= img.height) 
        return img.height-1;
    }
  }
  
  return y-1;
}
