include <slice_vector.scad>

/// vector の末尾要素から length 個の要素を並び順のまま取得
function pop_vector_block( v, length = 0 ) = 
  let( end = len( v ) )
    slice_vector( v, end - length, end )
  ;