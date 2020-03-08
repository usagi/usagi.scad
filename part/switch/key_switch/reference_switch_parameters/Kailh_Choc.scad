/// Kailh Choc 共通パラメーター群 ( Red をもとに作成し、他の種類と比較して共通部分を整理したパラメーター群です )
/// @ref https://github.com/keyboardio/keyswitch_documentation/blob/master/datasheets/Kailh/
reference_switch_parameters_Kailh_Choc = 
  [ [ "type", "Choc" ]
  , [ "top_hole_distance", 5.70 ] // 穴の中心間の距離(参考資料から決定)
  , [ "top_hole_size", [ 1.20, 3.00, 4.00 ] ] // 穴の寸法(X,Yは参考資料から,ZはRed_Linear_Chocの計測から)
  , [ "stage_hole_apertural_angle", 120 ]
  , [ "stage_hole_apertural_length", 0.2 ]
  , [ "stage_size", [ 10.30, 4.50, 4.72 ] ] // 
  , [ "stage_r", 0.20 ]
  , [ "shaft_size", [ 1.68, 7.07] ] // [ diameter, height of bottom to stage-top ]
  , [ "shaft_chamfering_parameters", [ 30, 0.4, "C" ] ]
  , [ "bottom_hole_size", [ 3.50, 4.00 ] ]
  , [ "side_wing_size", [ 0.80, 2.04, 0.62 ] ]
  , [ "front_rail_outer_size", [ 3.01, 1.16 ] ]
  , [ "front_rail_outer_thickness", 0.5 ]
  //, [ "rail_profile", [ ] ] // レール内のステージ上面からの深さ(-Z) に対するステージ前面からの押し出し長さ(-Y)のリスト [ [-Z0, -Y0], [-Z1, -Y1], ...  ]
  //, [ "back_craw_profile", [ ] ] // Kailh Choc White などクリッキー系にある背面の爪のプロファイル。ステージ上面からの深さ(-Z)に対するステージ背面からの押し出し長さ(+Y)のリスト
  , [ "back_craw_width", 0.6 ] // X軸幅
  , [ "back_craw_position", -3.2 ] // ステージの中心(造形ローカル座標系原点)から爪の中心部までの長さ(X軸位置)
  , [ "stage_longitudinal_hole_width", 1 ] // 穴の横幅(x)だけ与えれば出入り口の縦幅は2倍、中央の縦幅は1倍でうまいこと生成します
  , [ "stage_longitudinal_hole_position", [ 4.3, -3.5 ] ] // 穴の位置 [ x, z ]
  ];
