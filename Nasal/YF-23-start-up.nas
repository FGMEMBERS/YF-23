#--------------------------------------------------------------------
# YF-23 start-up scripts.
#--------------------------------------------------------------------
var start_up = func {
  settimer(initialise, 5);
}
#--------------------------------------------------------------------
var initialise = func {
  # This just sets a few things at start-up for initialisation.

  # Re-set the speed targets to force the target-speed listeners to
  # update the auto-speedbrake targets.
  var AP_target_speed_kt = getprop("/autopilot/settings/target-speed-kt");
  var AP_target_mach =     getprop("/autopilot/settings/target-mach");
  setprop("/autopilot/settings/target-speed-kt", AP_target_speed_kt);
  setprop("/autopilot/settings/target-mach", AP_target_mach);

  # Initialise the drop-view
  initialise_drop_view_pos();
}
#--------------------------------------------------------------------
