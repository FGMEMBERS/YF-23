#--------------------------------------------------------------------
var yaw_monitor = func {
  # This function works out the current aircraft yaw angle by comparing
  # /orientation/heading-deg and /instrumentation/gps/indicated-track-true-deg
  # and puts the result in /autopilot/internal/yaw-deg.
  # This is really a stop-gap measure until /orientation/yaw-deg works.

  var hdgdeg = props.globals.getNode("/orientation/heading-deg", 1);
  var gpsdeg = props.globals.getNode("/instrumentation/gps/indicated-track-true-deg", 1);
  var yawdeg = props.globals.getNode("/autopilot/internal/yaw-deg", 1);

  var yawtemp = (gpsdeg.getValue() - hdgdeg.getValue());

  # Check for 360-0 problems.
  if(yawtemp < -180) {
    yawtemp = yawtemp + 360;
  } else {
    if(yawtemp > 180) {
      yawtemp = yawtemp - 360;
    }
  }

  yawdeg.setValue(yawtemp);

  # Schedule the next call.
  settimer(yaw_monitor, 0.1);
}
#--------------------------------------------------------------------
settimer(yaw_monitor, 5);
#--------------------------------------------------------------------
