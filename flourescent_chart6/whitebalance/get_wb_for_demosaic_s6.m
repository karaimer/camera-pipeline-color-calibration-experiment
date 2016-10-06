
close all
clear all

load MacbethColorCheckerData.mat

imagefiles = dir('C:\Users\workshop\Documents\hakki\FALL15\Research\colorfulchart\chart6\flourescent\flourescent\samsung_s6_edge\*.dng');      
nfiles = length(imagefiles);    % Number of files found

s6_wb =zeros(nfiles, 3);
wb_info = cell(nfiles,2);

for ii=1:1
    currentfilename = imagefiles(ii).name;
    filename = ['C:\Users\workshop\Documents\hakki\FALL15\Research\colorfulchart\chart6\flourescent\flourescent\samsung_s6_edge\' currentfilename];
    s6_demosaiced_double = double(readDNGdemosaicRaw(filename));
    s6_demosaiced = im2double(readDNGdemosaicRaw(filename));

    masks = makeChartMask(s6_demosaiced,chart,colors);

    % Create a binary image ("mask") from the ROI object.
    mask_s6 = masks.white.mask;
    % figure, imshow(mask_nexus)

    s6_r = s6_demosaiced_double(:,:,1) .* mask_s6;
    s6_g = s6_demosaiced_double(:,:,2) .* mask_s6;
    s6_b = s6_demosaiced_double(:,:,3) .* mask_s6;
    % figure, imshow(nexus_r)
    % figure, imshow(nexus_r)
    % figure, imshow(nexus_r)

    pixelsWithinMask = s6_r(mask_s6);
    mean_s6_r = mean(pixelsWithinMask);
    pixelsWithinMask = s6_g(mask_s6);
    mean_s6_g = mean(pixelsWithinMask);
    pixelsWithinMask = s6_b(mask_s6);
    mean_s6_b = mean(pixelsWithinMask);% or equivalent mean( nonzeros(s6_b) )

    s6_patch = [mean_s6_r; mean_s6_g; mean_s6_b];
    % lg_wb = wb_result ./ lg_patch;
    s6_wb(ii,:) = s6_patch./s6_patch(2);    
    wb_info{ii,1} = currentfilename; 
    wb_info{ii,2} = s6_wb(ii,:); 
    clear mask_s6 masks
end

%% to get wb we need white patch's average do the following. 

save('s6_wb_cameraSpace_3k.mat','wb_info');
