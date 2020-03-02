// ジ・エムエックス・オブ・ザ・リングの example です
// モジュールのより詳しい使い方は the_MX_of_the_ring モジュールのコメントもご覧くださいませ

include <../../product/the_MX_of_the_ring.scad>

//$t = 0;
$fs = 0.05;
$fa = 1;

// シンプルなMXリング
color( [ 0.8, 0.8, 0.8 ] )
the_MX_of_the_ring( inner_circumference = 48.2, thickness = 1, width = 2, stage_depth = -0.5, stage_rotation = 45 );

// 幅を広くして台座を無くしたシンプルタイプ
translate( [ 20, 0, 0 ] )
color( [ 0.9, 0.8, 0.8 ] )
the_MX_of_the_ring( inner_circumference = 48.2, thickness = 1, width = 4.5, stage_depth = -0.5, stage_type = [ ] );

// 幅を広くして台座を無くしたシンプルタイプのお子様サイズ
translate( [ 20, 20, 0 ] )
color( [ 0.9, 0.8, 0.8 ] )
the_MX_of_the_ring( inner_circumference = 40.8, thickness = 1, width = 4.0, stage_depth = -0.5, stage_type = [ ] );

// 幅を広くして台座を無くしたシンプルタイプの太めの指をお持ちの方サイズ
translate( [ 20, -20, 0 ] )
color( [ 0.9, 0.8, 0.8 ] )
the_MX_of_the_ring( inner_circumference = 58.6, thickness = 1, width = 4.0, stage_depth = -0.5, stage_type = [ ] );

// 台座で立ち上げるタイプ
translate( [ 0, 20, 0 ] )
color( [ 0.8, 0.8, 0.8 ] )
the_MX_of_the_ring( inner_circumference = 48.2, thickness = 1, width = 2, stage_depth = +2.5, stage_rotation = 45 );

// 円形台座タイプ
translate( [ -20, 0, 0 ] )
color( [ 0.8, 0.8, 0.9 ] )
the_MX_of_the_ring( inner_circumference = 48.2, thickness = 1, width = 2, stage_depth = -0.5, stage_type = "shaft" );

// 円形台座で立ち上げるタイプ
translate( [ -20, 20, 0 ] )
color( [ 0.8, 0.8, 0.9 ] )
the_MX_of_the_ring( inner_circumference = 48.2, thickness = 1, width = 2, stage_depth = +2.5, stage_type = "shaft" );

// 安定でか台座タイプ(台座回転なし)
translate( [ 0, -20, 0 ] )
color( [ 0.8, 0.8, 0.8 ] )
the_MX_of_the_ring( inner_circumference = 48.2, thickness = 1, width = 2, stage_depth = -0.5, stage_size = [ 8, 8 ] );

// 安定でか台座タイプ(台座回転45deg)
translate( [ 0, -40, 0 ] )
color( [ 0.8, 0.8, 0.8 ] )
the_MX_of_the_ring( inner_circumference = 48.2, thickness = 1, width = 2, stage_depth = -0.5, stage_size = [ 8, 8 ], stage_rotation = 45 );

// 安定でか円形台座タイプ
translate( [ -20, -20, 0 ] )
color( [ 0.8, 0.8, 0.9 ] )
the_MX_of_the_ring( inner_circumference = 48.2, thickness = 1, width = 2, stage_depth = -0.5, stage_type = "shaft", stage_size = 8 );

// オリジナルデザインの台座を合成するタイプ
translate( [ 40, 0, 0 ] )
color( [ 0.9, 0.9, 0.8 ] )
union()
{
  thickness = 1;
  stage_depth = 0.5;
  my_stage_height = stage_depth + thickness;
  
  // オリジナルデザインの台座
  translate( [ 0, 0, -my_stage_height ] )
    cylinder( d = 8, h = my_stage_height, $fn = 6 );
  
  the_MX_of_the_ring( inner_circumference = 48.2, thickness = thickness, width = 4, stage_depth = stage_depth, stage_type = [ ] );
}

// ステムを若干きつめに調整したい場合 (ご注意: 例ではわかりやすいように「少し」どころではなくプレビューの見た目でわかるほど太くしています)
// make_switch_parameters で太いステムのスイッチデータを作って…
include <../../part/switch/key_switch/make_switch_parameters.scad>
my_switch_parameter = make_switch_parameters
( custom_parameters = 
  [ [ "stem_cross_x_bar", [ 5.00, 2.00 ] ] // 元の値は [ 4.00, 1.02 ]
  , [ "stem_cross_y_bar", [ 2.09, 5.00 ] ] // 元の値は [ 1.09, 4.00 ]
  ]
);
// key_switch_data 引数でオレオレキースイッチデータを渡します
translate( [ 40, -20, 0 ] )
color( [ 0.9, 0.9, 0.8 ] )
the_MX_of_the_ring( inner_circumference = 48.2, thickness = 0.5, width = 4, stage_depth = 0.5, stage_type = "shaft", stage_size = 12, key_switch_data = my_switch_parameter );
