#--------------------------------------------------------------------
# YF-23 Auto-takeoff scripts
#--------------------------------------------------------------------
var auto_takeoff = func {
  # This function checks that auto-takeoff is enabled and if so
  # initiates an auto-takeoff.

  if(getprop("/autopilot/locks/auto-takeoff") == "enabled") {
    ato_initiation();
  }
}
#--------------------------------------------------------------------
var ato_initiation = func {
  # Check that the aircraft is on the ground, initialise, call the
  # main loop and set the ato lock to engaged.

  if(getprop("/position/gear-agl-ft") < 0.1) {

    var current_heading_deg = getprop("/orientation/heading-deg");

    setprop("/autopilot/locks/auto-takeoff", "engaged");
    setprop("/autopilot/locks/rudder", "heading-hold");

    setprop("/controls/gear/brake-left", 0);
    setprop("/controls/gear/brake-right", 0);
    setprop("/controls/gear/brake-parking", 0);

    setprop("/autopilot/FCS/locks/auto-flap", "false");
    setprop("/autopilot/FCS/locks/auto-slat", "true");
    setprop("/autopilot/FCS/locks/auto-reheat", "false");
    setprop("/autopilot/FCS/locks/auto-speedbrake", "false");
    setprop("/autopilot/FCS/locks/pitch", "true");

    setprop("/autopilot/locks/heading", "wing-leveler");
    setprop("/autopilot/locks/speed", "speed-with-throttle");

    setprop("/autopilot/settings/target-pitch-deg", 0.0);
    setprop("/autopilot/settings/target-speed-kt", 450);

    setprop("/autopilot/FCS/settings/ground-roll-heading-deg", current_heading_deg);

    # Start the main takeoff loop.
    ato_loop();
  }
}
#--------------------------------------------------------------------
var ato_loop = func {
  if(getprop("/autopilot/locks/auto-takeoff") == "engaged") {
    ato_speed();
    ato_altitude();
    settimer(ato_loop, 0.1);
  }
}
#--------------------------------------------------------------------
var ato_speed = func {
  # Speed dependent actions.

  var target_pitch_deg =      props.globals.getNode("/autopilot/settings/target-pitch-deg", 1);
  var current_speed =         props.globals.getNode("/velocities/airspeed-kt", 1);
  var rotate_speed =          props.globals.getNode("/autopilot/FCS/settings/rotate-speed-kt", 1);
  var ground_roll_pitch_deg = props.globals.getNode("/autopilot/FCS/settings/ground-roll-pitch-deg", 1);
  var takeoff_pitch_deg =     props.globals.getNode("/autopilot/FCS/settings/takeoff-pitch-deg", 1);

  var cspd = current_speed.getValue();
  var rspd = rotate_speed.getValue();
  var grpd = ground_roll_pitch_deg.getValue();
  var topd = takeoff_pitch_deg.getValue();
  var tpd =  target_pitch_deg.getValue();

  if(cspd < rspd) {
    if(tpd == 0) {
      interpolate(target_pitch_deg, grpd, 2);
    }
  } else {
    if(tpd == grpd) {
      interpolate(target_pitch_deg, topd, 1);
    }
  }
}
#--------------------------------------------------------------------
var ato_altitude = func {
  # Altitude dependent actions.

  var current_agl_ft =   props.globals.getNode("/position/altitude-agl-ft", 1);
  var gear_up_agl_ft =   props.globals.getNode("/autopilot/FCS/settings/gear-up-agl-ft", 1);
  var climb_out_agl_ft = props.globals.getNode("/autopilot/FCS/settings/climb-out-agl-ft", 1);

  var cagl = current_agl_ft.getValue();
  var gagl = gear_up_agl_ft.getValue();
  var oagl = climb_out_agl_ft.getValue();

  if(cagl < gagl) {
    # Do nothing until we can get the gear up.
  } elsif(cagl < oagl) {
    # Gear up agl ft.
    setprop("/controls/gear/gear-down", "false");
  } else {
    setprop("/autopilot/locks/rudder", "");
    interpolate("/controls/flight/rudder", 0, 5);
    interpolate("/controls/gear/steering-norm", 0, 5);

    setprop("/autopilot/FCS/locks/auto-flap", "false");
    setprop("/autopilot/FCS/locks/auto-slat", "false");
    setprop("/autopilot/FCS/locks/auto-reheat", "false");
    setprop("/autopilot/FCS/controls/flight/flap-norm", 0.0);
    setprop("/autopilot/FCS/locks/auto-reheat", "false");
    setprop("/autopilot/locks/altitude", "altitude-hold");
    setprop("/autopilot/locks/heading", "true-heading-hold");
    setprop("/autopilot/locks/auto-takeoff", "disabled");
    setprop("/autopilot/locks/auto-land", "enabled");
  }
}
#--------------------------------------------------------------------
