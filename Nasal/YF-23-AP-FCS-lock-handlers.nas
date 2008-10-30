#--------------------------------------------------------------------
# ALTITUDE
#--------------------------------------------------------------------
var AP_altitude_lock_listener = func {
  # This listener monitors the autopilot altitude lock and engages
  # the appropriate FCS locks.

  var altitude_lock = cmdarg().getValue();

  if(altitude_lock == "altitude-hold") {
    setprop("/autopilot/FCS/locks/pitch", "true");
    setprop("/autopilot/FCS/locks/vfps", "true");
    setprop("/autopilot/FCS/locks/altitude-hold-climb-rate-gain", "true");
    setprop("/autopilot/FCS/locks/altitude-hold-climb-rate-reciprocal-gain", "true");
    tfa_off();
  } elsif (altitude_lock == "agl-hold") {
    setprop("/autopilot/FCS/locks/pitch", "true");
    setprop("/autopilot/FCS/locks/vfps", "true");
    setprop("/autopilot/FCS/locks/altitude-hold-climb-rate-gain", "false");
    tfa_engaged();
  } elsif (altitude_lock == "vfps-hold") {
    setprop("/autopilot/FCS/locks/pitch", "true");
    setprop("/autopilot/FCS/locks/vfps", "true");
    setprop("/autopilot/FCS/locks/altitude-hold-climb-rate-gain", "false");
    setprop("/autopilot/FCS/locks/altitude-hold-climb-rate-reciprocal-gain", "false");
    tfa_off();
  } elsif (altitude_lock == "mach-climb") {
    setprop("/autopilot/FCS/locks/pitch", "true");
    setprop("/autopilot/FCS/locks/vfps", "true");
    setprop("/autopilot/FCS/locks/altitude-hold-climb-rate-gain", "false");
    setprop("/autopilot/FCS/locks/altitude-hold-climb-rate-reciprocal-gain", "false");
    tfa_off();
  } elsif (altitude_lock == "gs1-hold") {
    setprop("/autopilot/FCS/locks/pitch", "true");
    setprop("/autopilot/FCS/locks/vfps", "true");
    setprop("/autopilot/FCS/locks/altitude-hold-climb-rate-gain", "false");
    setprop("/autopilot/FCS/locks/altitude-hold-climb-rate-reciprocal-gain", "false");
    tfa_off();
  } elsif (altitude_lock == "") {
    setprop("/autopilot/FCS/locks/pitch", "false");
    setprop("/autopilot/FCS/locks/vfps", "false");
    setprop("/autopilot/FCS/locks/altitude-hold-climb-rate-gain", "false");
    setprop("/autopilot/FCS/locks/altitude-hold-climb-rate-reciprocal-gain", "false");
    tfa_off();
  }
}
#--------------------------------------------------------------------
var tfa_engaged = func {
  var current_alt_ft = getprop("/position/altitude-ft");
  var tfa_mode =       getprop("/instrumentation/terrain-radar/settings/mode");
  setprop("/autopilot/settings/target-climb-rate-fps", 0);
  setprop("/autopilot/internal/target-tfa-altitude-ft", current_alt_ft);
  setprop("/instrumentation/terrain-radar/settings/state", "on");

  # Start the collision monitor.
  settimer(collision_monitor, 0.5);

  # Check the mode and start the appropriate loop.
  if(tfa_mode == "extend") {
    settimer(tfa_radar_extend_mode_loop, 0.1);
  } else {
    if(tfa_mode == "continuous") {
      settimer(tfa_radar_continuous_mode_loop, 0.1);
    }
  }
}
#--------------------------------------------------------------------
var tfa_off = func {
  setprop("/instrumentation/terrain-radar/settings/state", "off");
  setprop("/instrumentation/terrain-radar/hi-elev/alt-ft", -9999.9);
  setprop("/instrumentation/terrain-radar/hi-elev/lat-deg", -9999.9);
  setprop("/instrumentation/terrain-radar/hi-elev/lon-deg", -9999.9);
  setprop("/instrumentation/terrain-radar/hi-elev/dist-m", -9999.9);
  setprop("/instrumentation/terrain-radar/hi-elev/collision-status", "");
  setprop("/autopilot/internal/target-tfa-altitude-ft", -9999.9);
}
#--------------------------------------------------------------------
# HEADING
#--------------------------------------------------------------------
var AP_heading_lock_listener = func {
  # This listener monitors the autopilot heading lock and engages
  # the appropriate FCS locks.

  var heading_lock = cmdarg().getValue();

  if(heading_lock == "wing-leveler") {
    setprop("/autopilot/settings/target-roll-deg", 0);
    setprop("/autopilot/FCS/locks/aileron", "true");
    setprop("/autopilot/FCS/locks/roll", "true");
    setprop("/autopilot/FCS/settings/stick-roll-mode", "");
  } elsif (heading_lock == "true-heading-hold") {
    setprop("/autopilot/FCS/locks/aileron", "true");
    setprop("/autopilot/FCS/locks/roll", "true");
    setprop("/autopilot/FCS/settings/stick-roll-mode", "");
  } elsif (heading_lock == "dg-heading-hold") {
    setprop("/autopilot/FCS/locks/aileron", "true");
    setprop("/autopilot/FCS/locks/roll", "true");
    setprop("/autopilot/FCS/settings/stick-roll-mode", "");
  } elsif (heading_lock == "nav1-hold") {
    setprop("/autopilot/FCS/locks/aileron", "true");
    setprop("/autopilot/FCS/locks/roll", "true");
    setprop("/autopilot/FCS/settings/stick-roll-mode", "");
  } elsif (heading_lock == "") {
    setprop("/autopilot/FCS/locks/roll", "false");
    setprop("/autopilot/FCS/settings/stick-roll-mode", "adaptive");
  }
}
#--------------------------------------------------------------------
# SPEED
#--------------------------------------------------------------------
var AP_speed_lock_listener = func {
  # Monitors the AP speed lock and sets the appropriate auto-speedbrake mode
  # if auto-speedbrake is engaged.
  var AP_speed_lock = cmdarg().getValue();

  var FCS_auto_speedbrake_lock =      props.globals.getNode("/autopilot/FCS/locks/auto-speedbrake", 1);
  var FCS_auto_speedbrake_kias_lock = props.globals.getNode("/autopilot/FCS/locks/auto-speedbrake-kias", 1);
  var FCS_auto_speedbrake_mach_lock = props.globals.getNode("/autopilot/FCS/locks/auto-speedbrake-mach", 1);

  if(FCS_auto_speedbrake_lock.getValue() == 1) {
    if(AP_speed_lock == "speed-with-throttle") {
      FCS_auto_speedbrake_kias_lock.setValue("true");
      FCS_auto_speedbrake_mach_lock.setValue("false");
    } elsif (AP_speed_lock == "mach-with-throttle") {
      FCS_auto_speedbrake_kias_lock.setValue("false");
      FCS_auto_speedbrake_mach_lock.setValue("true");
    }
  }
}
#--------------------------------------------------------------------
var AP_target_speed_kt_listener = func {
  var AP_target_speed_kt = cmdarg().getValue();

  var FCS_auto_speedbrake_extend_kt = props.globals.getNode("/autopilot/FCS/settings/auto-speedbrake-extend-kt", 1);

  FCS_auto_speedbrake_extend_kt.setValue(AP_target_speed_kt + 10);
}
#--------------------------------------------------------------------
var AP_target_mach_listener = func {
  var AP_target_mach = cmdarg().getValue();

  var FCS_auto_speedbrake_extend_mach = props.globals.getNode("/autopilot/FCS/settings/auto-speedbrake-extend-mach", 1);

  FCS_auto_speedbrake_extend_mach.setValue(AP_target_mach + 0.02);
}
#--------------------------------------------------------------------
# FCS PITCH
#--------------------------------------------------------------------
var FCS_stick_pitch_mode_listener = func {
  # This listener monitors the FCS stick pitch-mode and engages the
  # appropriate FCS locks.  Also sets the corresponding yaw modes.

  var stick_pitch_mode = cmdarg().getValue();

  if(stick_pitch_mode == "direct") {
    setprop("/autopilot/locks/altitude", "");
    setprop("/autopilot/FCS/locks/ruddervator-pitch", "true");
    setprop("/autopilot/FCS/locks/ruddervator-yaw", "true");
    setprop("/autopilot/FCS/locks/stick-pitch-direct", "true");
    setprop("/autopilot/FCS/locks/stick-pitch-adaptive", "false");
    setprop("/autopilot/FCS/locks/rudder-direct", "true");
    setprop("/autopilot/FCS/locks/rudder-adaptive", "false");
  } elsif (stick_pitch_mode == "adaptive") {
    setprop("/autopilot/locks/altitude", "");
    setprop("/autopilot/FCS/locks/ruddervator-pitch", "true");
    setprop("/autopilot/FCS/locks/ruddervator-yaw", "true");
    setprop("/autopilot/FCS/locks/stick-pitch-direct", "false");
    setprop("/autopilot/FCS/locks/stick-pitch-adaptive", "true");
    setprop("/autopilot/FCS/locks/rudder-direct", "false");
    setprop("/autopilot/FCS/locks/rudder-adaptive", "true");
  } elsif (stick_pitch_mode == "pitch") {
    setprop("/autopilot/locks/altitude", "");
    setprop("/autopilot/FCS/locks/ruddervator-pitch", "false");
    setprop("/autopilot/FCS/locks/ruddervator-yaw", "false");
    setprop("/autopilot/FCS/locks/stick-pitch-direct", "false");
    setprop("/autopilot/FCS/locks/stick-pitch-adaptive", "false");
    setprop("/autopilot/FCS/locks/rudder-direct", "false");
    setprop("/autopilot/FCS/locks/rudder-adaptive", "false");
    setprop("/autopilot/FCS/locks/pitch", "true");
    setprop("/autopilot/FCS/locks/vfps", "false");
  } elsif (stick_pitch_mode == "vfps") {
    setprop("/autopilot/locks/altitude", "");
    setprop("/autopilot/FCS/locks/ruddervator-pitch", "false");
    setprop("/autopilot/FCS/locks/ruddervator-yaw", "false");
    setprop("/autopilot/FCS/locks/stick-pitch-direct", "false");
    setprop("/autopilot/FCS/locks/stick-pitch-adaptive", "false");
    setprop("/autopilot/FCS/locks/rudder-direct", "false");
    setprop("/autopilot/FCS/locks/rudder-adaptive", "false");
    setprop("/autopilot/FCS/locks/pitch", "true");
    setprop("/autopilot/FCS/locks/vfps", "true");
  }
}
#--------------------------------------------------------------------
# FCS ROLL
#--------------------------------------------------------------------
var FCS_stick_roll_mode_listener = func {
  # This listener monitors the FCS stick roll-mode and engages the
  # appropriate FCS locks.

  var stick_roll_mode = cmdarg().getValue();

  if(stick_roll_mode == "direct") {
    setprop("/autopilot/locks/heading", "stick-direct");
    setprop("/autopilot/FCS/locks/roll", "false");
    setprop("/autopilot/FCS/locks/stick-roll-direct", "true");
    setprop("/autopilot/FCS/locks/stick-roll-adaptive", "false");
  } elsif (stick_roll_mode == "adaptive") {
    setprop("/autopilot/locks/heading", "stick-adaptive");
    setprop("/autopilot/FCS/locks/roll", "false");
    setprop("/autopilot/FCS/locks/stick-roll-direct", "false");
    setprop("/autopilot/FCS/locks/stick-roll-adaptive", "true");
  } elsif (stick_roll_mode == "roll") {
    setprop("/autopilot/locks/heading", "stick-roll-set");
    setprop("/autopilot/FCS/locks/roll", "true");
    setprop("/autopilot/FCS/locks/stick-roll-direct", "false");
    setprop("/autopilot/FCS/locks/stick-roll-adaptive", "false");
  } elsif (stick_roll_mode == "") {
    setprop("/autopilot/FCS/locks/roll", "true");
    setprop("/autopilot/FCS/locks/stick-roll-direct", "false");
    setprop("/autopilot/FCS/locks/stick-roll-adaptive", "false");
  }
}
#--------------------------------------------------------------------
# FCS Auto Flap
#--------------------------------------------------------------------
var FCS_auto_flap_lock_listener = func {
  var FCS_auto_flap_lock = cmdarg().getValue();

  var target_flap_norm = props.globals.getNode("/autopilot/FCS/targets/target-flap-norm", 1);

  if(FCS_auto_flap_lock != 1) {
    interpolate(target_flap_norm, 0, 4);
  }
}
#--------------------------------------------------------------------
# FCS Auto Slat
#--------------------------------------------------------------------
var FCS_auto_slat_lock_listener = func {
  var FCS_auto_slat_lock = cmdarg().getValue();

  var target_slat_norm = props.globals.getNode("/autopilot/FCS/targets/target-slat-norm", 1);

  if(FCS_auto_slat_lock != 1) {
    interpolate(target_slat_norm, 0, 4);
  }
}
#--------------------------------------------------------------------
# FCS Auto Speedbrake
#--------------------------------------------------------------------
var FCS_auto_speedbrake_lock_listener = func {
  var FCS_auto_speedbrake_lock = cmdarg().getValue();

  var speedbrake_kias_lock =   props.globals.getNode("/autopilot/FCS/locks/auto-speedbrake-kias", 1);
  var speedbrake_mach_lock =   props.globals.getNode("/autopilot/FCS/locks/auto-speedbrake-mach", 1);
  var target_speedbrake_norm = props.globals.getNode("/autopilot/FCS/targets/target-speedbrake-norm", 1);
  var speed_mode =             props.globals.getNode("/autopilot/locks/speed", 1);

  var spdm = speed_mode.getValue();

  if(FCS_auto_speedbrake_lock == 1) {
    if(spdm == "speed-with-throttle") {
      speedbrake_kias_lock.setValue("true");
      speedbrake_mach_lock.setValue("false");
    } elsif(spdm == "mach-with-throttle") {
      speedbrake_kias_lock.setValue("false");
      speedbrake_mach_lock.setValue("true");
    }
  } else {
    speedbrake_kias_lock.setValue("false");
    speedbrake_mach_lock.setValue("false");
    interpolate(target_speedbrake_norm, 0, 4);
  }
}
#--------------------------------------------------------------------
# AP/FCS lock & settings handlers.
# Start the listeners.
#--------------------------------------------------------------------
setlistener("/autopilot/locks/altitude", AP_altitude_lock_listener);
setlistener("/autopilot/locks/heading", AP_heading_lock_listener);
setlistener("/autopilot/locks/speed", AP_speed_lock_listener);
setlistener("/autopilot/settings/target-speed-kt", AP_target_speed_kt_listener);
setlistener("/autopilot/settings/target-mach", AP_target_mach_listener);
setlistener("/autopilot/FCS/settings/stick-pitch-mode", FCS_stick_pitch_mode_listener);
setlistener("/autopilot/FCS/settings/stick-roll-mode", FCS_stick_roll_mode_listener);
setlistener("/autopilot/FCS/locks/auto-flap", FCS_auto_flap_lock_listener);
setlistener("/autopilot/FCS/locks/auto-slat", FCS_auto_slat_lock_listener);
setlistener("/autopilot/FCS/locks/auto-speedbrake", FCS_auto_speedbrake_lock_listener);
#--------------------------------------------------------------------
