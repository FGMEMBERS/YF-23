#--------------------------------------------------------------------
var altitude_hold_off = func {

  var ap_altitude_mode = getprop("/autopilot/locks/altitude");

  if(ap_altitude_mode != "") {
    setprop("/autopilot/locks/altitude", "");
  }
}
#--------------------------------------------------------------------
var toggle_altitude_hold = func {

  var ap_altitude_mode = getprop("/autopilot/locks/altitude");

  if(ap_altitude_mode == "altitude-hold") {
    setprop("/autopilot/locks/altitude", "");
  } else {
    setprop("/autopilot/locks/altitude", "altitude-hold");
  }
}
#--------------------------------------------------------------------
var toggle_agl_hold = func {

  var ap_altitude_mode = getprop("/autopilot/locks/altitude");

  if(ap_altitude_mode == "agl-hold") {
    setprop("/autopilot/locks/altitude", "");
  } else {
    setprop("/autopilot/locks/altitude", "agl-hold");
  }
}
#--------------------------------------------------------------------
var toggle_vfps_hold = func {

  var ap_altitude_mode = getprop("/autopilot/locks/altitude");

  if(ap_altitude_mode == "vfps-hold") {
    setprop("/autopilot/locks/altitude", "");
  } else {
    setprop("/autopilot/locks/altitude", "vfps-hold");
  }
}
#--------------------------------------------------------------------
var toggle_mc_hold = func {

  var ap_altitude_mode = getprop("/autopilot/locks/altitude");

  if(ap_altitude_mode == "mach-climb") {
    setprop("/autopilot/locks/altitude", "");
  } else {
    setprop("/autopilot/locks/altitude", "mach-climb");
  }
}
#--------------------------------------------------------------------
var toggle_gs1_hold = func {

  var ap_altitude_mode = getprop("/autopilot/locks/altitude");

  if(ap_altitude_mode == "gs1-hold") {
    setprop("/autopilot/locks/altitude", "");
  } else {
    setprop("/autopilot/locks/altitude", "gs1-hold");
  }
}
#--------------------------------------------------------------------
var heading_hold_off = func {

  var ap_heading_mode = getprop("/autopilot/locks/heading");

  if(ap_heading_mode != "") {
    setprop("/autopilot/locks/heading", "");
  }
}
#--------------------------------------------------------------------
var toggle_wing_leveler = func {

  var ap_heading_mode = getprop("/autopilot/locks/heading");

  if(ap_heading_mode == "wing-leveler") {
    setprop("/autopilot/locks/heading", "");
  } else {
    setprop("/autopilot/locks/heading", "wing-leveler");
  }
}
#--------------------------------------------------------------------
var toggle_true_heading_hold = func {

  var ap_heading_mode = getprop("/autopilot/locks/heading");

  if(ap_heading_mode == "true-heading-hold") {
    setprop("/autopilot/locks/heading", "");
  } else {
    setprop("/autopilot/locks/heading", "true-heading-hold");
  }
}
#--------------------------------------------------------------------
var toggle_dg_heading_hold = func {

  var ap_heading_mode = getprop("/autopilot/locks/heading");

  if(ap_heading_mode == "dg-heading-hold") {
    setprop("/autopilot/locks/heading", "");
  } else {
    setprop("/autopilot/locks/heading", "dg-heading-hold");
  }
}
#--------------------------------------------------------------------
var toggle_nav1_hold = func {

  var ap_heading_mode = getprop("/autopilot/locks/heading");

  if(ap_heading_mode == "nav1-hold") {
    setprop("/autopilot/locks/heading", "");
  } else {
    setprop("/autopilot/locks/heading", "nav1-hold");
  }
}
#--------------------------------------------------------------------
var select_fcs_stick_pitch_direct_mode = func {

  setprop("/autopilot/FCS/settings/stick-pitch-mode", "direct");
}
#--------------------------------------------------------------------
var select_fcs_stick_pitch_adaptive_mode = func {

  setprop("/autopilot/FCS/settings/stick-pitch-mode", "adaptive");
}
#--------------------------------------------------------------------
var select_fcs_stick_pitch_pitch_mode = func {

  setprop("/autopilot/FCS/settings/stick-pitch-mode", "pitch");
}
#--------------------------------------------------------------------
var select_fcs_stick_pitch_vfps_mode = func {

  setprop("/autopilot/FCS/settings/stick-pitch-mode", "vfps");
}
#--------------------------------------------------------------------
var select_fcs_stick_roll_direct_mode = func {

  setprop("/autopilot/FCS/settings/stick-roll-mode", "direct");
}
#--------------------------------------------------------------------
var select_fcs_stick_roll_adaptive_mode = func {

  setprop("/autopilot/FCS/settings/stick-roll-mode", "adaptive");
}
#--------------------------------------------------------------------
var select_fcs_stick_roll_roll_mode = func {

  setprop("/autopilot/FCS/settings/stick-roll-mode", "roll");
}
#--------------------------------------------------------------------
var toggle_fcs_auto_flap = func {

  var fcs_auto_flap_lock = getprop("/autopilot/FCS/locks/auto-flap");

  if(fcs_auto_flap_lock == 1) {
    setprop("/autopilot/FCS/locks/auto-flap", "false");
  } else {
    setprop("/autopilot/FCS/locks/auto-flap", "true");
  }
}
#--------------------------------------------------------------------
var toggle_fcs_auto_slat = func {

  var fcs_auto_slat_lock = getprop("/autopilot/FCS/locks/auto-slat");

  if(fcs_auto_slat_lock == 1) {
    setprop("/autopilot/FCS/locks/auto-slat", "false");
  } else {
    setprop("/autopilot/FCS/locks/auto-slat", "true");
  }
}
#--------------------------------------------------------------------
var toggle_fcs_auto_speedbrake = func {

  var fcs_auto_speedbrake_lock = getprop("/autopilot/FCS/locks/auto-speedbrake");

  if(fcs_auto_speedbrake_lock == 1) {
    setprop("/autopilot/FCS/locks/auto-speedbrake", "false");
  } else {
    setprop("/autopilot/FCS/locks/auto-speedbrake", "true");
  }
}
#--------------------------------------------------------------------
var toggle_fcs_auto_reheat = func {

  var fcs_auto_reheat_lock = getprop("/autopilot/FCS/locks/auto-reheat");

  if(fcs_auto_reheat_lock == 1) {
    setprop("/autopilot/FCS/locks/auto-reheat", "false");
  } else {
    setprop("/autopilot/FCS/locks/auto-reheat", "true");
  }
}
#--------------------------------------------------------------------
