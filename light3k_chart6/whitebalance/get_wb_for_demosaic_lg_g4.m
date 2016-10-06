close all
clear all

load MacbethColorCheckerData.mat

imagefiles = dir('C:\Users\workshop\Documents\hakki\FALL15\Research\colorfulchart\chart6\light_3K_all_v2\light_3K\lg_g4\*.dng');      
nfiles = length(imagefiles);    % Number of files found

lg_wb =zeros(nfiles, 3);
wb_info = cell(nfiles,2);

for ii=1:1
    currentfilename = imagefiles(ii).name;
    filename = ['C:\Users\workshop\Documents\hakki\FALL15\Research\colorfulchart\chart6\light_3K_all_v2\light_3K\lg_g4\' currentfilename];
    lg_demosaiced_double = double(readDNGdemosaicRaw(filename));
    lg_demosaiced = im2double(readDNGdemosaicRaw(filename));

    masks = makeChartMask(lg_demosaiced,chart,colors);

    % Create a binary image ("mask") from the ROI object.
    mask_lg = masks.white.mask;
    % figure, imshow(mask_nexus)

    lg_r = lg_demosaiced_double(:,:,1) .* mask_lg;
    lg_g = lg_demosaiced_double(:,:,2) .* mask_lg;
    lg_b = lg_demosaiced_double(:,:,3) .* mask_lg;
    % figure, imshow(nexus_r)
    % figure, imshow(nexus_r)
    % figure, imshow(nexus_r)

    pixelsWithinMask = lg_r(mask_lg);
    mean_lg_r = mean(pixelsWithinMask);
    pixelsWithinMask = lg_g(mask_lg);
    mean_lg_g = mean(pixelsWithinMask);
    pixelsWithinMask = lg_b(mask_lg);
    mean_lg_b = mean(pixelsWithinMask);% or equivalent mean( nonzeros(s6_b) )

    lg_patch = [mean_lg_r; mean_lg_g; mean_lg_b];
    % lg_wb = wb_result ./ lg_patch;
    lg_wb(ii,:) = lg_patch./lg_patch(2);    
    wb_info{ii,1} = currentfilename; 
    wb_info{ii,2} = lg_wb(ii,:); 
    clear mask_lg masks
end

%% to get wb we need white patch's average do the following. 

save('lg_wb_cameraSpace_3k.mat','wb_info');
