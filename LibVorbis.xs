#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <vorbis/codec.h>
#include <vorbis/vorbisenc.h>
#include <vorbis/vorbisfile.h>

#include "const-c.inc"

MODULE = Ogg::Vorbis::LibVorbis		PACKAGE = Ogg::Vorbis::LibVorbis		

INCLUDE: const-xs.inc
