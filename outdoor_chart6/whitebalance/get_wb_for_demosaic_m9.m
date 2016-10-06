
close all
clear all

load MacbethColorCheckerData.mat

imagefiles = dir('C:\Users\workshop\Documents\hakki\FALL15\Research\colorfulchart\chart6\outdoor\outdoor\htc_one_m9\*.dng');      
nfiles = length(imagefiles);    % Number of files found

m9_wb =zeros(nfiles, 3);
wb_info = cell(nfiles,2);

for ii=1:1
    currentfilename = imagefiles(ii).name;
    filename = ['C:\Users\workshop\Documents\hakki\FALL15\Research\colorfulchart\chart6\outdoor\outdoor\htc_one_m9\' currentfilename];
    m9_demosaiced_double = double(readDNGdemosaicRaw(filename));
    m9_demosaiced = im2double(readDNGdemosaicRaw(filename));

    masks = makeChartMask(m9_demosaiced,chart,colors);

    % Create a binary image ("mask") from the ROI object.
    mask_m9 = masks.white.mask;
    % figure, imshow(mask_nexus)

    m9_r = m9_demosaiced_double(:,:,1) .* mask_m9;
    m9_g = m9_demosaiced_double(:,:,2) .* mask_m9;
    m9_b = m9_demosaiced_double(:,:,3) .* mask_m9;
    % figure, imshow(nexus_r)
    % figure, imshow(nexus_r)
    % figure, imshow(nexus_r)

    pixelsWithinMask = m9_r(mask_m9);
    mean_m9_r = mean(pixelsWithinMask);
    pixelsWithinMask = m9_g(mask_m9);
    mean_m9_g = mean(pixelsWithinMask);
    pixelsWithinMask = m9_b(mask_m9);
    mean_m9_b = mean(pixelsWithinMask);% or equivalent mean( nonzeros(s6_b) )

    m9_patch = [mean_m9_r; mean_m9_g; mean_m9_b];
    % lg_wb = wb_result ./ lg_patch;
    m9_wb(ii,:) = m9_patch./m9_patch(2);    
    wb_info{ii,1} = currentfilename; 
    wb_info{ii,2} = m9_wb(ii,:); 
    clear mask_m9 masks
end

%% to get wb we need white patch's average do the following. 

save('m9_wb_cameraSpace_3k.mat','wb_info');
