// usagi.scad で JIS 規格のネジを一定のスケーリング範囲で造形して、
// 3Dプリンターの造形精度を簡単に確認するためのテストプリント用造形物です。
// --------
//   このテスターを使うと、手持ちの"実用上の精度が大丈夫そう"なボルト、ナット、レンチ等をテスターに噛み合わせるだけで、
//   少なくともそれらを使える程度の精度で造形できている/できていないをお手軽に判断できます。
//   
//   一般に日本のDIYショップやモノタロウで調達できる量産されたボルトやナットなどの部品はJIS/ISO規格を満たす十分な精度で
//   加工されています。六角棒スパナー、コの字形のスパナーもJIS/ISO規格に基づいて作られています。
//   それらとこのテスターを造形したものが上手く噛み合えば、3Dプリンターの精度が製品の規格の許容差をおおよそ満たしていると
//   簡易的にテストできます。市販品のナットやネジなどのJIS規格の許容差は JISC のウェブサイトから公式な規格書の最新版を確認できます。
//     https://www.jisc.go.jp/app/jis/general/GnrJISSearch.html
//
//   市販の規格品のネジ部品をはめるだけで簡単にテストできる、あるいは、
//   単純なテストプリントでもノギスやマイクロメーターで測るだけよりも実際にボルトやナットがはまると楽しい
//   そのような理由でお使い頂ければ幸いです。
//
// --------
// 使用方法
//   1. この .SCAD を .STL 等にエクスポートして3Dプリンターで造形します
//      - 初期設定は分解能 0.05 [mm] のUV光造形向けで M2 系です。テスト環境や手持ちの規格品のネジやナットに併せて DIAMETER パラメーターを変更してください。
//      - テスター側凸ネジ構造(規格品のナットはめ用)の高さ SCREW_LENGTH パラメーターは初期設定の 0 のままの場合、JIS規格のスタイル1ナットの高さに自動的に設定されます。
//        - M8 など大きめの系で試す場合に造形時間や樹脂の使用量を節約したい、あるいはスタイル1ナット以外の高さに合わせたい場合は適当な値を設定してください。
//      - SCALING_RANGE パラメーターを変更すると、テスターに造形するネジの凸/凹/溝幅を変えられます。
//        - 初期設定では基準値 100% を中心に 0.5% 刻みで +1.5%, -1.5% までスケーリングしたテストポイントを造形します。
//        - ほぼ最適な条件が既知の場合は初期設定程度で十分かもしれません。
//        - 最適な条件のアタリがついていない場合は刻みを刻み幅を広く、スケーリング範囲も広くするとよいかもしれません。
//      - STAGE_HEIGHT パラメーターは M8 などネジのピッチが大きい系で凹ネジを十分に試したい場合や反りを避けたい場合に厚く盛ってみてください。
//   2. 造形されたサンプルに規格品の部品/工具を噛み合わせてお手軽に精度を確認します
//      - テスター側「凸ネジ」部分の使い方:
//        - ナットをはめる         -> ナットが軽く回ればそのスケーリングで X軸、Y軸、Z軸 の全てがはめた手持ち部品の精度に適合するとわかります。
//        - 六角棒スパナーをはめる -> 六角棒が軽くはまればそのスケーリングで X軸、Y軸がはめた手持ちの六角棒スパナーの精度に適合するとわかります。
//      - テスター側「溝」部分の使い方:
//        - 六角棒スパナーをはめる -> 溝はスケーリングレンジでリニアーに幅が変化しているので、広い方から滑らせる事で、X軸が基準値よりもどの程度スケーリングされた造形になっているか探せます。
//      - テスター側「凹ネジ」部分の使い方:
//        - ボルトなどのネジをはめる:
//          -> ネジが軽く回ればそのスケーリングで X軸、Y軸、Z軸 の全てがはめた手持ち部品の精度に適合するとわかります。
//          -> ネジをはめた状態でネジ溝の「窓」部分を確認して、削れが目視できるほど生じていないか、谷底隙間は適切か確認できます。(谷底隙間については、小さめの経ではエントリークラスの光学顕微鏡レベルの測定用のシステムが必要かもしれません😅)
//   その他:
//      - 必要に応じて事前に部品/工具または造形後のサンプルをノギス、マイクロメーター等で計測して下さい
//      - 文字部分は照明の当て方を工夫しないと造形されていないように見えるかもしれません。必要に応じて調整するか、諦めて下さい。
//      - M2ナットはめチャレンジはテスターとナットを利き手の親指と人差し指または中指あたりで強めに押さえながら他方の手でてテスター側を回すと、精度に問題がなければはまりやすいです。
//      - UV光造形のテストではスケーリング1.00倍でちょうどよくはまればGOOD、拡大側なら露光時間を短く、縮小側なら露光時間を長くする目安となります。
// --------

// プレビュー時の分解能
RESOLUTION_IN_PREVIEW = 0.5;
// レンダー時の分解能
RESOLUTION_IN_RENDER = 0.05;
// 細分割の基準として採用するXY軸方向の分解能 [mm]
//   (数値を)小さくする=(分解能を)高くする=高精細化
//   (数値を)大きくする=(分解能を)低くする=粗化
RESOLUTION = $preview ? RESOLUTION_IN_PREVIEW : RESOLUTION_IN_RENDER;
// テスターのネジの呼び径
DIAMETER = 2;
// テスターの凸ネジ構造部分(ナットはめテスト用)の高さ。0を与えると自動的にJIS規格のスタイル1ナットの高さを採用します。
SCREW_LENGTH = 0;
// 本来の規格に対してスケーリングを施したテスターを用意する範囲を設定します
SCALING_RANGE = [ 0.985 : 0.005 : 1.015 ];
// 土台の高さ [mm]
STAGE_HEIGHT = 1.5;
// 土台の色
STAGE_COLOR = [0.40, 0.26, 0.13 ];
// 二面幅テスト用レールの位置マーカーの幅
RAIL_MARKER_THICKNESS = 0.1;
// 二面幅テスト用レールの位置マーカーの10/10位置の色
RAIL_MARKER_COLOR_10 = [ 1, 0, 0 ];
// 二面幅テスト用レールの位置マーカーの5/10位置の色
RAIL_MARKER_COLOR_5 = [ 1, 0.5, 0 ];
// 二面幅テスト用レールの位置マーカーの1/10位置の色
RAIL_MARKER_COLOR_1 = [ 1, 1, 0 ];
// 部品の色
PARTS_COLOR = [ 1.0, 0.7, 0.4 ];
// 文字列の色
TEXT_COLOR = [ 1.0, 0.8, 0.8 ];
// 文字列の高さ [mm]
TEXT_HEIGHT = 0.3;
// 文字列のY軸方向の大きさ [mm]
TEXT_SIZE = 0.6;
// 文字列のフォント
TEXT_FONT = "Yu Gothic";

// -------- ここからは↑パラメーターを変えて使うだけなら変更しなくていい部分 --------
// 変更があったときに変える。基本的には数値でインクリメント。
REVISION = 0;
// -------- ここからソース --------

include <../utility/text.scad>
include <../usagi.scad>

tester( DIAMETER, SCREW_LENGTH, scaling_range = SCALING_RANGE );

module tester( diameter, length = 0, type = 0, scaling_range = [ 0.98 : 0.005 : 1.02 ] )
{
  dihedral_length = get_JIS_B_1177_hexagon_socket_set_parameters( diameter, length )[ 0 ];

  nut = get_JIS_B_1181_hex_nut_parameters( diameter );
  nut_outer_diameter = calculate_circumcircle_diameter( nut[ 0 ] );
  nut_height = length > 0 ? length : nut[ 1 ];

  who_am_i_texts = [ "JIS B 1177", "Hexagon socket set", str( "M", diameter ) ];

  steps = ( scaling_range[ 2 ] - scaling_range[ 0 ] ) / scaling_range[ 1 ];
  margin = nut_outer_diameter + 1;

  // { < ( 土台 ) - 土台から削るもの > + 土台へ足すもの }
  union()
  {
    difference()
    {
      make_body( diameter, margin, nut_outer_diameter, scaling_range, steps );
      make_differences( diameter, dihedral_length, nut_height, nut_outer_diameter, margin, scaling_range, who_am_i_texts );
    }
    make_unions( diameter, nut_height, margin, scaling_range );
  }
}

module make_body( diameter, margin, nut_outer_diameter, scaling_range, steps )
{
  // 土台
  color( STAGE_COLOR )
    union()
    {
      // 手前側の表示用領域
      md = margin + TEXT_SIZE * 8;
      translate( [ -margin / 2 + md / 2, -margin / 2, -STAGE_HEIGHT ] )
      difference()
      {
        cylinder( d = md, h = STAGE_HEIGHT, $fn = calculate_round_subdivision( diameter, RESOLUTION ) );
        translate( [ -md / 2, 0, -1.0e-3 ] )
          cube( [ md, margin, STAGE_HEIGHT + 10 + 2.0e-3 ]  );
      }
      // 穴用出っ張り領域
      for ( scaling = scaling_range )
      {
        scaling3 = [ scaling, scaling, 1 ];
        n = ( scaling - scaling_range[ 0 ] ) / scaling_range[ 1 ];
        translate( [ -margin / 2, n * margin, -STAGE_HEIGHT ] )
        // この領域を作成するタイミングで difference しないとプレビュー不可能な重さになるため、ここで生成しつつ穴をあけてしまう
        difference()
        {
          union()
          {
            cylinder( d = nut_outer_diameter, h = STAGE_HEIGHT, $fn = 6 );
            translate( [ 0, -margin / 2, 0 ] )
            cube( [ margin + TEXT_SIZE * 8, margin, STAGE_HEIGHT ] );
          }
          translate( [ 0, 0, -1.0e-3 ] )
          {
            scale( scaling3 )
              screw( diameter, STAGE_HEIGHT + 2.0e-3, type = -1, resolution = RESOLUTION );
            translate( [ -nut_outer_diameter, -nut_outer_diameter, 0 ] )
              cube( nut_outer_diameter );
          }
        }
      }
    }
}

module make_differences( diameter, dihedral_length, nut_height, nut_outer_diameter, margin, scaling_range, who_am_i_texts )
{
  make_who_am_i( diameter, margin, who_am_i_texts );
  make_side_info( diameter, dihedral_length, nut_height, nut_outer_diameter, margin, scaling_range );
  make_rail( diameter, dihedral_length, margin, scaling_range );
}

module make_who_am_i( diameter, margin, texts )
{echo(margin -margin / 2);
  color( TEXT_COLOR )
  {
    translate( [ -margin / 2 + ( margin + TEXT_SIZE * 8 ) / 2, -margin * 7 / 8, -TEXT_HEIGHT ] )
      linear_extrude( height = TEXT_HEIGHT + 1.0e-3 )
        for ( n = [ 0 : len( texts ) - 1 ] )
        {
          text = texts[ n ];
          translate( [ -TEXT_SIZE * len( text ) / 3, -TEXT_SIZE * n * 1.5, 0 ] )
            text1( text );
        }
    translate( [ margin / 2 + TEXT_SIZE * 8 - TEXT_HEIGHT + 1.0e-3, 0, -STAGE_HEIGHT / 2 - TEXT_SIZE / 2 ] )
      rotate( [ 90, 0, 90 ] )
        linear_extrude( height = TEXT_HEIGHT + 1.0e-3 )
          text1( str( "revision=", REVISION,"  https://github.com/usagi/usagi.scad/test/3d-printer.scad" ) );
  }
}
//  translate( [ 2.8094 + TEXT_SIZE * 8, 0, -STAGE_HEIGHT / 2 - TEXT_SIZE / 2 ] )
//    rotate( [ 90, 0, 90 ] )
//      linear_extrude( height = TEXT_HEIGHT + 1.0e-3 )
//        text1( str( "revision=", REVISION,"  https://github.com/usagi/usagi.scad/test/3d-printer.scad" ) );

module make_side_info( diameter, dihedral_length, screw_height, nut_outer_diameter, margin, scaling_range )
{
  pitch = get_screw_pitch_from_diameter( diameter );
  for ( scaling = scaling_range )
  {
    n = ( scaling - scaling_range[ 0 ] ) / scaling_range[ 1 ];

    texts =
      [ str( "←×" , number_to_string_with_digit( scaling                    , 4, true ) )
      , str( "S="   , number_to_string_with_digit( dihedral_length * scaling  , 4, true ) )
      , str( "L="   , number_to_string_with_digit( screw_height * scaling     , 4, true ) )
      , str( "P="   , number_to_string_with_digit( pitch * scaling            , 4, true ) )
      , str( "D="   , number_to_string_with_digit( diameter * scaling         , 4, true ) )
      ];

    translate( [ nut_outer_diameter / 2 + 0.5, margin * n -TEXT_SIZE / 2, -TEXT_HEIGHT ] )
      color( TEXT_COLOR )
        linear_extrude( height = TEXT_HEIGHT + 1.0e-3 )
          for ( m = [ 0 : len( texts ) - 1 ] )
            translate( [ 0, -TEXT_SIZE * m * 1.5, 0 ] )
              text1( texts[ m ] );
  }
}

module make_rail( diameter, dihedral_length, margin, scaling_range )
{
  // 二面幅のレール
  steps = ( scaling_range[ 2 ] - scaling_range[ 0 ] ) / scaling_range[ 1 ];
  x_min = dihedral_length * scaling_range[ 0 ];
  dx_min = x_min / 2;
  x_max = dihedral_length * scaling_range[ 0 ];
  dx_max = x_max / 2;
  rail_depth = STAGE_HEIGHT / 2;
  translate( [ diameter / 2 + dihedral_length / 2 + TEXT_SIZE / 2, 0, -rail_depth ] )
  {
    difference()
    {
      // レール
        linear_extrude( rail_depth + 1.0e-3 )
          polygon( [ [ -dx_min, 0 ], [ +dx_min, 0 ], [ +dx_max, margin * steps ], [ -dx_max, margin * steps ] ] );
      // 10 等分マーカー
      for ( q = [ 0 : steps ] )
        for ( p = [ 0 : 9 ] )
        {
          translate( [ 0, margin * q + margin / 10 * p, 0 ] )
            if ( p == 0 )
              color( RAIL_MARKER_COLOR_10 )
                cube( [ x_max + 1.0e-3, RAIL_MARKER_THICKNESS, rail_depth / 2 ], center = true );
            else if ( p == 5 )
              color( RAIL_MARKER_COLOR_5 )
              {
                translate( [ -dihedral_length / 2, 0, 0 ] )
                  cube( [ x_max * 4 / 5 + 1.0e-3, RAIL_MARKER_THICKNESS, rail_depth / 4 ], center = true );
                translate( [ +dihedral_length / 2, 0, 0 ] )
                  cube( [ x_max * 4 / 5 + 1.0e-3, RAIL_MARKER_THICKNESS, rail_depth / 4 ], center = true );
              }
            else
              color( RAIL_MARKER_COLOR_1 )
              {
                  cube( [ x_max * 1 / 5 + 1.0e-3, RAIL_MARKER_THICKNESS, rail_depth / 8 ], center = true );
                translate( [ -dihedral_length / 2, 0, 0 ] )
                  cube( [ x_max * 2 / 5 + 1.0e-3, RAIL_MARKER_THICKNESS, rail_depth / 8 ], center = true );
                translate( [ +dihedral_length / 2, 0, 0 ] )
                  cube( [ x_max * 2 / 5 + 1.0e-3, RAIL_MARKER_THICKNESS, rail_depth / 8 ], center = true );
              }
        }
    }
  }
}

module make_unions( diameter, nut_height, margin, scaling_range )
{
  make_positive_screws( diameter, nut_height, margin, scaling_range );
}

module make_positive_screws( diameter, nut_height, margin, scaling_range )
{
  for ( scaling = scaling_range )
  {
    scaling3 = [ scaling, scaling, scaling ];
    n = ( scaling - scaling_range[ 0 ] ) / scaling_range[ 1 ];

    translate( [ 0, n * margin, 0 ] )
    {
      // 螺子
      scale( scaling3 )
        color( PARTS_COLOR )
          screw( diameter, nut_height, type = 1, resolution = RESOLUTION );
    }
  }
}

module text1( text )
{
  text( text, TEXT_SIZE, TEXT_FONT, language = "ja", $fn = calculate_round_subdivision( TEXT_SIZE, RESOLUTION ) );
}
