#--------------------------------------------------------------------
var auto_land = func {
  if(getprop("/autopilot/locks/auto-land") == "enabled") {
    setprop("/autopilot/locks/auto-land", "engaged");

    var app_aoa = getprop("/autopilot/FCS/settings/approach-aoa-deg");

    # Set nav1 heading & vfps locks, climb-rate to 0.
    setprop("/autopilot/settings/target-aoa-deg", app_aoa);
    setprop("/autopilot/settings/target-climb-rate-fps", 0);
    setprop("/autopilot/locks/aoa", "engaged");
    setprop("/autopilot/locks/altitude", "vfps-hold");
    setprop("/autopilot/locks/heading", "nav1-hold");
    setprop("/autopilot/locks/speed", "speed-with-throttle");
    setprop("/autopilot/FCS/locks/auto-flap", "true");
    setprop("/autopilot/FCS/locks/auto-slat", "true");
    setprop("/autopilot/FCS/locks/auto-speedbrake", "true");
    if(getprop("/autopilot/settings/target-speed-kt") > 250) {
      setprop("/autopilot/settings/target-speed-kt", 250);
    }
    atl_loop();
  }
}
#--------------------------------------------------------------------
var atl_loop = func {
  # Get the agl, kias, vfps & heading.
  var agl =       props.globals.getNode("/position/altitude-agl-ft", 1);
  var atl_lock =  props.globals.getNode("/autopilot/locks/auto-land", 1);

  if(agl.getValue() > 600) {
    # Glide Slope phase.
    atl_spddep();
    atl_glideslope();
  } else {
    # Touch Down Phase
    atl_touchdown();
  }

  # Re-schedule the next loop if the Landing function is still engaged.
  if(atl_lock.getValue() == "engaged") {
    settimer(atl_loop, 0.2);
  }
}
#--------------------------------------------------------------------
var atl_spddep = func {
  # This script handles the speed dependent actions.

  var kias = props.globals.getNode("/velocities/airspeed-kt", 1);
  var gear = props.globals.getNode("/controls/gear/gear-down", 1);

  if(kias.getValue() < 180) {
    gear.setValue("true");
  }
}
#--------------------------------------------------------------------
var atl_glideslope= func {
  # This script handles the Glide Slope phase
  # Don't engaged gs1-hold until we're heading towards the runway.

  var nav1_err =      props.globals.getNode("/autopilot/internal/nav1-heading-error-deg-filtered", 1);
  var gs1_vfps =      props.globals.getNode("/autopilot/internal/gs-rate-of-climb-filtered", 1);
  var tgt_vfps =      props.globals.getNode("/autopilot/settings/target-climb-rate-fps", 1);
  var curr_nav1_err = nav1_err.getValue();

  if(curr_nav1_err < 90) {
    if(curr_nav1_err > -90) {
      tgt_vfps.setValue(gs1_vfps.getValue());
    }
  }
}
#--------------------------------------------------------------------
var atl_touchdown = func {
  # Touch Down Phase
  var agl =       props.globals.getNode("/position/gear-agl-ft", 1);
  var aoa =       props.globals.getNode("/autopilot/locks/aoa", 1);
  var alt =       props.globals.getNode("/autopilot/locks/altitude", 1);
  var hdg =       props.globals.getNode("/autopilot/locks/heading", 1);
  var spd =       props.globals.getNode("/autopilot/locks/speed", 1);
  var atl =       props.globals.getNode("/autopilot/locks/auto-land", 1);
  var ato =       props.globals.getNode("/autopilot/locks/auto-takeoff", 1);
  var th0 =       props.globals.getNode("/controls/engines/engine[0]/throttle", 1);
  var th1 =       props.globals.getNode("/controls/engines/engine[1]/throttle", 1);
  var gbl =       props.globals.getNode("/controls/gear/brake-left", 1);
  var gbr =       props.globals.getNode("/controls/gear/brake-right", 1);
  var elevt =     props.globals.getNode("/controls/flight/elevator-trim", 1);
  var str =       props.globals.getNode("/autopilot/settings/steering-heading-deg", 1);
  var grl =       props.globals.getNode("/autopilot/settings/ground-roll-heading-deg", 1);
  var tgt_pd =    props.globals.getNode("/autopilot/settings/target-pitch-deg", 1);
  var tgt_spd =   props.globals.getNode("/autopilot/settings/target-speed-kt", 1);
  var tgt_vfps =  props.globals.getNode("/autopilot/settings/target-climb-rate-fps", 1);
  var strmd =     props.globals.getNode("/autopilot/FCS/settings/stick-roll-mode", 1);
  var vfps =      props.globals.getNode("/velocities/vertical-speed-fps", 1);
  var curr_agl =  agl.getValue();
  var curr_vfps = vfps.getValue();

  hdg.setValue("");

  if(curr_agl < 0.1) {
    atl.setValue("disabled");
    ato.setValue("enabled");
    gbl.setValue(0.1);
    gbr.setValue(0.1);
    interpolate(elevt, 0, 2);
    str.setValue(-9999.9);
    grl.setValue(-9999.9);
    tgt_vfps.setValue(0.0);
    tgt_pd.setValue(0.0);
  } else {
    if(curr_agl < 1) {
      if(curr_vfps < -1.0) {
        aoa.setValue("off");
        tgt_spd.setValue(0.0);
        tgt_vfps.setValue(-1.0);
      }
    } else {
      if(curr_agl < 10) {
        if(curr_vfps < -2.0) {
          tgt_vfps.setValue(-2.0);
          th0.setValue(0.0);
          th1.setValue(0.0);
        }
      } else {
        if(curr_agl < 20) {
          if(curr_vfps < -4.0) {
            tgt_vfps.setValue(-4.0);
            alt.setValue("");
            spd.setValue("");
          }
        } else {
          if(curr_agl < 40) {
            if(curr_vfps < -6.0) {
              tgt_vfps.setValue(-6.0);
            }
          } else {
            if(curr_agl < 80) {
              if(curr_vfps < -10.0) {
                tgt_vfps.setValue(-10.0);
              }
            } else {
              hdg.setValue("");
              strmd.setValue("adaptive");
              if(curr_agl < 160) {
                if(curr_vfps < -12.0) {
                  tgt_vfps.setValue(-12.0);
                }
              }
            }
          }
        }
      }
    }
  }
}
#--------------------------------------------------------------------
