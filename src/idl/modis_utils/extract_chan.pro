;*========================================================================
;* extract_chan.pro - extract a channel file from a level1b modis file
;*
;* 25-Oct-2000  Terry Haran  tharan@colorado.edu  492-1847
;* National Snow & Ice Data Center, University of Colorado, Boulder
;$Header: /export/data/modis/src/idl/fornav/extract_chan.pro,v 1.7 2001/02/10 00:20:19 haran Exp haran $
;*========================================================================*/

;+
; NAME:
;	extract_chan
;
; PURPOSE:
;
; CATEGORY:
;	Modis.
;
; CALLING SEQUENCE:
;       extract_chan, hdf_file, tag, channel, $
;                     /get_latlon, conversion=conversion, $
;                     swath_rows=swath_rows, $
;                     swath_row_first=swath_row_first
;
; ARGUMENTS:         
;
; KEYWORDS:
;
; EXAMPLE:
;
; ALGORITHM:
;
; REFERENCE:
;-

PRO extract_chan, hdf_file, tag, channel, $
                  get_latlon=get_latlon, conversion=conversion, $
                  swath_rows=swath_rows, $
                  swath_row_first=swath_row_first

  usage = 'usage: extract_chan, hdf_file, tag, channel ' + $
          '[, /get_latlon]' + $
          '[, conversion=conversion]' + $
          '[, swath_rows=swath_rows]' + $
          '[, swath_row_first=swath_row_first]'


  if n_params() ne 3 then $
    message, usage
  if n_elements(get_latlon) eq 0 then $
    get_latlon = 0
  if n_elements(conversion) eq 0 then $
    conversion = 'raw'
  if n_elements(swath_rows) eq 0 then $
    swath_rows = 0
  if n_elements(swath_row_first) eq 0 then $
    swath_row_first = 0

  raw = 0
  corrected = 0
  reflectance = 0
  temperature = 0

  if conversion eq 'raw' then $
    raw = 1
  if conversion eq 'corrected' then $
    corrected = 1
  if conversion eq 'reflectance' then $
    reflectance = 1
  if conversion eq 'temperature' then $
    temperature = 1

  print, 'extract_chan:'
  print, '  hdf_file:       ', hdf_file
  print, '  channel:        ', channel
  print, '  get_latlon:     ', get_latlon
  print, '  conversion:     ', conversion
  print, '  swath_rows:     ', swath_rows
  print, '  swath_row_first:', swath_row_first

  modis_type = strmid(hdf_file, 0, 5)
  area = [0L, swath_row_first, 999999L, swath_rows]
  if get_latlon ne 0 then begin
      if modis_type eq 'MOD02' then begin
          modis_level1b_read, hdf_file, channel, image, $
            latitude=lat, longitude=lon, $
            raw=raw, corrected=corrected, reflectance=reflectance, $
            temperature=temperature, area=area
      endif else if modis_type eq 'MOD10' then begin
          modis_snow_read, hdf_file, channel, image, $
            latitude=lat, longitude=lon, area=area
      endif else begin
          modis_ice_read, hdf_file, channel, image, $
            latitude=lat, longitude=lon, area=area
      endelse
      lat_dimen = size(lat, /dimensions)
      cols = lat_dimen[0]
      rows = lat_dimen[1]
      cols_string = string(cols, format='(I5.5)')
      rows_string = string(rows, format='(I5.5)')
      lat_file_out = tag + '_latf_' + $
        cols_string + '_' + rows_string + '.img'
      lon_file_out = tag + '_lonf_' + $
        cols_string + '_' + rows_string + '.img'
      openw, lat_lun, lat_file_out, /get_lun
      openw, lon_lun, lon_file_out, /get_lun
      writeu, lat_lun, lat
      writeu, lon_lun, lon
      free_lun, lat_lun
      free_lun, lon_lun
  endif else begin
      if modis_type eq 'MOD02' then begin 
          modis_level1b_read, hdf_file, channel, image, $
            raw=raw, corrected=corrected, reflectance=reflectance, $
            temperature=temperature, area=area
      endif else if modis_type eq 'MOD10' then begin
          modis_snow_read, hdf_file, channel, image, area=area
      endif else begin
          modis_ice_read, hdf_file, channel, image, area=area
      endelse
  endelse
  image_dimen = size(image, /dimensions)
  channel_string = string(channel, format='(I2.2)')
  conv_string = strmid(conversion, 0, 3)
  cols_string = string(image_dimen[0], format='(I5.5)')
  rows_string = string(image_dimen[1], format='(I5.5)')
  file_out = tag + '_ch' + channel_string + '_' + $
             conv_string + '_' + $
             cols_string + '_' + rows_string + '.img'
  openw, lun, file_out, /get_lun
  writeu, lun, image
  free_lun, lun

END ; extract_chan
