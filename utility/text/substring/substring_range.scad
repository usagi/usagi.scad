function substring_range( text, begin = 0, end = 0, buffer = "" ) = 
  let( end = end > begin ? end : begin )
    begin == end
      ? buffer
      : str( text[ begin ], substring_range( text, begin + 1, end, buffer ) )
  ;
