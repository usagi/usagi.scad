include <../angle/normalize_angle.scad>
include <../number/clamp.scad>

/// @param source [ Hue, Satulation, Lightness ]
/// @note Hue        の次元 = 角度 [deg]; [ 0 .. 360 )
///       Satulation の次元 = 無(比) [-]; [ 0 .. 1 ]
///       Lighenesss の次元 = 無(比) [-]; [ 0 .. 1 ]
/// @return [ Red, Green, Blue ]; 各要素の次元は無(比), 値域は [ 0 .. 1 ]
/// @note https://stackoverflow.com/a/9493060/1211392
function to_RGB_from_HSL( source ) = 
  let
  ( H = normalize_angle( source[ 0 ], 0, 360, true ) / 360
  , S = clamp( source[ 1 ], 0, 1 )
  , L = clamp( source[ 2 ], 0, 1 )
  , q = L < 0.5 ? L * ( 1 + S ) : L + S - L * S
  , p = 2 * L - q
  )
    S == 0
      ? [ L, L, L ]
      : [ to_RGB_from_HSL_detail( p, q, H + 1 / 3 )
        , to_RGB_from_HSL_detail( p, q, H         )
        , to_RGB_from_HSL_detail( p, q, H - 1 / 3 )
        ]
  ;

/// ユーザーが直接使用する事を想定していない to_RGB_from_HSL_detail から内部的に使用する実装詳細です
function to_RGB_from_HSL_detail( p, q, t ) = 
  let( t = t < 0 ? t + 1 : t )
    let( t = t > 1 ? t - 1 : t )
      t < 1 / 6
        ? p + ( q - p ) * 6 * t
        : t < 1 / 2
          ? q
          : t < 2 / 3
            ? p + ( q - p ) * ( 2 / 3 - t ) * 6
            : p
  ;
