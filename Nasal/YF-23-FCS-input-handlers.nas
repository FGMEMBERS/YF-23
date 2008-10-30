#--------------------------------------------------------------------
# PITCH
#--------------------------------------------------------------------
var FCS_stick_pitch_axis_listener = func {
  # This listener monitors stick pitch inputs and calls the
  # appropriate FCS stick mode handler with the data.

  var pitch_input_axis_norm = cmdarg().getValue();
  var FCS_stick_pitch_mode = props.globals.getNode("/autopilot/FCS/settings/stick-pitch-mode", 1);

  # May be tested multiple times so read once and store as a simple var.
  var fcsspm = FCS_stick_pitch_mode.getValue();

  if(fcsspm == "pitch") {
    FCS_stick_pitch_pitch_mode(pitch_input_axis_norm);
  } elsif (fcsspm == "vfps") {
    FCS_stick_pitch_climb_mode(pitch_input_axis_norm);
  }
}
#--------------------------------------------------------------------
var FCS_stick_pitch_pitch_mode = func (pitch_input_axis_norm) {
  # This handler reads the min and max FCS pitch settings and
  # generates a target pitch-deg AP setting from the normailsed
  # pitch input.

  var FCS_max_pitch_deg =   props.globals.getNode("/autopilot/FCS/settings/max-pitch-deg", 1);
  var FCS_min_pitch_deg =   props.globals.getNode("/autopilot/FCS/settings/min-pitch-deg", 1);
  var AP_target_pitch_deg = props.globals.getNode("/autopilot/settings/target-pitch-deg", 1);

  # To allow for different max-min values test for polarity.
  if(pitch_input_axis_norm < 0) {
    var aptpd = -1 * pitch_input_axis_norm * FCS_max_pitch_deg.getValue();
  } else {
    var aptpd = pitch_input_axis_norm * FCS_min_pitch_deg.getValue();
  }
  AP_target_pitch_deg.setValue(aptpd);
}
#--------------------------------------------------------------------
var FCS_stick_pitch_climb_mode = func (pitch_input_axis_norm) {
  # This handler reads the min and max FCS climb rate settings and
  # generates a target climb-rate-fps AP setting from the normalised
  # pitch input.

  var FCS_max_climb_rate_fps =   props.globals.getNode("/autopilot/FCS/settings/max-climb-rate-fps", 1);
  var FCS_min_climb_rate_fps =   props.globals.getNode("/autopilot/FCS/settings/min-climb-rate-fps", 1);
  var AP_target_climb_rate_fps = props.globals.getNode("/autopilot/settings/target-climb-rate-fps", 1);

  # To allow for different max-min values test for polarity.
  if(pitch_input_axis_norm < 0) {
    var aptcrfps = -1 * pitch_input_axis_norm * FCS_max_climb_rate_fps.getValue();
  } else {
    var aptcrfps = pitch_input_axis_norm * FCS_min_climb_rate_fps.getValue();
  }
  AP_target_climb_rate_fps.setValue(aptcrfps);
}
#--------------------------------------------------------------------
# ROLL
#--------------------------------------------------------------------
var FCS_stick_roll_axis_listener = func {
  # This listener monitors stick roll inputs and calls the
  # appropriate FCS stick mode handler with the data.

  var roll_input_axis_norm = cmdarg().getValue();

  var FCS_stick_roll_mode = props.globals.getNode("/autopilot/FCS/settings/stick-roll-mode", 1);

  # May be tested multiple times so read once and store as a simple var.
  var fcssrm = FCS_stick_roll_mode.getValue();

  if(fcssrm == "roll") {
    FCS_stick_roll_roll_mode(roll_input_axis_norm);
  }
}
#--------------------------------------------------------------------
var FCS_stick_roll_roll_mode = func (roll_input_axis_norm) {
  # This handler reads the min and max FCS roll settings and
  # generates a target roll-deg FCS setting from the normailsed
  # roll input.

  var FCS_max_roll_deg =   props.globals.getNode("/autopilot/FCS/settings/max-roll-deg", 1);
  var FCS_min_roll_deg =   props.globals.getNode("/autopilot/FCS/settings/min-roll-deg", 1);
  var AP_target_roll_deg = props.globals.getNode("/autopilot/settings/target-roll-deg", 1);

  # To allow for different max-min values test for polarity.
  # Not really needed here but its an option.
  if(roll_input_axis_norm > 0) {
    var aptrd = roll_input_axis_norm * FCS_max_roll_deg.getValue();
  } else {
    var aptrd = -1 * roll_input_axis_norm * FCS_min_roll_deg.getValue();
  }
  AP_target_roll_deg.setValue(aptrd);
}
#--------------------------------------------------------------------
# FLAPS
#--------------------------------------------------------------------
var FCS_flaps_axis_listener = func {
  # This listener monitors pilot flap control input and copies it to
  # the appropriate FCS property.

  var flap_input_axis_norm = cmdarg().getValue();

  var tgt_flap_norm = props.globals.getNode("/autopilot/FCS/targets/target-flap-norm", 1);

  tgt_flap_norm.setValue(flap_input_axis_norm);
}
#--------------------------------------------------------------------
# SLATS
#--------------------------------------------------------------------
var FCS_slats_axis_listener = func {
  # This listener monitors pilot slat control input and copies it to
  # the appropriate FCS property.

  var slat_input_axis_norm = cmdarg().getValue();

  var tgt_slat_norm = props.globals.getNode("/autopilot/FCS/targets/target-slat-norm", 1);

  tgt_slat_norm.setValue(slat_input_axis_norm);
}
#--------------------------------------------------------------------
# SPOILERS (Speedbrake)
#--------------------------------------------------------------------
var FCS_spoilers_axis_listener = func {
  # This listener monitors pilot spoiler (speedbrake) control input
  # and copies it to the appropriate FCS property.

  var spoilers_input_axis_norm = cmdarg().getValue();

  var tgt_speedbrake_norm = props.globals.getNode("/autopilot/FCS/targets/target-speedbrake-norm", 1);

  tgt_speedbrake_norm.setValue(spoilers_input_axis_norm);
}
#--------------------------------------------------------------------
# SPEED
#--------------------------------------------------------------------
var FCS_engine0_throttle_axis_listener = func {
  # This listener monitors engine 0 throttle inputs and calls the
  # appropriate FCS handler with the data.

  var eng0_throttle_input_axis_norm = cmdarg().getValue();

  var FCS_auto_reheat_lock = props.globals.getNode("/autopilot/FCS/locks/auto-reheat", 1);

  if(FCS_auto_reheat_lock.getValue() == 1) {
    FCS_eng0_throttle_ar_mode(eng0_throttle_input_axis_norm);
  } else {
    FCS_eng0_throttle_nar_mode(eng0_throttle_input_axis_norm);
  }
}
#--------------------------------------------------------------------
var FCS_engine1_throttle_axis_listener = func {
  # This listener monitors engine 1 throttle inputs and calls the
  # appropriate FCS handler with the data.

  var eng1_throttle_input_axis_norm = cmdarg().getValue();

  var FCS_auto_reheat_lock = props.globals.getNode("/autopilot/FCS/locks/auto-reheat", 1);

  if(FCS_auto_reheat_lock.getValue() == 1) {
    FCS_eng1_throttle_ar_mode(eng1_throttle_input_axis_norm);
  } else {
    FCS_eng1_throttle_nar_mode(eng1_throttle_input_axis_norm);
  }
}
#--------------------------------------------------------------------
var FCS_eng0_throttle_nar_mode = func (eng0_throttle_input_axis_norm) {
  # This handler passes the throttle input directly to the
  # engine 0 throttle driver.

  var tgt_eng0_throttle_norm = props.globals.getNode("/autopilot/FCS/targets/engines/engine[0]/target-throttle-norm", 1);
  var tgt_eng0_reheat_norm =   props.globals.getNode("/autopilot/FCS/targets/engines/engine[0]/target-reheat-norm", 1);

  # Pass the eng0_throttle_norm input to the target eng0-throttle-norm.
  tgt_eng0_throttle_norm.setValue(eng0_throttle_input_axis_norm);
  tgt_eng0_reheat_norm.setValue(0);
}
#--------------------------------------------------------------------
var FCS_eng0_throttle_ar_mode = func (eng0_throttle_input_axis_norm) {
  # This handler implements an auto-reheat function.  Throttle input between 0.0-0.8
  # are scaled to 0.0-1.0 and throttle inputs between 0.8-1.0 are scaled to 0.0-1.0
  # and passed to the reheat control.

  var tgt_eng0_throttle_norm = props.globals.getNode("/autopilot/FCS/targets/engines/engine[0]/target-throttle-norm", 1);
  var tgt_eng0_reheat_norm =   props.globals.getNode("/autopilot/FCS/targets/engines/engine[0]/target-reheat-norm", 1);

  if(eng0_throttle_input_axis_norm <= 0.8) {
    tgt_eng0_throttle_norm.setValue(eng0_throttle_input_axis_norm * 1.25);
    tgt_eng0_reheat_norm.setValue(0);
  } else {
    tgt_eng0_throttle_norm.setValue(1.0);
    tgt_eng0_reheat_norm.setValue((eng0_throttle_input_axis_norm - 0.8) * 5);
  }
}
#--------------------------------------------------------------------
var FCS_eng1_throttle_nar_mode = func (eng1_throttle_input_axis_norm) {
  # This handler passes the throttle input directly to the
  # engine 1 throttle driver.

  var tgt_eng1_throttle_norm = props.globals.getNode("/autopilot/FCS/targets/engines/engine[1]/target-throttle-norm", 1);
  var tgt_eng1_reheat_norm =   props.globals.getNode("/autopilot/FCS/targets/engines/engine[1]/target-reheat-norm", 1);

  # Pass the eng1_throttle_norm input to the target eng1-throttle-norm.
  tgt_eng1_throttle_norm.setValue(eng1_throttle_input_axis_norm);
  tgt_eng1_reheat_norm.setValue(0);
}
#--------------------------------------------------------------------
var FCS_eng1_throttle_ar_mode = func (eng1_throttle_input_axis_norm) {
  # This handler passes the throttle input directly to the
  # engine 1 throttle driver.

  var tgt_eng1_throttle_norm = props.globals.getNode("/autopilot/FCS/targets/engines/engine[1]/target-throttle-norm", 1);
  var tgt_eng1_reheat_norm =   props.globals.getNode("/autopilot/FCS/targets/engines/engine[1]/target-reheat-norm", 1);

  if(eng1_throttle_input_axis_norm <= 0.8) {
    tgt_eng1_throttle_norm.setValue(eng1_throttle_input_axis_norm * 1.25);
    tgt_eng1_reheat_norm.setValue(0);
  } else {
    tgt_eng1_throttle_norm.setValue(1.0);
    tgt_eng1_reheat_norm.setValue((eng1_throttle_input_axis_norm - 0.8) * 5);
  }
}
#--------------------------------------------------------------------
var FCS_engine0_reheat_axis_listener = func {

  var eng0_reheat_input_axis_norm = cmdarg().getValue();

  var tgt_eng0_reheat_norm = props.globals.getNode("/autopilot/FCS/targets/target-eng0-reheat-norm", 1);

  tgt_eng0_reheat_norm.setValue(eng0_reheat_input_axis_norm);
}
#--------------------------------------------------------------------
var FCS_engine1_reheat_axis_listener = func {

  var eng1_reheat_input_axis_norm = cmdarg().getValue();

  var tgt_eng1_reheat_norm = props.globals.getNode("/autopilot/FCS/targets/target-eng1-reheat-norm", 1);

  tgt_eng1_reheat_norm.setValue(eng1_reheat_input_axis_norm);
}
#--------------------------------------------------------------------
# FCS input listeners.
#--------------------------------------------------------------------
setlistener("/controls/flight/aileron", FCS_stick_roll_axis_listener);
setlistener("/controls/flight/elevator", FCS_stick_pitch_axis_listener);
setlistener("/controls/flight/flaps", FCS_flaps_axis_listener);
setlistener("/controls/flight/slats", FCS_slats_axis_listener);
setlistener("/controls/flight/spoilers", FCS_spoilers_axis_listener);
setlistener("/controls/engines/engine[0]/throttle", FCS_engine0_throttle_axis_listener);
setlistener("/controls/engines/engine[1]/throttle", FCS_engine1_throttle_axis_listener);
setlistener("/controls/engines/engine[0]/reheat", FCS_engine0_reheat_axis_listener);
setlistener("/controls/engines/engine[1]/reheat", FCS_engine1_reheat_axis_listener);
#--------------------------------------------------------------------
