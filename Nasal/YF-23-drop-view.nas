# Drop-view functions
#--------------------------------------------------------------------
# Let FG get initialised before trying to set a position.
var initialise = func {
  settimer(initialise_drop_view_pos, 4);
}
#--------------------------------------------------------------------
# Initialise the view to the starting location.
var initialise_drop_view_pos = func {
  var eyelatdeg = getprop("/position/latitude-deg");
  var eyelondeg = getprop("/position/longitude-deg");
  var eyealtft = getprop("/position/altitude-ft") + 20;
  setprop("/sim/view[100]/latitude-deg", eyelatdeg);
  setprop("/sim/view[100]/longitude-deg", eyelondeg);
  setprop("/sim/view[100]/altitude-ft", eyealtft);
}
#--------------------------------------------------------------------
# Move the view to the current location.
var update_drop_view_pos = func {
  var eyelatdeg = getprop("/position/latitude-deg");
  var eyelondeg = getprop("/position/longitude-deg");
  var eyealtft = getprop("/position/altitude-ft") + 20;
  interpolate("/sim/view[100]/latitude-deg", eyelatdeg, 5);
  interpolate("/sim/view[100]/longitude-deg", eyelondeg, 5);
  interpolate("/sim/view[100]/altitude-ft", eyealtft, 5);
}
#--------------------------------------------------------------------
