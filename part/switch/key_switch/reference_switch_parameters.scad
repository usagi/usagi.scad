include <reference_switch_parameters/Cherry_MX_Red.scad>
include <reference_switch_parameters/Cherry_MX_Brown.scad>

reference_switch_parameters = 
  concat
  ( reference_switch_parameters_Cherry_MX_Red
  , reference_switch_parameters_Cherry_MX_Brown
  );