include <substring/substring_range.scad>
include <substring/substring_left.scad>
include <substring/substring_right.scad>
include <substring/substring_length.scad>

/// @brief substring_left/substring_right/substring_range の疑似オーバーロード
/// @note ( text, positive_length ) -> substring_left
///       ( text, negative_length ) -> substring_right
///       ( text, begin, end )      -> substring_range
function substring( text, length_or_begin = [ ], nothing_or_end = [ ] ) = 
  nothing_or_end != [ ]
    ? substring_range( text, length_or_begin, nothing_or_end )
    : length_or_begin < 0
      ? substring_right( text, -length_or_begin )
      : substring_left( text, length_or_begin )
  ;
