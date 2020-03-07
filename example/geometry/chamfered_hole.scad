include <../../geometry/chamfered_hole.scad>

$fs = 0.1;

difference()
{
  // 穴を開けたい対象
  translate( [ 0, -2.5, -2 ] )
    cube( [ 10, 5, 2 ] );

  // 立方体で開口部の面取り付きの穴(不貫通)
  translate( [ 2, 0, 0 ] )
    chamfered_hole( hole_size = [ 1, 2, 1 ], hole_type = "cube", apertural_angle = 120, apertural_length = 0.2, center = true );

  // 立方体で開口部の面取り付きの穴(貫通)
  translate( [ 4, 0, 0 ] )
    chamfered_hole( hole_size = [ 1, 2, 2 ], hole_type = "cube", apertural_angle = 120, apertural_length = 0.2, center = true, piercing = true );

  // 円筒形で開口部の面取り付きの穴(不貫通)
  translate( [ 6, 0, 0 ] )
    chamfered_hole( hole_size = [ 1, 1 ], hole_type = "cylinder", apertural_angle = 120, apertural_length = 0.2, center = true );

  // 円筒形で開口部の面取り付きの穴(貫通)
  translate( [ 8, 0, 0 ] )
    chamfered_hole( hole_size = [ 1, 2 ], hole_type = "cylinder", apertural_angle = 120, apertural_length = 0.2, center = true, piercing = true );

}
