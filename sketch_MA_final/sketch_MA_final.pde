
/**
 * 
 * "New Narrative - AR make your mark" -- Visualization Part (Cultural Heritage Silk Road)
 *
 * By: Yawen Deng 33657474
 *     2022 MA Computational Arts
 *
 ------------------------------  Supporting documents -----------------------------
 
 * The idea and inspiration:
 *
 
 
 
 
 
 *
 *
 *
 * Refer to:
 -- processing.org/examples/PixelFlow v1.3.0 - www.thomasdiewald.com
 -- https://www.citeco.fr/10000-years-history-economics/antiquity-to-middle-ages/
 acceleration-of-trade-along-the-silk-road-dominated-by-the-mongol-empire
 -- https://tylerxhobbs.com/work
 -- https://cdv.dei.uc.pt/planar/
 -- https://cdv.dei.uc.pt/insta-ants/
 *
 *
 *
 **/

// ---------------------------------------------------------------------------------

// Single Frame from an Animation (with screen display)
// Create a boolean variable to turn the PDF recording process on and off
import processing.pdf.*;
boolean record;


// Pixelflow function and controlP5 function
import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.dwgl.DwGLSLProgram;
import com.thomasdiewald.pixelflow.java.fluid.DwFluid2D;
import com.thomasdiewald.pixelflow.java.fluid.DwFluidParticleSystem2D;

import controlP5.Accordion;
import controlP5.ControlP5;
import controlP5.Group;
import controlP5.RadioButton;
import controlP5.Toggle;
import processing.core.*;
import processing.opengl.PGraphics2D;


int viewport_w = 1920;
int viewport_h = 1000;
int viewport_x = 230;
int viewport_y = 0;

int fluidgrid_scale = 1;


// According to the dependency relationship, from left to right is probably
// Fluid object, fluid (two-dimensional), fluid data, fluid display object

// Fluid object
DwPixelFlow context;

// Fluid (two-dimensional)
DwFluid2D fluid;

// Fluid data
MyFluidData cb_fluid_data;
DwFluidParticleSystem2D particle_system;

PGraphics2D pg_fluid; 
PGraphics2D pg_image;      

PImage image;


public void settings() {
  size(viewport_w, viewport_h, P2D);
  smooth(4);
}


public void setup() {

  surface.setLocation(viewport_x, viewport_y);

  // An object that provides common functions related to fluid simulation, initialized here
  context = new DwPixelFlow(this);

  // Output some graphics card related information on the console
  context.print();
  context.printGL();

  // Fluid object initialization, function object, dimensions, fluid mesh size
  fluid = new DwFluid2D(context, viewport_w, viewport_h, fluidgrid_scale);

  // Set parameters that are not on some other constructors
  fluid.param.dissipation_density     = 1.00f;
  fluid.param.dissipation_velocity    = 0.80f;
  fluid.param.dissipation_temperature = 0.75f;
  fluid.param.vorticity               = 0.35f;

  // Fluid data should be placed in the fluid object
  cb_fluid_data = new MyFluidData();
  fluid.addCallback_FluiData(cb_fluid_data);

  // Load a picture
  image = loadImage("silk road-2.jpg");

  // Fluid render target
  pg_fluid = (PGraphics2D) createGraphics(viewport_w, viewport_h, P2D);
  pg_fluid.smooth(4);

  // Particles
  particle_system = new DwFluidParticleSystem2D();
  particle_system.resize(context, viewport_w/10, viewport_h/10);

  // Image/buffer that will be used as density input
  pg_image = (PGraphics2D) createGraphics(viewport_w, viewport_h, P2D);
  pg_image.noSmooth();
  pg_image.beginDraw();
  pg_image.clear();
  pg_image.translate(width/2, height/2);
  pg_image.scale(viewport_h / (float)image.height);
  pg_image.imageMode(CENTER);
  pg_image.image(image, 0, 0);
  pg_image.endDraw();

  createGUI();

  background(255);
  frameRate(60);
}


public void draw() {

  if (record) {
    // Note that #### will be replaced with the frame number
    beginRecord(PDF, "frame-####.pdf");
  }

  // The keyboard presses P to control this boolean value, thereby controlling whether the fluid is updated or not
  if (UPDATE_FLUID) {
    fluid.update();
    particle_system.update(fluid);
  }

  // Start drawing
  pg_fluid.beginDraw();
  // Draw background
  pg_fluid.background(BACKGROUND_COLOR);

  // The following is to update the fluid drawing results to pg_fluid before the end of the drawing
  if (DISPLAY_FLUID_TEXTURES) {
    fluid.renderFluidTextures(pg_fluid, DISPLAY_fluid_texture_mode);
  }

  if (DISPLAY_FLUID_VECTORS) {
    fluid.renderFluidVectors(pg_fluid, 10);
  }

  if (DISPLAY_PARTICLES) {
    particle_system.render(pg_fluid, null, 0);
  }

  // Finished drawing
  pg_fluid.endDraw();

  // Displayed after drawing
  image(pg_fluid, 0, 0);

  // Display some information on the window bar, which is not in the Processing document
  // It is the underlying function of java (Processing is a dialect of java, so it can be mixed)
  String txt_fps = String.format(getClass().getName()+ "   [size %d/%d]   [frame %d]   [fps %6.2f]", fluid.fluid_w, fluid.fluid_h, fluid.simulation_step, frameRate);
  surface.setTitle(txt_fps);

  if (record) {
    endRecord();
    record = false;
  }
}


public void fluid_resizeUp() {
  fluid.resize(width, height, fluidgrid_scale = max(1, --fluidgrid_scale));
}
public void fluid_resizeDown() {
  fluid.resize(width, height, ++fluidgrid_scale);
}
public void fluid_reset() {
  fluid.reset();
}
public void fluid_togglePause() {
  UPDATE_FLUID = !UPDATE_FLUID;
}
public void fluid_displayMode(int val) {
  DISPLAY_fluid_texture_mode = val;
  DISPLAY_FLUID_TEXTURES = DISPLAY_fluid_texture_mode != -1;
}
public void fluid_displayVelocityVectors(int val) {
  DISPLAY_FLUID_VECTORS = val != -1;
}

public void fluid_displayParticles(int val) {
  DISPLAY_PARTICLES = val != -1;
}


//Use a keypress so thousands of files aren't created
void mousePressed() {
  record = true;
}
