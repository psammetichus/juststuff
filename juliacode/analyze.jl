type AnalyzeImg
 imgarray::AbstractArray
 voxDims::Array{Float32}
 dtype::DataType

function parseAnalyze(hdrFile::UTF8String imgFile::UTF8String)

imgd = open(hdrFile, "r") do hdrStr
  hdrSize =  read(hdrStr, UInt32, 1)
  seek(hdrStr, 40)
  hdr_dims = read(hdrStr, UInt16, 8)
  seek(hdrStr, 40+30)
  dtype = begin
   d = read(hdrStr, UInt16, 1)
   if d == 0
    Float64 #unknown datatype, default to Float64
   elseif d == 1
    Bool #going to die, since this is actually 8 bits
   elseif d == 2
    UInt8
   elseif d == 4
    Int16
   elseif d == 8
    Int32
   elseif d == 16
    Float32
   elseif d == 32
    Complex{Float32}
   elseif d == 64
    Float64
   elseif d == 128
    Array{UInt8}(3) #the "RGB" format, which is I guess three packed uint8s?
   elseif d == 255
    Float64 #supposed to be DT_ALL whatever the fuck that means; default to float
   end
  end
  bitpix = seek(hdrStr, 40+32); read(hdrStr, UInt16, 1)
  @assert sizeof(dtype) == bitpix
  imageData = Array{dtype}([hdr_dims[i] for i in 2:(hdr_dims[1]+1)]...)
  pixdim = seek(hdrStr, 40+36); read(hdrStr, Float32, 8)
  vox_dims = pixdim[1:pixdim[1]+1]
  AnalzyeImg(imageData, vox_dims, dtype)
  end #open

  open(imgFile, "r") do img
    read!(img, imgd.imgarray)
  end #open
return imgd
