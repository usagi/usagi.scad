include <../../../../part/switch/key_switch/stem.scad>
include <../../../../part/switch/key_switch/make_switch_parameters.scad>

//$t = 0.5;
$fs = 0.1;
$fa = 5;

// ↓全体を造形したいだけの場合はこれでOK
//key_switch_stem( make_switch_parameters( "Cherry MX Blue" ) );

// ↓パーツ分離で造形したりアニメーションしたりしたい場合の例
blue_body_parameter  = make_switch_parameters( base_name = "Cherry MX Blue", custom_parameters = [ [ "splitted_part_enabling", [ true , false ] ] ] );
blue_skirt_parameter = make_switch_parameters( base_name = "Cherry MX Blue", custom_parameters = [ [ "splitted_part_enabling", [ false, true  ] ] ] );

// body/skirt を青軸の実際の押下挙動っぽくアニメーションする例

z_body  = lookup( $t, [ [ 0, 0 ],              [ 0.25, -2.0 ],                  [ 0.5, -3.2 ], [ 0.75, -2.0 ], [ 1, 0 ] ] );
z_skirt = lookup( $t, [ [ 0, 0,], [ 0.15, 0 ], [ 0.25, -0.8 ], [ 0.255, -2.0 ], [ 0.5, -2.0 ], [ 0.75, -2.0 ], [ 1, 0 ] ] );

echo( $t, z_body, z_skirt );

translate( [ 0, 0, z_body ] )
key_switch_stem( blue_body_parameter );
translate( [ 0, 0, z_skirt ] )
key_switch_stem( blue_skirt_parameter );

