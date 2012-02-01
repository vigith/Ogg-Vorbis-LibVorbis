use Test::More tests => 18;
BEGIN { use_ok('Ogg::Vorbis::LibVorbis'); $|++ };

use strict;
use Ogg::LibOgg ':all';
use Audio::Wav;


## Wav Audio File Info
my $wav = new Audio::Wav; 
my $read = $wav->read("t/test.wav"); 
my $details = $read->details();
my $channels = $details->{channels}; # 2
my $rate = $details->{sample_rate};  # 22050
my $length = $read->length_samples(); # 48066
ok(1, "Audio::Wav Read");


## Ogg Pages
my $op_h      = make_ogg_packet();
my $op_hcomm = make_ogg_packet();
my $op_hcode = make_ogg_packet();
my $op_audio   = make_ogg_packet();
my $os   = make_ogg_stream_state();
my $og = make_ogg_page();
ok(1, "Basic Ogg Setup");

my $vi = Ogg::Vorbis::LibVorbis::make_vorbis_info(); # vorbis_info
ok($vi, "vorbis_info");

my $vc = Ogg::Vorbis::LibVorbis::make_vorbis_comment(); # vorbis_comment
ok($vc, "vorbis_comment");

my $vb = Ogg::Vorbis::LibVorbis::make_vorbis_block(); # vorbis_block
ok($vb, "make_vorbis_block");

Ogg::Vorbis::LibVorbis::vorbis_info_init($vi);
ok(1, "vorbis_info_init");

my $v = Ogg::Vorbis::LibVorbis::make_vorbis_dsp_state(); # vorbis_dsp_state
ok($v, "vorbis_dsp_state");

my $ret = Ogg::Vorbis::LibVorbis::vorbis_encode_init_vbr($vi, $channels, $rate, 1.0);
ok($ret == 0, "vorbis_encode_init_vbr");

$ret = Ogg::Vorbis::LibVorbis::vorbis_analysis_init($v, $vi);
ok( $ret == 0, "vorbis_analysis_init");

$ret = Ogg::Vorbis::LibVorbis::vorbis_encode_setup_init($vi);
ok($ret == 0, "vorbis_encode_setup_init");

Ogg::Vorbis::LibVorbis::vorbis_comment_init($vc);
ok(1, "vorbis_comment_init");

$ret = Ogg::Vorbis::LibVorbis::vorbis_block_init($v, $vb);
ok($ret == 0, "vorbis_block_init");

$ret = Ogg::Vorbis::LibVorbis::vorbis_analysis_headerout($v, $vc, $op_h, $op_hcomm, $op_hcode);
ok($ret == 0, "vorbis_analysis_headerout");

$ret = ogg_stream_init($os, int(rand(1000)));
ok($ret == 0, "ogg_stream_init");

$ret = ogg_stream_packetin($os, $op_h);
ok($ret == 0, "ogg_stream_packetin");

$ret = ogg_stream_packetin($os, $op_hcomm);
ok($ret == 0, "ogg_stream_packetin");

$ret = ogg_stream_packetin($os, $op_hcode);
ok($ret == 0, "ogg_stream_packetin");

my $filename = "t/vorbis_encode.ogg";
open OUT, ">", "$filename" or die "can't open $filename for writing [$!]";
binmode OUT;

save_page();

close OUT;

################
# SUB ROUTINES #
################

sub save_page {
  ## forms packets to pages 
  if (ogg_stream_pageout($os, $og) != 0) {
    my $h_page = get_ogg_page($og);
    ## writes the header and body 
    print OUT $h_page->{header};
    print OUT $h_page->{body};
  } else {
    # pass, we don't have to worry about insufficient data
  }
}

sub add_frames {
  
}
