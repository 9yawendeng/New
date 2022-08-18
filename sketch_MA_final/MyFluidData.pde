private class MyFluidData implements DwFluid2D.FluidData {


  @Override
    // this is called during the fluid-simulation update step.
    public void update(DwFluid2D fluid) {

    // Make a few lines to cool down causing the fluid to flow down
    for (int i =0; i<height/2; i=i+50) {
      float x = random(width);
      float y = i/4;
      // The four parameters are xy coordinates, range, temperature in order
      fluid.addTemperature(x, y, 
        random(11, 34), 
        random(-58, 0));
    }

    // Make a few lines to heat up causing the fluid to flow upwards
    for (int i =0; i<height/2; i=i+50) {
      float x = random(width);
      float y = i/4;
      // The four parameters are xy coordinates, range, temperature in order
      fluid.addTemperature(x, y, 
        random(10, 25), 
        random(0, 25));
    }
    // use the text as input for density
    float mix = fluid.simulation_step == 0 ? 1.0f : 0.01f;
    addDensityTexture(fluid, pg_image, mix);
  }

  // custom shader, to add density from a texture (PGraphics2D) to the fluid.
  public void addDensityTexture(DwFluid2D fluid, PGraphics2D pg, float mix) {
    int[] pg_tex_handle = new int[1];
  //      pg_tex_handle[0] = pg.getTexture().glName;
    context.begin();
    context.getGLTextureHandle(pg, pg_tex_handle);
    context.beginDraw(fluid.tex_density.dst);
    DwGLSLProgram shader = context.createShader(this, "data/addDensity.frag");
    shader.begin();
    shader.uniform2f     ("wh", fluid.fluid_w, fluid.fluid_h);                                                                   
    shader.uniform1i     ("blend_mode", 6);   
    shader.uniform1f     ("mix_value", mix);     
    shader.uniform1f     ("multiplier", 1);     
    shader.uniformTexture("tex_ext", pg_tex_handle[0]);
    shader.uniformTexture("tex_src", fluid.tex_density.src);
    shader.drawFullScreenQuad();
    shader.end();
    context.endDraw();
    context.end("app.addDensityTexture");
    fluid.tex_density.swap();
  }
}
