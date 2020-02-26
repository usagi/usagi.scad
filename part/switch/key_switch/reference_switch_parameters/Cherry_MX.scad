/// Cherry MX 共通パラメーター群 ( Red をもとに作成し、他の種類と比較して共通部分を整理したパラメーター群です )
reference_switch_parameters_Cherry_MX = 
   [ [ "type", "MX" ]

  , [ "stem_cross_x_bar", [ 4.00, 1.02 ] ]
  , [ "stem_cross_y_bar", [ 1.09, 4.00 ] ]
  , [ "stem_cross_z", 3.60 ]
  , [ "stem_cross_x_bar_top_right_chamfering_parameters" , [ 45, 0.20, "C" ] ]
  , [ "stem_cross_x_bar_top_left_chamfering_parameters" , [ 45, 0.20, "C" ] ]
  , [ "stem_cross_y_bar_top_chamfering_parameters" , [ 45, 0.20, "C" ] ]
  , [ "stem_cross_x_bar_extruding", [ 3.90, 1.31, 3.50 ] ]
  , [ "stem_cross_x_bar_extruding_chamfering_parameters", [ 0, 0.1, "R" ] ]
  , [ "stem_cross_x_bar_inset_width", 0.20 ]
  
  // Cherry MX や Kailh のクロス部を横から見ると y_bar の +/- 何れかにある切り欠けの設定
  // 厳密にはキャップとの摩擦に影響するが、大量に射出成形するわけでなければ無くてもよいかもしれません
  , [ "stem_cross_y_notch_depth", -0.20 ]
  , [ "stem_cross_y_notch_z_position", 2.60 ]
  , [ "stem_cross_y_notch_chamfering_angle", 45 ]
  , [ "stem_cross_y_notch_height", 1.50 ]
  
  , [ "housing_bottom_outer_size", [ 15.6, 15.6 ] ]

  , [ "housing_bottom_outer_r", 1.00 ] // マウントプレートに引っかかる部分の角丸のR
  , [ "housing_height", 11.6 ] // 組み立て状態で下部ハウジングの底面(円柱は含まず)からステムのクロス部下端までの長さ
                              // Note: 上部ハウジング上面とステムのクロス部下端の間には
                              //       面取り(Authorの目測でおよそ30deg)の高さ分に等しい隙間があります。
  , [ "stem_stage_top_chamfering_parameters" , [ 30, 0.8, "C" ] ] // ステムのクロスが乗るステージ部分の上面取り設定
  , [ "stem_stage_side_chamfering_parameters", [ 0, 0.2, "R" ] ] // ステムのクロスが乗るステージ部分の側面取り設定
  , [ "stem_stage_size", [ 7.22, 5.57, 3.50 ] ] // ステムの胴体部分(組み立て状態ではハウジングに埋まっている)の外形
                                                // Z は円柱状の穴の面(切れ込みに見える部分)まで
  , [ "stem_stage_x_clearance", 0.48 ] // [mm] 出っ張りの無い部分の下部ハウジングとのクリアランス
  
  , [ "stem_stage_hole_diameter", 4.3 ] // [mm] ステムを裏から見ると空いている円柱穴の直径
  , [ "stem_stage_hole_height"  , 2.5 ] // [mm] ステムを裏から見ると空いている円柱穴の深さ

  , [ "stem_bottom_shaft_diameter"          ,  1.97 ] // [mm] ステム下部シャフトの直径
  , [ "stem_bottom_shaft_height"            ,  9.00 ] // [mm] ステム下部シャフト最下端からステージ上面までの長さ
  , [ "stem_bottom_shaft_chamfering_angle"  , 30.00 ] // [deg] ステム下部シャフトのC面取り角度
  , [ "stem_bottom_shaft_chamfering_length" ,  0.866025 ] // [mm] ステム下部シャフトのC面取り深さ (周辺の長さの計測と角度の目視推定から 0.5 / tan( 30 ) = 0.866025 と推定した )

  , [ "stem_skirt_height", [ 6.40, 5.75, 5.00 ] ] // [mm] ステージ上面からステム下部へ続くスカート構造の最下部までの長さ (端子に直接触れる出っ張り部分は除く) [ 側面部, 背面部, 側面部の厚みが僅かに変化するまでの高さ ]
  , [ "stem_skirt_thickness", [ 0.75, 0.80, 0.65 ] ] // [mm] ステージ上面からステム下部へ続くスカート構造の厚さ [ 側面部のX軸方向の厚さ, 背面部のY軸方向の厚さ, 側面下端部の厚さ(外側が僅かに薄くなる) ]
  , [ "stem_skirt_notch_length", 2.48 ] // [mm] ステージ上面からステム下部へ続くスカート構造の背面側の切り欠き部の長さ(X軸方向)

  //, [ "stem_craw_extruding_map" [] ]
  //, [ "stem_craw_electric_contact_avoider", [] ]
  , [ "stem_craw_tip_width", 0.40 ] // [mm] 爪の先端のY軸幅
  , [ "stem_craw_electric_contact_clearance", [ 5.5, 0.8 ] ] // [ ステージからの深さ(-Z) [mm], Y軸方向の幅 [mm] ]

  , [ "stem_rail_width", [ 2.2, 1.4 ] ] // [mm] ステム側面のハウジングレールとの噛み合わせ構造部の幅(Y軸方向長さ) [ 下部, 上部 ]
  , [ "stem_rail_thickness", 1.50 ] // [mm] ステム側面のハウジングレールとの噛み合わせ構造部の幅(X軸方向長さ)
  , [ "stem_rail_height", [ 4.35, 5.2 ] ] // [mm] ステム側面のハウジングレールとの噛み合わせ構造部の高さ [ 側面部, 中央部 ]
  , [ "stem_rail_chamfering_parameters", [ 0, 0.2, "R" ] ]

  //, [ "stem_skirt_splitted", false ] // true: ステムのスカート部分がステム本体から分離されるよう造形します(いわゆるクリッキー＆音の大きな青軸っぽくする), false: 分離しない一体化した造形にします
  //, [ "stem_skirt_color", [ ] ] // ステムのスカート部分の色をRGB値または空で設定。空にした場合は stem_color が自動的に採用されます

  , [ "housing_bottom_stem_hole_diameter", 2.00 ] // [mm] stem_bottom_shaft が挿さる穴
  
  , [ "stem_skirt_side_shrinking", true ] // true: スカート下部のX軸方向の幅の削りを有効にします(レンダーでの形状の再現性を優先), false: 無効にします(プレビューでのツメの凹構造の描画欠けの抑止を優先)

  ];
