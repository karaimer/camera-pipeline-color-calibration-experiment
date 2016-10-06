function avgImg_double = processRaw(fileName, cameraName)

% Get the TIFF file from RAW
% if(~exist([fileName(1:end-3) 'tiff'], 'file'))
%     system(['.\dcraw.exe -4 -D -v -T ', fileName]);
% end
pathname = [fileName '\*.tif'];
imagefiles = dir(pathname);      
nfiles = length(imagefiles);    % Number of files found

currentfilename = imagefiles(1).name;
filename = [fileName '\' currentfilename];
avgImg_double = double(imread(filename));
% avgImg_for_plot = im2double(imread(filename));

for ii=2:nfiles
   currentfilename = imagefiles(ii).name;
   filename = [fileName '\' currentfilename];
   currentimage_double = double(imread(filename));
%    currentimage_plot = im2double(imread(filename));
   avgImg_double = avgImg_double + currentimage_double;
%    avgImg_for_plot = avgImg_for_plot + currentimage_plot;
%    figure, imshow(avgImg_for_plot)
end
avgImg_double = avgImg_double / nfiles;
% avgImg_for_plot = avgImg_for_plot / nfiles;

% Iraw = double(imread([fileName(1:end-3) 'tif']));

[w, h] = size(avgImg_double);
if w > h
    avgImg_double = imrotate(avgImg_double,-90);
end
% info = getCameraInfo(cameraName);
% Iraw = demosaic(Iraw, info.BP);
% Iraw = normalize(Iraw, info.min, info.max);
% delete([fileName(1:end-3) 'tiff']);

function Y = normalize(X, min, max)
% Normalize the data into the range of 0 and 1 according to the name of the
% camera 
% input:
%       X: data needed to be normalized
%       min: minimum value
%       max: maximum value
% output:
%       Y: data after normalizing

% Normalize the data X
X = double(X);
Y = (X - min) / (max - min);
Y(Y<0) = 0;
Y(Y>1) = 1;


function info = getCameraInfo(cameraName)
switch(cameraName)
        case 'Canon_1D'
        info.BP = 'rggb';
        info.max = 15100;
        info.min = 1024;
    case 'Canon_550D'
        info.BP = 'rggb';
        info.max = 15000;
        info.min = 2048;
    case 'Canon_600D'
        info.BP = 'rggb';
        info.max = 15000;
        info.min = 2048;
        
    case 'Fujifilm_X-M1'
        info.BP = 'grbg';
        info.max = 4094;
        info.min = 256;
    case 'Nikon_D40'
        info.BP = 'bggr';
        info.max = 3880;
        info.min = 0;
    case 'Nikon_D3000'
        info.BP = 'gbrg';
        info.max = 3880;
        info.min = 0;
    case 'Nikon_D5200'
        info.BP = 'rggb';
        info.max = 15892;
        info.min = 0;
        
   case 'Olympus_E-PL6'
        info.BP = 'rggb';
        info.max = 4000;
        info.min = 255;
    case 'Panasonic_GX1'
        info.BP = 'grbg';
        info.max = 3956;
        info.min = 143;
    case 'Pentax_K7'
        info.BP = 'bggr';
        info.max = 4095;
        info.min = 0;
    case 'Samsung_NX2000'
        info.BP = 'gbrg';
        info.max = 4095;
        info.min = 0;
    case 'Sony_A57'
        info.BP = 'rggb';
        info.max = 4075;
        info.min = 128;
end