include <../../../part/switch/key_switch.scad>

$fs = 0.1;
$fa = 5;

// この example と key_switch 系モジュールは実装途中です。
// 現在はステムの造形にのみ対応しています。
// https://github.com/usagi/usagi.scad/issues/1

// とりあえずデフォルト(Cherry MX Red)設定でステムを造形
translate( [ 0, 0, -4 * cos( $t * 360 + 90 ) ] )
key_switch_stem( make_switch_parameters( "Cherry MX Red" ) );

// Cherry MX Red をベースに一部の設定をお好みカスタマイズして…(つづく)
my_switch_parameters = make_switch_parameters
( base_name = "Cherry MX Red"
, custom_parameters =
  [ [ "stem_color", to_RGB_from_HSL( [ 30, 0.75, 0.90 ] ) ]
  , [ "stem_craw_extruding_map"
    , [ [ 3.20, 0.00 ]
      , [ 3.20, 0.43 ]
      , [ 4.08, 0.63 ]
      , [ 4.48, 0.93 ]
      , [ 4.88, 0.83 ]
      , [ 5.28, 0.83 ]
      , [ 5.68, 1.03 ]
      , [ 6.08, 0.88 ]
      , [ 6.48, 0.98 ]
      , [ 6.88, 1.03 ]
      , [ 6.88, 0.53 ]
      , [ 6.38, 0.43 ]
      ]
    ]
  ]
);

// (つづいて)カスタムしたパラメーターで造形
translate( [ 12, 0, -4 * cos( $t * 360 + 120 ) ] )
key_switch_stem( my_switch_parameters );
