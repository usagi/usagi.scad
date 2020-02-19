/// vector の部分 vector を取得
/// @param begin 取得したい部分 vector の先頭位置
/// @param end   取得したい部分 vector の終端位置
/// @param internal_buffer 内部バッファー ( 明示的に引数として与える必要はありません )
function slice_vector( v, begin = 0, end = 0, internal_buffer = [ ] ) = 
  let( end = end > begin ? end : begin )
    begin == end
      ? internal_buffer
      : concat( [ v[ begin ] ], slice_vector( v, begin + 1, end, internal_buffer ) )
  ;
