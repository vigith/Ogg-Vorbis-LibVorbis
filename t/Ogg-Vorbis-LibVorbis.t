# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Ogg-Vorbis-LibVorbis.t'

#########################

# change 'tests => 2' to 'tests => last_test_to_print';

use Test::More tests => 2;
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
#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

