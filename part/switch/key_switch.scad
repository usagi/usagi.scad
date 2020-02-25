/// Cherry MX convertible switch

include <../shaft.scad>
include <../../geometry/chamfered_cube.scad>
include <../../utility/color/HSL.scad>

include <key_switch/make_switch_parameters.scad>
include <key_switch/stem.scad>
include <key_switch/housing_bottom.scad>
include <key_switch/housing_top.scad>
include <key_switch/spring.scad>

module key_switch
( data = [ ]
, no_spring = true
)
{
  echo( "cherry_mx_switch: この機能は実装途中です。現在はステムの造形にのみ対応しています。たぶん数日以内に実装します。" );
  
  let( data = data == [ ] ? switch_reference_data_MX : data )
  {
    key_switch_stem( data );
    if ( ! no_spring )
      key_switch_spring( data );
    key_switch_housing_bottom( data );
    key_switch_housing_top( data );
  }
}
