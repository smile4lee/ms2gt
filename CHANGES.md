As of 0.7 there is an updated version of ppgc.html, "Points,
Pixels, Grids, and Cells", which describes the updated gpd
syntax. Included in the grids directory are some examples of gpd files
using the new format.

As of 0.8, mod02.pl was modified to use a row offset of 0.5 when
interpolating data from 1 km to 500 m resolution, and a row offset of 1.5
when interpolating data from 1 km to 250 m resolution. Also, congridx.pro
was modified to allow for fractional offsets. These modifications were
implemented to fix geolocation problems arising from apparently incorrect
row offsets that are specified in the HDF-EOS structural metadata for
geolocation mappings.

As of 0.9, the maps directory was replaced with the mapx directory
containing the latest (as of 25 August 2004) unreleased version of the
mapx library. Also, mod02.pl has been modified to accept the fix250
parameter which allows for destriping and/or solar zenith angle correction
of MOD02QKM and MOD03 data. Finally, the lle2cre utility has been added to
the distribution to facilitate the conversion of ASCII latitude,
longitude, elevation files to column, row, elevation files for a
particular gpd file. Type lle2cre -h for the syntax.

As of 0.10, several modifications to mod02.pl were made in support of the
MODIS Mosaic of Antarctica (MOA) project. In support of these changes,
several programs were also added including extract_valid_scans.pro,
extract_region.c, insert_region.c, make_mask.c, and apply_mask.c.

As of 0.11, several modifications were made to mod02.pl and
modis_adjust.pro in support of MOA version 11 and higher including keeping
the mask file and using 16-bit solar zenith values for solar zenith
normalization.

As of 0.12, modifications to extract_valid_scans.pro and
modis_level1b_read.pro were made such that valid scans are now determined
exclusively by the latitude array. However, out of range data values are
still mapped to the fill value for valid scans. Added checks to make sure
that fix250 is specified with correct chanfile and ancilfile
specifications. Fixed error messages in extract_valid_scans.pro and fixed
modis_ancillary_read.pro so that it works with MOD021KM data.

As of 0.13, a bug was fixed in mod02.pl that caused problems when
tile_cols was equal to 1 but tile_rows was greater than 1.

As of 0.14, a bug was fixed in extract_chan.pro that cause problems with
processing MYD35 files using mod35_l2.pl (thanks to Ian Joughin who found
and fixed this).

As of 0.15, mod10_l2.pl and mod29.pl have been updated for MODIS
collection 5 products.

As of 0.16, grid_convert.pl (which calls grids.pl and C program
grid_convert) can be used to convert lat-lon or col-row pairs to col-row
or lat-lon pairs, respectively. Type grid_convert.pl without any
parameters to get the syntax.

As of 0.17, mod02.pl has been modified to include support for outputting
the sine and cosine of sensor azimuth and solar azimuth angles as either
floating-point values or as signed integers scaled by 30000. This required
additional changes to extract_ancil.pro. Type mod02.pl without any
parameters for the syntax. Also, modis_ancillary_read.pro was modified so
that 360 is no longer added to scaled ancillary values that are less than
0.

As of 0.18, a bug in mod35_l2.pl has been fixed to handle the case of
using lat-lon data in the MxD35_L2 hdf file rather than from a MxD03 file.
This also required changes in interp_colrow.pro including the addition of
a fill keyword, allowing colsout > interp_factor * colsin, and filling the
excess colsout columns of output row and column values with the fill
value. The bug arose because apparently the 5km latitude and longitude
arrays in a MxD35_L2 hdf file have one column less than the same arrays in
a corresponding MxD021KM hdf file.

As of 0.19, a bug in src/utils/Makefile has been fixed such that "make
clean" now removes all *.o files in the src/utils/ directory (thanks to
Jesse Allen for finding this problem).

As of 0.20, the swath_width_fraction parameter has been added to mod02.pl
in order to fix a problem seen in the use of Universal Transverse Mercator
(UTM) whereby anamalous streaks would appear in the output grids. The problem
was due to the fact that UTM is unique in that accuracy of forward and
inverse mappings decreases rapidly for regions outside of the specified
UTM zone. This had the effect of introducing noise into the output image
when retrieving pixels from the edges of the swath. This has been fixed by
restricting the swath center fraction used to 0.75 of the total swath
width when a UTM projection is specified in gpdfile.

As of 0.20, a new program called "projection" was written to retrieve the
standard projection name string from a gpd file so that mod02.pl can
determine when a UTM projection has been specified. The utility program
apply_mask was modified to accept the -S option to allow a mask file to be
in the same format specified for the input file, and to print an error if
bytes_per_cell is 8 and either the -b or -B byte_swap options are
specified.

As of 0.21, the mapx library used in MS2GT has been changed to use the
current subversion-controlled mapx release 0.10. This appears to have fixed a
problem on some installations whereby certain programs that use the mapx
library such as "gridsize" and "projection" caused "Segmentation fault"
errors.

As of 0.22, the utility xy2ll has been added which converts ascii x-y pairs
to latitude-longitude pairs; and the utility ll2xy has been added which
converts latitude-longitude pairs to x-y pairs.

As of 0.23, grids.c and grids.h were modified such that for certain
projections, new members of the mapx grid_class stucture, namely u_min
and u_max, are initialized to minus and plus the scaled earth radius
times pi, respectively. The projections for which this initialization
is performed include Cylindrical Equal Area (both spherical and
ellipsoidal), Mercator, Mollweide, Sinusoidal, Cylindrical
Equidistant, Interrupted Homolosine Equal Area, and Integerized
Sinusoidal; for all other projections, u_min and u_max are initialized
to 0. Then for both forward and inverse transformations: if the
computed u value is greater than u_max, then 2 * u_max is subtracted
from u; and if the computed u value is less than u_min, then 2 * u_min
is added to u. This effectively allows associated column values to be
monotonic across the +180/-180 longitude boundary, and avoids "holes"
and "garbage" from appearing in gridded output images created by
mod02.pl for grids that include or are close to the boundary.

As of 0.24, fornav.c was modified to fix a bug such that garbage output
was produced when both averaging and a non-zero fill value were specified
in chanfile of the mod02.pl script. Thanks to Yinghui Liu of SSEC U. of
Wisconsin for reporting this bug.

As of 0.25, fornav.c was modified to fix a bug such that the -s option
was not working correctly due to incorrect testing of the return value
from lseek64. Thanks to Peter Keehn, NOAA Affiliate, for reporting this
bug.

As of 0.26, grids.c was modified such that the modifications described
in the 0.23 note above were confined to the Cylindrical Equidistant
projection only. The modifications to grids.c in 0.23 caused problems
with the other projections, particularly to the Cylindrical Equal Area
Ellipsoidal projection.

As of 0.27, wdbpltc.c routine ufree(), changed return to return(0) since
ufree() is defined as returning an int. Thanks to Jack Saba of NASA Goddard
who reported this bug which was preventing successful compilation under Mac
OSX 10.8.

As of 0.28, additional make files src/Makefile.mac and
src/fornav/Makefile.mac were added to the distribution to support
making MS2GT for Mac OSX 10.9.5.  File src/fornav/fornav.c was
modified to conditionally compile code for the Mac such that lseek()
is called in place of lseek64() because lseek() can be used on files
larger than 2^32 bytes on Mac OSX, and so lseek64() does not exist on
Mac OSX.The above additions also included src/utils/Makefile.mac; and
the above modifications were also made to files apply_mask.c,
extract_region.c, insert_region.c, and make_mask.c all in
src/utils. Note that when building the executables for Mac OSX, the
"make all" command should be replaced with "make all -f Makefile.mac".

As of 0.29, a bug in fornav has been fixed wherein setting grid fill
using the -F option to a non-zero value was actually using a value of
0 when maximum weight mode was set. Thanks to Yinghui Liu of
CIMSS/SSEC at the University of Wisconsin for reporting this bug.
