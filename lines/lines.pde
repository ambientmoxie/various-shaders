PImage seeds;
PGraphics buffer, output;
float w, h, xLimit, yLimit, cell;
boolean isInColor, verticalDistribution;

void setup() {
  size(700, 990);
  seeds = loadImage("0.jpg");
  buffer = createGraphics(width, height);
  output = createGraphics(width / 2, height);
  noLoop();

  // --------------------------------------------
  // Options

  isInColor = false;
  verticalDistribution = true;
  cell = 19;

  // --------------------------------------------
  
}

void draw() {

  // Init the image to be dithered
  drawBuffer();

  // Init the dithered output and display it
  drawOutput();
  image(output, 0, 0);

  // Display a reverse output to obtain a "mirror effect"
  pushMatrix(); 
  scale(-1, 1);
  translate(- width, 0);
  image(output, 0, 0);
  popMatrix();
}

void drawBuffer() {
  buffer.beginDraw();
  buffer.imageMode(CENTER);
  buffer.image(seeds, width / 2, height / 2);
  buffer.endDraw();
}

// Line dithering
void drawOutput() {

  output.beginDraw();

  w = verticalDistribution ? width / cell : 2;
  h = verticalDistribution ? 2 : height / cell;
  xLimit = verticalDistribution ? cell : output.width;
  yLimit = verticalDistribution ? output.height : cell;
  
  // Load the pixels of the buffer
  buffer.loadPixels();

  for (int x = 0; x < xLimit; x++) {
    for (int y = 0; y < yLimit; y++) {

      int pxW = int((w * x) + (w / 2));
      int pxH = int((h * y) + (h / 2));

      int c = buffer.pixels[index(pxW, pxH, buffer)];

      float red = red(c);
      float green = green(c);
      float blue = blue(c);

      if (isInColor) {
        buffer.colorMode(RGB, 255, 255, 255);
        color nc = color(red, green, blue);
        output.stroke(nc);
        output.fill(nc);
      } else {
        buffer.colorMode(HSB, 360, 100, 100);
        float cb = brightness(c);
        output.stroke(cb);
        output.fill(cb);
      }

      output.rect(w * x, h * y, w, h);
    }
  }
  output.endDraw();
}

// Accessing px in the px array
int index(int x, int y, PImage target) {
  // Prevent "array out of bounds" error
  if (x < target.width && y < target.height) {
    return x + y * target.width;
  } else {
    // Safe value
    return 0;
  }
}

void keyTyped() {
  if (key == 's' || key == 'S') {
    save("export/mirror.tif");
  }
}
