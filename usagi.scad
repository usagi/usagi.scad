// --- このライブラリーの使い方 ---
// - 螺子っぽいものは `screw( diameter = 3, length = 5 )` のように呼び径と呼び長さのみ、あるいは他に追加で必要なパラメーターがあれば設定して呼び出して使用します。
// - ナットは `nut( diameter = 3 )` のように呼び径のみ、あるいは他に追加で必要なパラメーターがあれば設定して呼び出して使用します。
// - スペーサーは `spacer( diameter = 3 )` のように呼び径のみ、あるいは他に追加で必要なパラメーターがあれば設定して呼び出して使用します。
// それぞれの引数はモジュールの定義と doxy 風に付けたソースコードドキュメントから読み解いて下さい。
// ---------------------------

// ---------------------------
// ここから螺子が本体っぽいものを呼び径で生成する module
// ---------------------------

/// @brief 「ねじ」を呼び径、ピッチ、長さ、形状、分解能を指定して生成
/// @note JIS B { 1176, 1177, 1180: { 2004, 2014 } }
/// @param diameter 呼び径(螺子の螺子部分の直径。M2なら2,M2.5なら2.5,M8なら8の部分)
/// @param length   螺子部分の長さ
/// @param pitch    螺子ピッチ:=螺子山1周でネジ部分の長さ方向にどれだけ進むか
///                   default=0の場合は並目ピッチを自動的に採用します。
///                   細目や独自のピッチを指定したい場合のみ具体的に指定します。
/// @param type     螺子の種類
///                    -1: 寸切り(両端面取りなし/凸螺子山クリアランスなし; このタイプは"螺子穴を掘るための型"が必要な場合に使用する特殊なタイプです)
///                     0: 寸切り; flush cut bolt
///                     1: 六角穴付き止めねじ(平先)    ; hexagon socket set screw      (only available: M1.6/2/2.5/2/    4/5/6/8/10/12/   16/   20/   24)
///                     2: 六角穴付き止めねじ(とがり先); hexagon socket set screw      (only available: M1.6/2/2.5/2/    4/5/6/8/10/12/   16/   20/   24)
///                     3: 六角穴付き止めねじ(棒先)    ; hexagon socket set screw      (only available: M1.6/2/2.5/2/    4/5/6/8/10/12/   16/   20/   24)
///                     4: 六角穴付き止めねじ(くぼみ先); hexagon socket set screw      (only available: M1.6/2/2.5/2/    4/5/6/8/10/12/   16/   20/   24)
///                   100: 六角穴付き                ; hexagon socket head cap screw (only available: M1.6/2/2.5/3/    4/5/6/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/   64)
///                   200: 六角(JIS B 1180:2004)     ; hexagon head bolt             (only available: M1.6/2/2.5/3/3.5/4/5/6/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64)
///                   201: 六角(JIS B 1180:2014)     ; hexagon head bolt             (only available: M1.6/2/2.5/3/3.5/4/5/6/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64)
///                        note: このライブラリーで扱う六角ボルトの JIS B 1180 の 2004 -> 2014 の違いは
///                                (1) ワッシャーフェイス なし -> あり
///                                (2) M10/12/14/22 それぞれ二面幅が 1mm または 2mm 変更
///                              です。どちらを使うか迷ったら新しい 2014 版の規格を採用すればよいかもしれません。
/// @param resolution XY軸方向を基準とした分解能 [mm/XY-axis]
module screw( diameter, length, pitch = 0, type = 100, resolution = 0.05 )
{
  round_subdivision = calculate_round_subdivision( diameter, resolution );

  let( pitch = pitch == 0 ? get_screw_pitch_from_diameter( diameter ) : pitch )
  {
    angle = 60;
    root_clearance = calculate_root_clearance( pitch );
    if ( type == -1 )
      screw_thread( diameter, pitch, angle, length, root_clearance,  0,  0, true, resolution );
    else if ( type == 0 )
      screw_thread( diameter, pitch, angle, length, root_clearance, 45, 45, false, resolution );
    else if ( type >= 1 && type <= 4 )
      screw_hexagon_socket_set( diameter, length, pitch, type, angle, root_clearance, resolution, round_subdivision );
    else if ( type == 100 )
      screw_hexagon_socket_head_cap( diameter, length, pitch, type, angle, root_clearance, resolution, round_subdivision );
    else if ( type == 200 || type == 201 )
      screw_hexagon_head( diameter, length, pitch, type, angle, root_clearance, resolution, round_subdivision );
    else
      echo( str( "不明な type(=", type, ")で screw が呼び出されました。 screw の type の仕様を確認し、再設定して下さい。" ) );
  }
}

// ---------------------------
// ここからナットを生成する module
// ---------------------------

/// @brief 「ナット」を生成
/// @note JIS B 1181:2014
/// @param style        JIS B 1181:2014 で定義される「スタイル」による定義
///                        (2014系は全てワッシャーフェイス付き)
///                        1:=スタイル1=並高≃約0.9D (面取り指定省略時は両面取り)   ; M1.6/2/2.5/3/3.5/4/5/6/  8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64
///                        2:=スタイル2=高高≃約1.0D (面取り指定省略時は両面取り)   ; M        5/          6/  8/10/12/14/16/   20/   24/   30/   36
///                        3:=C                                                    ; M        5/          6/  8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64
///                        4:=低                                                   ; M1.6/2/2.5/3/3.5/4/5/6/  8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64
///                     または旧規格/附属書JAの「種」による定義
///                       (六角=旧規格の主系)
///                       -1:=六角/1種≃約0.8D/上部取り                             ; M    2/2.5/3/3.5/4/5/6/7/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64
///                       -2:=六角/2種≃約0.8D/両面取り                             ; M    2/2.5/3/3.5/4/5/6/7/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64
///                       -3:=六角/3種≃約0.6D/両面取り                             ; M    2/2.5/3/3.5/4/5/6/7/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64
///                       -4:=六角/4種≃約0.8D/上部面取り/下部ワッシャーフェイス    ; M                  5/6/7/8/10/12/14/16/18/20/22/24
///                       (小型六角=二面幅が狭い系)
///                       -5:=小型六角/1種≃約0.8D/上部取り                         ; M                        8/10/12/14/16/18/20/22/24/27/30/33/36/39
///                       -6:=小型六角/2種≃約0.8D/両面取り                         ; M                        8/10/12/14/16/18/20/22/24/27/30/33/36/39
///                       -7:=小型六角/3種≃約0.6D/両面取り                         ; M                        8/10/12/14/16/18/20/22/24/27/30/33/36/39
///                       -8:=小型六角/4種≃約0.8D/上部面取り/下部ワッシャーフェイス; M                        8/10/12/14/16/18/20/22/24
/// @top_chamfering     上部を面取りするか true/false ( style で旧規格を設定した場合は引数を与えても無効とし、規格を優先します )
/// @bottom_chamfering  下部を面取りするか true/false ( style で旧規格を設定した場合は引数を与えても無効とし、規格を優先します )
/// @has_washer_face    下部にワッシャーフェイスを持つか true/false ( style で旧規格を設定した場合は引数を与えても無効とし、規格を優先します )
/// @param pitch        螺子ピッチ:=螺子山1周でネジ部分の長さ方向にどれだけ進むか
///                       default=0の場合は並目ピッチを自動的に採用します。
///                       細目や独自のピッチを指定したい場合のみ具体的に指定します。
/// @param resolution   XY軸方向を基準とした分解能 [mm/XY-axis]
module nut
( diameter
, style = 1
, top_chamfering = true
, bottom_chamfering = true
, has_washer_face = false
, pitch = 0
, resolution = 0.05
)
{
  chamferings = nut_style_to_chamferings( style, top_chamfering, bottom_chamfering, has_washer_face );
  round_subdivision = calculate_round_subdivision( diameter, resolution );
  
  ps = get_JIS_B_1181_hex_nut_parameters( diameter, style );

  is_invalid_washer_face_settings = chamferings[ 2 ] && ( ps[ 2 ] == 0 || ps[ 3 ] == 0 );

  if ( ps == 0 || is_invalid_washer_face_settings )
  {
    // fatal
    nut_style_name = get_nut_style_name( style );
    nut_style_diameters = get_nut_style_diameters( style );
    echo( str( "注意: 指定された呼び径(", diameter, ")とスタイルID(", style ,";", nut_style_name ,")は JIS B 1181 では定義されていません。意図的に特別な螺子を設計したい場合は nut の実装詳細を覗いて my_nut モジュールを新たにお好みで作成するとよいかもしれません。" ) );
    echo( str( "参考: ", nut_style_name ," に含まれる呼び径は M", nut_style_diameters ," です。" ) );
    if ( is_invalid_washer_face_settings && style < 0 )
      echo( str( "参考: または、附属書規格ではなく本体規格では対応する全ての呼び径", get_nut_style_diameters( 1 ) ,"でワッシャーフェイスを使用可能です。" ) );
  }
  else
  {
    let( pitch = pitch == 0 ? get_screw_pitch_from_diameter( diameter ) : pitch )
      difference()
      {
        // ナット本体
        hex_head( ps[ 0 ], ps[ 1 ], chamferings[ 0 ] ? 30 : 0, chamferings[ 1 ] ? 30 : 0 );

        // 螺子型
        p = get_screw_pitch_from_diameter( diameter );
        translate( [ 0, 0, -pitch ] )
          screw( diameter, ps[ 1 ] + 2 * pitch, type = -1, pitch = pitch, resolution = resolution );
        
        if ( chamferings[ 2 ] )
          // ワッシャーフェイス
          washer_face( ps[ 3 ] / 2, ps[ 0 ] * 2, ps[ 2 ], round_subdivision );
        
        // インロー部面取り; 外側の面取り方式によらず穴は常に面取りする
        chamfer_hole( diameter, ps[ 1 ], 30, 30, 0.05, round_subdivision );
      }
  }
}

// ---------------------------
// ここからワッシャーを生成する module
// ---------------------------

/// @brief 「ワッシャー」を生成 
/// @note JIS B 1256:2008
/// @diameter 呼び径
/// @type     JIS B 1256:2008 で定義される「形」
///              0:小形/部品等級A                         ; M1.6/2/2.5/3/3.5/4/5/6/8/10/12/14/16/18/20/22/24/27/30/33/36
///              1:並形/部品等級A (新JIS/みがき丸) default; M1.6/2/2.5/3/3.5/4/5/6/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64
///              2:並形面取り/部品等級A                   ; M                  5/6/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64
///              3:並形/部品等級C                         ; M1.6/2/2.5/3/3.5/4/5/6/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64
///              4:大形/部品等級A                         ; M          3/3.5/4/5/6/8/10/12/14/16/18/20/22/24/27/30/33/36
///              5:大形/部品等級C                         ; M          3/3.5/4/5/6/8/10/12/14/16/18/20/22/24/27/30/33/36
///              6:特大形/部品等級C                       ; M                  5/6/8/10/12/14/16/18/20/22/24/27/30/33/36
///             -1:附属書JA/小形角                        ; M                    6/8/10/12/14/16/18/20/22/24/27
///             -2:附属書JA/大形角                        ; M                    6/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52
/// @param resolution XY軸方向を基準とした分解能 [mm/XY-axis]
module washer( diameter, type = 1, resolution = 0.05 )
{
  round_subdivision = calculate_round_subdivision( diameter, resolution );
  
  ps = get_JIS_B_1256_hex_nut_parameters( diameter, type );

  if ( ps == 0 )
  {
    // fatal
    washer_style_name = get_washer_style_name( type );
    washer_style_diameters = get_washer_style_diameters( type );
    echo( str( "注意: 指定された呼び径(", diameter, ")と形ID(", type ,";", washer_style_name ,")は JIS B 1256 では定義されていません。意図的に特別な螺子を設計したい場合は washer の実装詳細を覗いて my_washer モジュールを新たにお好みで作成するとよいかもしれません。" ) );
    echo( str( "参考: ", washer_style_name ," に含まれる呼び径は M", washer_style_diameters ," です。" ) );
  }
  else
  {
    if ( type == -1 || type == -2 )
      difference()
      {
        translate( [ 0, 0, ps[ 2 ] / 2 ] )
          cube( size = [ ps[ 1 ], ps[ 1 ], ps[2] ], center = true );
        cylinder( d = ps[ 0 ], h = ps[ 2 ] * 10, $fn = round_subdivision, center = true );
      }
    else
    {
      if ( type == 2 )
        rotate_extrude( convexity = 10, $fn = round_subdivision )
          polygon( [ [ ps[ 0 ] / 2, 0 ], [ ps[ 1 ] / 2, 0 ], [ ps[ 1 ] / 2, ps[ 2 ] / 2 ], [ ps[ 1 ] / 2 - ps[ 2 ] / 2, ps[ 2 ] ], [ ps[ 0 ] / 2, ps[ 2 ] ] ] );
      else
        rotate_extrude( convexity = 10, $fn = round_subdivision )
          polygon( [ [ ps[ 0 ] / 2, 0 ], [ ps[ 1 ] / 2, 0 ], [ ps[ 1 ] / 2, ps[ 2 ] ], [ ps[ 0 ] / 2, ps[ 2 ] ] ] );
    }
  }
}

// ---------------------------
// ここからスペーサーを生成する module
// ---------------------------

/// @brief 「スペーサー」を生成
/// @note JIS 規格は無いので必要に応じてユーザーの設定した値から JIS B 1180:2014 など相当する screw 系の数値を参照して造形します
// --- 使い方の例 ---
//   上下ともに凸螺子 M2 長さ 4mm        の 六角スペーサー 胴体 M2 六角ヘッド相当 長さ 3mm: spacer( 2, 3, 4, 4 )
//   貫通穴 M2                           の 丸スペーサー   胴体外径 ⌀ 4mm 長さ 3mm        : spacer( 2, 3, -3, body_outer_dimeter = 4, top_screw_pitch = -1 )
//   上凸 M2 長さ 2mm, 下凹 M3 長さ 2mm  の 六角スペーサー 胴体 六角二面幅 5.5mm 長さ 3mm : spacer( top_diameter = 2, bottom_diameter = 3, top_length = 2, bottom_length = -2, body_length = 3, body_dihedral_length = 5.5 )
//   上凹 M1.6 長さ 2mm, 下平底          の 八角足         胴体外径 ⌀ 8mm 長さ 3mm        : spacer( 1.6, 3, -2, body_outer_diameter = 8, body_round_resolution = 8 )
//   上凹 M1.6 長さ 2mm, 下平底          の 立方体足       胴体外径 ⌀ 4*sqrt(2)mm 長さ 4mm: spacer( 1.6, 4, -2, body_outer_diameter = 4 * sqrt( 2 ), body_round_resolution = 4 )
// ---
/// @param diameter               呼び径 ( top_diameter, bottom_diameter を同じ値にしたい場合に使用)
/// @param body_length            胴部分の長さ
/// @param top_sctew_length       上部螺子部分の長さ ( 0->螺子なし、正の値->凸螺子、負の値->凹螺子を造形します )
/// @param bottom_sctew_length    下部螺子部分の長さ ( 0->螺子なし、正の値->凸螺子、負の値->凹螺子を造形します )
// --- ↓何れか1つを設定 ---
/// @param body_hexagon_dihedral_length 胴部分を六角形にする場合の二面幅 ( 省略時 = max( top_diameter, bottom_diameter ) の呼び径の JIS B 1180:2014 六角ボルトの頭部の二面幅を自動的に採用 )
/// @param body_round_diameter          胴部分を丸または外接円の直径を基準とした多角形にする場合の直径 ( 省略時 = body_hexagon_dihedral_length を優先 )
// --- ↓詳細設定用オプション (すべて省略可) ---
/// @param top_diameter           上側の呼び径 (省略時は diameter)
/// @param bottom_diameter        下側の呼び径 (省略時は diameter)
/// @param body_round_resolution  胴部分の周方向の多角形分解能
///                                 省略時 ( body_hexagon_dihedral_length が有効な場合 ) -> 6
///                                 省略時 ( body_round_diameter が有効な場合 ) -> resolution を基準とした相当する周方向の分解能 ( resolution が大きすぎなければ円形になります )
/// @param top_screw_pitch        上側の螺子ピッチ (省略時は top_diameter に対応する並目ピッチを自動的に採用, < 0 の場合は螺子山を作らず円形の穴または円柱形の棒を造形)
/// @param bottom_screw_pitch     下側の螺子ピッチ (省略時は top_diameter に対応する並目ピッチを自動的に採用, < 0 の場合は螺子山を作らず円形の穴または円柱形の棒を造形)
/// @top_chamfering_angle         上側の面取り角度 (省略時は 0 = 面取りなし)
/// @bottom_chamfering_angle      下側の面取り角度 (省略時は 0 = 面取りなし)
/// @param resolution             XY軸方向を基準とした分解能 [mm/XY-axis]
module spacer
( diameter = 0
, body_length = 0
, top_screw_length = 0
, bottom_screw_length = 0
, body_dihedral_length = 0
, body_outer_diameter = 0
, top_diameter = 0
, bottom_diameter = 0
, body_round_resolution = 0
, top_screw_pitch = 0
, bottom_screw_pitch = 0
, top_chamfering_angle = 0
, bottom_chamfering_angle = 0
, resolution = 0.05
)
{
  let
  ( top_diameter        = top_diameter        == 0 ? diameter : top_diameter
  , bottom_diameter     = bottom_diameter     == 0 ? diameter : bottom_diameter
  , top_screw_pitch     = top_screw_pitch     == 0 ? get_screw_pitch_from_diameter( top_diameter )    : top_screw_pitch
  , bottom_screw_pitch  = bottom_screw_pitch  == 0 ? get_screw_pitch_from_diameter( bottom_diameter ) : bottom_screw_pitch
  )
  {
    max_diameter = max( top_diameter, bottom_diameter );
    round_subdivision = calculate_round_subdivision( max_diameter, resolution );

    union()
    {
      difference()
      {
        // 胴部分
        translate( [ 0, 0, bottom_screw_length > 0 ? bottom_screw_length : 0 ] )
        {
          if ( body_outer_diameter > 0 )
            intersection()
            {
              cylinder( h = body_length, d = body_outer_diameter, $fn = body_round_resolution == 0 ? round_subdivision : body_round_resolution );
              r = body_outer_diameter / 2;
              cylinder_chamferer( r, r * 0.90, body_length, top_chamfering_angle, bottom_chamfering_angle, round_subdivision );
            }
          else
          {
            ps = get_JIS_B_1180_hexagon_head_parameters( max_diameter );
            if ( body_dihedral_length == 0 && ps == 0 )
              echo
              ( str
                ( "spacer は body_dihedral_length を自動設定しようと試みましたが"
                , " JIS B 1180 に相当する呼び径(", max_diameter, " = max(top_diameter=", top_diameter, ",bottom_diameter=", bottom_diameter,"))"
                , "の定義が無いためスペーサーの胴部分を造形できません。 body_dihedral_length を直接設定するか、"
                , " top_diameter と bottom_diameter のうち最大の直径を JIS B 1180 の呼び径に一致させて下さい。"
                )
              );
            let
            ( body_dihedral_length = 
                body_dihedral_length > 0
                  ? body_dihedral_length
                  : ps[ 1 ]
            )
              hex_head( body_dihedral_length, body_length, top_chamfering_angle, bottom_chamfering_angle, round_subdivision );
          }
        }

        // 凹上
        if ( top_screw_length < 0 )
        {
          angle = 60;
          root_clearance = calculate_root_clearance( top_screw_pitch );
          translate( [ 0, 0, body_length + max( 0, bottom_screw_length ) + top_screw_length -1.0e-3 ] )
          {
            // 穴
            screw_thread( top_diameter, top_screw_pitch, angle, -top_screw_length + 2.0e-3, root_clearance, 0, 0, true, resolution );
            // インロー部の面取り
            chamfer_hole( top_diameter, -top_screw_length, 30, 0, 0.05, round_subdivision );
          }
        }

        // 凹下
        if ( bottom_screw_length < 0 )
        {
          angle = 60;
          root_clearance = calculate_root_clearance( bottom_screw_pitch );
          // 穴
          translate( [ 0, 0, -1.0e-3 ] )
          screw_thread( bottom_diameter, bottom_screw_pitch, angle, -bottom_screw_length + 2.0e-3, root_clearance, 0, 0, true, resolution );
          // インロー部の面取り
          chamfer_hole( bottom_diameter, -bottom_screw_length, 0, 30, 0.05, round_subdivision );
        }

      }

      // 凸上
      if ( top_screw_length > 0 )
      {
        angle = 60;
        root_clearance = calculate_root_clearance( top_screw_pitch );
        translate( [ 0, 0, body_length + max( 0, bottom_screw_length ) ] )
          screw_thread( top_diameter, top_screw_pitch, angle, top_screw_length, root_clearance, 45, 0, false, resolution );
      }

      // 凸下
      if ( bottom_screw_length > 0 )
      {
        angle = 60;
        root_clearance = calculate_root_clearance( bottom_screw_pitch );
        screw_thread( bottom_diameter, bottom_screw_pitch, angle, bottom_screw_length, root_clearance, 0, 45, false, resolution );
      }
    }
  }
}

// ------------------------------------------------------------------------------------------------
// ここから先はマニアックな使い方をしたい場合にどうぞ。たいていの場合は直接ユーザーコードで使用する必要はないかもな部分です。
// ------------------------------------------------------------------------------------------------

/// @brief メートル螺子の尖り山の高さ H [mm] を pitch [mm] から計算
function calculate_H( pitch ) = sqrt( 3 ) / 2 * pitch;

/// @brief メートル螺子の有効径 D2 [mm] を 呼び径 diameter [mm] と pitch [mm] から計算
function calculate_D2( diameter, pitch ) = diameter - 2 * 3 / 8 * calculate_H( pitch );

/// @brief 凸螺子の谷底隙間
function calculate_root_clearance( pitch ) = calculate_H( pitch ) / 4;

/// @brief 凹螺子の谷底隙間
function calculate_bottom_clearance( pitch ) = calculate_H( pitch ) / 8;
function calculate_bottom_clearance_reversed( pitch ) = calculate_bottom_clearance( pitch ) * 7;

/// @brief 六角の2面幅から外接円の直径を計算
function calculate_circumcircle_diameter( dihedral_length ) = dihedral_length / cos( 30 );

/// @brief 円周の分解能を計算
function calculate_round_subdivision( diameter, resolution ) = floor( PI * diameter / resolution );

/// @brief 螺子の呼び径に対応したピッチ(並目)を取得
/// @return ピッチ(並目) または 0 (定義の存在しない呼び径の場合)
function get_screw_pitch_from_diameter( diameter ) =
  diameter ==   1   ? 0.25 :
  diameter ==   1.1 ? 0.25 :
  diameter ==   1.2 ? 0.25 :
  diameter ==   1.4 ? 0.3 :
  diameter ==   1.6 ? 0.35 :
  diameter ==   1.8 ? 0.35 :
  diameter ==   2   ? 0.4 :
  diameter ==   2.2 ? 0.45 :
  diameter ==   2.5 ? 0.45 :
  diameter ==   3   ? 0.5 :
  diameter ==   3.5 ? 0.6 :
  diameter ==   4   ? 0.7 :
  diameter ==   4.5 ? 0.75 :
  diameter ==   5   ? 0.8 :
  diameter ==   6   ? 1 :
  diameter ==   7   ? 1 :
  diameter ==   8   ? 1.25 :
  diameter ==   9   ? 1.25 :
  diameter ==  10   ? 1.5 :
  diameter ==  11   ? 1.5 :
  diameter ==  12   ? 1.75 :
  diameter ==  14   ? 2 :
  diameter ==  16   ? 2 :
  diameter ==  18   ? 2.5 :
  diameter ==  20   ? 2.5 :
  diameter ==  22   ? 2.5 :
  diameter ==  24   ? 3 :
  diameter ==  27   ? 3 :
  diameter ==  30   ? 3.5 :
  diameter ==  33   ? 3.5 :
  diameter ==  36   ? 4 :
  diameter ==  39   ? 4 :
  diameter ==  42   ? 4.5 :
  diameter ==  45   ? 4.5 :
  diameter ==  48   ? 5 :
  diameter ==  52   ? 5 :
  diameter ==  56   ? 5.5 :
  diameter ==  60   ? 5.5 :
  diameter ==  68   ? 6 :
  diameter ==  70   ? 6 :
  diameter ==  72   ? 6 :
  diameter ==  76   ? 6 :
  diameter ==  80   ? 6 :
  diameter ==  85   ? 6 :
  diameter ==  90   ? 6 :
  diameter ==  95   ? 6 :
  diameter == 100   ? 6 :
  diameter == 105   ? 6 :
  diameter == 110   ? 6 :
  diameter == 115   ? 6 :
  diameter == 120   ? 6 :
  diameter == 125   ? 8 :
  diameter == 130   ? 8 :
  diameter == 140   ? 8 :
  diameter == 150   ? 8 :
  diameter == 160   ? 8 :
  diameter == 170   ? 8 :
  diameter == 180   ? 8 :
  diameter == 190   ? 8 :
  diameter == 200   ? 8 :
  diameter == 210   ? 8 :
  diameter == 220   ? 8 :
  diameter == 230   ? 8 :
  diameter == 240   ? 8 :
  diameter == 250   ? 8 :
  diameter == 260   ? 8 :
  diameter == 270   ? 8 :
  diameter == 280   ? 8 :
  diameter == 290   ? 8 :
  diameter == 300   ? 8 :
  0
  ;

/// @brief 六角穴付きボルトの呼び径(M2とか)に対するISO/JIS規格で定義された造形用パラメーターを取得
/// @return [ 0:頭部の高さ, 1:頭部の直径, 2:六角穴の二面幅, 3:六角穴の深さ, 4:[ 細目ピッチ(1), 細目ピッチ(2), ... ], 5:[ 呼び長さ(1), ... ] ]
///         または 0 (定義が存在しない場合)
function get_JIS_B_1176_hexagon_socket_head_cap_parameters( diameter ) = 
  //           d       [0]   [1]   [2]   [3]   [4]            [5]
  diameter ==  1.6 ? [  1.6,  3  ,  1.5,  0.7, [ ]          , [ 2.5, 3, 4, 5, 6, 8, 10, 12, 16 ] ] :
  diameter ==  2   ? [  2  ,  3.8,  1.5,  1  , [ ]          , [ 3, 4, 5, 6, 8, 10, 12, 16, 20 ] ] :
  diameter ==  2.5 ? [  2.5,  4.5,  2  ,  1.1, [ ]          , [ 4, 5, 6, 8, 10, 12, 16, 20, 25 ] ] :
  diameter ==  3   ? [  3  ,  5.5,  2.5,  1.3, [ ]          , [ 5, 6, 8, 10, 12, 16, 20, 25, 30 ] ] :
  diameter ==  4   ? [  4  ,  7  ,  3  ,  2  , [ ]          , [ 6, 8, 10, 12, 16, 20, 25, 30, 35, 40 ] ] :
  diameter ==  5   ? [  5  ,  8.5,  4  ,  2.5, [ ]          , [ 8, 10, 12, 16, 20, 25, 30, 35, 40, 45, 50 ] ] :
  diameter ==  6   ? [  6  , 10  ,  5  ,  3  , [ ]          , [ 10, 12, 16, 20, 25, 30, 35, 40, 45, 50, 55, 60 ] ] :
  diameter ==  8   ? [  8  , 13  ,  6  ,  4  , [ 1 ]        , [ 12, 16, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 80 ] ] :
  diameter == 10   ? [ 10  , 16  ,  8  ,  5  , [ 1, 1.25 ]  , [ 16, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 80, 90, 100 ] ] :
  diameter == 12   ? [ 12  , 18  , 10  ,  6  , [ 1.5, 1.25 ], [ 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 80, 90, 100, 110, 120 ] ] :
  diameter == 14   ? [ 14  , 21  , 12  ,  7  , [ 1.5 ]      , [ 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 80, 90, 100, 110, 120, 130, 140 ] ] :
  diameter == 16   ? [ 16  , 24  , 14  ,  8  , [ 1.5 ]      , [ 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160 ] ] :
  diameter == 20   ? [ 20  , 30  , 17  , 10  , [ 1.5, 2 ]   , [ 30, 35, 40, 45, 50, 55, 60, 65, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 180, 200 ] ] :
  diameter == 24   ? [ 24  , 36  , 19  , 12  , [ 2 ]        , [ 40, 45, 50, 55, 60, 65, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 180, 200 ] ] :
  diameter == 30   ? [ 30  , 45  , 22  , 15  , [ 2 ]        , [ 45, 50, 55, 60, 65, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 180, 200 ] ] :
  diameter == 36   ? [ 36  , 54  , 27  , 19  , [ 3 ]        , [ 55, 60, 65, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 180, 200 ] ] :
  diameter == 42   ? [ 42  , 63  , 32  , 24  , [ ]          , [ 60, 65, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 180, 200, 220, 240, 260, 280, 300 ] ] :
  diameter == 48   ? [ 48  , 72  , 36  , 28  , [ ]          , [ 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 180, 200, 220, 240, 260, 280, 300 ] ] :
  diameter == 56   ? [ 56  , 84  , 41  , 34  , [ ]          , [ 80, 90, 100, 110, 120, 130, 140, 150, 160, 180, 200, 220, 240, 260, 280, 300] ] :
  diameter == 64   ? [ 64  , 96  , 46  , 38  , [ ]          , [ 90, 100, 110, 120, 130, 140, 150, 160, 180, 200, 220, 240, 260, 280, 300] ] :
  0
  ;

/// @brief 六角穴付き止めねじの呼び径(M2とか)に対するISO/JIS規格に定義された造形用パラメーターを取得
/// @param diameter 呼び径
/// @param length   螺子の長さ
/// @return [ 0:六角穴の二面幅, 1:六角穴の深さ, 2:上部の面取り角度, 3:[ 尖り先/内径, 尖り先/角度 ], 4:[ 棒先/内径, 棒先長さ ], 5: [ 呼び長さ(1), ... ] ]
///         または 0 (定義が存在しない場合)
function get_JIS_B_1177_hexagon_socket_set_parameters( diameter, length ) = 
  //                  [0]  [1]                          [2]                       [3]                                  [4]                                       [5]
  diameter == 1.6 ? [ 0.7, length <= 2   ?  0.7 :  1.5, length <= 2   ? 120 : 90, [ 0.4 , length <=  2.5 ? 120 : 90 ], [  0.80, length <=  2.5 ? 0.40 :  0.80 ], [ 2, 2.5, 3, 4, 5, 6, 8 ] ]:
  diameter == 2   ? [ 0.9, length <= 2.5 ?  0.8 :  1.7, length <= 2.5 ? 120 : 90, [ 0.5 , length <=  3   ? 120 : 90 ], [  1.00, length <=  3   ? 0.50 :  1.00 ], [ 2, 2.5, 3, 4, 5, 6, 8, 10 ] ]:
  diameter == 2.5 ? [ 1.3, length <= 3   ?  1.2 :  2  , length <= 3   ? 120 : 90, [ 0.65, length <=  3   ? 120 : 90 ], [  1.50, length <=  4   ? 0.63 :  1.25 ], [ 2.5, 3, 4, 5, 6, 8, 10, 12 ] ]:
  diameter == 3   ? [ 1.5, length <= 4   ?  1.2 :  2  , length <= 4   ? 120 : 90, [ 0.75, length <=  4   ? 120 : 90 ], [  2.00, length <=  5   ? 0.75 :  1.50 ], [ 3, 4, 5, 6, 8, 10, 12, 16 ] ]:
  diameter == 4   ? [ 2  , length <= 5   ?  1.5 :  2.5, length <= 5   ? 120 : 90, [ 1   , length <=  5   ? 120 : 90 ], [  2.50, length <=  6   ? 1.00 :  2.00 ], [ 4, 5, 6, 8, 10, 12, 16, 20 ] ]:
  diameter == 5   ? [ 2.5, length <= 5   ?  2   :  3  , length <= 5   ? 120 : 90, [ 1.25, length <=  6   ? 120 : 90 ], [  3.5 , length <=  6   ? 1.25 :  2.00 ], [ 5, 6, 8, 10, 12, 16, 20, 25 ] ]:
  diameter == 6   ? [ 3  , length <= 6   ?  2   :  3.5, length <= 6   ? 120 : 90, [ 1.5 , length <=  6   ? 120 : 90 ], [  4.0 , length <=  8   ? 1.50 :  3.00 ], [ 6, 8, 10, 12, 16, 20, 25, 30 ] ]:
  diameter == 8   ? [ 4  , length <= 8   ?  3   :  5  , length <= 8   ? 120 : 90, [ 2   , length <=  8   ? 120 : 90 ], [  5.5 , length <= 10   ? 2.00 :  4.0  ], [ 8, 10, 12, 16, 20, 25, 30, 35, 40 ] ]:
  diameter == 10  ? [ 5  , length <= 10  ?  4   :  6  , length <= 10  ? 120 : 90, [ 2.5 , length <= 10   ? 120 : 90 ], [  7.00, length <= 12   ? 2.50 :  5.0  ], [ 10, 12, 16, 20, 25, 30, 35, 40, 45, 50 ] ]:
  diameter == 12  ? [ 6  , length <= 12  ?  4.8 :  8  , length <= 12  ? 120 : 90, [ 3   , length <= 12   ? 120 : 90 ], [  8.50, length <= 16   ? 3.00 :  6.0  ], [ 12, 16, 20, 25, 30, 35, 40, 45, 50, 55, 60 ] ]:
  diameter == 16  ? [ 8  , length <= 16  ?  6.4 : 10  , length <= 16  ? 120 : 90, [ 4   , length <= 16   ? 120 : 90 ], [ 12.00, length <= 20   ? 4.0  :  8.00 ], [ 16, 20, 25, 30, 35, 40, 45, 50, 55, 60 ] ]:
  diameter == 20  ? [ 10 , length <= 20  ?  8   : 12  , length <= 20  ? 120 : 90, [ 5   , length <= 20   ? 120 : 90 ], [ 15.00, length <= 25   ? 5.0  : 10.00 ], [ 20, 25, 30, 35, 40, 45, 50, 55, 60 ] ]:
  diameter == 24  ? [ 12 , length <= 25  ? 10   : 15  , length <= 25  ? 120 : 90, [ 6   , length <= 25   ? 120 : 90 ], [ 18.00, length <= 30   ? 6.0  : 12.00 ], [ 25, 30, 35, 40, 45, 50, 55, 60 ] ]:
  0
  ;

/// @brief  六角ボルトの呼び径(M2とか)に対するISO/JIS規格で定義された造形用パラメーターを取得
/// @return [ 0:頭部の高さ, 1:頭部の二面幅, 2:ワッシャーフェイスの高さ, 3:ワッシャーフェイスの直径, 4:[ 細目ピッチ(1), ... ], 5:[呼び長さ(1), ... ] ]
///         または 0 (定義が存在しない場合)
function get_JIS_B_1180_hexagon_head_parameters( diameter, version = 2014 ) =
  //                   [0]  [1]                           [2]   [3]   [4]            [5]
  diameter ==  1.6 ? [  1.1,                         3.2, 0.25,  2  , [           ], [ 2, 3, 4, 5, 6, 8, 10, 12, 16 ] ] :
  diameter ==  2   ? [  1.4,                         4  , 0.25,  2.6, [           ], [ 4, 5, 6, 8, 10, 12, 16, 20 ] ] :
  diameter ==  2.5 ? [  1.7,                         5  , 0.25,  3.1, [           ], [ 5, 6, 8, 10, 12, 16, 20, 25 ] ] :
  diameter ==  3   ? [  2  ,                         5.5, 0.4 ,  3.6, [           ], [ 6, 8, 10, 12, 16, 20, 25, 30 ] ] :
  diameter ==  3.5 ? [  2.4,                         6  , 0.4 ,  4.1, [           ], [ 8, 10, 12, 16, 20, 25, 30, 35 ] ] :
  diameter ==  4   ? [  2.8,                         7  , 0.4 ,  4.7, [           ], [ 8, 10, 12, 16, 20, 25, 30, 35, 40 ] ] :
  diameter ==  5   ? [  3.5,                         8  , 0.5 ,  5.7, [           ], [ 10, 12, 16, 20, 25, 30, 35, 40, 45, 50 ] ] :
  diameter ==  6   ? [  4  ,                        10  , 0.5 ,  6.8, [           ], [ 12, 16, 20, 25, 30, 35, 40, 45, 50, 55, 60 ] ] :
  diameter ==  8   ? [  5.5,                        13  , 0.6 ,  9.2, [ 1         ], [ 16, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 80 ] ] :
  diameter == 10   ? [  7  , version >= 2014 ? 16 : 17  , 0.6 , 11.2, [ 1, 1.25   ], [ 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 80, 90, 100 ] ] :
  diameter == 12   ? [  8  , version >= 2014 ? 18 : 19  , 0.6 , 13.7, [ 1.5, 1.25 ], [ 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 80, 90, 100, 110, 120 ] ] :
  diameter == 14   ? [  9  , version >= 2014 ? 21 : 22  , 0.6 , 15.7, [ 1.5       ], [ 30, 35, 40, 45, 50, 55, 60, 65, 70, 80, 90, 100, 110, 120, 130, 140 ] ] :
  diameter == 16   ? [ 10  ,                        24  , 0.8 , 17.7, [ 1.5       ], [ 30, 35, 40, 45, 50, 55, 60, 65, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200 ] ] :
  diameter == 18   ? [ 12  ,                        27  , 0.8 , 20.2, [ 1.5       ], [ 35, 40, 45, 50, 55, 60, 65, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200 ] ] :
  diameter == 20   ? [ 13  ,                        30  , 0.8 , 22.4, [ 1.5, 2    ], [ 40, 45, 50, 55, 60, 65, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200 ] ] :
  diameter == 22   ? [ 14  , version >= 2014 ? 34 : 32  , 0.8 , 24.4, [ 1.5       ], [ 45, 50, 55, 60, 65, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200 ] ] :
  diameter == 24   ? [ 15  ,                        36  , 0.8 , 26.4, [ 2         ], [ 50, 55, 60, 65, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200 ] ] :
  diameter == 27   ? [ 17  ,                        41  , 0.8 , 30.4, [ 2         ], [ 55, 60, 65, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200 ] ] :
  diameter == 30   ? [ 19  ,                        46  , 0.8 , 33.4, [ 2         ], [ 60, 65, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200 ] ] :
  diameter == 33   ? [ 21  ,                        50  , 0.8 , 36.4, [ 2         ], [ 65, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200 ] ] :
  diameter == 36   ? [ 23  ,                        55  , 0.8 , 39.4, [ 3         ], [ 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200 ] ] :
  diameter == 39   ? [ 25  ,                        60  , 1   , 42.4, [ 3         ], [ 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200 ] ] :
  diameter == 42   ? [ 26  ,                        65  , 1   , 45.6, [ 3         ], [ 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200 ] ] :
  diameter == 45   ? [ 28  ,                        70  , 1   , 48.6, [ 3         ], [ 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200 ] ] :
  diameter == 48   ? [ 30  ,                        75  , 1   , 52.6, [ 3         ], [ 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200 ] ] :
  diameter == 52   ? [ 33  ,                        80  , 1   , 56.6, [ 4         ], [ 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200 ] ] :
  diameter == 56   ? [ 35  ,                        85  , 1   , 63  , [ 4         ], [ 110, 120, 130, 140, 150, 160, 170, 180, 190, 200 ] ] :
  diameter == 60   ? [ 38  ,                        90  , 1   , 67  , [ 4         ], [ 120, 130, 140, 150, 160, 170, 180, 190, 200 ] ] :
  diameter == 64   ? [ 40  ,                        95  , 1   , 71  , [ 4         ], [ 120, 130, 140, 150, 160, 170, 180, 190, 200 ] ] :
  0
  ;

/// @return [ 0:二面幅, 1:高さ, 2:ワッシャーフェイス許容高さ, 3:ワッシャーフェイス直径, 4:[ 細目(1), ... ] ]
///         または 0 (定義が存在しない場合)
function get_JIS_B_1181_hex_nut_parameters( diameter, style = 1 ) = 
  ( style <= -5 && style >= -8 ) ?
  ( // 附属書JA/小型六角/1種,2種,3種(低),4種(ワッシャーフェイス)
    diameter ==  8   ? [ 12, style == -7 ?  5   :  6.5, style == -8 ? 0.6 : 0, style == -8 ? 11.6 : 0, [ 1 ]    ] :
    diameter == 10   ? [ 14, style == -7 ?  6   :  8  , style == -8 ? 0.6 : 0, style == -8 ? 14.6 : 0, [ 1.25 ] ] :
    diameter == 12   ? [ 17, style == -7 ?  7   : 10  , style == -8 ? 0.6 : 0, style == -8 ? 16.6 : 0, [ 1.25 ] ] :
    diameter == 14   ? [ 19, style == -7 ?  8   : 11  , style == -8 ? 0.6 : 0, style == -8 ? 19.6 : 0, [ 1.5 ]  ] :
    diameter == 16   ? [ 22, style == -7 ? 10   : 13  , style == -8 ? 0.8 : 0, style == -8 ? 22.5 : 0, [ 1.5 ]  ] :
    diameter == 18   ? [ 24, style == -7 ? 11   : 15  , style == -8 ? 0.8 : 0, style == -8 ? 24.9 : 0, [ 1.5 ]  ] :
    diameter == 20   ? [ 27, style == -7 ? 12   : 16  , style == -8 ? 0.8 : 0, style == -8 ? 27.7 : 0, [ 1.5 ]  ] :
    diameter == 22   ? [ 30, style == -7 ? 13   : 18  , style == -8 ? 0.8 : 0, style == -8 ? 31.4 : 0, [ 1.5 ]  ] :
    diameter == 24   ? [ 32, style == -7 ? 14   : 19  , style == -8 ? 0.8 : 0, style == -8 ? 33.3 : 0, [ 2 ]    ] :
    diameter == 27   ? [ 36, style == -7 ? 16   : 22  ,                     0,                      0, [ 2 ]    ] :
    diameter == 30   ? [ 41, style == -7 ? 18   : 24  ,                     0,                      0, [ 2 ]    ] :
    diameter == 33   ? [ 46, style == -7 ? 20   : 26  ,                     0,                      0, [ 2 ]    ] :
    diameter == 36   ? [ 50, style == -7 ? 21   : 29  ,                     0,                      0, [ 3 ]    ] :
    diameter == 39   ? [ 55, style == -7 ? 23   : 31  ,                     0,                      0, [ 3 ]    ] :
    0
  ) :
  ( style <= -1 && style >= -4 ) ?
  ( // 附属書JA/1種,2種,3種(低),4種(ワッシャーフェイス)
    diameter ==  2   ? [  4, style == -3 ?  1.2 :  1.6,                     0,                      0, [  ]     ] :
    diameter ==  2.5 ? [  5, style == -3 ?  1.6 :  2  ,                     0,                      0, [  ]     ] :
    diameter ==  3   ? [  5, style == -3 ?  1.8 :  2.4,                     0,                      0, [  ]     ] :
    diameter ==  3.5 ? [  6, style == -3 ?  2   :  2.8,                     0,                      0, [  ]     ] :
    diameter ==  4   ? [  7, style == -3 ?  2.4 :  3.2,                     0,                      0, [  ]     ] :
    diameter ==  5   ? [  8, style == -3 ?  3.2 :  4  , style == -4 ? 0.5 : 0, style == -4 ?  6.9 : 0, [  ]     ] :
    diameter ==  6   ? [ 10, style == -3 ?  3.6 :  5  , style == -4 ? 0.5 : 0, style == -4 ?  8.9 : 0, [  ]     ] :
    diameter ==  7   ? [ 11, style == -3 ?  4.2 :  5.5, style == -4 ? 0.5 : 0, style == -4 ?  8.9 : 0, [  ]     ] :
    diameter ==  8   ? [ 13, style == -3 ?  5   :  6.5, style == -4 ? 0.6 : 0, style == -4 ? 11.6 : 0, [ 1 ]    ] :
    diameter == 10   ? [ 17, style == -3 ?  6   :  8  , style == -4 ? 0.6 : 0, style == -4 ? 14.6 : 0, [ 1.25 ] ] :
    diameter == 12   ? [ 19, style == -3 ?  7   : 10  , style == -4 ? 0.6 : 0, style == -4 ? 16.6 : 0, [ 1.25 ] ] :
    diameter == 14   ? [ 22, style == -3 ?  8   : 11  , style == -4 ? 0.6 : 0, style == -4 ? 19.6 : 0, [ 1.5 ]  ] :
    diameter == 16   ? [ 24, style == -3 ? 10   : 13  , style == -4 ? 0.8 : 0, style == -4 ? 22.5 : 0, [ 1.5 ]  ] :
    diameter == 18   ? [ 27, style == -3 ? 11   : 15  , style == -4 ? 0.8 : 0, style == -4 ? 24.9 : 0, [ 1.5 ]  ] :
    diameter == 20   ? [ 30, style == -3 ? 12   : 16  , style == -4 ? 0.8 : 0, style == -4 ? 27.7 : 0, [ 1.5 ]  ] :
    diameter == 22   ? [ 32, style == -3 ? 13   : 18  , style == -4 ? 0.8 : 0, style == -4 ? 31.4 : 0, [ 1.5 ]  ] :
    diameter == 24   ? [ 36, style == -3 ? 14   : 19  , style == -4 ? 0.8 : 0, style == -4 ? 33.3 : 0, [ 2 ]    ] :
    diameter == 27   ? [ 41, style == -3 ? 16   : 22  ,                     0,                      0, [ 2 ]    ] :
    diameter == 30   ? [ 46, style == -3 ? 18   : 24  ,                     0,                      0, [ 2 ]    ] :
    diameter == 33   ? [ 50, style == -3 ? 20   : 26  ,                     0,                      0, [ 2 ]    ] :
    diameter == 36   ? [ 55, style == -3 ? 21   : 29  ,                     0,                      0, [ 3 ]    ] :
    diameter == 39   ? [ 49, style == -3 ? 23   : 31  ,                     0,                      0, [ 3 ]    ] :
    diameter == 42   ? [ 65, style == -3 ? 25   : 34  ,                     0,                      0, [  ]     ] :
    diameter == 45   ? [ 58, style == -3 ? 27   : 36  ,                     0,                      0, [  ]     ] :
    diameter == 48   ? [ 75, style == -3 ? 29   : 38  ,                     0,                      0, [  ]     ] :
    diameter == 52   ? [ 78, style == -3 ? 31   : 42  ,                     0,                      0, [  ]     ] :
    diameter == 56   ? [ 85, style == -3 ? 34   : 45  ,                     0,                      0, [  ]     ] :
    diameter == 60   ? [ 87, style == -3 ? 36   : 48  ,                     0,                      0, [  ]     ] :
    diameter == 64   ? [ 95, style == -3 ? 38   : 51  ,                     0,                      0, [  ]     ] :
    0
  ) :
  style == 4 ?
  ( // 低
    diameter ==  1.6 ? [  3.20,  1.00, 0, 0, [  ]          ] :
    diameter ==  2   ? [  4.00,  1.20, 0, 0, [  ]          ] :
    diameter ==  2.5 ? [  5.00,  1.60, 0, 0, [  ]          ] :
    diameter ==  3   ? [  5.50,  1.80, 0, 0, [  ]          ] :
    diameter ==  3.5 ? [  6.00,  2.00, 0, 0, [  ]          ] :
    diameter ==  4   ? [  7.00,  2.20, 0, 0, [  ]          ] :
    diameter ==  5   ? [  8.00,  2.70, 0, 0, [  ]          ] :
    diameter ==  6   ? [ 10.00,  3.20, 0, 0, [  ]          ] :
    diameter ==  8   ? [ 13.00,  4.00, 0, 0, [ 1 ]         ] :
    diameter == 10   ? [ 16.00,  5.00, 0, 0, [ 1, 1.25 ]   ] :
    diameter == 12   ? [ 18.00,  6.00, 0, 0, [ 1.5, 1.25 ] ] :
    diameter == 14   ? [ 21.00,  7.00, 0, 0, [ 1.5 ]       ] :
    diameter == 16   ? [ 24.00,  8.00, 0, 0, [ 1.5 ]       ] :
    diameter == 18   ? [ 27.00,  9.00, 0, 0, [ 1.5 ]       ] :
    diameter == 20   ? [ 30.00, 10.00, 0, 0, [ 1.5 ]       ] :
    diameter == 22   ? [ 34.00, 11.00, 0, 0, [ 2 ]         ] :
    diameter == 24   ? [ 36.00, 12.00, 0, 0, [ 2 ]         ] :
    diameter == 27   ? [ 41.00, 13.50, 0, 0, [ 1.5, 2 ]    ] :
    diameter == 30   ? [ 46.00, 15.00, 0, 0, [ 2 ]         ] :
    diameter == 33   ? [ 50.00, 16.50, 0, 0, [ 2 ]         ] :
    diameter == 36   ? [ 55.00, 18.00, 0, 0, [ 3 ]         ] :
    diameter == 39   ? [ 49.00, 19.50, 0, 0, [ 3 ]         ] :
    diameter == 42   ? [ 65.00, 21.00, 0, 0, [ 3 ]         ] :
    diameter == 45   ? [ 58.80, 22.50, 0, 0, [ 3 ]         ] :
    diameter == 48   ? [ 75.00, 24.00, 0, 0, [ 3 ]         ] :
    diameter == 52   ? [ 78.10, 26.00, 0, 0, [ 4 ]         ] :
    diameter == 56   ? [ 85.00, 28.00, 0, 0, [ 4 ]         ] :
    diameter == 60   ? [ 87.80, 30.00, 0, 0, [ 4 ]         ] :
    diameter == 64   ? [ 95.00, 32.00, 0, 0, [ 4 ]         ] :
    0
  ) :
  style == 3 ?
  ( // C
    diameter ==  5   ? [  8.00,  5.60, 0, 0, [  ]          ] :
    diameter ==  6   ? [ 10.00,  6.40, 0, 0, [  ]          ] :
    diameter ==  8   ? [ 13.00,  7.90, 0, 0, [ 1 ]         ] :
    diameter == 10   ? [ 16.00,  9.50, 0, 0, [ 1, 1.25 ]   ] :
    diameter == 12   ? [ 18.00, 12.20, 0, 0, [ 1.5, 1.25 ] ] :
    diameter == 14   ? [ 21.00, 13.90, 0, 0, [ 1.5 ]       ] :
    diameter == 16   ? [ 24.00, 15.90, 0, 0, [ 1.5 ]       ] :
    diameter == 18   ? [ 27.00, 16.90, 0, 0, [ 1.5 ]       ] :
    diameter == 20   ? [ 30.00, 19.00, 0, 0, [ 1.5 ]       ] :
    diameter == 22   ? [ 34.00, 20.20, 0, 0, [ 2 ]         ] :
    diameter == 24   ? [ 36.00, 22.30, 0, 0, [ 2 ]         ] :
    diameter == 27   ? [ 41.00, 24.70, 0, 0, [ 1.5, 2 ]    ] :
    diameter == 30   ? [ 46.00, 26.40, 0, 0, [ 2 ]         ] :
    diameter == 33   ? [ 50.00, 29.50, 0, 0, [ 2 ]         ] :
    diameter == 36   ? [ 55.00, 31.90, 0, 0, [ 3 ]         ] :
    diameter == 39   ? [ 49.00, 34.30, 0, 0, [ 3 ]         ] :
    diameter == 42   ? [ 65.00, 34.90, 0, 0, [ 3 ]         ] :
    diameter == 45   ? [ 58.80, 36.90, 0, 0, [ 3 ]         ] :
    diameter == 48   ? [ 75.00, 38.90, 0, 0, [ 3 ]         ] :
    diameter == 52   ? [ 78.10, 42.90, 0, 0, [ 4 ]         ] :
    diameter == 56   ? [ 85.00, 45.90, 0, 0, [ 4 ]         ] :
    diameter == 60   ? [ 87.80, 48.90, 0, 0, [ 4 ]         ] :
    diameter == 64   ? [ 95.00, 52.40, 0, 0, [ 4 ]         ] :
    0
  ) :
  style == 2 ?
  ( // style 2
    diameter ==  5   ? [  8.00,  5.10, 0.50,  6.90, [ [  ]          ] ] :
    diameter ==  6   ? [ 10.00,  5.70, 0.50,  8.90, [ [  ]          ] ] :
    diameter ==  8   ? [ 13.00,  7.50, 0.50, 11.60, [ [ 1 ]         ] ] :
    diameter == 10   ? [ 16.00,  9.30, 0.50, 14.60, [ [ 1, 1.25 ]   ] ] :
    diameter == 12   ? [ 18.00, 12.00, 0.50, 16.60, [ [ 1.5, 1.25 ] ] ] :
    diameter == 14   ? [ 21.00, 14.10, 0.60, 19.60, [ [ 1.5 ]       ] ] :
    diameter == 16   ? [ 24.00, 16.40, 0.50, 22.50, [ [ 1.5 ]       ] ] :
    diameter == 20   ? [ 30.00, 20.30, 0.50, 27.70, [ [ 1.5 ]       ] ] :
    diameter == 24   ? [ 36.00, 23.90, 0.50, 33.20, [ [ 2 ]         ] ] :
    diameter == 30   ? [ 46.00, 28.60, 0.50, 42.70, [ [ 2 ]         ] ] :
    diameter == 36   ? [ 55.00, 34.70, 0.50, 51.10, [ [ 3 ]         ] ] :
    0
  ) :
  ( // style 1
    diameter ==  1.6 ? [  3.20,  1.30, 0.20,  2.40, [  ]          ] :
    diameter ==  2   ? [  4.00,  1.60, 0.20,  3.10, [  ]          ] :
    diameter ==  2.5 ? [  5.00,  2.00, 0.30,  4.10, [  ]          ] :
    diameter ==  3   ? [  5.50,  2.40, 0.40,  4.60, [  ]          ] :
    diameter ==  3.5 ? [  6.00,  2.80, 0.40,  5.00, [  ]          ] :
    diameter ==  4   ? [  7.00,  3.20, 0.40,  5.90, [  ]          ] :
    diameter ==  5   ? [  8.00,  4.70, 0.50,  6.90, [  ]          ] :
    diameter ==  6   ? [ 10.00,  5.20, 0.50,  8.90, [  ]          ] :
    diameter ==  8   ? [ 13.00,  6.80, 0.60, 11.60, [ 1 ]         ] :
    diameter == 10   ? [ 16.00,  8.40, 0.60, 14.60, [ 1, 1.25 ]   ] :
    diameter == 12   ? [ 18.00, 10.80, 0.60, 16.60, [ 1.5, 1.25 ] ] :
    diameter == 14   ? [ 21.00, 12.80, 0.60, 19.60, [ 1.5 ]       ] :
    diameter == 16   ? [ 24.00, 14.80, 0.80, 22.50, [ 1.5 ]       ] :
    diameter == 18   ? [ 27.00, 15.80, 0.80, 24.90, [ 1.5 ]       ] :
    diameter == 20   ? [ 30.00, 18.00, 0.80, 27.70, [ 1.5 ]       ] :
    diameter == 22   ? [ 34.00, 19.40, 0.80, 31.40, [ 2 ]         ] :
    diameter == 24   ? [ 36.00, 21.50, 0.80, 33.30, [ 2 ]         ] :
    diameter == 27   ? [ 41.00, 23.80, 0.80, 38.00, [ 1.5, 2 ]    ] :
    diameter == 30   ? [ 46.00, 25.60, 0.80, 42.80, [ 2 ]         ] :
    diameter == 33   ? [ 50.00, 28.70, 0.80, 46.60, [ 2 ]         ] :
    diameter == 36   ? [ 55.00, 31.00, 0.80, 51.10, [ 3 ]         ] :
    diameter == 39   ? [ 49.00, 33.40, 1.00, 55.90, [ 3 ]         ] :
    diameter == 42   ? [ 65.00, 34.00, 1.00, 60.00, [ 3 ]         ] :
    diameter == 45   ? [ 58.80, 36.00, 1.00, 64.70, [ 3 ]         ] :
    diameter == 48   ? [ 75.00, 38.00, 1.00, 69.50, [ 3 ]         ] :
    diameter == 52   ? [ 78.10, 42.00, 1.00, 74.20, [ 4 ]         ] :
    diameter == 56   ? [ 85.00, 45.00, 1.00, 78.70, [ 4 ]         ] :
    diameter == 60   ? [ 87.80, 48.00, 1.00, 83.40, [ 4 ]         ] :
    diameter == 64   ? [ 95.00, 51.00, 1.00, 88.20, [ 4 ]         ] :
    0
  )
  ;

/// @param style        JIS B 1181:2014 で定義される「スタイル」
///                        1:=約0.9D (面取り指定省略時は両面取り)
///                        2:=約1.0D (面取り指定省略時は両面取り)
///                     または旧規格の「種」
///                       -1:=1種≃約0.8D/上部取り
///                       -2:=2種≃約0.8D/両面取り
///                       -3:=3種≃約0.6D/両面取り
///                       -4:4種≃約0.8D/上部面取り/下部ワッシャーフェイス
/// @top_chamfering     上部を面取りするか true/false ( style で旧規格を設定した場合は引数を与えても無効とし、規格を優先します )
/// @bottom_chamfering  下部を面取りするか true/false ( style で旧規格を設定した場合は引数を与えても無効とし、規格を優先します )
/// @has_washer_face    下部にワッシャーフェイスを持つか true/false ( style で旧規格を設定した場合は引数を与えても無効とし、規格を優先します )
function nut_style_to_chamferings( style, top_chamfering = true, bottom_chamfering = true, has_washer_face = false ) = 
  style == -1 ? [ true, false, false ] :
  style == -2 ? [ true, true , false ] :
  style == -3 ? [ true, true , false ] :
  style == -4 ? [ true, false, true  ] :
  [ top_chamfering, has_washer_face ? false : bottom_chamfering, has_washer_face ]
  ;

function get_nut_style_name( style ) = 
  style == 1 ? "JIS B 1181:2014 本体規格 スタイル1" :
  style == 2 ? "JIS B 1181:2014 本体規格 スタイル2" :
  style == 3 ? "JIS B 1181:2014 本体規格 C" :
  style == 4 ? "JIS B 1181:2014 本体規格 低" :
  style == -1 ? "JIS B 1181:2014 附属書JA 六角/1種" :
  style == -2 ? "JIS B 1181:2014 附属書JA 六角/2種" :
  style == -3 ? "JIS B 1181:2014 附属書JA 六角/3種" :
  style == -4 ? "JIS B 1181:2014 附属書JA 六角/4種" :
  style == -5 ? "JIS B 1181:2014 附属書JA 小型六角/1種" :
  style == -6 ? "JIS B 1181:2014 附属書JA 小型六角/2種" :
  style == -7 ? "JIS B 1181:2014 附属書JA 小型六角/3種" :
  style == -8 ? "JIS B 1181:2014 附属書JA 小型六角/4種" :
  "(不明なスタイルID)"
  ;

function get_nut_style_diameters( style ) = 
  style == 1 ? "1.6/2/2.5/3/3.5/4/5/6/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64" :
  style == 2 ? "5/6/8/10/12/14/16/20/24/30/36" :
  style == 3 ? "5/6/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64" :
  style == 4 ? "1.6/2/2.5/3/3.5/4/5/6/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64" :
  style == -1 ? "2/2.5/3/3.5/4/5/6/7/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64" :
  style == -2 ? "2/2.5/3/3.5/4/5/6/7/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64" :
  style == -3 ? "2/2.5/3/3.5/4/5/6/7/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64" :
  style == -4 ? "5/6/7/8/10/12/14/16/18/20/22/24" :
  style == -5 ? "8/10/12/14/16/18/20/22/24/27/30/33/36/39" :
  style == -6 ? "8/10/12/14/16/18/20/22/24/27/30/33/36/39" :
  style == -7 ? "8/10/12/14/16/18/20/22/24/27/30/33/36/39" :
  style == -8 ? "8/10/12/14/16/18/20/22/24" :
  "(n/a)"
  ;


/// @brief JIS B 1256 ワッシャーの「呼び径」と「形」から造形に必要な他のパラメーターを取得 
/// @return [ 0:内径, 1:外径, 2:厚さ ]
function get_JIS_B_1256_hex_nut_parameters( diameter, type ) = 
  type == -2 ?
  ( // 附属書JA/大形角
    diameter ==  6   ? [  6.6,  20,  2.3 ] :
    diameter ==  8   ? [  9  ,  26,  2.3 ] :
    diameter == 10   ? [ 11  ,  32,  2.3 ] :
    diameter == 12   ? [ 14  ,  40,  3.2 ] :
    diameter == 14   ? [ 16  ,  44,  3.2 ] :
    diameter == 16   ? [ 18  ,  52,  4.5 ] :
    diameter == 18   ? [ 20  ,  55,  4.5 ] :
    diameter == 20   ? [ 22  ,  62,  6   ] :
    diameter == 22   ? [ 24  ,  68,  6   ] :
    diameter == 24   ? [ 26  ,  72,  6   ] :
    diameter == 27   ? [ 30  ,  80,  6   ] :
    diameter == 30   ? [ 33  ,  90,  6   ] :
    diameter == 33   ? [ 36  , 100,  8   ] :
    diameter == 36   ? [ 39  , 110,  8   ] :
    diameter == 39   ? [ 42  , 115,  8   ] :
    diameter == 42   ? [ 45  , 120,  9   ] :
    diameter == 45   ? [ 48  , 130,  9   ] :
    diameter == 48   ? [ 52  , 140, 12   ] :
    diameter == 52   ? [ 56  , 150, 12   ] :
    0
  ) :
  type == -1 ?
  ( // 附属書JA/小形角
    diameter ==  6   ? [  6.6, 17, 1.2 ] :
    diameter ==  8   ? [  9  , 23, 1.6 ] :
    diameter == 10   ? [ 11  , 28, 1.6 ] :
    diameter == 12   ? [ 14  , 35, 2.3 ] :
    diameter == 14   ? [ 16  , 40, 3.2 ] :
    diameter == 16   ? [ 18  , 45, 3.2 ] :
    diameter == 18   ? [ 20  , 52, 4.5 ] :
    diameter == 20   ? [ 22  , 56, 4.5 ] :
    diameter == 22   ? [ 24  , 64, 4.5 ] :
    diameter == 24   ? [ 26  , 68, 6   ] :
    diameter == 27   ? [ 30  , 73, 6   ] :
    0
  ) :
  type == 6 ?
  ( // 特大形/部品等級C
    diameter ==  5   ? [  5.5 ,  18.0, 2 ] :
    diameter ==  6   ? [  6.60,  22.0, 2 ] :
    diameter ==  8   ? [  9.00,  28.0, 3 ] :
    diameter == 10   ? [ 11.00,  34.0, 3 ] :
    diameter == 12   ? [ 13.50,  44.0, 4 ] :
    diameter == 14   ? [ 15.50,  50.0, 4 ] :
    diameter == 16   ? [ 17.5 ,  56.0, 5 ] :
    diameter == 18   ? [ 20.00,  60.0, 5 ] :
    diameter == 20   ? [ 22.00,  72.0, 6 ] :
    diameter == 22   ? [ 24.00,  80.0, 6 ] :
    diameter == 24   ? [ 26.00,  85.0, 6 ] :
    diameter == 27   ? [ 30.00,  98.0, 6 ] :
    diameter == 30   ? [ 33   , 105.0, 6 ] :
    diameter == 33   ? [ 36   , 115.0, 8 ] :
    diameter == 36   ? [ 39   , 125.0, 8 ] :
    0
  ) : 
  ( type == 4 || type == 5 ) ?
  ( // 大形/部品等級A or 大形/部品等級C
    diameter ==  3   ? [ type == 5 ?  3.4  :  3.20,   9.00,                   0.8 ] :
    diameter ==  3.5 ? [ type == 5 ?  3.9  :  3.70,  11.00, type == 5 ? 0.8 : 0.9 ] :
    diameter ==  4   ? [ type == 5 ?  4.5  :  4.30,  12.00,                   1   ] :
    diameter ==  5   ? [ type == 5 ?  5.5  :  5.30,  15.00,                   1   ] :
    diameter ==  6   ? [ type == 5 ?  6.60 :  6.40,  18.00,                   1.6 ] :
    diameter ==  8   ? [ type == 5 ?  9.00 :  8.40,  24.00,                   2   ] :
    diameter == 10   ? [ type == 5 ? 11.00 : 10.50,  30.00,                   2.5 ] :
    diameter == 12   ? [ type == 5 ? 13.50 : 13.00,  37.00,                   3   ] :
    diameter == 14   ? [ type == 5 ? 15.50 : 15.00,  44.00,                   3   ] :
    diameter == 16   ? [ type == 5 ? 17.50 : 17.00,  50.00,                   3   ] :
    diameter == 18   ? [ type == 5 ? 20.00 : 19.00,  56.00,                   4   ] :
    diameter == 20   ? [ type == 5 ? 22.00 : 21.00,  60.00,                   4   ] :
    diameter == 22   ? [ type == 5 ? 24.00 : 23.00,  66.0 ,                   5   ] :
    diameter == 24   ? [ type == 5 ? 26.00 : 25.00,  72.0 ,                   5   ] :
    diameter == 27   ? [ type == 5 ? 30.00 : 30.00,  85.0 ,                   6   ] :
    diameter == 30   ? [ type == 5 ? 33.00 : 33.00,  92.0 ,                   6   ] :
    diameter == 33   ? [ type == 5 ? 36    : 36.00, 105.0 ,                   6   ] :
    diameter == 36   ? [ type == 5 ? 39    : 39.00, 110.0 ,                   8   ] :
    0
  ) :  type == 2 ?
  ( // 並形面取り
    diameter ==  5   ? [  5.30,  10.00, 1   ] :
    diameter ==  6   ? [  6.40,  12.00, 1.6 ] :
    diameter ==  8   ? [  8.40,  16.00, 1.6 ] :
    diameter == 10   ? [ 10.50,  20.00, 2   ] :
    diameter == 12   ? [ 13.00,  24.00, 2.5 ] :
    diameter == 14   ? [ 15.00,  28.00, 2.5 ] :
    diameter == 16   ? [ 17.00,  30.00, 3   ] :
    diameter == 18   ? [ 19.00,  34.00, 3   ] :
    diameter == 20   ? [ 21.00,  37.00, 3   ] :
    diameter == 22   ? [ 23.00,  39.00, 3   ] :
    diameter == 24   ? [ 25.00,  44.00, 4   ] :
    diameter == 27   ? [ 28.00,  50.00, 4   ] :
    diameter == 30   ? [ 31.00,  56.00, 4   ] :
    diameter == 33   ? [ 34.00,  60.00, 5   ] :
    diameter == 36   ? [ 37.00,  66.0 , 5   ] :
    diameter == 39   ? [ 42.00,  72.0 , 6   ] :
    diameter == 42   ? [ 45.00,  78.0 , 8   ] :
    diameter == 45   ? [ 48.00,  85.0 , 8   ] :
    diameter == 48   ? [ 52.00,  92.0 , 8   ] :
    diameter == 52   ? [ 56.00,  98.0 , 8   ] :
    diameter == 56   ? [ 62.00, 105.0 , 10   ] :
    diameter == 60   ? [ 66.00, 110.0 , 10   ] :
    diameter == 64   ? [ 70.00, 115.0 , 10   ] :
    0
  ) :
  ( type == 1 || type == 3 ) ?
  ( // 並形/部品等級A or 並形/部品等級C
    diameter ==  1.6 ? [ type == 3 ?  1.80 :  1.70,   4.0 ,  0.3 ] :
    diameter ==  2   ? [ type == 3 ?  2.40 :  2.20,   5.0 ,  0.3 ] :
    diameter ==  2.5 ? [ type == 3 ?  2.90 :  2.70,   6.0 ,  0.5 ] :
    diameter ==  3   ? [ type == 3 ?  3.4  :  3.20,   7.0 ,  0.5 ] :
    diameter ==  3.5 ? [ type == 3 ?  3.9  :  3.70,   8.0 ,  0.5 ] :
    diameter ==  4   ? [ type == 3 ?  4.5  :  4.30,   9.00,  0.8 ] :
    diameter ==  5   ? [ type == 3 ?  5.5  :  5.30,  10.00,  1   ] :
    diameter ==  6   ? [ type == 3 ?  6.60 :  6.40,  12.00,  1.6 ] :
    diameter ==  8   ? [ type == 3 ?  9.00 :  8.40,  16.00,  1.6 ] :
    diameter == 10   ? [ type == 3 ? 11.00 : 10.50,  20.00,  2   ] :
    diameter == 12   ? [ type == 3 ? 13.50 : 13.00,  24.00,  2.5 ] :
    diameter == 14   ? [ type == 3 ? 15.50 : 15.00,  28.00,  2.5 ] :
    diameter == 16   ? [ type == 3 ? 17.50 : 17.00,  30.00,  3   ] :
    diameter == 18   ? [ type == 3 ? 20.00 : 19.00,  34.00,  3   ] :
    diameter == 20   ? [ type == 3 ? 22.00 : 21.00,  37.00,  3   ] :
    diameter == 22   ? [ type == 3 ? 24.00 : 23.00,  39.00,  3   ] :
    diameter == 24   ? [ type == 3 ? 26.00 : 25.00,  44.00,  4   ] :
    diameter == 27   ? [ type == 3 ? 30.00 : 28.00,  50.00,  4   ] :
    diameter == 30   ? [ type == 3 ? 33.00 : 31.00,  56.00,  4   ] :
    diameter == 33   ? [ type == 3 ? 36    : 34.00,  60.00,  5   ] :
    diameter == 36   ? [ type == 3 ? 39    : 37.00,  66.0 ,  5   ] :
    diameter == 39   ? [ type == 3 ? 42    : 42.00,  72.0 ,  6   ] :
    diameter == 42   ? [ type == 3 ? 45    : 45.00,  78.0 ,  8   ] :
    diameter == 45   ? [ type == 3 ? 48    : 48.00,  85.0 ,  8   ] :
    diameter == 48   ? [ type == 3 ? 52.0  : 52.00,  92.0 ,  8   ] :
    diameter == 52   ? [ type == 3 ? 56.0  : 56.00,  98.0 ,  8   ] :
    diameter == 56   ? [ type == 3 ? 62.0  : 62.00, 105.0 , 10   ] :
    diameter == 60   ? [ type == 3 ? 66.0  : 66.00, 110.0 , 10   ] :
    diameter == 64   ? [ type == 3 ? 70.0  : 70.00, 115.0 , 10   ] :
    0
  ) :
  type == 0 ?
  ( // 小形
    diameter ==  1.6 ? [  1.70,  3.5 , 0.3 ] :
    diameter ==  2   ? [  2.20,  4.5 , 0.3 ] :
    diameter ==  2.5 ? [  2.70,  5.0 , 0.5 ] :
    diameter ==  3   ? [  3.20,  6.0 , 0.5 ] :
    diameter ==  3.5 ? [  3.70,  7.0 , 0.5 ] :
    diameter ==  4   ? [  4.30,  8.00, 0.5 ] :
    diameter ==  5   ? [  5.30,  9.00, 1   ] :
    diameter ==  6   ? [  6.40, 11.00, 1.6 ] :
    diameter ==  8   ? [  8.40, 15.00, 1.6 ] :
    diameter == 10   ? [ 10.50, 18.00, 1.6 ] :
    diameter == 12   ? [ 13.00, 20.00, 2   ] :
    diameter == 14   ? [ 15.00, 24.00, 2.5 ] :
    diameter == 16   ? [ 17.00, 28.00, 2.5 ] :
    diameter == 18   ? [ 19.00, 30.00, 3   ] :
    diameter == 20   ? [ 21.00, 34.00, 3   ] :
    diameter == 22   ? [ 23.00, 37.00, 3   ] :
    diameter == 24   ? [ 25.00, 39.00, 4   ] :
    diameter == 27   ? [ 28.00, 44.00, 4   ] :
    diameter == 30   ? [ 31.00, 50.00, 4   ] :
    diameter == 33   ? [ 34.00, 56.00, 5   ] :
    diameter == 36   ? [ 37.00, 60.0 , 5   ] :
    0
  ) :
  0
  ;

function get_washer_style_name( style ) = 
  type == 0 ? "JIS B 1256:2008 本体規格 小形/部品等級A" :
  type == 1 ? "JIS B 1256:2008 本体規格 並形/部品等級A (新JIS/みがき丸)" :
  type == 2 ? "JIS B 1256:2008 本体規格 並形面取り/部品等級A" :
  type == 3 ? "JIS B 1256:2008 本体規格 並形/部品等級C" :
  type == 4 ? "JIS B 1256:2008 本体規格 大形/部品等級A" :
  type == 5 ? "JIS B 1256:2008 本体規格 大形/部品等級c" :
  type == 6 ? "JIS B 1256:2008 本体規格 特大形/部品等級C" :
  type == -1 ? "JIS B 1256:2008 附属書JA 角座金/小形角" :
  type == -2 ? "JIS B 1256:2008 附属書JA 角座金/小形角" :
  "(不明なスタイルID)"
  ;

function get_washer_style_diameters( style ) = 
  type == 0 ? "1.6/2/2.5/3/3.5/4/5/6/8/10/12/14/16/18/20/22/24/27/30/33/36" :
  type == 1 ? "1.6/2/2.5/3/3.5/4/5/6/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64" :
  type == 2 ? "5/6/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64" :
  type == 3 ? "1.6/2/2.5/3/3.5/4/5/6/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52/56/60/64" :
  type == 4 ? "3/3.5/4/5/6/8/10/12/14/16/18/20/22/24/27/30/33/36" :
  type == 5 ? "3/3.5/4/5/6/8/10/12/14/16/18/20/22/24/27/30/33/36" :
  type == 6 ? "5/6/8/10/12/14/16/18/20/22/24/27/30/33/36" :
  type == -1 ? "6/8/10/12/14/16/18/20/22/24/27" :
  type == -2 ? "6/8/10/12/14/16/18/20/22/24/27/30/33/36/39/42/45/48/52" :
  "(n/a)"
  ;

/// @brief 六角穴付き止めねじ
module screw_hexagon_socket_set( diameter, length, pitch, type, angle, root_clearance, resolution, round_subdivision )
{
  ps = get_JIS_B_1177_hexagon_socket_set_parameters( diameter, length );

  if ( ps == 0 )
  {
    // fatal
    echo( str( "注意: 指定された呼び径(", diameter, ")は JIS B 1177 では定義されていません。意図的に特別な螺子を設計したい場合は screw の実装詳細を覗いて my_screw モジュールを新たにお好みで作成するとよいかもしれません。" ) );
    echo( "参考: JIS B 1177 に含まれる呼び径は M1.6/2/2.5/3/4/5/6/8/10/12/14/16/20/24 です。");
  }
  else
  {
    // warning
    if ( pitch != get_screw_pitch_from_diameter( diameter ) )
      echo( str( "注意: 特殊なピッチ(", pitch, ")が設定されています。 JIS B 1177 ではピッチは並目のみ定義されています。意図的に特別なピッチ設定を望まない場合は pitch をデフォルト値(=0)に再設定し自動的に並目が採用されるように修正して下さい。" ) );

    // warning
    if ( len( search( length, ps[ 5 ] ) ) == 0 )
      echo( str( "注意: 指定された呼び径(", diameter, ")と呼び長さ(", length, ")の組み合わせは JIS B 1177 では定義されていません。意図的に特別な呼び長さ設定を望まない場合は length を ", ps[ 5 ] , " の何れかに修正して下さい。" ) );
    
    // 生成
    difference()
    {
      // ねじ部
      screw_thread( diameter, pitch, angle, length, root_clearance, 90 - ps[ 2 ] / 2, 45, false, resolution );

      // 先
      inner_diameter = diameter - calculate_H( pitch ) * 7 / 8 * 2;
      if ( type == 4 ) // くぼみ
        cylinder( h = inner_diameter * tan( 30 ), d1 = inner_diameter * 2, d2 = 0, $fn = round_subdivision, center = true );
      else if ( type == 3 ) // 棒
      {
        x0 = 0;
        x1 = ps[ 4 ][ 0 ] / 2;
        x2 = ps[ 4 ][ 1 ] + diameter;
        y0 = -1.0e-3;
        y1 = ps[ 4 ][ 1 ];
        y2 = ps[ 4 ][ 1 ] + diameter;
        rotate_extrude( convexity = 10, $fn = round_subdivision )
          polygon( [ [ x0, y0 ], [ x1, y0 ], [ x1, y1 ], [ x2, y2 ], [ x2, y0 ] ] );
      }
      else if ( type == 2 ) // とがり
      {
        x0 = ps[ 3 ][ 0 ] / 2;
        x1 = x0 + diameter;
        y0 = -1.0e-3;
        y1 = diameter / tan( ps[ 3 ][ 1 ] / 2 );
        rotate_extrude( convexity = 10, $fn = round_subdivision )
          polygon( [ [ x0, y0 ], [ x1, y1 ], [ x1, y0 ] ] );
      }
      
      // type == 1 平 はそのままで造形できた状態になっているので何もしない

      // 頭
      translate( [ 0, 0, length ] )
        hexagon_hole( ps[ 0 ], ps[ 1 ], round_subdivision = round_subdivision );
    }
  }
}

module screw_hexagon_socket_head_cap( diameter, length, pitch, type, angle, root_clearance, resolution, round_subdivision )
{
  // 六角穴付き
  ps = get_JIS_B_1176_hexagon_socket_head_cap_parameters( diameter );

  if ( ps == 0 )
  {
    // fatal
    echo( str( "注意: 指定された呼び径(", diameter, ")は JIS B 1176 では定義されていません。意図的に特別な螺子を設計したい場合は screw の実装詳細を覗いて my_screw モジュールを新たにお好みで作成するとよいかもしれません。" ) );
    echo( "参考: JIS B 1176 に含まれる呼び径は M1.6/2/2.5/3/4/5/6/8/10/12/14/16/20/24/30/36/42/48/56/64 です。");
  }
  else
  {
    // warning
    if ( pitch != get_screw_pitch_from_diameter( diameter ) && len( search( pitch, ps[ 4 ] ) ) == 0 )
      echo( str( "注意: 指定された呼び径(", diameter, ")とピッチ(", pitch, ")の組み合わせは JIS B 1176 では定義されていません。意図的に特別なピッチ設定を望まない場合は pitch をデフォルト値(=0)に再設定し自動的に並目が採用されるように修正して下さい。" ) );

    // warning
    if ( len( search( length, ps[ 5 ] ) ) == 0 )
      echo( str( "注意: 指定された呼び径(", diameter, ")と呼び長さ(", length, ")の組み合わせは JIS B 1176 では定義されていません。意図的に特別な呼び長さ設定を望まない場合は length を ", ps[ 5 ] , " の何れかに修正して下さい。" ) );
    
    // 生成
    union()
    {
      difference()
      {
        // ヘッド本体
        translate( [ 0, 0, length ] )
          hand_screw_head( diameter = ps[ 1 ], height = ps[ 0 ] );
        // ヘッド六角穴
        translate ( [ 0, 0, length + ps[ 0 ] ] )
          hexagon_hole( ps[ 2 ], ps[ 3 ], round_subdivision = round_subdivision );
      }
      // ねじ部
      screw_thread( diameter, pitch, angle, length, root_clearance, 0, 45, false, resolution );
    }
  }
}

module screw_hexagon_head( diameter, length, pitch, type, angle, root_clearance, resolution, round_subdivision )
{
  ps = get_JIS_B_1180_hexagon_head_parameters( diameter, type == 201 ? 2014 : 2004 );

  if ( ps == 0 )
  {
    // fatal
    echo( str( "注意: 指定された呼び径(", diameter, ")は JIS B 1176 では定義されていません。意図的に特別な螺子を設計したい場合は screw の実装詳細を覗いて my_screw モジュールを新たにお好みで作成するとよいかもしれません。" ) );
    echo( "参考: JIS B 1180 に含まれる呼び径は M1.6/2/2.5/3/4/5/6/8/10/12/14/16/20/24/30/36/42/48/56/64 です。");
  }
  else
  {
    // warning
    if ( pitch != get_screw_pitch_from_diameter( diameter ) && len( search( pitch, ps[ 4 ] ) ) == 0 )
      echo( str( "注意: 指定された呼び径(", diameter, ")とピッチ(", pitch, ")の組み合わせは JIS B 1180 では定義されていません。意図的に特別なピッチ設定を望まない場合は pitch をデフォルト値(=0)に再設定し自動的に並目が採用されるように修正して下さい。" ) );

    // warning
    if ( len( search( length, ps[ 5 ] ) ) == 0 )
      echo( str( "注意: 指定された呼び径(", diameter, ")と呼び長さ(", length, ")の組み合わせは JIS B 1180 では定義されていません。意図的に特別な呼び長さ設定を望まない場合は length を ", ps[ 5 ] , " の何れかに修正して下さい。" ) );
    
    // 六角(JIS B 1180:2004 or JIS B 1180:2014)
    union()
    {
      difference()
      {
        translate( [ 0, 0, length ] )
        {
          difference()
          {
            // 六角ヘッド部
            hex_head( ps[ 1 ], ps[ 0 ], 30, 0, round_subdivision );
            // ワッシャーフェイス部
            if ( type == 201 )
              washer_face( ps[ 3 ] / 2, ps[ 1 ] * 2, ps[ 2 ], round_subdivision );
          }
        }
      }
      // ねじ部
      screw_thread( diameter, pitch, angle, length, root_clearance, 0, 45, false, resolution );
    }
  }
}

/// @brief 任意の全螺子を生成
/// @param diameter   : 螺子部分の直径 [mm]
/// @param pitch      : 螺子山の間隔 [mm] ( < 0 の場合は螺子山なし、直径 diameter + clearance * 2 を螺子山のない穴を開けます )
/// @param angle      : 螺子山の角度 [deg]
/// @param length     : 螺子部分の長さ [mm]
/// @param clearance  : 螺子山の谷底隙間 [mm]
/// @param resolution : 分解能 [mm]
/// @param countersink: 末端の丸め処理 {-2:両端はみ出す,-1:下端はみ出す＆上端平坦,0:両端平坦,1:上端丸め＆下端平坦,2:両端丸め}
module screw_thread
( diameter
, pitch
, angle
, length
, clearance
, top_chamfering_angle    = 45
, bottom_chamfering_angle = 45
, for_molding = false
, resolution = 0.05
)
{
  radius = diameter / 2;
  inner_radius = radius - pitch / 2 * cos( angle / 2 ) / sin( angle / 2 ) + clearance;
  round_subdivision = calculate_round_subdivision( diameter, resolution );
  xy_resolution = 360 / round_subdivision;
  ttn = round( length / pitch + 1 );
  zt = pitch / round_subdivision;

  if ( pitch >= 0 )
    union()
    {
      intersection()
      {
        full_thread( ttn, pitch, round_subdivision, zt, xy_resolution, radius + clearance, inner_radius );
        cylinder( r = radius * ( for_molding ? 2 : 1 ), h = length, $fn = round_subdivision );

        if ( ! for_molding )
          cylinder_chamferer( radius , inner_radius, length, top_chamfering_angle, bottom_chamfering_angle, round_subdivision );
      }
      
      if ( for_molding )
        cylinder( r = radius + clearance - calculate_bottom_clearance_reversed( pitch ), h = length, $fn = round_subdivision );
    }
  else
    cylinder( r = for_molding ? radius + clearance : radius, h = length, $fn = round_subdivision );
}

module full_thread
( ttn
, pitch
, round_subdivision
, zt
, xy_resolution
, outer_radius
, inner_radius
)
{
  if ( inner_radius < 0.2 )
    echo( "注意: 螺子ピッチが急勾配過ぎて螺子部を造形できません。ピッチを下げるか呼び径を大きく再設定すると造形できるかもしれません。" );
  //else if ( ttn < 1 )
    //echo( "注意: 螺子の巻数が 1 未満のため螺子部を造形できません。" );
  else
    union()
      for ( i = [ 0 : ttn - 1 ] )
        for ( j = [ 0 : round_subdivision - 1 ] )
        {
          pt =
            [ [ 0                                              , 0                                              , i * pitch - pitch                      ]
            , [ inner_radius * cos( j * xy_resolution )        , inner_radius * sin( j * xy_resolution )        , i * pitch + j * zt - pitch             ]
            , [ inner_radius * cos( ( j + 1 ) * xy_resolution ), inner_radius * sin( ( j + 1 ) * xy_resolution ), i * pitch + ( j + 1 ) * zt - pitch     ]
            , [ 0                                              , 0                                              , i * pitch                           ]
            , [ outer_radius * cos( j * xy_resolution )        , outer_radius * sin( j * xy_resolution )        , i * pitch + j * zt - pitch / 2         ]
            , [ outer_radius * cos( ( j + 1 ) * xy_resolution ), outer_radius * sin( ( j + 1 ) * xy_resolution ), i * pitch + ( j + 1 ) * zt - pitch / 2 ]
            , [ inner_radius * cos( j * xy_resolution )        , inner_radius * sin( j * xy_resolution )        , i * pitch + j * zt                  ]
            , [ inner_radius * cos( ( j + 1 ) * xy_resolution ), inner_radius * sin( ( j + 1 ) * xy_resolution ), i * pitch + ( j + 1 ) * zt          ]
            , [ 0                                              , 0                                              , i * pitch + pitch                      ]
            ];
          polyhedron
          ( points = pt
          , faces =
            [ [1,0,3], [1,3,6], [6,3,8], [1,6,4]
            , [0,1,2], [1,4,2], [2,4,5], [5,4,6], [5,6,7], [7,6,8]
            , [7,8,3], [0,2,3], [3,2,7], [7,2,5]
            ]
          );
        }
    
}

/// @dihedral_length          六角の二面幅 [mm]
/// @height                   高さ [mm]
/// @chamfering_radius_ratio  与えられた二面幅の外接円の半径に対する面取りで削る半径の比 (eg. 0.05 -> 半径の 5% を面取で削る) [-]
/// @top_chamfering_angle     上側の面取り角度 [deg]
/// @bottom_chamfering_angle  下側の面取り角度 [deg]
/// @round_subdivision        平面角の細分割数 [-]
module hex_head
( dihedral_length
, height
, top_chamfering_angle = 30
, bottom_chamfering_angle = 0
, round_subdivision = 64
)
{
  circumcircle_diameter = calculate_circumcircle_diameter( dihedral_length );

  outer_radius            = circumcircle_diameter / 2;
  inner_radius            = dihedral_length / 2;

	intersection()
	{
    // 六角本体
    cylinder( d = circumcircle_diameter, h = height, $fn = 6 );
    // 面取り
    cylinder_chamferer( outer_radius, inner_radius, height, top_chamfering_angle, bottom_chamfering_angle, round_subdivision );
	}
}

/// @brief 円柱を intersection で面取りする構造物を生成 (これじたいは円盤というか、そろばんの珠形のようなものを生成します)
module cylinder_chamferer
( outer_radius
, inner_radius
, height
, top_chamfering_angle = 30
, bottom_chamfering_angle = 0
, round_subdivision = 64
)
{
  half_height             = height / 2;
  chamfered_width         = outer_radius - inner_radius;
  chamfered_x             = outer_radius - chamfered_width;
  chamfered_height_top    = chamfered_width * tan( top_chamfering_angle );
  chamfered_height_bottom = chamfered_width * tan( bottom_chamfering_angle );
  chamfered_x0_top        = chamfered_x + chamfered_width * half_height / chamfered_height_top;
  chamfered_x0_bottom     = chamfered_x + chamfered_width * half_height / chamfered_height_bottom;

  bx = bottom_chamfering_angle  > 0 ? chamfered_x0_bottom : outer_radius;
  by = bottom_chamfering_angle  > 0 ? half_height         : 0;
  tx = top_chamfering_angle     > 0 ? chamfered_x0_top    : outer_radius;
  ty = top_chamfering_angle     > 0 ? half_height         : height;

  rotate_extrude( convexity = 10, $fn = round_subdivision )
    polygon
    ( [ [ 0           , 0       ] // 下端中心軸
      , [ chamfered_x , 0       ] // 面取りで削った下端
      , [ bx          , by      ] // 下端から伸びる面取りの面を高さの中心まで伸ばした点
      , [ tx          , ty      ] // 上端から伸びる面取りの面を高さの中心まで伸ばした点
      , [ chamfered_x , height  ] // 面取りで削った上端
      , [ 0           , height  ] // 上端中心軸
      ]
    );
}

module hand_screw_head( diameter, number_of_tooth = 64, chamfering_angle = 30, height = 1 )
{
  radius = diameter / 2;
  gear_height = PI * radius / number_of_tooth;
  gear_top_width = gear_height * cos( chamfering_angle * 2 );
  gear_bottom_width = gear_height * 2 - gear_top_width;
  inner_radius = radius - gear_height;
  gear_radius = sqrt( inner_radius * inner_radius + gear_bottom_width * gear_bottom_width );
  //difference()
  intersection()
  {
    union()
    {
      // 微小な歯車状のグリップ構造部分
      for ( n = [ 0 : number_of_tooth ] )
      {
        rotate( a = n * 360 / number_of_tooth, v = [ 0, 0, 1 ] )
          translate( [ 0, radius - gear_height, 0 ] )
            linear_extrude( height = height )
              polygon( [ [ -gear_bottom_width / 2, 0 ], [ -gear_top_width / 2, gear_height ], [ gear_top_width / 2, gear_height ], [ gear_bottom_width / 2, 0 ] ] );
      }
      // グリップ構造の付くシリンダー本体部分
      cylinder( r = gear_radius, $fn = number_of_tooth, h = height );
    }
    radius = diameter / 2;
    // 面取り
    cylinder_chamferer( radius , gear_radius, height, 45, 45 );
  }
}

/// @brief 六角穴を difference で掘る型を生成
module hexagon_hole( dihedral_length, depth, top_chamfering_angle = 30, bottom_chamfering_angle = 120, round_subdivision = 64 )
{
  // 六角穴
  circumcircle_diameter = calculate_circumcircle_diameter( dihedral_length );
  translate( [ 0, 0, -depth ] )
    cylinder( d = circumcircle_diameter, h = depth + 1.0e-3, $fn = 6, center = false );
  
  // 六角穴の底の円錐形隙間
  additional_depth = circumcircle_diameter / ( 2 * tan( bottom_chamfering_angle / 2 ) );
  translate( [ 0, 0, -depth - additional_depth ] )
    intersection()
    {
      cylinder( d = circumcircle_diameter, h = additional_depth * 10, $fn = 6, center = true );
      cylinder( d1 = 0, d2 = circumcircle_diameter, h = additional_depth + 1.0e-3, $fn = round_subdivision, center = false );
    }
  
  // 六角穴の面取り(インロー部=30[deg])
  spigot_joint_width = circumcircle_diameter * 0.05;
  spigot_joint_depth = spigot_joint_width / 2 * tan( top_chamfering_angle );
  translate( [ 0, 0, - spigot_joint_depth ] )
    cylinder( d1 = circumcircle_diameter, d2 = circumcircle_diameter + spigot_joint_width, h = spigot_joint_depth + 1.0e-3, $fn = 6, center = false );
}

/// @brief ワッシャーフェイスを difference で削る用の型を生成
module washer_face( inner_radius, outer_radius, cutting_height, round_subdivision = 64 )
{
  rotate_extrude( convexity = 10, $fn = round_subdivision )
  polygon( [ [ inner_radius, -1.0e-3 ], [ outer_radius, -1.0e-3 ], [ outer_radius, cutting_height ], [ inner_radius, cutting_height ] ] );
}

/// @brief 穴のインロー部を difference で面取り用する型を生成
module chamfer_hole( diameter, height, top_chamfering_angle, bottom_chamfering_angle, chamfering_radius_ratio = 0.05, round_subdivision = 64 )
{
  radius = diameter / 2;

  w = radius * chamfering_radius_ratio;
  s = radius / w;

  if ( top_chamfering_angle > 0 )
  {
    d = w * tan( top_chamfering_angle );
    translate( [ 0, 0, height - d * s ] )
      cylinder( r1 = 0, r2 = radius + w * s, h = d * s * 2, $fn = round_subdivision );
  }

  if ( bottom_chamfering_angle > 0 )
  {
    d = w * tan( bottom_chamfering_angle );
    translate( [ 0, 0, -d * s ] )
      cylinder( r1 = radius + w * s, r2 = 0, h = d * s * 2, $fn = round_subdivision );
  }
}