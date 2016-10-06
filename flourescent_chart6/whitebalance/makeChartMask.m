function masks = makeChartMask(inImg,chart,colors,dim)
%
% MASKS = MAKECHARTMASK(INIMG,CHART,COLORS,DIM)
% 
% INIMG     : input RGB image of size NxMx3.
% CHART     : struct containing properties of the color chart. see
% macbethColorChecker.m for the format.
% COLORS    : cell array containing the names, or numbers of color patches
% in the chart being used. see macbethColorChecker.m for the format.
% DIM       : approximate pixel dimension of the each patch of the chart in
% image. default: 7% of the smallest image dimension
% MASKS     : struct that contains a mask for each color patch. 
%           masks.(color).pts has the xy coordinates of the masks, and
%           masks.(color),mask has a binary mask.
%
% ************************************************************************
% If you use this code, please cite the following paper:
%
%
% <paper>
%
% ************************************************************************
% For questions, comments and bug reports, please use the interface at
% Matlab Central/ File Exchange. See paper above for details.
% ************************************************************************


s = size(colors);
assert(numel(size(inImg))==3,'The input image has to be a color image.')

% find approximate RGB colors to represent the chart masks
RGB = getRGBcolors4chart(chart,colors);

if nargin<4
    dim = 0.07*min(size(inImg,1),size(inImg,2));
end

space = 0.2*dim;
shiftVal = dim + space;
x_box = [1 2 2 1];
y_box = [1 1 2 2];
tempMask =cell(s(1),s(2));

% accept the mask for the darkSkin, all others will follow
figure;
imshow(inImg)
for col = 1:s(2)
    for  row = 1:s(1)
        curColor = colors{row,col};
        pts(:,1) = shiftVal*col + dim*x_box;
        pts(:,2) = -shiftVal*(-row+1) + dim*y_box;
        masks.(curColor).pts = pts;
        curRGB = RGB{row,col};
        tempMask{row,col} = impoly(gca,masks.(curColor).pts) ;
        setColor(tempMask{row,col},curRGB./255);
    end
end
title('Place masks over corresponding patches;then double click the first patch','fontsize',20);

% wait for the user to double click to confirm location
curColor = colors{1,1};
curMask = tempMask{1,1};
position = wait(curMask);
masks.(curColor).mask = createMask(curMask);
delete(curMask)

for row = 1:s(1)
    for col = 1:s(2)
        curColor = colors{row,col};
        if ~strcmp(curColor,colors{1,1})
            curMask = tempMask{row,col};
            masks.(curColor).mask = createMask(curMask);
            delete(curMask)
        end
    end
end
close
end

function RGB = getRGBcolors4chart(chart,colors)
s = size(colors);
c = makecform('xyz2srgb');
RGB = cell(s(1),s(2));
for row = 1:s(1)
    for col = 1:s(2)
        curColor = colors{row,col};
        RGB{row,col} = 255.*(reshape(applycform(reshape(chart.(curColor).xyz,[1 1 3]),c),[1 3]));
    end
end
end




