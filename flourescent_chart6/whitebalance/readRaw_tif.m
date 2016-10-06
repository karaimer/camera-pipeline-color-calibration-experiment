function Iraw = readRaw_tif(fileName)
% Get the TIFF file from RAW
if(~exist([fileName(1:end-3) 'tif'], 'file'))
    system(['.\dcraw.exe -4 -D -v -T ', fileName]);
end
Iraw = imread([fileName(1:end-3) 'tif']);
% delete([fileName(1:end-3) 'tiff']);