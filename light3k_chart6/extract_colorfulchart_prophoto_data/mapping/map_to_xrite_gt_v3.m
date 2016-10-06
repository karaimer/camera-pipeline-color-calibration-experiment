clear all
close all

load('..\samsung_s6_edge\data.mat','data');
s6_prophoto = im2double(data)/65535;
clear data

load('..\motorola_nexus6\data.mat','data');
nexus_prophoto = im2double(data)/65535;
clear data

load('..\lg_g4\data.mat','data');
lg_prophoto = im2double(data)/65535;
clear data

load('..\htc_one_m9\data.mat','data');
m9_prophoto = im2double(data)/65535;
clear data

load('C:\Users\workshop\Documents\hakki\SPRING16\Research\ECCV16\colorimetry_experiments_v2\light3k_chart6\extract_colorchart_prophoto_data\mapping\T_one.mat','T_one');
load('C:\Users\workshop\Documents\hakki\SPRING16\Research\ECCV16\colorimetry_experiments_v2\light3k_chart6\extract_colorchart_prophoto_data\mapping\T_two.mat','T_two');
load('C:\Users\workshop\Documents\hakki\SPRING16\Research\ECCV16\colorimetry_experiments_v2\light3k_chart6\extract_colorchart_prophoto_data\mapping\T_three.mat','T_three');
load('C:\Users\workshop\Documents\hakki\SPRING16\Research\ECCV16\colorimetry_experiments_v2\light3k_chart6\extract_colorchart_prophoto_data\mapping\T_four.mat','T_four');

load('C:\Users\workshop\Documents\hakki\FALL15\Research\cvpr16\gt_values_xrite\prophoto_points.mat','prophoto_points');

workspace;	% Make sure the workspace panel is showing.
fontSize = 16;

figure(1),
hold on;
Rx = -sqrt(2)/2;Ry = -1/sqrt(6);
Gx = sqrt(2)/2;Gy = -1/sqrt(6);Bx = 0;By = 2/sqrt(6);
line([Rx, Gx, Bx, Rx], [Ry, Gy, By, Ry], 'Color', [0, 0, 1]);
f = 25;

errorForXrite = zeros(81,1);

for i=1:81
 
    c = s6_prophoto(i,:)/255;

    s6_prophoto_projected = rang_project(s6_prophoto(i,:));
    scatter(s6_prophoto_projected(1),s6_prophoto_projected(2), f, c, 'filled', 'd')    
    
    nexus_prophoto_projected = rang_project(nexus_prophoto(i,:));
    scatter(nexus_prophoto_projected(1),nexus_prophoto_projected(2), f, c, 'filled', 's')    
    
    lg_prophoto_projected = rang_project(lg_prophoto(i,:));
    scatter(lg_prophoto_projected(1),lg_prophoto_projected(2), f, c, 'filled', 'o')    
    
    m9_prophoto_projected = rang_project(m9_prophoto(i,:));
    scatter(m9_prophoto_projected(1), m9_prophoto_projected(2), f, c, 'filled', 'p')    
    
    z_axes = [lg_prophoto_projected; s6_prophoto_projected; m9_prophoto_projected; nexus_prophoto_projected];
    h1 = plot_gaussian_ellipsoid(mean(z_axes), cov(z_axes));
    eigenvalues = eig(cov(z_axes));
    errorForXrite(i,1) = sqrt(abs(eigenvalues(1))) + sqrt(abs(eigenvalues(2)));
    set(h1,'color',c);     
%     title('Xrite ProPhotoRGB Stage - 81 Color Chart', 'FontSize', fontSize);
    grid on;    
    hold on;
end 
legend('Equilateral triangle', 'Samsung-S6-edge', 'Motorola-nexus6', 'LG-G4', 'HTC-one-m9')    
sumOfErrorForXrite = sum(errorForXrite)

%% with transformed data. (xrite gt is selected as ref.)xrite has 24, 
% but i have 81 colors. dot product between vectors cannot be applied. Show
% this to dongliang 

s6_prophoto_transformed = s6_prophoto * T_one;
m9_prophoto_transformed = m9_prophoto * T_four;
nexus_prophoto_transformed = nexus_prophoto * T_three;
lg_prophoto_transformed = lg_prophoto * T_two;

s6_prophoto_transformed(s6_prophoto_transformed<=0)=0;
s6_prophoto_transformed(s6_prophoto_transformed>1)=1;

m9_prophoto_transformed(m9_prophoto_transformed<=0)=0;
m9_prophoto_transformed(m9_prophoto_transformed>1)=1;

nexus_prophoto_transformed(nexus_prophoto_transformed<=0)=0;
nexus_prophoto_transformed(nexus_prophoto_transformed>1)=1;

lg_prophoto_transformed(lg_prophoto_transformed<=0)=0;
lg_prophoto_transformed(lg_prophoto_transformed>1)=1;

figure(2),
hold on;
Rx = -sqrt(2)/2;Ry = -1/sqrt(6);
Gx = sqrt(2)/2;Gy = -1/sqrt(6);Bx = 0;By = 2/sqrt(6);
line([Rx, Gx, Bx, Rx], [Ry, Gy, By, Ry], 'Color', [0, 0, 1]);
f = 25;

errorForOurs = zeros(81,1);

for i=1:81
 
    c = s6_prophoto_transformed(i,:);

    s6_prophoto_transformed_projected = rang_project(s6_prophoto_transformed(i,:));
    scatter(s6_prophoto_transformed_projected(1),s6_prophoto_transformed_projected(2), f, c, 'filled', 'd')    
    
    nexus_prophoto_transformed_projected = rang_project(nexus_prophoto_transformed(i,:));
    scatter(nexus_prophoto_transformed_projected(1),nexus_prophoto_transformed_projected(2), f, c, 'filled', 's')    
    
    lg_prophoto_transformed_projected = rang_project(lg_prophoto_transformed(i,:));
    scatter(lg_prophoto_transformed_projected(1),lg_prophoto_transformed_projected(2), f, c, 'filled', 'o')    
    
    m9_prophoto_transformed_projected = rang_project(m9_prophoto_transformed(i,:));
    scatter(m9_prophoto_transformed_projected(1), m9_prophoto_transformed_projected(2), f, c, 'filled', 'p')    
    
    z_axes = [lg_prophoto_transformed_projected; s6_prophoto_transformed_projected; m9_prophoto_transformed_projected; nexus_prophoto_transformed_projected];
    h1 = plot_gaussian_ellipsoid(mean(z_axes), cov(z_axes));
    eigenvalues = eig(cov(z_axes));
    errorForOurs(i,1) = sqrt(abs(eigenvalues(1))) + sqrt(abs(eigenvalues(2)));    
    set(h1,'color',c);     
%     title('Xrite ProPhotoRGB Stage Mapping Based on Angular Error - 81 Color Chart', 'FontSize', fontSize);
    grid on;    
    hold on;
end 
sumOfErrorForOurs = sum(errorForOurs)

legend('Equilateral triangle', 'Samsung-S6-edge', 'Motorola-nexus6', 'LG-G4', 'HTC-one-m9')    
