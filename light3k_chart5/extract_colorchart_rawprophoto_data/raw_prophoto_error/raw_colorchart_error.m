clear all
close all

load('C:\Users\workshop\Documents\hakki\FALL15\Research\cvpr16\extract_colorchart_rawprophoto_data\samsung_s6_edge\data.mat','data');
s6_prophoto_raw = data;
clear data

load('C:\Users\workshop\Documents\hakki\FALL15\Research\cvpr16\extract_colorchart_rawprophoto_data\motorola_nexus6\data.mat','data');
nexus_prophoto_raw = data;
clear data

load('C:\Users\workshop\Documents\hakki\FALL15\Research\cvpr16\extract_colorchart_rawprophoto_data\lg_g4\data.mat','data');
lg_prophoto_raw = data;
clear data

load('C:\Users\workshop\Documents\hakki\FALL15\Research\cvpr16\extract_colorchart_rawprophoto_data\htc_one_m9\data.mat','data');
m9_prophoto_raw = data;
clear data

workspace;	% Make sure the workspace panel is showing.
fontSize = 16;

figure(1),
hold on;
Rx = -sqrt(2)/2;Ry = -1/sqrt(6);
Gx = sqrt(2)/2;Gy = -1/sqrt(6);Bx = 0;By = 2/sqrt(6);
line([Rx, Gx, Bx, Rx], [Ry, Gy, By, Ry], 'Color', [0, 0, 1]);
f = 25;

errorForRaw = zeros(24,1);

for i=1:24
 
    c = s6_prophoto_raw(i,:)/255;

    s6_prophoto_projected = rang_project(s6_prophoto_raw(i,:));
    scatter(s6_prophoto_projected(1),s6_prophoto_projected(2), f, c, 'filled', 'd')    
    
    nexus_prophoto_projected = rang_project(nexus_prophoto_raw(i,:));
    scatter(nexus_prophoto_projected(1),nexus_prophoto_projected(2), f, c, 'filled', 's')    
    
    lg_prophoto_projected = rang_project(lg_prophoto_raw(i,:));
    scatter(lg_prophoto_projected(1),lg_prophoto_projected(2), f, c, 'filled', 'o')    
    
    m9_prophoto_projected = rang_project(m9_prophoto_raw(i,:));
    scatter(m9_prophoto_projected(1), m9_prophoto_projected(2), f, c, 'filled', 'p')    
    
    z_axes = [lg_prophoto_projected; s6_prophoto_projected; m9_prophoto_projected; nexus_prophoto_projected];
    h1 = plot_gaussian_ellipsoid(mean(z_axes), cov(z_axes));
    eigenvalues = eig(cov(z_axes));
    errorForRaw(i,1) = sqrt(abs(eigenvalues(1))) + sqrt(abs(eigenvalues(2)));
    set(h1,'color',c);     
%     title('RAW ProPhotoRGB Stage - Xrite Color Chart', 'FontSize', fontSize);
    grid on;    
    hold on;
end 
legend('Equilateral triangle', 'Samsung-S6-edge', 'Motorola-nexus6', 'LG-G4', 'HTC-one-m9')    
sumOfErrorForRAW = sum(errorForRaw)
