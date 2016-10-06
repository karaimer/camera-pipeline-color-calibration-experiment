function varargout = extractDatafromColorChartImages(varargin)
% extractDatafromColorChartImages MENUHELP-file for extractDatafromColorChartImages.fig
%      extractDatafromColorChartImages, by itself, creates a new extractDatafromColorChartImages or raises the existing
%      singleton*.
%
%      H = extractDatafromColorChartImages returns the handle to a new extractDatafromColorChartImages or the handle to
%      the existing singleton*.
%
%      extractDatafromColorChartImages('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in extractDatafromColorChartImages.MENUHELP with the given input arguments.
%
%      extractDatafromColorChartImages('Property','Value',...) creates a new extractDatafromColorChartImages or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before extractDatafromColorChartImages_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to extractDatafromColorChartImages_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menuFile.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help extractDatafromColorChartImages

% Last Modified by GUIDE v2.5 06-Sep-2013 17:33:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @extractDatafromColorChartImages_OpeningFcn, ...
                   'gui_OutputFcn',  @extractDatafromColorChartImages_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before extractDatafromColorChartImages is made visible.
function extractDatafromColorChartImages_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to extractDatafromColorChartImages (see VARARGIN)

% Choose default command line output for extractDatafromColorChartImages
handles.output = hObject;

%TODO
% maximize the GUI 
set(0, 'Unit', 'pixel');
winsize = get(0, 'ScreenSize');

% Set the Gui position
winsize(1) = winsize(1) + 100;
winsize(2) = winsize(2) + 100;
winsize(3) = winsize(3) - 150;
winsize(4) = winsize(4) - 150;
set(gcf, 'Position', winsize);

step = winsize(4) / 16;
% Set the Panel position
set(handles.uipanel1, 'Position', [3/4* winsize(3) + 10, 10, 1/4*winsize(3) - 20, winsize(4) - 20]); 
% Set popup menu
set(handles.text1, 'Position', [10, winsize(4) - (step + 30), 80, 30]);
set(handles.popupmenu1, 'Position', [120, winsize(4) - (step + 30), 120, 30])
% Set the Color Chart type in area 3
set(handles.uipanel2, 'Position', [10, winsize(4) - (3*step + 30), 1/4 * winsize(3) - 40, 60]);

% Set the Button position in area 4
set(handles.pushbutton1, 'Position', [10, winsize(4)-(4*step + 30), 80, 30]); 
set(handles.pushbutton3, 'Position', [120, winsize(4)-(4*step + 30), 80, 30]);
% Set the Button position in area 5
set(handles.pushbutton2, 'Position', [10, winsize(4)-(5*step + 30), 80, 30]);
set(handles.pushbutton4, 'Position', [120, winsize(4)-(5*step + 30), 80, 30]);

% Set the Axes position disappear
set(handles.axes1, 'Position', [-10, -10, 5, 5]);
% Set the UTable position in area 1
set(handles.uitable1, 'Position', [10, 10, 1/4*winsize(3) - 40, winsize(4)/2 - 20]);

% Update handles structure
handles.myData.winsize = winsize;
handles.myData.selectedPoints = [];
handles.myData.CC.m = 9;
handles.myData.CC.n = 9;
handles.myData.CC.w = 900;
handles.myData.CC.h = 900;
handles.myData.data = [];
handles.myData.cameraName = '';
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = extractDatafromColorChartImages_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function I = createMask(w, h, m, n)
I = 0.5 * ones(w, h, 3);
wc = w / m;
hc = h / n;

for i = 1:m
    wstart = uint16(wc * (i-1) + wc/4);
    wend = uint16(wc * i - wc/4);
    for j = 1:n        
        hstart = uint16(hc * (j-1) + hc/4);
        hend = uint16(hc * j - hc/4);
        I(wstart:wend, hstart:hend,:) = 1;
    end
end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pos=get(gca,'CurrentPoint');
handles.myData.selectedPoints = [handles.myData.selectedPoints; round(pos(1,2)) round(pos(1,1))];
X = pos(1,1); Y = pos(1,2);
line('XData', [X; X;], 'YData', [Y; Y;], 'Marker','.','LineStyle','-', 'Color', 'r', 'LineWidth',2);
% Update handles structure
guidata(hObject, handles);

% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
c= get(gcf,'CurrentCharacter');

% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

function filterImage(I, handles)
winsize = handles.myData.winsize;
ws = winsize(4)- 20 ;
hs = ws/3 * 2;
mask = createMask(size(I,1), size(I,2), handles.myData.CC.m, handles.myData.CC.n);
I = mask .* I;
set(handles.axes1, 'Position', [10 10 hs ws]);
axes(handles.axes1);
I(:,:,1) = I(:,:,1) ./ max(max(I(:,:,1)));
I(:,:,2) = I(:,:,2) ./ max(max(I(:,:,2)));
I(:,:,3) = I(:,:,3) ./ max(max(I(:,:,3)));
imshow(I);

function data = extractData(I, m, n)
[w, h, ~] = size(I);
wc = w / m;
hc = h / n;
data = zeros(m*n, 3);
for i = 1:m
    wstart = uint16(wc * (i-1) + wc/4);
    wend = uint16(wc * i - wc/4);
    for j = 1:n        
        hstart = uint16(hc * (j-1) + hc/4);
        hend = uint16(hc * j - hc/4);
        temp = I(wstart:wend, hstart:hend,:);
        temp = reshape(temp, [], 3);
        data((i-1)*n + j,:) = mean(temp,1);
    end
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Crop image and apply mask
input_points =handles.myData.selectedPoints;

xmin = min(input_points(:,1));
xmax = max(input_points(:,1));
ymin = min(input_points(:,2));
ymax = max(input_points(:,2));
I = handles.myData.image(xmin:xmax, ymin:ymax, :);
input_points(:,1) = input_points(:,1) - xmin + 1;
input_points(:,2) = input_points(:,2) - ymin + 1;
control_points = input_points;
control_points(:,1) = input_points(:,2);
control_points(:,2) = input_points(:,1);
w = handles.myData.CC.w;
h = handles.myData.CC.h;
base_points = [1 1;h 1; h w; 1 w];
tform = cp2tform(control_points, base_points, 'projective');
K = zeros(w+10, h+10, 3);
K(6:w+5, 6:h+5,:) = imtransform(I, tform, 'XData',[1 h], 'YData',[1 w]);
filterImage(K, handles);
handles.myData.image = K;
% Get the old data (if any)
data = handles.myData.data;
data = [data;extractData(K, handles.myData.CC.m ,handles.myData.CC.n)];
set(handles.uitable1, 'Data', data);
% Save the extracted data
handles.myData.data = data;
% Delete the selected points
handles.myData.selectedPoints = [];
% Update user data
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 
data = handles.myData.data;
save('data.mat', 'data');

function fn = getNextfile(fn)
str1 = fn(end-7:end-4);
num = str2double(str1);
num = num+1;
str2 = num2str(num);
str1(end-length(str2)+ 1:end) = str2;
fn(end-7:end-4) = str1; 

% --- Executes when selected object is changed in uipanel2.
function uipanel2_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel2 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue, 'Tag')
    case 'cc1'
        handles.myData.CC.m = 6;
        handles.myData.CC.n = 4;
        handles.myData.CC.w = 1500;
        handles.myData.CC.h = 1000;
    case 'cc2'
        handles.myData.CC.m = 14;
        handles.myData.CC.n = 10;
        handles.myData.CC.w = 1400;
        handles.myData.CC.h = 1000;
    case 'cc3'
        handles.myData.CC.m = 9;
        handles.myData.CC.n = 9;
        handles.myData.CC.w = 900;
        handles.myData.CC.h = 900;        
end

guidata(hObject, handles);

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.myData.image = handles.myData.originalIm;
guidata(hObject, handles);
showImage(handles);

function showImage(handles)
I = handles.myData.image;
winsize = handles.myData.winsize;
[wi, hi, ~] = size(I);
ws = winsize(4);
hs = 3/4*winsize(3);
if (ws/hs > wi/hi)
    ws = hs * (wi/hi);
else
    hs = ws * (hi/wi);
end

set(handles.axes1, 'Position', [10, 10, hs - 20, ws - 20]);
% set(handles.pushbutton1, 'Parent', handles.uipanel1);
axes(handles.axes1);
I(:,:,1) = I(:,:,1) ./ max(max(I(:,:,1)));
I(:,:,2) = I(:,:,2) ./ max(max(I(:,:,2)));
I(:,:,3) = I(:,:,3) ./ max(max(I(:,:,3)));
imshow(I);

% --------------------------------------------------------------------
function menuFile_Callback(hObject, eventdata, handles)
% hObject    handle to menuFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function menuOpen_Callback(hObject, eventdata, handles)
% hObject    handle to menuOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if isempty(handles.myData.cameraName)
%     msgbox('Please choose camera name first');
% else
   pathname = uigetdir('C:\');
%    if isequal(filename,0) || isequal(pathname,0)
%    else
%         handles.myData.fileName = [pathname filename];
        I = processRaw(pathname, 'asd');
        handles.myData.image = I;
        handles.myData.originalIm = I;
        handles.myData.selectedPoints = [];
        handles.myData.data = [];
        guidata(hObject, handles);
        showImage(handles);
        set(handles.uitable1,'Data', []);
%    end
% end

% --------------------------------------------------------------------
function menuHelp_Callback(hObject, eventdata, handles)
% hObject    handle to menuHelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes when figure1 is resized.
function figure1_ResizeFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
val = get(hObject, 'Value');
switch(val)
    case 2
        handles.myData.cameraName = 'Canon_1D';
    case 3
        handles.myData.cameraName = 'Canon_550D';
    case 4
        handles.myData.cameraName = 'Nikon_D40';
    case 5
        handles.myData.cameraName = 'Nikon_D3000';
    case 6
        handles.myData.cameraName = 'Pentax_K7';
    case 7
        handles.myData.cameraName = 'Sony_A57';
    case 8
        handles.myData.cameraName = 'Spectral';
end
guidata(hObject, handles);
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.myData.image = imrotate(handles.myData.image, -90);
handles.myData.originalIm = imrotate(handles.myData.originalIm, -90);
guidata(hObject, handles);
showImage(handles);
