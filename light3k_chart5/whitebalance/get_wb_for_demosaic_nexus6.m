
close all
clear all

load MacbethColorCheckerData.mat

imagefiles = dir('C:\Users\workshop\Documents\hakki\FALL15\Research\colorfulchart\chart5\light_3K_all_v2\profiles\motorola_nexus6\*.dng');      
nfiles = length(imagefiles);    % Number of files found

nexus_wb =zeros(nfiles, 3);
wb_info = cell(nfiles,2);

for ii=1:1
    currentfilename = imagefiles(ii).name;
    filename = ['C:\Users\workshop\Documents\hakki\FALL15\Research\colorfulchart\chart5\light_3K_all_v2\profiles\motorola_nexus6\' currentfilename];
    nexus_demosaiced_double = double(readDNGdemosaicRaw(filename));
    nexus_demosaiced = im2double(readDNGdemosaicRaw(filename));

    masks = makeChartMask(nexus_demosaiced,chart,colors);

    % Create a binary image ("mask") from the ROI object.
    mask_nexus = masks.white.mask;
    % figure, imshow(mask_nexus)

    nexus_r = nexus_demosaiced_double(:,:,1) .* mask_nexus;
    nexus_g = nexus_demosaiced_double(:,:,2) .* mask_nexus;
    nexus_b = nexus_demosaiced_double(:,:,3) .* mask_nexus;
    % figure, imshow(nexus_r)
    % figure, imshow(nexus_r)
    % figure, imshow(nexus_r)

    pixelsWithinMask = nexus_r(mask_nexus);
    mean_nexus_r = mean(pixelsWithinMask);
    pixelsWithinMask = nexus_g(mask_nexus);
    mean_nexus_g = mean(pixelsWithinMask);
    pixelsWithinMask = nexus_b(mask_nexus);
    mean_nexus_b = mean(pixelsWithinMask);% or equivalent mean( nonzeros(s6_b) )

    nexus_patch = [mean_nexus_r; mean_nexus_g; mean_nexus_b];
    % lg_wb = wb_result ./ lg_patch;
    nexus_wb(ii,:) = nexus_patch./nexus_patch(2);    
    wb_info{ii,1} = currentfilename; 
    wb_info{ii,2} = nexus_wb(ii,:); 
    clear mask_nexus masks
end

%% to get wb we need white patch's average do the following. 

save('nexus_wb_cameraSpace_3k.mat','wb_info');

