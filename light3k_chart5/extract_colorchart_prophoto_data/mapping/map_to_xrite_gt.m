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
load('C:\Users\workshop\Documents\hakki\FALL15\Research\cvpr16\gt_values_xrite\prophoto_points.mat','prophoto_points');

figure,
hold on;
% Plot the triangle
Rx = -sqrt(2)/2;Ry = -1/sqrt(6);
Gx = sqrt(2)/2;Gy = -1/sqrt(6);Bx = 0;By = 2/sqrt(6);
line([Rx, Gx, Bx, Rx], [Ry, Gy, By, Ry], 'Color', [0, 0, 1]);

% prophoto_points = prophoto_points.^(2.2);
% prophoto_points(:,1) = (prophoto_points(:,1)-min(prophoto_points(:,1)))/(max(prophoto_points(:,1))-min(prophoto_points(:,1)));
% prophoto_points(:,2) = (prophoto_points(:,2)-min(prophoto_points(:,2)))/(max(prophoto_points(:,2))-min(prophoto_points(:,2)));
% prophoto_points(:,3) = (prophoto_points(:,3)-min(prophoto_points(:,2)))/(max(prophoto_points(:,3))-min(prophoto_points(:,3)));

workspace;	% Make sure the workspace panel is showing.
fontSize = 24;

f = 25;

errorForXrite = zeros(24,1);

for i=1:24
 
    c = prophoto_points(i,:);
    prophoto_points_projected = rang_project(prophoto_points(i,:));
    scatter(prophoto_points_projected(1),prophoto_points_projected(2), f, c, 'filled', '>')    

    s6_prophoto_projected = rang_project(s6_prophoto(i,:));
    scatter(s6_prophoto_projected(1),s6_prophoto_projected(2), f, c, 'filled', 'd')    
    
    nexus_prophoto_projected = rang_project(nexus_prophoto(i,:));
    scatter(nexus_prophoto_projected(1),nexus_prophoto_projected(2), f, c, 'filled', 's')    
    
    lg_prophoto_projected = rang_project(lg_prophoto(i,:));
    scatter(lg_prophoto_projected(1),lg_prophoto_projected(2), f, c, 'filled', 'o')    
    
    m9_prophoto_projected = rang_project(m9_prophoto(i,:));
    scatter(m9_prophoto_projected(1),m9_prophoto_projected(2), f, c, 'filled', 'p')    
    
    z_axes = [lg_prophoto_projected; s6_prophoto_projected; m9_prophoto_projected; nexus_prophoto_projected];
    h1 = plot_gaussian_ellipsoid(mean(z_axes), cov(z_axes));
    set(h1,'color',c);     
%     title('Xrite ProPhotoRGB Stage - ColorChecker', 'FontSize', fontSize);
    eigenvalues = eig(cov(z_axes));
    errorForXrite(i,1) = sqrt(abs(eigenvalues(1))) + sqrt(abs(eigenvalues(2)));    
    grid on;    
    hold on;
end 
legend('Equilateral triangle', 'GT','Samsung-S6-edge','Motorola-nexus6','LG-G4','HTC-one-m9')    
sumOfErrorForXrite = sum(errorForXrite)

[T_one, f_s6] = optTwithMinAE(s6_prophoto, prophoto_points);
[T_two, f_lg] = optTwithMinAE(lg_prophoto, prophoto_points);
[T_three, f_nexus]= optTwithMinAE(nexus_prophoto, prophoto_points);
[T_four, f_m9]= optTwithMinAE(m9_prophoto, prophoto_points);

f_s6
f_lg
f_nexus
f_m9

save('T_one.mat','T_one');
save('T_two.mat','T_two');
save('T_three.mat','T_three');
save('T_four.mat','T_four');


%%

figure,
hold on;
Rx = -sqrt(2)/2;Ry = -1/sqrt(6);
Gx = sqrt(2)/2;Gy = -1/sqrt(6);Bx = 0;By = 2/sqrt(6);
line([Rx, Gx, Bx, Rx], [Ry, Gy, By, Ry], 'Color', [0, 0, 1]);

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

f = 25;

errorForOurs = zeros(24,1);

for i=1:24
 
    c = prophoto_points(i,:);
    prophoto_points_projected = rang_project(prophoto_points(i,:));
    scatter(prophoto_points_projected(1),prophoto_points_projected(2), f, c, 'filled', '>')    

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
%     title('Xrite ProPhotoRGB Stage Mapping Based on Angular Error - ColorChecker', 'FontSize', fontSize);
    grid on;    
    hold on;
end 
legend('Equilateral triangle', 'GT','Samsung-S6-edge','Motorola-nexus6','LG-G4','HTC-one-m9')    
sumOfErrorForOurs = sum(errorForOurs)