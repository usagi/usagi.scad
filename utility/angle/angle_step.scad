include <distance_of_angle_range.scad>

/// OpenSCAD の circle と同様のアルゴリズムにより $fn, $fa, $fs から角度範囲のステップ角度[deg]を取得
function angle_step( radius, range = [ 0 : 360 ] ) = 
  let( drange = distance_of_angle_range( range ) )
    drange
      / ( $fn > 0
            ? ( $fn >= 3 ? $fn : 3)
            : ceil
              ( max
                ( min
                  ( drange / $fa
                  , radius * 2 * PI * drange / 360 / $fs
                  )
                , 5
                )
              )
        )
  ;

/// $fn のみから角度範囲のステップ角度を取得
function angle_step_fn( range = [ 0 : 360 ] ) = distance_of_range( range ) / $fn;

/// $fs のみから角度範囲のステップ角度を取得
function angle_step_fs( radius = 1, range = [ 0 : 360 ] ) = distance_of_range( range ) / asin( $fs / radius );
