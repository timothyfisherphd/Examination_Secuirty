%{
Edited From: RAHUL RANJAN, Avi Nehemiah, MATHWORKS & MATLAB Applications

Authors: Timothy F. (CSC 6630\tfisher10), Kevin S.(CSC 4630\kseveur1), Micheal M.
(CSC 4630\ mmoloney1), Adrian M.(CSC 4630\amcghee3)


Description: To develop a GUI that recognizes a face and matches it to the
images GUI's database. The database will automatically check if the
matched faced from the live captured image is present in the database.
 
Assumptions: 
- User knows basic usage of a computers components (mouse, keyboard,
webcam, etc.)
- Must download the complete zip file and not edit the organization of the folders. 
- User has MATLAB2018a with Computer Vision toolbox, Image Acquisition
toolbox,  Statistics and Machine Learning Toolbox and the 
correct video adapter for MATLAB installed. 

Usage:
1.) In MATLAB Command Window, type TestVerification to begin the program. 
2.) First select the student's name you are trying to verify. This will begin the training and set the matching to the student's folder. ( Go to step 5 if student name is not in drop down box.)
3.) Click the Verify ID then click Camera. Follow all the prompts in the message boxes and dialogue boxes.
4.  If matched, then in the right window you will have a matched image from the database. If not matched then you will have a red x. 
5.) If student is not in the database then go to Database menu option. Then click New Student to add a new folder to FaceDatabaseFolder. 
6.) Then add new student image by scrolling to Database then clicking New Student Picture to add a new student picture. Follow all the prompts.  
7.) Reset the program after you added the new pictures. 
8.) Redo steps 1 through 4. 
9.) Quit the program when you are done.  

Program Outline & Responsibilities (R)

TestVerification.m
    1.) R - Timothy F. \ Adrian M.
        GUI Initialization code (lines 31 to 48)
        function TestVerification_OpeningFcn(hObject, eventdata, handles, varargin)
        function varargout = TestVerification_OutputFcn(hObject, eventdata, handles)
    
    2.) R - Micheal M. 

        function Verify_Callback(hObject, eventdata, handles) 
        function Camera_Callback(hObject, eventdata, handles)

    3.) R - Adrian M. \ Timothy F. (RAHUL)

        function Database_Callback(hObject, eventdata, handles)
        function View_Callback(hObject, eventdata, handles)
        function Picture_Callback(hObject, eventdata, handles)
        function New_Student_Callback(hObject, eventdata, handles)

    4.) R - Timothy F. 


        function Other_Callback(hObject, eventdata, handles)
        function HE_LP_Callback(hObject, eventdata, handles)
        
        function Reset_Callback(hObject, eventdata, handles)
        function All_Callback(hObject, eventdata, handles)

        function Exit_Callback(hObject, eventdata, handles)
        function Quit_Callback(hObject, eventdata, handles)

    5.) R - Micheal M. 

        function Student_Select_Callback(hObject, eventdata, handles)

        function Student_Select_CreateFcn(hObject, eventdata, handles)


train_match.m (AVI)
    1.) R - Micheal M. \ Kevin S.
        classdef train_match
            properties
            methods
                function setStudentChoice
                function train
                function match

Other Responsibilities:
    Troubleshooting \ Debugging: All
    Ideas : All
    Video Editing: Micheal M. 


Notes: 
- If you have a windows or linux system then use need to change the .m files code
  to your respective adaptors.
- Change the \ to \ when using windows!!!!
- Must install all the toolboxes\adaptors for this to fully function. 
- Keep the folder\file names consistent and keep the same structure as downloaded originally.  
%}

% From guide, MATLAB has a preset structure for a GUI and it's elements.
function varargout = TestVerification(varargin)
% TESTVERIFICATION MATLAB code for TestVerification.fig
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @TestVerification_OpeningFcn, ...
    'gui_OutputFcn',  @TestVerification_OutputFcn, ...
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

% Guide has a opening function, to open the GUI in a figure.
function TestVerification_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

% When calling the program for the GUI. The popup menu shows the names of
% each in the database. 
files = dir('FaceDatabaseFolder');
dirFlags = [files.isdir];
subDirs = files(dirFlags);
names = {subDirs.name};
set(handles.Student_Select,'string',names(3:end));

tx2 = msgbox('Training Features. Please Wait.','Wait!');
pause(4)
delete(tx2)

trnMatClass = train_match();
trnMatClass.train();
handles.trnMatClass=trnMatClass;
guidata(hObject,handles);

% Guide has a output function which the outputs are returned to the command
% line.
function varargout = TestVerification_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% After the student's name is selected from the popup menu, the user has to
% verfiy the name by these two functions.
function Verify_Callback(hObject, eventdata, handles) % Main function callback to verify student from popup menu.
function Camera_Callback(hObject, eventdata, handles) % Apart of main Verify _Callback.
info = imaqhwinfo('winvideo');
did = info.DeviceIDs;

%Check to see if your system has webcam
if isempty(did)
    msgbox({'YOUR SYSTEM DO NOT HAVE A WEBCAM';' ';'CONNECT A ONE'},'WARNING....!!!!','warn','modal')
    return
end

fd = vision.CascadeObjectDetector(); % Detect objects using the Viola-Jones algorithm
did = cell2mat(did); 

% Checks the webcam resolution.
for k = 1:length(did)
    devinfo = imaqhwinfo('winvideo',k);
    na(1,k) = {devinfo.DeviceName};
    sr(1,k) = {devinfo.SupportedFormats};
end
[a,b] = listdlg('promptstring','SELECT A WEB CAM DEVICE','liststring',na,'ListSize', [125, 75],'SelectionMode','single');
if b == 0
    return
end
if b ~= 0
    frmt = sr{1,a};
    [a1,b1] = listdlg('promptstring','SELECT RESOLUTION','liststring',frmt,'ListSize', [150, 100],'SelectionMode','single');
    if b1 == 0
        return
    end
end
frmt = frmt{a1};
l = find(frmt == '_');
res = frmt(l+1 : end); % Stores the selected resolution
l = find(res == 'x'); % Finds were the postion of the variable x in 1280x720 resolution
res1 = str2double(res(1: l-1)); % Stores the 1280 dimenson of the resolution
res2 = str2double(res(l+1 : end)); % Stores the 720 dimension of the resolution
axes(handles.left_window) 
vid = videoinput('winvideo', a);% Live video of through mac video adaptor.
vr  =  [res1    res2]; % Video resolution of each dimension stored as an array [1280,720]
nbands  =  get(vid,'NumberofBands'); % To indicate the number of bands in data to be acquired in the video. 
h2im  = image(zeros([vr(2)  vr(1)  nbands] , 'uint8')); % Sets the number of bands as the size of the left window stored in h2im.
preview(vid,h2im); % Shows live video feed based on the dimensions of h2im.
handles.vdx = vid;
guidata(hObject,handles)
tx = msgbox('Stand still in front of camera.','Instruction');
pause(1)
close(tx)
kx  =  0;

% To recognize the face of the live camera from the webcam. 
while 1 % A loop that is continuosly extracting the frames of the live video. 
    im = getframe(handles.left_window); % Gets a frame of the video
    im =  im.cdata;
    bbox = step(fd, im);
    vo = insertObjectAnnotation(im,'rectangle',bbox,'FACE'); % Inserts a rectangle and 
    % put the annotation FACE to label the detected face.
    axes(handles.right_window)
    imshow(vo)
    
    % Checks to see how many faces are in the live camera frame. 
    if size(bbox,1) > 1
        msgbox({'Too many many faces in frame.';' ';'Only one face is accepted.'},'WARNING.....!!!','warn','modal')
        uiwait
        stoppreview(vid)
        delete(vid)
        handles = rmfield(handles,'vdx');
        guidata(hObject,handles)
        cla(handles.left_window)
        reset(handles.left_window)
        set(handles.left_window,'box','on','xtick',[],'ytick',[],'xcolor',[1 1 1],'ycolor',[1 1  1],'color',co,'linewidth',1.5)
        cla(handles.right_window)
        reset(handles.right_window)
        set(handles.right_window,'box','on','xtick',[],'ytick',[],'xcolor',[1 1 1],'ycolor',[1 1  1],'color',co,'linewidth',1.5)
        return
    end
    
    % After 10 frames are captured then it will break the while loop. 
    kx = kx + 1; 
    if kx > 10 && ~isempty(bbox)
        break
    end
end

% To crop, resize and set the recgonized face in the left window. This
% displays the current image. 
imc = imcrop(im,[bbox(1)+3    bbox(2)-35    bbox(3)-10      bbox(4)+70]); % Crops im based on the indices of bbox
imx  =   imresize(imc,[300  300]); % Resizes the imc 
axes(handles.left_window) % To control the left window in TestVerification figure. 
image(imx)  % Sets imx to the left window of the GUI.
text(20,20,'\bfYour current image.','fontsize',12,'color','y','fontname','comic sans ms')
set(handles.left_window,'xtick',[],'ytick',[],'box','on')

% The match function from the train_match class is used to match the
% recgonized student face to the face images in the GUI FaceDatabaseFolder.
trnMatClass=handles.trnMatClass;
trnMatClass.match(imx);

% These functions are all to view or to update the Database. 
function Database_Callback(hObject, eventdata, handles) % Main function callback to construct the Database.
function View_Callback(hObject, eventdata, handles) 

%{
The function to view all the images of the database base on the students folder\sub-directory.

This function request the user to input the student's first and last name to
search the folder name containing the student's pictures.  If the
requested folder name is not found, the function with display a msgbox
stating the image is not found.  If the folder is found all pictures
listed in the folder database are display to the user.
%}


% To select the sub-directory by the student's name. 
name = inputdlg('What is the student''s first and last name? (eg. Timothy Fisher)','Name');
f = dir('.\FaceDatabaseFolder\'+string(name)+'\\'); % Change the \ to \ when using windows!!!!

%{
Check to see if the name is in the database.

If length of the directory equals 2 then the directory is empty and only
contains (parent node) as the first entry and (child node) as the
second entry. Then display's a error message.
%}
if length(f) == 2
    msgbox('Your database has no image to display.','Not Found','modal')
    return
end
l = length(f)-2;
while 1
    a = factor(l);
    if length(a) >= 4
        break
    end
    l = l+1;
end
d  = a(1: ceil(length(a)\2));
d = prod(d);
d1 = a(ceil(length(a)\2)+1  : end);
d1 = prod(d1);
zx = sort([d d1]);

% Set the select name and it's images to a figure.
figure('menubar','none','numbertitle','off','name','Images of FaceDatabaseFolder','color',[0.0431  0.5176  0.7804],'position',[300 200 600 500])
for k = 3:length(f)
    im = imread(strcat(f(k).folder,'\',f(k).name));
    subplot(zx(1),zx(2),k-2)
    imshow(im)
    title(f(k).name,'fontsize',10,'color','w')
end

% Allow the user to easily access the help.txt file for instructions how to
% use the TestVerification program. 
function Other_Callback(hObject, eventdata, handles)
function HE_LP_Callback(hObject, eventdata, handles)
system(['open help.txt'])

% To reset all of the elements and figures of the GUI. 
function Reset_Callback(hObject, eventdata, handles)
function All_Callback(hObject, eventdata, handles)
clc;
clear;
close all;
reset = msgbox('Reset Complete, reopening the program!','Reset','modal');
pause(3)
delete(reset)
TestVerification

% To exit the TestVerification program. 
function Exit_Callback(hObject, eventdata, handles)
function Quit_Callback(hObject, eventdata, handles) % Apart of the main Exit Callback.
close gcf;


% Apart of the popup box to select the student's name and train the choice
% selected.
function Student_Select_Callback(hObject, eventdata, handles)
contents = cellstr(get(hObject,'String'));
choice = contents{get(hObject,'Value')};
%trnMatClass = train_match();
%trnMatClass.setStudentChoice(choice);
% handles.trnMatClass=trnMatClass;
% guidata(hObject,handles);
trnMatClass=handles.trnMatClass;
trnMatClass.setStudentChoice(choice);

% When using guide, the program will execute during object creation, after setting all properties.
function Student_Select_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% To make a new sub-folder of a new student. 
function New_Student_Callback(hObject, eventdata, handles)
cd FaceDatabaseFolder\
new_student = string(inputdlg('Input first and last name. (eg. Timothy Fisher)', 'New Student'));
mkdir ('.\'+(new_student)+'\\');
cd ..
msgbox('Please reset the program to access the new directory','Reset','modal')

% To capture a new image of the new student and store it in its directory. 
function Picture_Callback(hObject, eventdata, handles)
global co

% To reset the axes of the TestVerification figure. 
if isfield(handles,'vdx')
    vid = handles.vdx;
    stoppreview(vid)
    delete(vid)
    handles = rmfield(handles,'vdx');
    guidata(hObject,handles)
    cla(handles.left_window)
    reset(handles.left_window)
    set(handles.left_window,'box','on','xcolor','w','ycolor','w','xtick',[],'ytick',[],'color',[0.0431  0.5176  0.7804],'linewidth',1.5)
    cla(handles.right_window)
    reset(handles.right_window)
    set(handles.right_window,'box','on','xcolor','w','ycolor','w','xtick',[],'ytick',[],'color',[0.0431  0.5176  0.7804],'linewidth',1.5)
end


fd = vision.CascadeObjectDetector(); % Detects an object in a live camera image. 
info = imaqhwinfo('winvideo');
did = info.DeviceIDs;
if isempty(did)
    msgbox({'Your system does not contain a webcam';' ';'Connect a webcam'},'WARNING....!!!!','warn','modal')
    return
end
did = cell2mat(did);
for k = 1:length(did)
    devinfo = imaqhwinfo('winvideo',k); %https:\\www.mathworks.com\help\imaq\macintosh-video-hardware.htm
    na(1,k) = {devinfo.DeviceName};
    sr(1,k) = {devinfo.SupportedFormats};
end
[a,b] = listdlg('promptstring','Select a webcam device.','liststring',na,'ListSize', [125, 75],'SelectionMode','single');
if b == 0
    return
end
if b ~= 0
    frmt = sr{1,a};
    [a1,b1] = listdlg('promptstring','Select resolution','liststring',frmt,'ListSize', [150, 100],'SelectionMode','single');
    if b1 == 0
        return
    end
end
frmt = frmt{a1};
l = find(frmt == '_');
res = frmt(l+1 : end); % Stores the selected resolution
l = find(res == 'x'); % Finds were the postion of the variable x in 1280x720 resolution
res1 = str2double(res(1: l-1)); % Stores the 1280 dimenson of the resolution
res2 = str2double(res(l+1 : end)); % Stores the 720 dimension of the resolution
axes(handles.left_window) 
vid = videoinput('winvideo', a);% Live video of through mac video adaptor.
vr  =  [res1    res2]; % Video resolution of each dimension stored as an array [1280,720]
nbands  =  get(vid,'NumberofBands'); % To indicate the number of bands in data to be acquired in the video. 
h2im  = image(zeros([vr(2)  vr(1)  nbands] , 'uint8')); % Sets the number of bands as the size of the left window stored in h2im.
preview(vid,h2im); % Shows live video feed based on the dimensions of h2im.
handles.vdx = vid;
guidata(hObject,handles)
tx = msgbox('Stand still in front of camera.','Instruction');
pause(1)
close(tx)
kx  =  0;

% To recognize the face of the live camera from the webcam. 
while 1 % A loop that is continuosly extracting the frames of the live video. 
    im = getframe(handles.left_window); % Gets a frame of the video
    im =  im.cdata;
    bbox = step(fd, im);
    vo = insertObjectAnnotation(im,'rectangle',bbox,'FACE'); % Inserts a rectangle and 
    % put the annotation FACE to label the detected face.
    axes(handles.right_window)
    imshow(vo)
    
    % Checks to see how many faces are in the live camera frame. 
    if size(bbox,1) > 1
        msgbox({'Too many faces in frame.';' ';'Only one face is accepted'},'WARNING.....!!!','warn','modal')
        uiwait
        stoppreview(vid)
        delete(vid)
        handles = rmfield(handles,'vdx');
        guidata(hObject,handles)
        cla(handles.left_window)
        reset(handles.left_window)
        set(handles.left_window,'box','on','xtick',[],'ytick',[],'xcolor',[1 1 1],'ycolor',[1 1  1],'color',co,'linewidth',1.5)
        cla(handles.right_window)
        reset(handles.right_window)
        set(handles.right_window,'box','on','xtick',[],'ytick',[],'xcolor',[1 1 1],'ycolor',[1 1  1],'color',co,'linewidth',1.5)
        return
    end
    
     % After 10 frames are captured then it will break the while loop. 
    kx = kx + 1; 
    if kx > 10 && ~isempty(bbox)
        break
    end
end

% To crop, resize and set the recgonized face in the left window. This
% displays the current image. 
imc = imcrop(im,[bbox(1)+3    bbox(2)-35    bbox(3)-10      bbox(4)+70]); % Crops im based on the indices of bbox
imx  =   imresize(imc,[300  300]); % Resizes the imc 
axes(handles.left_window) % To control the left window in TestVerification figure. 
image(imx)  % Sets imx to the left window of the GUI.
cd ('FaceDatabaseFolder');
while 1
    dd = string(inputdlg('What directory would you like your image stored? (eg. Timothy Fisher) Enter student name:', 'Folder'));
    cd ('.\'+(dd)+'\\')
    qq = char(inputdlg('Enter students initials and picture number (eg. TF1).','Initials'));
    n = [qq    '.jpg'];
    imwrite(imx,n);
    cd ..\..\
    if isempty(qq)
        msgbox({'Please enter intials';' ';'You can not cancel'},'INFO','HELP','MODAL')
        uiwait
    else
        break
    end
end
stoppreview(vid)
delete(vid)
handles = rmfield(handles,'vdx');
guidata(hObject,handles)
cla(handles.left_window)
reset(handles.left_window)
set(handles.left_window,'box','on','xtick',[],'ytick',[],'xcolor',[1 1 1],'ycolor',[1 1  1],'color',[0.0431  0.5176  0.7804],'linewidth',1.5)
cla(handles.right_window)
reset(handles.right_window)
set(handles.right_window,'box','on','xtick',[],'ytick',[],'xcolor',[1 1 1],'ycolor',[1 1  1],'color',[0.0431  0.5176  0.7804],'linewidth',1.5)
