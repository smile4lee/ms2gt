FUNCTION fix_modis_250, image
coeffs = [0.9994515103, $ ; increased by 0.003 over Mark's number
          1.0020342508, $ ; increased by 0.001 
          1.0031991534, $
          1.0045418857, $
          1.0048417388, $
          1.0042399897, $
          1.0035183564, $
          1.0024332692, $
          1.0011955317, $
          1.0004481912, $
          0.9994905873, $
          0.9991745534, $
          0.9984699475, $
          0.9980182321, $
          0.9986817376, $
          0.9993878855, $
          0.9985251621, $
          0.9999686404, $
          0.9996179939, $
          1.0000000000, $
          1.0002329090, $
          1.0005215981, $
          1.0019718826, $
          1.0011218774, $
          1.0014979235, $
          1.0021325089, $
          1.0020614252, $
          1.0021370344, $
          1.0027051133, $
          1.0023170736, $ ; increased by 0.001 over Mark's number
          1.0036402579, $
          1.0044137375, $
          1.0075717742, $
          1.0088212590, $
          1.0110360007, $
          1.0117578509, $
          1.0108138919, $
          1.0108824534, $
          1.0096043691, $
          1.0082523096]   ; increased by 0.0005
image_size = size(image)
cols = image_size[1]
rows = image_size[2]
scans = rows / 40
c_array = fltarr(cols, 40)
for col = 0, cols - 1 do $
  c_array[col,*] = transpose(coeffs)
for scan = 0, scans - 1 do begin
    row_start = scan * 40
    row_end = row_start + 39
    image[*,row_start:row_end] = $
      fix(round(image[*,row_start:row_end] * c_array))
endfor
return, image
end
