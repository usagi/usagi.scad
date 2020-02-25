include <reference_switch_parameters.scad>
include <../../../utility/vector/concat_without_duplicate.scad>

function make_switch_parameters
( base_name = "Cherry MX Red"
, base_parameters   = [ ]
, custom_parameters = [ ]
) =
  let
  ( base_parameters = 
      base_parameters != [ ]
        ? base_parameters
        : ( let( indices = search( [ base_name ], reference_switch_parameters ) )
              indices != [ ]
                ? reference_switch_parameters[ indices[ 0 ] ][ 1 ]
                : [ ]
          )
  )
    concat_without_duplicate( base_parameters, custom_parameters )
  ;
