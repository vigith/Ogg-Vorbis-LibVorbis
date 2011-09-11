# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Ogg-Vorbis-LibVorbis.t'

use Test::More tests => 11;
BEGIN { use_ok('Ogg::Vorbis::LibVorbis') };


my $fail = 0;
foreach my $constname (qw(
	INITSET NOTOPEN OPENED OV_EBADHEADER OV_EBADLINK OV_EBADPACKET
	OV_ECTL_IBLOCK_GET OV_ECTL_IBLOCK_SET OV_ECTL_LOWPASS_GET
	OV_ECTL_LOWPASS_SET OV_ECTL_RATEMANAGE2_GET OV_ECTL_RATEMANAGE2_SET
	OV_ECTL_RATEMANAGE_AVG OV_ECTL_RATEMANAGE_GET OV_ECTL_RATEMANAGE_HARD
	OV_ECTL_RATEMANAGE_SET OV_EFAULT OV_EIMPL OV_EINVAL OV_ENOSEEK
	OV_ENOTAUDIO OV_ENOTVORBIS OV_EOF OV_EREAD OV_EVERSION OV_FALSE OV_HOLE
	PARTOPEN STREAMSET)) {
  next if (eval "my \$a = $constname; 1");
  if ($@ =~ /^Your vendor has not defined Ogg::Vorbis::LibVorbis macro $constname/) {
    print "# pass: $@";
  } else {
    print "# fail: $@";
    $fail = 1;
  }

}

ok( $fail == 0 , 'Constants' );

## END GENERATED ##

# Create Data Structures
my $vf = Ogg::Vorbis::LibVorbis::make_oggvorbis_file(); # OggVorbis_File
ok($vf, "OggVorbis_File");

my $vi = Ogg::Vorbis::LibVorbis::make_vorbis_info(); # vorbis_info
ok($vi, "vorbis_info");

# Open Vorbis File
my $filename = "t/test.ogg";
open IN, $filename or die "can't open [$filename] : $!";
my $status = Ogg::Vorbis::LibVorbis::ov_open(*IN,  $vf, 0, 0);
ok($status == 0, "ov_open");

# ov_seekable
$status = Ogg::Vorbis::LibVorbis::ov_seekable($vf);
ok($status != 0, "ov_seekable");

# ov_time_total
$status = Ogg::Vorbis::LibVorbis::ov_time_total($vf, -1);
ok($status > 0, "ov_time_total");

# ov_time_seek
$status = Ogg::Vorbis::LibVorbis::ov_time_seek($vf, 1);
ok($status == 0, "ov_time_seek");

# ov_streams
$status = Ogg::Vorbis::LibVorbis::ov_streams($vf);
ok($status, "ov_streams");

# ov_info
$vi = Ogg::Vorbis::LibVorbis::ov_info($vf, 1); # 1 'coz we know our test .vob file has only 1 bitstream
ok($$vi, "ov_info");

# ov_clear
$status = Ogg::Vorbis::LibVorbis::ov_clear($vf);
ok($status == 0, "ov_clear");
