// GUI part

ControlP5 cp5;

int gui_w = 100;
int gui_x = 0;
int gui_y = 0;

// some state variables for the GUI/display
int     BACKGROUND_COLOR           = 255;
boolean UPDATE_FLUID               = true;
boolean DISPLAY_FLUID_TEXTURES     = true;
boolean DISPLAY_FLUID_VECTORS      = false;
int     DISPLAY_fluid_texture_mode = 0;
boolean DISPLAY_PARTICLES          = true;

public void createGUI() {
  cp5 = new ControlP5(this);

  int sx, sy, px, py, oy;

  sx = 50; 
  sy = 10; 
  oy = (int)(sy*1.5f);


  ////////////////////////////////////////////////////////////////////////////
  // GUI - FLUID
  ////////////////////////////////////////////////////////////////////////////
  Group group_fluid = cp5.addGroup("fluid");
  {
    group_fluid.setHeight(10).setSize(gui_w, 150)
      .setBackgroundColor(color(16, 180)).setColorBackground(color(16, 180));
    group_fluid.getCaptionLabel().align(CENTER, CENTER);

    px = 10; 
    py = 15;

    cp5.addButton("reset").setGroup(group_fluid).plugTo(this, "fluid_reset"     ).setSize(80, 18).setPosition(px, py);
    cp5.addButton("+"    ).setGroup(group_fluid).plugTo(this, "fluid_resizeUp"  ).setSize(39, 18).setPosition(px+=82, py);
    cp5.addButton("-"    ).setGroup(group_fluid).plugTo(this, "fluid_resizeDown").setSize(39, 18).setPosition(px+=41, py);

    px = 10;
    py = 15;

    cp5.addSlider("velocity").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=(int)(oy*1.5f))
      .setRange(0, 1).setValue(fluid.param.dissipation_velocity).plugTo(fluid.param, "dissipation_velocity");

    cp5.addSlider("density").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 1).setValue(fluid.param.dissipation_density).plugTo(fluid.param, "dissipation_density");

    cp5.addSlider("temperature").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 1).setValue(fluid.param.dissipation_temperature).plugTo(fluid.param, "dissipation_temperature");

    cp5.addSlider("vorticity").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 1).setValue(fluid.param.vorticity).plugTo(fluid.param, "vorticity");

    cp5.addSlider("iterations").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 80).setValue(fluid.param.num_jacobi_projection).plugTo(fluid.param, "num_jacobi_projection");

    cp5.addSlider("timestep").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 1).setValue(fluid.param.timestep).plugTo(fluid.param, "timestep");

    cp5.addSlider("gridscale").setGroup(group_fluid).setSize(sx, sy).setPosition(px, py+=oy)
      .setRange(0, 50).setValue(fluid.param.gridscale).plugTo(fluid.param, "gridscale");

    RadioButton rb_setFluid_DisplayMode = cp5.addRadio("fluid_displayMode").setGroup(group_fluid).setSize(80, 18).setPosition(px, py+=(int)(oy*1.5f))
      .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(2)
      .addItem("Density", 0)
      .addItem("Temperature", 1)
      .addItem("Pressure", 2)
      .addItem("Velocity", 3)
      .activate(DISPLAY_fluid_texture_mode);
    for (Toggle toggle : rb_setFluid_DisplayMode.getItems()) toggle.getCaptionLabel().alignX(CENTER);

    cp5.addRadio("fluid_displayVelocityVectors").setGroup(group_fluid).setSize(18, 18).setPosition(px, py+=(int)(oy*2.5f))
      .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(1)
      .addItem("Velocity Vectors", 0)
      .activate(DISPLAY_FLUID_VECTORS ? 0 : 2);
  }


  ////////////////////////////////////////////////////////////////////////////
  // GUI - DISPLAY
  ////////////////////////////////////////////////////////////////////////////
  Group group_display = cp5.addGroup("display");
  {
    group_display.setHeight(10).setSize(gui_w, 15)
      .setBackgroundColor(color(16, 180)).setColorBackground(color(16, 180));
    group_display.getCaptionLabel().align(CENTER, CENTER);

    px = 10; 
    py = 15;

    cp5.addSlider("BACKGROUND").setGroup(group_display).setSize(sx, sy).setPosition(px, py)
      .setRange(0, 255).setValue(BACKGROUND_COLOR).plugTo(this, "BACKGROUND_COLOR");

    cp5.addRadio("fluid_displayParticles").setGroup(group_display).setSize(28, 28).setPosition(px, py+=(int)(oy*5.5f))
      .setSpacingColumn(2).setSpacingRow(2).setItemsPerRow(1)
      .addItem("particles", 0)
      .activate(DISPLAY_PARTICLES ? 0 : 10);
  }


  ////////////////////////////////////////////////////////////////////////////
  // GUI - ACCORDION
  ////////////////////////////////////////////////////////////////////////////
  cp5.addAccordion("acc").setPosition(gui_x, gui_y).setWidth(gui_w).setSize(gui_w, height)
    .setCollapseMode(Accordion.MULTI)
    .addItem(group_fluid)
    .addItem(group_display)
    .open(4);
}
