include <reference_switch_parameters/Cherry_MX_Red.scad>
include <reference_switch_parameters/Cherry_MX_Brown.scad>
include <reference_switch_parameters/Cherry_MX_Blue.scad>
include <reference_switch_parameters/Cherry_MX_Speed_Silver.scad>
include <reference_switch_parameters/Invyr_UHMWPE_Linear.scad>

reference_switch_parameters = 
  concat
  ( reference_switch_parameters_Cherry_MX_Red
  , reference_switch_parameters_Cherry_MX_Brown
  , reference_switch_parameters_Cherry_MX_Blue
  , reference_switch_parameters_Cherry_MX_Speed_Silver
  , reference_switch_parameters_Invyr_UHMWPE_Linear
  );