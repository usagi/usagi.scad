include <slice_vector.scad>

/// vector の先頭から length 個の部分要素を取得
function shift_vector( v, length = 0 ) = 
  slice_vector( v, 0, length )
  ;