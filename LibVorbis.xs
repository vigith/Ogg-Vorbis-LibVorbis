#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include <stdio.h>
#include <ogg/ogg.h>
#include <vorbis/codec.h>
#include <vorbis/vorbisenc.h>
#include <vorbis/vorbisfile.h>

#include "const-c.inc"

typedef PerlIO *        OutputStream;
typedef PerlIO *        InputStream;

MODULE = Ogg::Vorbis::LibVorbis		PACKAGE = Ogg::Vorbis::LibVorbis	PREFIX = LibVorbis_

INCLUDE: const-xs.inc

PROTOTYPES: DISABLE

=head1 Functions (malloc)

L<http://www.xiph.org/vorbis/doc/vorbisfile/datastructures.html>

=cut

=head2 make_oggvorbis_file

Creates a memory allocation for OggVorbis_File datastructure

-Input:
  Void

-Output:
  Memory Pointer

=cut
OggVorbis_File *
LibVorbis_make_oggvorbis_file()
  PREINIT:
    OggVorbis_File *memory;
  CODE:
    New(0, memory, 1, OggVorbis_File);
    RETVAL = memory;
  OUTPUT:
    RETVAL  


=head1 make_vorbis_info

Creates a memory allocation for vorbis_info

-Input:
  void

-Output:
  Memory Pointer to vorbis_info

=cut

vorbis_info *
LibVorbis_make_vorbis_info()
  PREINIT:
    vorbis_info *	memory;
  CODE:
    New(0, memory, 1, vorbis_info);
    RETVAL = memory;
  OUTPUT:
    RETVAL  


=head1 Functions (vorbisfile)

L<http://www.xiph.org/vorbis/doc/vorbisfile/reference.html>

=cut

=head2 ov_open

ov_open is one of three initialization functions used to initialize an OggVorbis_File 
structure and prepare a bitstream for playback. 

L<http://www.xiph.org/vorbis/doc/vorbisfile/ov_open.html>

-Input:
  FILE *, File pointer to an already opened file or pipe,
  OggVorbis_File, A pointer to the OggVorbis_File structure,
  char *, Typically set to NULL,
  int, Typically set to 0.

-Output:
  0 indicates succes,
  less than zero for failure:

    OV_EREAD - A read from media returned an error.
    OV_ENOTVORBIS - Bitstream is not Vorbis data.
    OV_EVERSION - Vorbis version mismatch.
    OV_EBADHEADER - Invalid Vorbis bitstream header.
    OV_EFAULT - Internal logic fault; indicates a bug or heap/stack corruption.

=cut

int
LibVorbis_ov_open(f, vf, initial, ibytes)
    InputStream	     f
    OggVorbis_File * vf
    char *	     initial
    int		     ibytes
  PREINIT:
    FILE *fp = PerlIO_findFILE(f);
  CODE:
    /* check whether it is a valid file handler */
    if (fp == (FILE*) 0 || fileno(fp) <= 0) {   
      Perl_croak(aTHX_ "Expected Open FILE HANDLER");
    }
    /* open the vorbis file */
    RETVAL = ov_open(fp, vf, initial, ibytes);
  OUTPUT:
    RETVAL


=head2 ov_clear

ov_clear() to clear the decoder's buffers and close the file

L<http://www.xiph.org/vorbis/doc/vorbisfile/ov_clear.html>

-Input:
  OggVorbis_File

-Output:
  0 for success

=cut

int
LibVorbis_ov_clear(vf)
    OggVorbis_File *	vf
  CODE:
    RETVAL = ov_clear(vf);
  OUTPUT:
    RETVAL


=head2 ov_seekable

This indicates whether or not the bitstream is seekable. 

L<http://www.xiph.org/vorbis/doc/vorbisfile/ov_seekable.html>

-Input:
  OggVorbis_File

-Output:
  0 indicates that the file is not seekable.
  nonzero indicates that the file is seekable.

=cut

int
LibVorbis_ov_seekable(vf)
    OggVorbis_File *	vf
  CODE:
    RETVAL = ov_seekable(vf);
  OUTPUT:
    RETVAL


=head2 ov_time_total

Returns the total time in seconds of the physical bitstream or a specified logical bitstream. 

L<http://www.xiph.org/vorbis/doc/vorbisfile/ov_time_total.html>

-Input:
  OggVorbis_File,
  int (link to the desired logical bitstream)

-Output:
  OV_EINVAL means that the argument was invalid. In this case, the requested bitstream did not exist or the bitstream is nonseekable.
  n total length in seconds of content if i=-1.
  n length in seconds of logical bitstream if i=0 to n.

=cut

double
LibVorbis_ov_time_total(vf, i)
    OggVorbis_File *	    vf
    int		   	    i
  CODE:
    RETVAL = ov_time_total(vf, i);
  OUTPUT:
    RETVAL


=head2 ov_time_seek

For seekable streams, this seeks to the given time.

L<http://www.xiph.org/vorbis/doc/vorbisfile/ov_time_seek.html>

-Input:
  OggVorbis_File,
  double, (location to seek in seconds)

-Output:
  0 for success
  nonzero indicates failure, described by several error codes:

    OV_ENOSEEK - Bitstream is not seekable.
    OV_EINVAL - Invalid argument value; possibly called with an OggVorbis_File structure that isn't open.
    OV_EREAD - A read from media returned an error.
    OV_EFAULT - Internal logic fault; indicates a bug or heap/stack corruption.
    OV_EBADLINK - Invalid stream section supplied to libvorbisfile, or the requested link is corrupt.

=cut

int
LibVorbis_ov_time_seek(vf, s)
    OggVorbis_File *	   vf
    double	   	   s
  CODE:
    RETVAL = ov_time_seek(vf, s);
  OUTPUT:
    RETVAL  


=head ov_streams

Returns the number of logical bitstreams within our physical bitstream. 

L<http://www.xiph.org/vorbis/doc/vorbisfile/ov_streams.html>

-Input:
  OggVorbis_File

-Output:
  1 indicates a single logical bitstream or an unseekable file,
  n indicates the number of logical bitstreams.

=cut

long
LibVorbis_ov_streams(vf)
    OggVorbis_File *	vf
  CODE:
    RETVAL = ov_streams(vf);
  OUTPUT:
    RETVAL


=head2 ov_info

Returns the vorbis_info struct for the specified bitstream.

L<http://www.xiph.org/vorbis/doc/vorbisfile/ov_info.html>

-Input:
  OggVorbis_File,
  int (link to desired logical bitstream)

-Output:
  Returns the vorbis_info struct for the specified bitstream,
  NULL if the specified bitstream does not exist or the file has been initialized improperly.

=cut

vorbis_info *
LibVorbis_ov_info(vf, link)
    OggVorbis_File *  vf
    int		      link
  CODE:
    RETVAL = ov_info(vf, link);
  OUTPUT:
    RETVAL