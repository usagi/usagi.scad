include <../geometry/chamfered_square.scad>

/// パイプ(=中空の丸棒部品)を内径と外径と長さから造形
/// @param inner_diameter 内径 [mm]
/// @param outer_diameter 外径 [mm]
/// @param length 長さ [mm]
// --- optional ---
/// @param chamfering_type 面取りタイプ (default="C")
///                          "C": 平面 (chamfering_angle,chamfering_lengthと合わせて使う)
///                          "R": 曲面 (chamfering_lengthが半径指定に変わります)
/// @param chamfering_angle 面取り角度(Y軸からX軸方向への開き角度) [deg]
/// @param chamfering_length 面取り長さ(Y軸食い込み長さ) [mm]
// --- optional for more details ---
/// @param inner_chamfering_angle 内径側の面取り角度(内径側と外径側で同じ設定を採用する場合は chamfering_angle のみ設定すればよい)
/// @param inner_chamfering_length 内径側の面取り長さ(内径側と外径側で同じ設定を採用する場合は chamfering_length のみ設定すればよい)
/// @param outer_chamfering_angle 外径側の面取り角度(内径側と外径側で同じ設定を採用する場合は chamfering_angle のみ設定すればよい)
/// @param outer_chamfering_length 外径側の面取り長さ(内径側と外径側で同じ設定を採用する場合は chamfering_length のみ設定すればよい)
module pipe
( inner_diameter
, outer_diameter
, length

// --- optional detail level-2 ( highest )
, chamfering_angle  = 45
, chamfering_length = 0
, chamfering_type   = "C"

// --- optional for detail level-1
, inner_chamfering_angle = [ ]
, outer_chamfering_angle = [ ]

, inner_chamfering_length  = [ ]
, outer_chamfering_length  = [ ]

, inner_chamfering_type  = [ ]
, outer_chamfering_type  = [ ]

// --- optional for detail level-0 ( lowest )
, inner_bottom_chamfering_angle = [ ]
, inner_top_chamfering_angle    = [ ]
, outer_bottom_chamfering_angle = [ ]
, outer_top_chamfering_angle    = [ ]

, inner_bottom_chamfering_length  = [ ]
, inner_top_chamfering_length     = [ ]
, outer_bottom_chamfering_length  = [ ]
, outer_top_chamfering_length     = [ ]

, inner_bottom_chamfering_type  = [ ]
, inner_top_chamfering_type     = [ ]
, outer_bottom_chamfering_type  = [ ]
, outer_top_chamfering_type     = [ ]

, center = false
)
{
  translate( [ 0, 0, center ? -length / 2 : 0 ] )
  rotate_extrude()
  translate( [ inner_diameter / 2, 0, 0 ] )
    chamfered_square
    ( [ ( outer_diameter - inner_diameter ) / 2
      , length
      ]
    
    // ここから面取りパラメーターの単純転送
    , chamfering_angle = chamfering_angle
    , chamfering_length = chamfering_length
    , chamfering_type = chamfering_type

    , inner_chamfering_angle = inner_chamfering_angle
    , outer_chamfering_angle = outer_chamfering_angle

    , inner_chamfering_length = inner_chamfering_length
    , outer_chamfering_length = outer_chamfering_length

    , inner_chamfering_type = inner_chamfering_type
    , outer_chamfering_type = outer_chamfering_type

    , inner_bottom_chamfering_angle = inner_bottom_chamfering_angle
    , inner_top_chamfering_angle =inner_top_chamfering_angle
    , outer_bottom_chamfering_angle = outer_bottom_chamfering_angle
    , outer_top_chamfering_angle = outer_top_chamfering_angle

    , inner_bottom_chamfering_length = inner_bottom_chamfering_length
    , inner_top_chamfering_length = inner_top_chamfering_length
    , outer_bottom_chamfering_length = outer_bottom_chamfering_length
    , outer_top_chamfering_length = outer_top_chamfering_length

    , inner_bottom_chamfering_type= inner_bottom_chamfering_type
    , inner_top_chamfering_type = inner_top_chamfering_type
    , outer_bottom_chamfering_type = outer_bottom_chamfering_type
    , outer_top_chamfering_type = outer_top_chamfering_type
    )
  ;
}
