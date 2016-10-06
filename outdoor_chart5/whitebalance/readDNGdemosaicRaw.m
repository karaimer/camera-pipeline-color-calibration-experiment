function [ raw ] = readDNGdemosaicRaw( fileName )
%readRaw Summary of this function goes here
%   Detailed explanation goes here
inputFileName = fileName;
stage3OutputFileName = [inputFileName(1:end-4) '_stage3.tif'];

% adobe_result = [inputFileName(1:end-4) '_adobe.dng'];
system_command = ['.\dng_validate.exe -3 '  stage3OutputFileName ' ' inputFileName];
system(system_command);

% - - - Reading Adobe's Result file - - - I'll use later. 
warning off MATLAB:tifflib:TIFFReadDirectory:libraryWarning
% t = Tiff(adobe_result,'r');
% offsets = getTag(t,'SubIFD');
% setSubDirectory(t,offsets(1));
% raw = read(t);
% close(t);
% meta_info = imfinfo(adobe_result);
% x_origin = meta_info.SubIFDs{1}.ActiveArea(2)+1;
% width = meta_info.SubIFDs{1}.DefaultCropSize(1);
% y_origin = meta_info.SubIFDs{1}.ActiveArea(1)+1;
% height = meta_info.SubIFDs{1}.DefaultCropSize(2);
% raw =double(raw(y_origin:y_origin+height-1,x_origin:x_origin+width-1));

raw = imread(stage3OutputFileName);
   
% already normalized
% after adobe stage2- - - Linearize - - -dont apply linearize twice
% lin_bayer = (raw-64)/(1023-64);
% lin_bayer = max(0,min(lin_bayer,1));
    
delete(stage3OutputFileName);
% delete(adobe_result);


% Iraw = normalize(Iraw, min(Iraw(:)), max(Iraw(:))); already normalized
% after adobe stage2

% these steps will be applied after wb.
% camera_info = getCameraInfo('Nexus_6');
% Iraw = uint16(Iraw);
% Iraw = demosaic(Iraw, camera_info.BP);



% % - - - Linearize - - -
% if isfield(meta_info.SubIFDs{1},'LinearizationTable')
%     ltab=meta_info.SubIFDs{1}.LinearizationTable;
%     raw = ltab(raw+1);
% end
% black = meta_info.SubIFDs{1}.BlackLevel(1);
% saturation = meta_info.SubIFDs{1}.WhiteLevel;
% lin_bayer = (raw-black)/(saturation-black);
% lin_bayer = max(0,min(lin_bayer,1));

% just plot the wb info
%     wb_multipliers = (meta_info.AsShotNeutral).^-1;
%     wb_multipliers = wb_multipliers/wb_multipliers(2) 
end

