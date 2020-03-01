include <pop_vector_block.scad>

/// vector(a) の vector(b) について最大の a[ index ] を取得
function max_element_of( vs, index = 0, current = [ ] ) = 
  let( l = len( vs ) )
    l == 0
      ? current
      : max_element_of
        ( pop_vector_block( vs, l - 1 )
        , index
        , current == [ ] || vs[ 0 ][ index ] > current ? vs[ 0 ][ index ] : current
        )
  ;
