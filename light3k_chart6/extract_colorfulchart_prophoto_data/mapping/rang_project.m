% function plot_chroma(colors)
% chromas = project(colors);
% figure; hold on;
% Rx = -sqrt(2)/2;Ry = -1/sqrt(6);
% Gx = sqrt(2)/2;Gy = -1/sqrt(6);Bx = 0;By = 2/sqrt(6);
% % line([Rx, Gx, Bx, Rx], [Ry, Gy, By, Ry], 'Color', [0, 0, 1]);
% % plot(Rx, Ry, 'ko','MarkerSize',9, 'MarkerFaceColor', [1 0 0]);
% % plot(Gx, Gy, 'ko','MarkerSize',9, 'MarkerFaceColor', [0 1 0]);
% % plot(Bx, By, 'ko','MarkerSize',9, 'MarkerFaceColor', [0 0 1]);
% % 
% % for i = 1:23
% %     plot(chromas(i,1), chromas(i,2), ...
% %         'bo','MarkerSize',16, 'MarkerFaceColor', [0, 0, 1]);
% % end


function A = rang_project(C)
sumC = sum(C, 2);
C = C./repmat(sumC, [1 3]);
n3 = [1, 1, 1]; n3 = n3./ sqrt(sum(n3.^2));
n2 = [0, 0, 1] - [1/3, 1/3, 1/3]; n2 = n2./ sqrt(sum(n2.^2));
n1 = cross(n2, n3);

N = [n1; n2; n3];
A = N * C';
A = A(1:2,:)';

