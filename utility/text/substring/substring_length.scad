include <substring_range.scad>

function substring_length( text, begin, length ) =
  substring_range( text, begin, begin + length )
  ;