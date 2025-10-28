function varargout = PMTec_Reconstr(varargin)
% PMTEC_RECONSTR MATLAB code for PMTec_Reconstr.fig
%      PMTEC_RECONSTR, by itself, creates a new PMTEC_RECONSTR or raises the existing
%      singleton*.
%
%      H = PMTEC_RECONSTR returns the handle to a new PMTEC_RECONSTR or the handle to
%      the existing singleton*.
%
%      PMTEC_RECONSTR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PMTEC_RECONSTR.M with the given input arguments.
%
%      PMTEC_RECONSTR('Property','Value',...) creates a new PMTEC_RECONSTR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PMTec_Reconstr_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PMTec_Reconstr_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PMTec_Reconstr

% Last Modified by GUIDE v2.5 21-Sep-2014 22:24:41

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PMTec_Reconstr_OpeningFcn, ...
                   'gui_OutputFcn',  @PMTec_Reconstr_OutputFcn, ...
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


% --- Executes just before PMTec_Reconstr is made visible.
function PMTec_Reconstr_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PMTec_Reconstr (see VARARGIN)

% Choose default command line output for PMTec_Reconstr
handles.output = hObject;

%--------------------------------------------------------------------------
% Enter expity date
nexepiry = datenum('31-Dec-2025');
curdate = datenum(date);
if curdate > nexepiry
    sadnews=figure('menubar','none','position',[330 322 450 94]);
    axis off
uicontrol('style','text','string',...
    'Please download the latest PMTec release! http://www.ualberta.ca/~vadim/software.htm',...
    'position',[30 30 400 40],'fontsize',12,'fontweight','bold');
    uiwait(sadnews);
    close all;clear all
end
%--------------------------------------------------------------------------

% initiate map axes and all the map background data
axes(handles.axes1); axesm eqdcylin % mollweid;eqdcylin;
framem on; axis off; tightmap; gridm on,
handles.ProjT='eqdcylin';

% 2) load coastline
coast=load('coast');
handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none');

set(handles.view1,'string',num2str(0));
set(handles.view2,'string',num2str(0));
set(handles.view3,'string',num2str(0));

set(handles.viewR1,'string',num2str(0));
set(handles.viewR2,'string',num2str(0));
set(handles.viewR3,'string',num2str(0));

set(handles.latR,'string','NaN');
set(handles.lonR,'string','NaN');

% setup maptype for Rec
handles.ProjTypes1=2; %'mollweid';
handles.ColorCodeS=jet; % autumn

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PMTec_Reconstr wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PMTec_Reconstr_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in MakeRecSt.
function MakeRecSt_Callback(hObject, eventdata, handles)
% hObject    handle to MakeRecSt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%-------------------------------
% RecSt=NewEulerAPWP(Euler,APWP)
% 1) construct structural data
% f1=[APWP; APWP tracks];
% f2=[APWP tracks'];
% f3=[PEP; PEP'; PEP_err; PEP'_err;];
% f4=[ref, ref_cor (ref_Modify), (ref_cor)];
% f5=[plate];
% f6=[plate_cor (plate_adj)];
% f7=[(plate_cor)];
% f8=[age,Velo,LatV,LonV]; from PMTec_PtKin
% f9-f10: backup storage
%-------------------------------

ref=[str2num(get(handles.lonR,'String')),...
     str2num(get(handles.latR,'String'))];

 if isfield(handles,{'PEP','APWP','Contour'})==0
     disp('Please load PEP, APWP and plate contour first!');
 elseif isfield(handles,{'PEP','APWP','Contour'})==1
     RecSt=NewEulerAPWP(handles.PEP, handles.APWP);
     RecSt(1).f4=ref;
     RecSt(1).f5=handles.Contour;
     RecSt(1).f6=handles.Contour;
     RecSt(1).f7=handles.Contour;
     RecSt(1).f8=handles.APWP(:,1);
     
     handles.rec.RecSt=RecSt;
     set(handles.hContour,'visible','off');
     set(handles.href,'visible','off');
     
     % save .mat file
     [FileName,PathName]=uiputfile('*.mat','Save Plate Contour As');
     if FileName ~= 0
         nbfiles = 1;
     else
         nbfiles = 0;
     end
     
     if nbfiles==1
         % FullName=[PathName,FileName];
         FullName=[PathName,'RecSt','_',FileName];
         save(FullName, 'RecSt');
         handles.RecStName1=FileName;
         handles.RecStName2=FullName;
         disp('RecSt compiled and exported.');
     elseif nbfiles==0
         %     disp('Please name RecSt file!');
     end
 end
% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function lonR_Callback(hObject, eventdata, handles)
% hObject    handle to lonR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lonR as text
%        str2double(get(hObject,'String')) returns contents of lonR as a double
% plot the reference site

delete(handles.href);
handles.href=geoshow(str2num(get(handles.latR,'String')),...
    str2num(get(handles.lonR,'String')),...
    'DisplayType','point','Marker','o','MarkerSize',8,...
    'MarkerFaceColor',[1 .6 .78],'MarkerEdgeColor','k','LineWidth',1);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function lonR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lonR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function latR_Callback(hObject, eventdata, handles)
% hObject    handle to latR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of latR as text
%        str2double(get(hObject,'String')) returns contents of latR as a double
delete(handles.href);
handles.href=geoshow(str2num(get(handles.latR,'String')),...
    str2num(get(handles.lonR,'String')),...
    'DisplayType','point','Marker','o','MarkerSize',8,...
    'MarkerFaceColor',[1 .6 .78],'MarkerEdgeColor','k','LineWidth',1);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function latR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to latR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function view1_Callback(hObject, eventdata, handles)
% hObject    handle to view1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of view1 as text
%        str2double(get(hObject,'String')) returns contents of view1 as a double
cla(handles.axes1);

% 2) Initially defined parameters:
mapview=[str2num(get(handles.view1,'String')),...
         str2num(get(handles.view2,'String')),...
         str2num(get(handles.view3,'String'))];


% 3) initiate map axes and all the map background data
axes(handles.axes1); axis off, axesm(handles.ProjT) % mollweid;ortho;eqdcylin
setm(gca,'Origin', mapview), framem on; tightmap; gridm on

% load coastline
coast=load('coast');
handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none');

 guidata(hObject, handles);
 
 

% --- Executes during object creation, after setting all properties.
function view1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to view1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function view2_Callback(hObject, eventdata, handles)
% hObject    handle to view2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of view2 as text
%        str2double(get(hObject,'String')) returns contents of view2 as a double
cla(handles.axes1);

% 2) Initially defined parameters:
mapview=[str2num(get(handles.view1,'String')),...
         str2num(get(handles.view2,'String')),...
         str2num(get(handles.view3,'String'))];


% 3) initiate map axes and all the map background data
axes(handles.axes1); axis off, axesm(handles.ProjT) % mollweid;ortho;eqdcylin
setm(gca,'Origin', mapview), framem on; tightmap; gridm on

% load coastline
coast=load('coast');
handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none');

 guidata(hObject, handles);
 

% --- Executes during object creation, after setting all properties.
function view2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to view2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function view3_Callback(hObject, eventdata, handles)
% hObject    handle to view3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of view3 as text
%        str2double(get(hObject,'String')) returns contents of view3 as a double
cla(handles.axes1);

% 2) Initially defined parameters:
mapview=[str2num(get(handles.view1,'String')),...
         str2num(get(handles.view2,'String')),...
         str2num(get(handles.view3,'String'))];


% 3) initiate map axes and all the map background data
axes(handles.axes1); axis off, axesm(handles.ProjT) % mollweid;ortho;eqdcylin
setm(gca,'Origin', mapview), framem on; tightmap; gridm on

% load coastline
coast=load('coast');
handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none');

 guidata(hObject, handles);
 
 
% --- Executes during object creation, after setting all properties.
function view3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to view3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OpenGeometry.
function OpenGeometry_Callback(hObject, eventdata, handles)
% hObject    handle to OpenGeometry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Open standard dialog box for retrieving files
[FileName,PathName] = uigetfile( ...
{'*.xlsx;*.xls;*.txt;*.dat;*.shp',...
 'Excel Workbook (*.xlsx,*.xls)';
   '*.txt',  'Tab delimited (*.txt)'; ...
   '*.dat','Data files (*.dat)'; ...
   '*.shp','Shape files (*.shp)'}, ...
   'Select a file');
if FileName ~= 0
    nbfiles = 1;
else
    nbfiles = 0;
end

if nbfiles==1
    FFPNPM = strcat(PathName,FileName);
    % Data of PM data
    if FileName(length(FileName)-4:length(FileName))=='.xlsx'
        LoadINdata=xlsread(FFPNPM);
    elseif FileName(length(FileName)-3:length(FileName))=='.xls'
        LoadINdata=xlsread(FFPNPM);
    elseif FileName(length(FileName)-3:length(FileName))=='.shp'
        LoadINdata2=shaperead(FFPNPM);
        LoadINdata1X=[]; LoadINdata1Y=[];
        for i=1:length(LoadINdata2)
            LoadINdata1X=[LoadINdata1X,LoadINdata2(i).X];
            LoadINdata1Y=[LoadINdata1Y,LoadINdata2(i).Y];
        end
        LoadINdata=[LoadINdata1X',LoadINdata1Y'];
    else
        LoadINdata=importdata(FFPNPM);
    end
    handles.Contour=LoadINdata;
    
    % plot the contour
    handles.hContour=geoshow(handles.Contour(:,2),handles.Contour(:,1),...
        'DisplayType','line','linestyle','--','color',[0 .5 0],'LineWidth',1.5);
    
    % plot the reference site
    handles.href=geoshow(handles.Contour(1,2),handles.Contour(1,1),...
        'DisplayType','point','Marker','o','MarkerSize',9,...
        'MarkerFaceColor',[1 .6 .78],'MarkerEdgeColor','k','LineWidth',1.5);
    
    % pass the results to text box
    set(handles.lonR,'string',num2str(handles.Contour(1,1)));
    set(handles.latR,'string',num2str(handles.Contour(1,2)));
    
    disp('Plate contour file loaded.');
elseif nbfiles==0
%     disp('Please select a file!')
end

guidata(hObject, handles);



% --- Executes on button press in OpenPEP.
function OpenPEP_Callback(hObject, eventdata, handles)
% hObject    handle to OpenPEP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Open standard dialog box for retrieving files
[FileName,PathName] = uigetfile( ...
{'*.xlsx;*.xls;*.txt;*.dat',...
 'Excel Workbook (*.xlsx,*.xls)';
   '*.txt',  'Tab delimited (*.txt)'; ...
   '*.dat','Data files (*.dat)'}, ...
   'Select a file');
if FileName ~= 0
    nbfiles = 1;
else
    nbfiles = 0;
end

if nbfiles==1
    % FFPNPM=Full File Path Name of PM data
    FFPNPM = strcat(PathName,FileName);
    % Data of PM data
    if FileName(length(FileName)-4:length(FileName))=='.xlsx'
        handles.PEP=xlsread(FFPNPM);
    elseif FileName(length(FileName)-3:length(FileName))=='.xls'
        handles.PEP=xlsread(FFPNPM);
    else
        handles.PEP=importdata(FFPNPM);
    end
    disp('PEP file loaded.');
elseif nbfiles==0
%     disp('Please select a file!')
end

guidata(hObject, handles);


% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in OpenAPWP.
function OpenAPWP_Callback(hObject, eventdata, handles)
% hObject    handle to OpenAPWP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Open standard dialog box for retrieving files
[FileName,PathName] = uigetfile( ...
{'*.xlsx;*.xls;*.txt;*.dat',...
 'Excel Workbook (*.xlsx,*.xls)';
   '*.txt',  'Tab delimited (*.txt)'; ...
   '*.dat','Data files (*.dat)'}, ...
   'Select a file');
if FileName ~= 0
    nbfiles = 1;
else
    nbfiles = 0;
end

if nbfiles==1
    % FFPNPM=Full File Path Name of PM data
    FFPNPM = strcat(PathName,FileName);
    % Data of PM data
    if FileName(length(FileName)-4:length(FileName))=='.xlsx'
        handles.APWP=xlsread(FFPNPM);
    elseif FileName(length(FileName)-3:length(FileName))=='.xls'
        handles.APWP=xlsread(FFPNPM);
    else
        handles.APWP=importdata(FFPNPM);
    end
    handles.RecStAge=handles.APWP(:,1);
    disp('APWP file loaded.');
elseif nbfiles==0
%     disp('Please select a file!')
end

guidata(hObject, handles);

% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Calculate.
function Calculate_Callback(hObject, eventdata, handles)
% hObject    handle to Calculate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton28.
function pushbutton28_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton28 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton29.
function pushbutton29_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton29 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LoadRecSt.
function LoadRecSt_Callback(hObject, eventdata, handles)
% hObject    handle to LoadRecSt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Open standard dialog box for retrieving files
[FileName,PathName] = uigetfile('*.mat');
if FileName ~= 0
    nbfiles = 1;
else
    nbfiles = 0;
end

if nbfiles==1
    % FFPNPM=Full File Path Name of PM data
    FFPNPM = strcat(PathName,FileName);
    handles.RecStName1=FileName;
    handles.RecStName2=FFPNPM;
    % Rotation parameters
    load(FFPNPM);
    if exist('RecSt','var')==0
        disp('Please load the correct RecSt file!');
    elseif exist('RecSt','var')==1
        handles.rec.RecSt=RecSt;
        disp('RecSt.mat loaded.');
        handles.RecStAge=RecSt(1).f8(:,1);
    end
    
elseif nbfiles==0
%     disp('Please select a file!')
end

guidata(hObject, handles);


% --- Executes on button press in pushbutton33.
function pushbutton33_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton33 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton34.
function pushbutton34_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton34 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in CalcRec.
function CalcRec_Callback(hObject, eventdata, handles)
% hObject    handle to CalcRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'rec')==0
    disp('Please load RecSt file first!');
elseif isfield(handles,'rec')==1
    clear Aux RecSt Euler
    RecSt=handles.rec.RecSt;
    
    % Euler poles
    % RecSt(2).f3(:,3)=-RecSt(2).f3(:,3);
    Euler=RecSt(2).f3;
    Euler(:,3)=-Euler(:,3);
    
    % Aux=[R2S_i, R2StC_i,RecSub2,RecSubCorr2]
    Aux=struct('f1',{NaN},'f2',{NaN},'f3',{NaN},'f4',{NaN});
    
    maptype=handles.ProjTypes1;
    mapview=[str2num(get(handles.viewR1,'String')),...
        str2num(get(handles.viewR2,'String')),...
        str2num(get(handles.viewR3,'String'))];
    
    figure(1)
    % plotmap(APWP,plate,ref,Euler,mapview,maptype)
    plotmap(RecSt(1).f2,RecSt(1).f5,RecSt(1).f4,Euler,mapview,maptype);
    % 1) 1st rotation
    % [R2S,R2St2,plaRect2]=PEP_Rec(APWPt,plate,ref,Euler,flipcon,theta_M)
    % [RecSub,RecSubCorr]=...
    %            SubRotCorr(APWPt,ref,Euler,color1,color2,marker1,marker2,theta_M)
    theta_M1=distance(RecSt(1).f4(1,2),RecSt(1).f4(1,1),...
        [RecSt(1).f1(1,2);RecSt(1).f1(length(RecSt(1).f1(:,1)),2)],...
        [RecSt(1).f1(1,1);RecSt(1).f1(length(RecSt(1).f1(:,1)),1)]);
    theta_M2=distance(RecSt(1).f4(1,2),RecSt(1).f4(1,1),...
        RecSt(1).f1(:,2),RecSt(1).f1(:,1));
    
    [Aux(1).f1,Aux(1).f2,RecSt(2).f6]=...
        PEP_Rec(RecSt(1).f2,RecSt(1).f5,RecSt(1).f4(1,:),Euler(1,:),2,theta_M1);
    [Aux(1).f3,Aux(1).f4]=SubRotCorr(RecSt(1).f2,...
        RecSt(1).f4(1,:),Euler(1,:),winter,autumn,'s','s',theta_M2);
    temp1=Aux(1).f3;
    temp2=Aux(1).f4;
    
    for i=2:length(RecSt(2).f3(:,1))
        
        figure(i)
        plotmap(RecSt(i).f2,RecSt(i).f6,Aux(i-1).f2,...
            Euler,mapview,maptype)
        
        % actual colatitude
        theta_M1=distance(RecSt(1).f4(1,2),RecSt(1).f4(1,1),...
            [RecSt(i).f1(1,2);RecSt(i).f1(length(RecSt(i).f1(:,1)),2)],...
            [RecSt(i).f1(1,1);RecSt(i).f1(length(RecSt(i).f1(:,1)),1)]);
        theta_M2=distance(RecSt(1).f4(1,2),RecSt(1).f4(1,1),...
            RecSt(i).f1(:,2),RecSt(i).f1(:,1));
        
        [Aux(i).f1,Aux(i).f2,RecSt(i+1).f6]=...
            PEP_Rec(RecSt(i).f2,RecSt(i).f6,Aux(i-1).f2,Euler(i,:),2,theta_M1);
        
        [Aux(i).f3,Aux(i).f4]=SubRotCorr(RecSt(i).f2,...
            Aux(i-1).f2,Euler(i,:),winter,autumn,'s','s',theta_M2);
        
        temp1=[temp1;Aux(i).f3(2:length(Aux(i).f3(:,1)),:)];
        temp2=[temp2;Aux(i).f4(2:length(Aux(i).f4(:,1)),:)];
        
    end
    
    % f4=[ref; ref_cor]
    RecSt(1).f4=temp1; RecSt(2).f4=temp2;
    % separate the data from the uncertainties
    RecSt(i+1).f1=NaN;RecSt(i+1).f2=NaN;RecSt(i+1).f3=NaN;RecSt(i+1).f4=NaN;
    RecSt(i+1).f5=NaN;RecSt(i+2).f6=NaN;RecSt(i+1).f7=NaN;RecSt(i+1).f8=NaN;
    RecSt(i+1).f9=NaN;RecSt(i+1).f10=NaN;
    
    %-------------------------------------------------------------------------
    % plot the reconstructed refs
    axes(handles.axes1);
    handles.hrefrec=geoshow(RecSt(2).f4(:,2),RecSt(2).f4(:,1),...
        'DisplayType','point','Marker','o','MarkerSize',7,...
        'MarkerFaceColor',[.73 .83 .95],'MarkerEdgeColor','k','LineWidth',1);
    indP=[1:1:length(RecSt(2).f4(:,1))]';
    [GP,GNP]=grp2idx(indP);
    GNP(length(GNP))=[];GNP=['0';GNP];
    for i = 1:length(RecSt(2).f4(:,1))
        textm(RecSt(2).f4(i,2),RecSt(2).f4(i,1),GNP(i),'Color',...
            'blue','FontSize',12)
    end
    
    %-------------------------------------------------------------------------
    % calculate plate contour at different ages
    value={NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN};
    Platecont=struct('f1',value,'f2',value,'f3',value);
    Platecont(1).f1=RecSt(1).f5;
    Platecont(1).f2=RecSt(1).f5;
    Platecont(1).f3=RecSt(1).f5;
    for j=1:length(RecSt(2).f3(:,1))
        clear contourSub1 contourSub2
        contourSub1=struct('f1',{'v'},'f2',{'v'});
        contourSub2=struct('f1',{'v'},'f2',{'v'});
        
        for i=sum(RecSt(2).f3(1:j-1,4))-j+2:sum(RecSt(2).f3(1:j,4))-(j-1)
            contourSub1(i-(sum(RecSt(2).f3(1:j-1,4))-j+1)).f1=Platecont(i).f1;
            contourSub1(i-(sum(RecSt(2).f3(1:j-1,4))-j+1)).f2=Platecont(i).f1;
        end
        
        contourSub2=SubRotPlateOnly(RecSt(j).f2,...
            RecSt(2).f4(sum(RecSt(2).f3(1:j-1,4))-j+2,:),Euler(j,:),contourSub1);
        
        for i=sum(RecSt(2).f3(1:j-1,4))-j+3:sum(RecSt(2).f3(1:j,4))-(j-1)
            Platecont(i).f1=contourSub2(i-(sum(RecSt(2).f3(1:j-1,4))-j+1)).f1;
            Platecont(i).f2=contourSub2(i-(sum(RecSt(2).f3(1:j-1,4))-j+1)).f2;
        end
        
    end
    %-------------------------------------------------------------------------
    
    for i=1:length(RecSt(2).f4(:,1))
        RecSt(i).f5=Platecont(i).f1;
        RecSt(i).f6=Platecont(i).f2;
    end
    RecSt(i+1).f5=NaN;RecSt(i+1).f6=NaN;
    
    handles.rec.RecSt=RecSt;
    
    caxis([min(RecSt(1).f8) max(RecSt(1).f8)]);
    % apply new colormap
    colormap(jet(length(RecSt(2).f4(:,2))));
    
    % calculate finite rotations from reconstructed plate contours
    numCont=round(linspace(1,length(RecSt(1).f6(:,1)),3));
    % convert Point M(lonM,latM) to cartesian coordinates:
    [Mx0,My0,Mz0]=sph2cart(RecSt(1).f5(numCont,1)*pi/180,...
        RecSt(1).f5(numCont,2)*pi/180,1);
    R0=[Mx0,My0,Mz0]';
    [Mx0,My0,Mz0]=sph2cart(RecSt(1).f6(numCont,1)*pi/180,...
        RecSt(1).f6(numCont,2)*pi/180,1);
    Rt0=[Mx0,My0,Mz0]';    
    for i=1:length(RecSt(2).f4(:,1))
        % for uncorrected plate
        [Mx,My,Mz]=sph2cart(RecSt(i).f5(numCont,1)*pi/180,...
            RecSt(i).f5(numCont,2)*pi/180,1);
        Rx=[Mx,My,Mz]';
        RotMat=Rx/R0;
        [lonE,latE,omega]=step2_Wing_RotM2Euler(RotMat);
        RecSt(1).f4(i,10:12)=[lonE,latE,omega];
        
        % for corrected plate
        [Mx,My,Mz]=sph2cart(RecSt(i).f6(numCont,1)*pi/180,...
            RecSt(i).f6(numCont,2)*pi/180,1);
        Rtx=[Mx,My,Mz]';
        RotMat=Rtx/Rt0;
        [lonE,latE,omega]=step2_Wing_RotM2Euler(RotMat);
        RecSt(2).f4(i,10:12)=[lonE,latE,omega];
    end
    
    FileName=handles.RecStName1;
    FFPNPM=handles.RecStName2;
%     save(FileName,'RecSt');
    save(FFPNPM,'RecSt');
    disp('Reconstructions calculated and saved.');
end
guidata(hObject, handles);



% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4

axes(handles.axes1); axis off;
ProjTypes=get(hObject,'Value');
switch ProjTypes
    case 1
        % initiate map: mollweid, ortho
        cla(handles.axes1); axesm mollweid; handles.ProjT='mollweid';
    case 2
        cla(handles.axes1); axesm mollweid; handles.ProjT='mollweid';
    case 3
        cla(handles.axes1); axesm ortho; handles.ProjT='ortho';
    case 4
        cla(handles.axes1); axesm robinson; handles.ProjT='robinson';
    case 5
        cla(handles.axes1); axesm mercator; handles.ProjT='mercator';
    case 6
        cla(handles.axes1); axesm sinusoid; handles.ProjT='sinusoid';
    case 7
        cla(handles.axes1); axesm eqdcylin; handles.ProjT='eqdcylin';
    otherwise
        %axesm mercator;
end

% 2) Initially defined parameters:
mapview=[str2num(get(handles.view1,'String')),...
         str2num(get(handles.view2,'String')),...
         str2num(get(handles.view3,'String'))];


% 3) initiate map axes and all the map background data
setm(gca,'Origin', mapview), framem on; tightmap; gridm on

% load coastline
coast=load('coast');
handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none');

disp('Projection map selected.');
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton41.
function pushbutton41_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton41 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uipanel6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


function viewR1_Callback(hObject, eventdata, handles)
% hObject    handle to viewR1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of viewR1 as text
%        str2double(get(hObject,'String')) returns contents of viewR1 as a double


% --- Executes during object creation, after setting all properties.
function viewR1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to viewR1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function viewR2_Callback(hObject, eventdata, handles)
% hObject    handle to viewR2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of viewR2 as text
%        str2double(get(hObject,'String')) returns contents of viewR2 as a double


% --- Executes during object creation, after setting all properties.
function viewR2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to viewR2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function viewR3_Callback(hObject, eventdata, handles)
% hObject    handle to viewR3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of viewR3 as text
%        str2double(get(hObject,'String')) returns contents of viewR3 as a double


% --- Executes during object creation, after setting all properties.
function viewR3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to viewR3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ProjTypes1.
function ProjTypes1_Callback(hObject, eventdata, handles)
% hObject    handle to ProjTypes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ProjTypes1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ProjTypes1
handles.ProjTypes1=get(hObject,'Value');

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ProjTypes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ProjTypes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ColorCodeS.
function ColorCodeS_Callback(hObject, eventdata, handles)
% hObject    handle to ColorCodeS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ColorCodeS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ColorCodeS

ColorCodeS=get(hObject,'Value');
if isfield(handles,'rec')==0
    disp('Please load RecSt file first!');
elseif isfield(handles,'rec')==1
    switch ColorCodeS
        case 1
            % initiate colormap
            handles.ColorCodeS=jet(length(handles.rec.RecSt(1).f8(:,1)));
        case 2
            handles.ColorCodeS=jet(length(handles.rec.RecSt(1).f8(:,1)));
        case 3
            handles.ColorCodeS=hsv(length(handles.rec.RecSt(1).f8(:,1)));
        case 4
            handles.ColorCodeS=hot(length(handles.rec.RecSt(1).f8(:,1)));
        case 5
            handles.ColorCodeS=cool(length(handles.rec.RecSt(1).f8(:,1)));
        case 6
            handles.ColorCodeS=spring(length(handles.rec.RecSt(1).f8(:,1)));
        case 7
            handles.ColorCodeS=summer(length(handles.rec.RecSt(1).f8(:,1)));
        case 8
            handles.ColorCodeS=autumn(length(handles.rec.RecSt(1).f8(:,1)));
        case 9
            handles.ColorCodeS=winter(length(handles.rec.RecSt(1).f8(:,1)));
        case 10
            handles.ColorCodeS=gray(length(handles.rec.RecSt(1).f8(:,1)));
        case 11
            handles.ColorCodeS=bone(length(handles.rec.RecSt(1).f8(:,1)));
        case 12
            handles.ColorCodeS=copper(length(handles.rec.RecSt(1).f8(:,1)));
        case 13
            handles.ColorCodeS=pink(length(handles.rec.RecSt(1).f8(:,1)));
        case 14
            handles.ColorCodeS=lines(length(handles.rec.RecSt(1).f8(:,1)));
        otherwise
            
    end
    
    disp('Colormap selected.');
end
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ColorCodeS_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ColorCodeS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton46.
function pushbutton46_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton46 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton47.
function pushbutton47_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton47 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in ExportBootEu.
function ExportBootEu_Callback(hObject, eventdata, handles)
% hObject    handle to ExportBootEu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'BootEuNewRG')==0
    disp('Please calculate Boot Euler parameters first!');
elseif isfield(handles,'BootEuNewRG')==1
    BootEuNewRG=handles.BootEuNewRG;
    [FileName,PathName]=uiputfile('*.mat','Save BootEuNewRG As');
    if FileName ~= 0
        nbfiles = 1;
    else
        nbfiles = 0;
    end
    
    if nbfiles==1
        FileName(length(FileName))=[];FileName(length(FileName))=[];
        FileName(length(FileName))=[];FileName(length(FileName))=[];
        FullName=[PathName,'BootEuNewRG','_',FileName,'.mat'];
        save(FullName, 'BootEuNewRG');
        disp('BootEuNewRG.mat saved.');
    elseif nbfiles==0
        %     disp('Please name the data!');
    end
end
guidata(hObject, handles);


% --- Executes on button press in ExportBootRec.
function ExportBootRec_Callback(hObject, eventdata, handles)
% hObject    handle to ExportBootRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'BootRecRG')==0
    disp('Please calculate Boot reconstructions first!');
elseif isfield(handles,'BootRecRG')==1
    BootRecRG=handles.BootRecRG;
    [FileName,PathName]=uiputfile('*.mat','Save BootRecRG As');
    if FileName ~= 0
        nbfiles = 1;
    else
        nbfiles = 0;
    end
    
    if nbfiles==1
        
        FileName(length(FileName))=[];FileName(length(FileName))=[];
        FileName(length(FileName))=[];FileName(length(FileName))=[];
        FullName=[PathName,'BootRec','_',FileName,'.mat'];
        save(FullName, 'BootRecRG');
        disp('BootRecRG.mat saved.');
    elseif nbfiles==0
        %     disp('Please name the data!');
    end
end
guidata(hObject, handles);


% --- Executes on button press in OpenAPWPboot.
function OpenAPWPboot_Callback(hObject, eventdata, handles)
% hObject    handle to OpenAPWPboot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Open standard dialog box for retrieving files
[FileName,PathName] = uigetfile('*.mat');
if FileName ~= 0
    nbfiles = 1;
else
    nbfiles = 0;
end

if nbfiles==1
    % FFPNPM=Full File Path Name of PM data
    FFPNPM = strcat(PathName,FileName);
    % Rotation parameters
    load(FFPNPM);
    if exist('BootRes','var')==0
        disp('Please load the correct APWPboot file!');
    elseif exist('BootRes','var')==1
        handles.BootRes=BootRes;
        disp('APWPboot loaded.');
    end
elseif nbfiles==0
%     disp('Please select a file!')
end

guidata(hObject, handles);


% --- Executes on button press in BootEuler.
function BootEuler_Callback(hObject, eventdata, handles)
% hObject    handle to BootEuler (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,{'BootRes','rec'})==0
    disp('Please load APWPboot and RecSt files first!');
elseif isfield(handles,{'BootRes','rec'})==1
%------------------------------------------------------------------------
    disp('Bootstrap Calculating... Be Patient... (5 steps) O(*_*)O')
    disp('1. Rearranging APWPboot (BootAPWP)... ... ...')
    % 1) Rearrange the BootAPWP
    BootRes=handles.BootRes;
    
    lonBoot=zeros(length(BootRes),length(BootRes(1).f1(:,1)));
    latBoot=zeros(length(BootRes),length(BootRes(1).f1(:,1)));
    for i=1:length(BootRes)
        % save the bootstrap resampled data
        lonBoot(i,:)=BootRes(i).f1(:,1)';
        latBoot(i,:)=BootRes(i).f1(:,2)';
    end
    % construct a structure data
    value={NaN};
    BootAPWP=struct('f',value);
    BootAPWP(1).f=lonBoot;
    BootAPWP(2).f=latBoot;
    
    % function BootAPWPnew=ReArrAPWP(BootAPWP,ResN,N)
    BootAPWP=ReArrAPWP(BootAPWP,length(BootRes),length(BootRes(1).f1(:,1)));
    
    % save BootAPWP.mat BootAPWP
    handles.BootAPWP=BootAPWP;
    
%------------------------------------------------------------------------
    % 2) BootEuler_Main2
    disp('2. Calculating boot Euler parameters (BootEuGC,BootEuSC)... ...')
    
    BootAPWP=handles.BootAPWP;
    RecSt=handles.rec.RecSt;
    
    % initiate resulting structure data
    value={NaN};
    BootEuGC=struct('f1',value,'f2',value);
    BootEuSC=struct('f1',value,'f2',value);
    
    % Reconstruct BootAPWP into segments for direct fitted:
    % ResBootAPWP=[lonP,latP]
    ResBootAPWP=struct('f1',value,'f2',value);
    
    Num=RecSt(2).f3(:,4);
    ResBootAPWP(1).f1=BootAPWP(1).f(1:Num(1),:);
    ResBootAPWP(1).f2=BootAPWP(2).f(1:Num(1),:);
    for i=2:length(RecSt(2).f3(:,1))
        ResBootAPWP(i).f1=BootAPWP(1).f(sum(Num(1:i-1))-(i-2):sum(Num(1:i))-(i-1),:);
        ResBootAPWP(i).f2=BootAPWP(2).f(sum(Num(1:i-1))-(i-2):sum(Num(1:i))-(i-1),:);
    end
    
    % calculate the bootstrapped GC and SC fitting
    for k=1:length(RecSt(2).f3(:,1))
        % specify APWP segment [Dec Inc]
        Dec=ResBootAPWP(k).f1;
        Inc=ResBootAPWP(k).f2;
        
        npts=size(Dec);  % [row, col]
        
        % convert [Dec Inc] into direction cosine (a1, a2, a3), where
        % a1^2+a2^2+a3^2=1
        [a1, a2, a3]=sph2cart(Dec./(180/pi), Inc./(180/pi), 1);
        BootFit_SC=zeros(npts(2),4);
        BootFit_GC=zeros(npts(2),4);
        BootEuPar_GC=zeros(npts(2),6);
        BootEuPar_SC=zeros(npts(2),6);
        
        % calculate both GC and SC bootstrapped Euler parameters
        for j=1:npts(2)
            % 1) least-square small circle fitting
            % [lonV_SC, latV_SC, D_SC, rSC]=LSQCircFit_SC(a1, a2, a3, N(1));
            [lonV_SC, latV_SC, D_SC, rSC]=LSQCircFit_SC(a1(:,j), a2(:,j), a3(:,j), npts(1));
            BootFit_SC(j,:)=[lonV_SC, latV_SC, D_SC, rSC];
            % correct the rotation direction of SC fitting
            if distance(RecSt(1).f3(k,2),RecSt(1).f3(k,1),...
                    BootFit_SC(j,2),BootFit_SC(j,1))>90
                BootFit_SC(j,3)=RecSt(1).f3(k,5)*BootFit_SC(j,3);
            end
            
            % calculate boostrapped Euler parameters for SC fitting
            % BootEuPar_SC=[lonESC latESC omegaSC]
            [lonESC latESC omegaSC]=LSQCircFit_EuraPar(BootFit_SC(j,1),...
                BootFit_SC(j,2),Dec(:,j),Inc(:,j),npts(1));
            BootEuPar_SC(j,:)=[lonESC latESC omegaSC,length(Dec(:,j)),1,-10];
            
            % 2) least-square great circle fitting
            % [lonV_GC, latV_GC, D_GC, rGC]=LSQCircFit_GC(a1, a2, a3, N(1));
            [lonV_GC, latV_GC, D_GC, rGC]=LSQCircFit_GC(a1(:,j), a2(:,j), a3(:,j), npts(1));
            BootFit_GC(j,:)=[lonV_GC, latV_GC, D_GC, rGC];
            
            % calculate boostrapped Euler parameters for GC fitting
            % BootEuPar_GC=[lonE latE omega]
            % [lonEGC latEGC omegaGC]=step1_EulerPole_Wing(Dec, Inc);
            [lonEGC latEGC omegaGC]=step1_EulerPole_Wing(Dec(:,j),Inc(:,j));
            BootEuPar_GC(j,:)=[lonEGC,latEGC,omegaGC,length(Dec(:,j)),1,10];
        end
        
        
        BootEuGC(k).f1=BootEuPar_GC;
        BootEuGC(k).f2=BootFit_GC;
        BootEuSC(k).f1=BootEuPar_SC;
        BootEuSC(k).f2=BootFit_SC;
    end

    % calculate the necessary antipodes for bootstrap poles with GCD>90
    for k=1:length(RecSt(2).f3(:,1))
        for j=1:length(BootEuGC(k).f2(:,2))
            if distance(RecSt(1).f3(k,2),RecSt(1).f3(k,1),...
                    BootEuGC(k).f2(j,2),BootEuGC(k).f2(j,1))>90
                [latAnti1,lonAnti1]=antipode(BootEuGC(k).f2(j,2),...
                    BootEuGC(k).f2(j,1));
                BootEuGC(k).f2(j,2)=latAnti1;
                BootEuGC(k).f2(j,1)=lonAnti1;
            end
            
             if distance(RecSt(1).f3(k,2),RecSt(1).f3(k,1),...
                    BootEuGC(k).f1(j,2),BootEuGC(k).f1(j,1))>90
                [latAnti2,lonAnti2]=antipode(BootEuGC(k).f1(j,2),...
                    BootEuGC(k).f1(j,1));
                BootEuGC(k).f1(j,2)=latAnti2;
                BootEuGC(k).f1(j,1)=lonAnti2;
            end           
        end
    end
    
    % project paleomagnetic data or APWP
    maptype=handles.ProjTypes1;
    mapview=[str2num(get(handles.viewR1,'String')),...
        str2num(get(handles.viewR2,'String')),...
        str2num(get(handles.viewR3,'String'))];
    for k=1:length(RecSt(2).f3(:,1))
        figure(k)
        % InitMap(maptype,mapview)
        InitMap(maptype,mapview)
        hold on
        
        Dec=ResBootAPWP(k).f1;
        Inc=ResBootAPWP(k).f2;
        npts=size(Dec);
        % decide the color code: [ind2,MapCol]=ColorCodeCal(data,colortype)
        % colormap: jet, hsv, hot, cool, spring, autumn, summer, winter, gray
        [ind,MapCol]=ColorCodeCal(Dec(:,1),jet);
        
        % plot bootstrapped APWP
        for i=1:npts(1)
            geoshow(Inc(i,:), Dec(i,:),'DisplayType','point',...
                'Marker','o','MarkerEdgeColor',MapCol(ind(i),:),'MarkerSize',7);
        end
        
        % 1) plot bootstrap Euler poles both for GC fitting
        geoshow(BootEuGC(k).f2(:,2), BootEuGC(k).f2(:,1),'DisplayType',...
            'point','Marker','o','MarkerEdgeColor','m','MarkerSize',7);
        % plot circles for bootstrapped GC fitting
        for i = 1:length(BootEuGC(k).f1(:,1))
            % A95 for the paleopoles
            [IncGC,DecGC] = scircle1(BootEuGC(k).f2(i,2),...
                BootEuGC(k).f2(i,1),BootEuGC(k).f2(i,3));
            geoshow(IncGC,DecGC,'Color','m','LineWidth',1.5);
            
        end
        
        % 2) plot bootstrap Euler poles both for SC fitting
        geoshow(BootEuSC(k).f2(:,2), BootEuSC(k).f2(:,1),'DisplayType','point',...
            'Marker','o','MarkerEdgeColor','b','MarkerSize',7);
        % plot circles for bootstrapped SC fitting
        for i = 1:length(BootEuSC(k).f1(:,1))
            % A95 for the paleopoles
            [IncSC,DecSC] = scircle1(BootEuSC(k).f2(i,2),...
                BootEuSC(k).f2(i,1),BootEuSC(k).f2(i,3));
            geoshow(IncSC,DecSC,'Color','b','LineWidth',1.5);
            
        end
        
    end
    
    % save BootEuGC.mat BootEuGC
    % save BootEuSC.mat BootEuSC
    handles.BootEuGC=BootEuGC;
    handles.BootEuSC=BootEuSC;
    hold off
    
%--------------------------------------------------------------------------
    %% 3) DataStruc_Main3
    disp('3. Combining BootEuler & BootAPWP (StrucEuAPWP)... ... ...')
    % import bootstrapped APWP: BootAPWP=[lonBoot,latBoot]
    lonP=BootAPWP(1).f;
    latP=BootAPWP(2).f;
    
    % need adjustment according to number of bootstrap resampling N
    value={NaN};
    
    % StrucEuAPWP: [BootEulerPara, BootAPWP]
    StrucEuAPWP_GC=struct('f1',value,'f2',value);
    StrucEuAPWP_SC=struct('f1',value,'f2',value);
    StrucEuAPWP=struct('f1',value,'f2',value);
    
    % 1) GC
    for i=1:length(BootAPWP(1).f(1,:))
        BootEuGCtemp1=[];
        for j=1:length(BootEuGC)
            BootEuGCtemp1=[BootEuGCtemp1;BootEuGC(j).f1(i,:)];
        end
        StrucEuAPWP_GC(i).f1=BootEuGCtemp1;
        
        StrucEuAPWP_GC(i).f2=[lonP(:,i),latP(:,i)];
    end
    
    % convert Euler rotations into correct direction: + CCW, - CW
    for i=1:length(BootAPWP(1).f(1,:))
        for j=1:length(RecSt(2).f3(:,1))
            StrucEuAPWP_GC(i).f1(j,3)=RecSt(1).f3(j,5)...
                *StrucEuAPWP_GC(i).f1(j,3);
        end
    end
    
    % 2) SC
    for i=1:length(BootAPWP(1).f(1,:))
        BootEuSCtemp1=[];
        for j=1:length(BootEuSC)
            BootEuSCtemp1=[BootEuSCtemp1;BootEuSC(j).f1(i,:)];
        end
        StrucEuAPWP_SC(i).f1=BootEuSCtemp1;
        
        StrucEuAPWP_SC(i).f2=[lonP(:,i),latP(:,i)];
    end
    
    % convert Euler rotations into correct direction: + CCW, - CW
    for i=1:length(BootAPWP(1).f(1,:))
        for j=1:length(RecSt(2).f3(:,1))
            StrucEuAPWP_SC(i).f1(j,3)=RecSt(1).f3(j,5)...
                *StrucEuAPWP_SC(i).f1(j,3);
        end
    end
    
    StrucEuAPWP_GC(1).f3=RecSt(1).f3; StrucEuAPWP_GC(2).f3=RecSt(2).f3;
    StrucEuAPWP_SC(1).f3=RecSt(1).f3; StrucEuAPWP_SC(2).f3=RecSt(2).f3;
    
    % 3) combine GC & SC bootstrapped fitting
    StrucEuAPWP=StrucEuAPWP_GC;
    for i=1:length(BootAPWP(1).f(1,:))
        for j=1:length(RecSt(2).f3(:,1))
            if RecSt(2).f3(j,6)==10 % GC
                StrucEuAPWP(i).f1(j,:)=StrucEuAPWP_GC(i).f1(j,:);
            elseif RecSt(2).f3(j,6)==-10 % SC
                StrucEuAPWP(i).f1(j,:)=StrucEuAPWP_SC(i).f1(j,:);
                StrucEuAPWP(i).f1(j,6)=-10;
            else
                disp('Incorrect assignment for GC & SC fitting in RecSt.mat!')
            end
        end
    end
    
    % save StrucEuAPWP.mat StrucEuAPWP
    handles.StrucEuAPWP=StrucEuAPWP;  
    
%-------------------------------------------------------------------------
    %% 4) BootEuNew_Main4
    disp('4. Calculating new BootEuler & BootAPWP (BootEuAPWPnew)... ...')
    BootEuAPWPnew=struct('f1',{NaN},'f2',{NaN});
    
    for i=1:length(BootAPWP(1).f(1,:))
        
        % [RecSt,BootEuAPWPnew]=NewEulerAPWP(Euler,APWP,FunCon)
        [RecStemp,BootEuAPWPtemp]=NewEulerAPWP(StrucEuAPWP(i).f1,...
            [NaN(length(StrucEuAPWP(i).f2(:,1)),1),StrucEuAPWP(i).f2],1);      
        
        for j=1:length(BootEuAPWPtemp(1).f(:,1))
            if distance(BootEuAPWPtemp(1).f(j,2),BootEuAPWPtemp(1).f(j,1),...
                    StrucEuAPWP(2).f3(j,2),StrucEuAPWP(2).f3(j,1))>90
                [BootEuAPWPtemp(1).f(j,2),BootEuAPWPtemp(1).f(j,1)]=antipode(...,
                    BootEuAPWPtemp(1).f(j,2),BootEuAPWPtemp(1).f(j,1));
                %             BootEuAPWPtemp(1).f(j,3)=-BootEuAPWPtemp(1).f(j,3);
            end
        end
        
        BootEuAPWPnew(i).f1=BootEuAPWPtemp(1).f;
        
        BootEuAPWPtemp1=[];
        for j=2:length(BootEuAPWPtemp)
            BootEuAPWPtemp1=[BootEuAPWPtemp1;[BootEuAPWPtemp(j).f;[NaN NaN]]];
        end
        % remove NaN in the last row
        % BootEuAPWPtemp1(length(BootEuAPWPtemp1(:,1)),:)=[];
        BootEuAPWPnew(i).f2=BootEuAPWPtemp1;
    end
    
    % save BootEuAPWPnew.mat BootEuAPWPnew
    handles.BootEuAPWPnew=BootEuAPWPnew;
      
%-------------------------------------------------------------------------
    %% 4.5) BootEuNew_Main45
    disp('5. Estimating uncertainties of boot Euler parameters (BootEuNewRG)... ...')
    % import the rotated Euler poles
    Euler45=StrucEuAPWP(2).f3;
    
    % Rearrange the BootRec data into groups by age: BootRecRG
    value={NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN};
    % uncorrected and corrected reconstructions
    BootEuNewRG=struct('f1',value,'f2',value,'f3',value);
    N45=length(value);
    
    media1=zeros(N45,length(BootEuAPWPnew(1).f1(1,:)));
    media2=zeros(N45,length(BootEuAPWPnew(1).f1(1,:)));
    % media1=zeros(N45,3);
    % media2=zeros(N45,3);
    for j=1:length(BootEuAPWPnew(1).f1(:,1))
        for i=1:N45
            % unrotated Euler parameters
            media1(i,:)=StrucEuAPWP(i).f1(j,:);
            % rotated Euler parameters
            media2(i,:)=BootEuAPWPnew(i).f1(j,:);
        end
        BootEuNewRG(j).f1=media1;
        BootEuNewRG(j).f2=media2;
    end
    
    % ensure the longitude is in [-180 180]
    for j=1:length(BootEuAPWPnew(1).f1(:,1))
        for i=1:length(BootEuNewRG(1).f1(:,1))
            if BootEuNewRG(j).f1(i,1)>180
                BootEuNewRG(j).f1(i,1)=BootEuNewRG(j).f1(i,1)-360;
            end
            if BootEuNewRG(j).f2(i,1)>180
                BootEuNewRG(j).f2(i,1)=BootEuNewRG(j).f2(i,1)-360;
            end
        end
    end
    
    % npts along APWP
    npts45=length(BootEuAPWPnew(1).f1(:,1));
    % decide the color code: [ind2,MapCol]=ColorCodeCal(data,colortype)
    % colormap: jet, hsv, hot, cool, spring, autumn, summer, winter, gray
    [ind,MapCol]=ColorCodeCal(zeros(npts45,1),handles.ColorCodeS); 
    
    for k=1:npts45
        axes(handles.axes1);
        geoshow(BootEuNewRG(k).f2(:,2), BootEuNewRG(k).f2(:,1),'DisplayType','point',...
            'Marker','o','MarkerEdgeColor',MapCol(ind(k),:),'MarkerSize',7);
        
        % Uncertainty ellipse estimation from covariance matrix
        % Fisher mean [Dm,Im,alpha95,kappa]=fishpar(D,I)
        [Dm,Im,alpha95,kappa]=fishpar(BootEuNewRG(k).f2(:,1), BootEuNewRG(k).f2(:,2));
        axes(handles.axes1);
        geoshow(Im,Dm,'DisplayType','point','Marker','p',...
            'MarkerEdgeColor',MapCol(ind(k),:),'MarkerSize',14);
        geoshow(Euler45(k,2),Euler45(k,1),'DisplayType','point','Marker','p',...
            'MarkerEdgeColor',MapCol(ind(k),:),'MarkerFaceColor',...
            MapCol(ind(k),:),'MarkerSize',14);
        
        Mu=[Dm,Im];
        X=[BootEuNewRG(k).f2(:,1), BootEuNewRG(k).f2(:,2)];        
        % calculate confidence ellipse
        % function [EllPara,Cov]=CovEllp(BootReSamp,Mu,conf)
        STD=2;
        
        % calculate the ellipse centered on Fisherian Means        
        [EllPara1,Cov1]=CovEllp(X,Mu,2*normcdf(STD)-1);
        [elat1,elon1]=ellipse1(Mu(2),Mu(1),...
            [EllPara1(1) EllPara1(3)],EllPara1(4));
        trigonom1=[elon1 elat1];
        
        % calculate the ellipse centered on Euler poles
        [EllPara2,Cov2]=CovEllp(X,Euler45(k,1:2),2*normcdf(STD)-1);
        % calculate the ellipse centered on Fisherian Means
        [elat2,elon2]=ellipse1(Euler45(k,2),Euler45(k,1),...
            [EllPara2(1) EllPara2(3)],EllPara2(4));
        trigonom2=[elon2 elat2];      
        
        axes(handles.axes1);
        % plot cov and major/minor axes
        geoshow(trigonom1(:,2), trigonom1(:,1),'LineStyle','--','Color',...
            MapCol(ind(k),:));
        % quiverm(Mu(1),Mu(2), VV(2,1),VV(1,1), 'Color','k');
        geoshow(trigonom2(:,2), trigonom2(:,1), 'Color',MapCol(ind(k),:));
        
        % GCD between Fisherian mean and Ref
        GCD=distance(Euler45(k,2),Euler45(k,1),Mu(2),Mu(1));
        
        % combine result into BootRecRG
        BootEuNewRG(k).f3=[Euler45(k,1:2);Mu;Cov1];
        BootEuNewRG(k).f3(:,3:4)=NaN; BootEuNewRG(k).f3(1,3)=GCD;
        BootEuNewRG(k).f3(5,:)=EllPara2;
        
        % store the confidence ellipse in [trigonom1 trigonom2]
        BootEuNewRG(k).f4=[trigonom1, trigonom2];
    end
    caxis([min(handles.RecStAge) max(handles.RecStAge)]);
    axes(handles.axes1);
    % plot the trajectory of reconstructions
    geoshow(Euler45(:,2),Euler45(:,1),'LineStyle','--','color',...
        [.75 .0 .75],'linewidth',1.5);
    % Add data label
    ind=[1:1:length(Euler45(:,1))]';
    [G,GN]=grp2idx(ind);
    axes(handles.axes1);
    % Project text annotation on map axes
    for i = 1:length(Euler45(:,1))
        textm(Euler45(i,2),Euler45(i,1),GN(i),'Color',[.75 .0 .75],'FontSize',14);
    end
    
    % export bootstrapped results
    % BootEuNewRG=[Euler EulerRot XX YY], XX=[EulerRot;Mu;Cov;GCG],
    % YY=[trigonom1', trigonom2']
    % save BootEuNewRG.mat BootEuNewRG
    handles.BootEuNewRG=BootEuNewRG;
    disp('Boot Euler calculation is done.')
    
    caxis([min(RecSt(1).f8(:,1)) max(RecSt(1).f8(:,1))]);
    % apply new colormap
    colormap(jet(length(RecSt(2).f4(:,2))));
    
    % save cov into RecSt(1).f3(:,7:9), RecSt(2).f3(:,7:9)
    for i=1:npts45
        SavCov(i,:)=[BootEuNewRG(i).f3(3,1), BootEuNewRG(i).f3(3,2),...
            BootEuNewRG(i).f3(4,2), BootEuNewRG(i).f3(5,:)];
        RecSt(1).f3(i,7:13)=SavCov(i,:); RecSt(2).f3(i,7:13)=SavCov(i,:);
    end
    
    handles.rec.RecSt=RecSt;
    save(handles.RecStName2,'RecSt');
end

guidata(hObject, handles);


% --- Executes on button press in BootRec.
function BootRec_Callback(hObject, eventdata, handles)
% hObject    handle to BootRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,{'rec','BootEuAPWPnew'})==0
    disp('Please calculate Boot Euler first!');
elseif isfield(handles,{'rec','BootEuAPWPnew'})==1
    % 4.5) BootEuNew_Main45
    disp('Bootstrap Calculating... Be Patient... (2 steps) O(*_*)O')
    disp('6. Calculating bootstrap reconstructions (BootRec)... ... ...')
    
    RecSt=handles.rec.RecSt;
    BootEuAPWPnew=handles.BootEuAPWPnew;
    % load BootEuAPWPnew.mat
    
    % reference site
    ref=RecSt(1).f4(1,1:2);
    % convert Euler parameters for recosntruction: backward in time
    for i=1:length(BootEuAPWPnew)
        BootEuAPWPnew(i).f1(:,3)=-BootEuAPWPnew(i).f1(:,3);
    end
    
    % initiate structure data for new Euler parameters and APWP
    % uncorrected and corrected reconstructions
    BootRec=struct('f1',{NaN},'f2',{NaN});
    
    % npts along APWP
    npts5=sum(BootEuAPWPnew(1).f1(:,4))-(length(BootEuAPWPnew(1).f1(:,1))-1);
    
    % decide the color code: [ind2,MapCol]=ColorCodeCal(data,colortype)
    % colormap: jet, hsv, hot, cool, spring, autumn, summer, winter, gray
    [ind,MapCol]=ColorCodeCal(zeros(npts5,1),handles.ColorCodeS);
    
    % Aux=[R2S_i, R2StC_i,RecSub2,RecSubCorr2]
    Aux5=struct('f1',{NaN},'f2',{NaN},'f3',{NaN},'f4',{NaN});
    
    % % [R2S,R2St2]=PEP_BootRec(APWP,ref,Euler,flipcon)
    % % [RecSub,RecSubCorr]=SubRotCorr(APWP,ref,Euler,color1,color2,marker1,marker2)
    % % ColorCode(data,colortype,marker)
    [row,col]=find(isnan(BootEuAPWPnew(i).f2(:,1)));
    nrow=length(row);
    axes(handles.axes1);
    for i=1:length(BootEuAPWPnew)
        
        % 1) 1st rotations
        % [R2S_1,R2StC_1]=PEP_BootRec(APWP1,ref,Euler(1,:),2,theta_M);
        [Aux5(1).f1,Aux5(1).f2]=PEP_BootRec(BootEuAPWPnew(i).f2(1:row(1)-1,:),ref,...
            BootEuAPWPnew(i).f1(1,:),2);
        [Aux5(1).f3,Aux5(1).f4]=BootSubRotCorr(BootEuAPWPnew(i).f2(1:row(1)-1,:),...
            ref,BootEuAPWPnew(i).f1(1,:));
        RecSub1=Aux5(1).f3;
        RecSubCorr1=Aux5(1).f4;    
        
        % 2) 2-nrow st rotation
        for k=2:nrow
            
            % [R2S,R2St2]=PEP_BootRec(APWP,ref,Euler,flipcon,theta_M)
            [Aux5(k).f1,Aux5(k).f2]=PEP_BootRec(...
                BootEuAPWPnew(i).f2(row(k-1)+1:row(k)-1,:),...
                Aux5(k-1).f2,BootEuAPWPnew(i).f1(k,:),2);
            
            % [RecSub,RecSubCorr]=BootSubRotCorr(APWP,ref,Euler,theta_M)
            [Aux5(k).f3,Aux5(k).f4]=BootSubRotCorr(...
                BootEuAPWPnew(i).f2(row(k-1)+1:row(k)-1,:),...
                Aux5(k-1).f2,BootEuAPWPnew(i).f1(k,:));
            
            % combine the results
            RecSub1=[RecSub1;Aux5(k).f3(2:length(Aux5(k).f3(:,1)),:)];
            RecSubCorr1=[RecSubCorr1;Aux5(k).f4(2:length(Aux5(k).f4(:,1)),:)];
        end
        
        BootRec(i).f1=RecSub1;
        BootRec(i).f2=RecSubCorr1;
               
    end
    
    % export bootstrapped results
    % save BootRec.mat BootRec
    handles.BootRec=BootRec;
    
%-------------------------------------------------------------------------
    disp('7. Estimating uncertainties for BootRec (BootRecRG)... ... ...')
    
    Ref6=RecSt(2).f4;
    
    % Rearrange the BootRec data into groups by age: BootRecRG
    value={NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
        NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN};
    % uncorrected and corrected reconstructions
    BootRecRG=struct('f1',value,'f2',value,'f3',value,'f4',value);
    N=length(value);
    
    media1=zeros(N,2);
    media2=zeros(N,2);
    for j=1:length(BootRec(1).f1(:,1))
        for i=1:N
            media1(i,:)=BootRec(i).f1(j,:);
            media2(i,:)=BootRec(i).f2(j,:);
        end
        BootRecRG(j).f1=media1;
        BootRecRG(j).f2=media2;
    end
    
    % npts along APWP
    npts6=length(BootRec(1).f1(:,1));
    % decide the color code: [ind2,MapCol]=ColorCodeCal(data,colortype)
    % colormap: jet, hsv, hot, cool, spring, autumn, summer, winter, gray
    [ind,MapCol]=ColorCodeCal(zeros(npts6,1),handles.ColorCodeS);
    
    for k=1:npts6
        geoshow(BootRecRG(k).f2(:,2), BootRecRG(k).f2(:,1),'DisplayType','point',...
            'Marker','o','MarkerEdgeColor',MapCol(ind(k),:),'MarkerSize',7);
        geoshow(Ref6(k,2), Ref6(k,1),'DisplayType','point','Marker','p',...
            'MarkerEdgeColor',MapCol(ind(k),:),'MarkerFaceColor',...
            MapCol(ind(k),:),'MarkerSize',14);
        
        % Uncertainty ellipse estimation from covariance matrix
        % Fisher mean [Dm,Im,alpha95,kappa]=fishpar(D,I)
        [Dm,Im,alpha95,kappa]=fishpar(BootRecRG(k).f2(:,1), BootRecRG(k).f2(:,2));
        geoshow(Im,Dm,'DisplayType','point','Marker','p',...
            'MarkerEdgeColor',MapCol(ind(k),:),'MarkerSize',14);
        
        Mu=[Dm,Im];
        X=[BootRecRG(k).f2(:,1), BootRecRG(k).f2(:,2)];
        % calculate confidence ellipse
        % function [EllPara,Cov]=CovEllp(BootReSamp,Mu,conf)
        STD=2;        
  
        % calculate the ellipse centered on Fisherian Means        
        [EllPara1,Cov1]=CovEllp(X,Mu,2*normcdf(STD)-1);
        [elat1,elon1]=ellipse1(Mu(2),Mu(1),...
            [EllPara1(1) EllPara1(3)],EllPara1(4));
        trigonom1=[elon1 elat1];
        
        % calculate the ellipse centered on Euler poles
        [EllPara2,Cov2]=CovEllp(X,Ref6(k,1:2),2*normcdf(STD)-1);
        % calculate the ellipse centered on Fisherian Means
        [elat2,elon2]=ellipse1(Ref6(k,2), Ref6(k,1),...
            [EllPara2(1) EllPara2(3)],EllPara2(4));
        trigonom2=[elon2 elat2];  
        
        % plot cov and major/minor axes
        geoshow(trigonom1(:,2), trigonom1(:,1),'LineStyle','--','Color',MapCol(ind(k),:));
        % quiverm(Mu(1),Mu(2), VV(2,1),VV(1,1), 'Color','k');
        geoshow(trigonom2(:,2), trigonom2(:,1), 'Color',MapCol(ind(k),:));
        
        % GCD between Fisherian mean and Ref
        GCD=distance(Ref6(k,2),Ref6(k,1),Mu(2),Mu(1));
        
        % combine result into BootRecRG
        BootRecRG(k).f3=[Ref6(k,1:2);Mu;Cov1];
        BootRecRG(k).f3(:,3:4)=NaN; BootRecRG(k).f3(1,3)=GCD;
        BootRecRG(k).f3(5,:)=EllPara2;
        
        % store the confidence ellipse in [trigonom1 trigonom2]
        BootRecRG(k).f4=[trigonom1, trigonom2];
    end
    caxis([min(handles.RecStAge) max(handles.RecStAge)]);
    % plot the trajectory of reconstructions
    geoshow(Ref6(:,2),Ref6(:,1),'LineStyle','--','color',...
        [.75 .0 .75],'linewidth',1.5);
    
    % export bootstrapped results
    % BootRecRG=[Rec RecCor XX YY], XX=[Ref;Mu;Cov;GCG], YY=[trigonom1, trigonom2]
    % save BootRecRG.mat BootRecRG
    handles.BootRecRG=BootRecRG;
    
    disp('Calculation is done. ')
    caxis([min(RecSt(1).f8(:,1)) max(RecSt(1).f8(:,1))]);
    % apply new colormap
    colormap(jet(length(RecSt(2).f4(:,2))));
    
    % save cov into RecSt(1).f4(:,3:5), RecSt(2).f4(:,3:5)
    for i=1:npts6
        SavCov(i,:)=[BootRecRG(i).f3(3,1), BootRecRG(i).f3(3,2),...
            BootRecRG(i).f3(4,2), BootRecRG(i).f3(5,:)];
        RecSt(1).f4(i,3:9)=SavCov(i,:); RecSt(2).f4(i,3:9)=SavCov(i,:);
    end
    
    handles.rec.RecSt=RecSt;
    save(handles.RecStName2,'RecSt');
end
guidata(hObject, handles);


% --- Executes on button press in pushbutton54.
function pushbutton54_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton54 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%-------------------------------------------------------------------------
% construct data structure for the reconstructions
function [RecSt,BootEuAPWPnew]=NewEulerAPWP(Euler,APWP,FunCon)

if nargin <3
    FunCon=0;
end

lonE=Euler(:,1);
latE=Euler(:,2);
omega=-Euler(:,3);
Num=Euler(:,4);
n=length(lonE);

% 1) construct structural data
% f1=[APWP; APWP tracks];
% f2=[APWP tracks'];
% f3=[PEP; PEP'];
% f4=[ref, ref_cor (ref_adj), (ref_cor)];
% f5=[plate];
% f6=[plate_cor (plate_adj)];
% f7=[(plate_cor)];
% f8=[age,Velo,LatV,LonV]; from PMTec_PtKin
% f9-f10: backup storage

if FunCon==0
RecSt=struct('f1',{NaN},'f2',{NaN},'f3',{NaN},'f4',{NaN},'f5',{NaN},...
             'f6',{NaN},'f7',{NaN},'f8',{NaN},'f9',{NaN},'f10',{NaN});
else
    RecSt=struct('f1',{NaN},'f2',{NaN});
end

% Assign APWP
RecSt(1).f1=APWP(1:Num(1),2:3);
for i=2:n
    RecSt(i).f1=APWP(sum(Num(1:i-1))-(i-2):sum(Num(1:i))-(i-1),2:3);
end

% Assign PEP
RecSt(1).f3=Euler;

% 2) calculate new Euler parameters EE(lonEE,latEE,omegaEE)
% set up matrix for translated poles EE(lonEE,latEE)
lonEE=zeros(n-1,1);
latEE=zeros(n-1,1);

% rotate old Euler poles around 1st one to obtain [lonET(i),latET(i)]
lonET=zeros(n,1);
latET=zeros(n,1);
lonET(1)=lonE(1);latET(1)=latE(1);
for i=2:n
    [lonET(i),latET(i)]=step2_Wing_Rot(lonE(i),latE(i),...
        lonE(1),latE(1),omega(1));
end

% The combined Euler paramters from product of a series of rotation matrix
ETT=zeros(length(n),3); % [lonETT,latETT,omegaTT]
EP_APWP=zeros(length(n),3);

% 3) Calculate new Euler poles and corresponding rotation matrix
% Rotation matrix for the ist Euler pole
RotMat1T=step2_Wing_RotMatrix(lonE(1),latE(1),omega(1));

RecSt(1).f2=RecSt(1).f1(:,1:2);

% RecStRotTemp=[RotMatiT, Mat_temp]
RecStRotTemp=struct('f1',{NaN},'f2',{NaN});
RecStRotTemp(1).f1=NaN; RecStRotTemp(1).f2=NaN;
for i=2:n
    if i==2
        % rotate old Euler pole to new position: [lonEE(i),latEE(i)]
        [lonEE(i),latEE(i)]=step2_Wing_Rot(lonE(i),latE(i),...
            lonE(1),latE(1),omega(1));
        % rotation matrix for new Euler pole: RotMatiT
        RecStRotTemp(i).f1=step2_Wing_RotMatrix(lonEE(i),latEE(i),omega(i));
        RecStRotTemp(i).f2=NaN;
        
        % corresponding Euler parameters is EP_APWP
        EP_APWP(i,:)=[lonE(1),latE(1),omega(1)];
        % rotate earlier APWP segments to new positions
        [RecSt(i).f2(:,1),RecSt(i).f2(:,2)]=...
            step2_Wing_Rot(RecSt(i).f1(:,1),RecSt(i).f1(:,2),...
            EP_APWP(i,1),EP_APWP(i,2),EP_APWP(i,3));
        
    elseif i==3
        % matrix multiplication temp: mat_temp
        RecStRotTemp(i).f2=1*RecStRotTemp(i-1).f1;
        % corresponding Euler parameters is ETTt
        [ETT(i,1) ETT(i,2) ETT(i,3)]=step2_Wing_RotM2Euler(RecStRotTemp(i).f2);
        % rotate old Euler pole to new position
        [lonEE(i),latEE(i)]=step2_Wing_Rot(lonET(i),latET(i),...
            ETT(i,1),ETT(i,2),ETT(i,3));
        % rotation matrix for new Euler pole: RotMatiT
        RecStRotTemp(i).f1=step2_Wing_RotMatrix(lonEE(i),latEE(i),omega(i));
        
        % matrix multiplication temp for APWP: Mat_APWPtemp
        Mat_APWPtemp=RecStRotTemp(i).f2*RotMat1T;
        % corresponding Euler parameters is EP_APWP
        [EP_APWP(i,1) EP_APWP(i,2) EP_APWP(i,3)]=step2_Wing_RotM2Euler(Mat_APWPtemp);
        % rotate earlier APWP segments to new positions
        [RecSt(i).f2(:,1),RecSt(i).f2(:,2)]=...
            step2_Wing_Rot(RecSt(i).f1(:,1),RecSt(i).f1(:,2),...
            EP_APWP(i,1),EP_APWP(i,2),EP_APWP(i,3));
        
    elseif i>=4
        % matrix multiplication temp: mat_temp
        RecStRotTemp(i).f2=RecStRotTemp(i-1).f1*RecStRotTemp(i-1).f2;
        
        % corresponding Euler parameters is ETTt
        [ETT(i,1) ETT(i,2) ETT(i,3)]=step2_Wing_RotM2Euler(RecStRotTemp(i).f2);
        % rotate old Euler pole to new position
        [lonEE(i),latEE(i)]=step2_Wing_Rot(lonET(i),latET(i),...
            ETT(i,1),ETT(i,2),ETT(i,3));
        % rotation matrix for new Euler pole: RotMatiT
        RecStRotTemp(i).f1=step2_Wing_RotMatrix(lonEE(i),latEE(i),omega(i));
        
        % matrix multiplication temp for APWP: Mat_APWPtemp
        Mat_APWPtemp=RecStRotTemp(i).f2*RotMat1T;
        % corresponding Euler parameters is EP_APWP
        [EP_APWP(i,1) EP_APWP(i,2) EP_APWP(i,3)]=step2_Wing_RotM2Euler(Mat_APWPtemp);
        % rotate earlier APWP segments to new positions
        [RecSt(i).f2(:,1),RecSt(i).f2(:,2)]=...
            step2_Wing_Rot(RecSt(i).f1(:,1),RecSt(i).f1(:,2),...
            EP_APWP(i,1),EP_APWP(i,2),EP_APWP(i,3));
        
    end
    
end

% new Euler rotation parameter NewPara(lonEE,latEE,omega)
NewPara=Euler;
NewPara(2:n,1)=lonEE(2:n);
NewPara(2:n,2)=latEE(2:n);
RecSt(2).f3=NewPara;

if FunCon==0
    BootEuAPWPnew=0;
else
    BootEuAPWPnew=struct('f',{NaN});
    BootEuAPWPnew(1).f=NewPara;
    for i=1:length(Euler(:,1))
        BootEuAPWPnew(i+1).f=RecSt(i).f2;
    end
end


function [lonMR,latMR]=step2_Wing_Rot(lonM,latM,lonE,latE,omega)

% check distance between point M and Euler pole
dist=distance(latM,lonM,latE,lonE);
if min(dist)>90
    [latE,lonE]=antipode(latE,lonE);
    omega=-omega;
end
  
% convert Point M(lonM,latM) to cartesian coordinates:
[Mx,My,Mz]=sph2cart(lonM*pi/180,latM*pi/180,1);

% calculate the rotation matrix from Euler parameters (lonE,latE,omega) 
RotMat=step2_Wing_RotMatrix(lonE,latE,omega);

for i=1:length(lonM)
    % rotate the Point M to new position M'(lonMR,latMR)
    MR(:,i)=RotMat*[Mx(i);My(i);Mz(i)];
end

% coordinates converted back
[lonMR,latMR,rMR]=cart2sph(MR(1,:),MR(2,:),MR(3,:));
lonMR=lonMR*180/pi;
latMR=latMR*180/pi;

if (lonMR<0)
    lonMR=lonMR+360;
end


function RotMat=step2_Wing_RotMatrix(lonE,latE,omega)
    
    % convert to cartesian coordinates:
    [Ex,Ey,Ez]=sph2cart(lonE*pi/180,latE*pi/180,1);
    
    % set up rotation matrix R
    R11=Ex*Ex*(1-cosd(omega))+cosd(omega);
    R12=Ex*Ey*(1-cosd(omega))-Ez*sind(omega);
    R13=Ex*Ez*(1-cosd(omega))+Ey*sind(omega);
    R21=Ey*Ex*(1-cosd(omega))+Ez*sind(omega);
    R22=Ey*Ey*(1-cosd(omega))+cosd(omega);
    R23=Ey*Ez*(1-cosd(omega))-Ex*sind(omega);
    R31=Ez*Ex*(1-cosd(omega))-Ey*sind(omega);
    R32=Ez*Ey*(1-cosd(omega))+Ex*sind(omega);
    R33=Ez*Ez*(1-cosd(omega))+cosd(omega);
    
    % combine results
    RotMat=[R11 R12 R13;R21 R22 R23;R31 R32 R33];


function [lonE,latE,omega]=step2_Wing_RotM2Euler(RotMat)
    
    % Euler pole longitude
    lonE=atan2d(RotMat(1,3)-RotMat(3,1),RotMat(3,2)-RotMat(2,3));
    if (lonE<0)
        lonE=lonE+360;
    end
    
    % Euler pole latitude
    latE=asind((RotMat(2,1)-RotMat(1,2))/...
        (sqrt((RotMat(3,2)-RotMat(2,3))^2+(RotMat(1,3)-RotMat(3,1))^2+...
        (RotMat(2,1)-RotMat(1,2))^2)));
    
    % Finite rotation angle
    omega=atan2d(sqrt((RotMat(3,2)-RotMat(2,3))^2+(RotMat(1,3)-RotMat(3,1))^2+...
        (RotMat(2,1)-RotMat(1,2))^2),RotMat(1,1)+RotMat(2,2)+RotMat(3,3)-1);


function plotmap(APWP,plate,ref,Euler,mapview,maptype)

if nargin <5
    mapview=[0,0,0];
    maptype=1;
end

if maptype==1
%     maptypeV='eqdcylin';
elseif maptype==2
    maptypeV='mollweid';
elseif maptype==3
    maptypeV='ortho';
elseif maptype==4
    maptypeV='eqdcylin';
end

% mapview=[lat lon tilt];
axesm(maptypeV,'Origin',mapview)
framem on; gridm on; axis off; tightmap
s = ['viewpoint (' angl2str(mapview(1),'ns') ...
    ',' angl2str(mapview(2),'ew') ',' angl2str(mapview(3)),'D )'];
title(s)

% project coastlines
coast=load('coast');
geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none')

% plot APWP, reference site, plate contour and Euler poles
% 1) plot plate contour
geoshow(plate(:,2),plate(:,1),'Color','magenta','LineWidth',2)

% 2) plot paleomagnetic data
for i=1:length(APWP(:,1))
    geoshow(APWP(i,2),APWP(i,1),'DisplayType','point',...
        'Marker','o','MarkerSize',9,'MarkerFaceColor',[1 .6 .78],...
        'MarkerEdgeColor','k','LineWidth',1.5)
end
% Add data label for paleopoles
indP=[1:1:length(APWP(:,1))]';
[GP,GNP]=grp2idx(indP);
for i = 1:length(APWP(:,1))
    textm(APWP(i,2),APWP(i,1),GNP(i),'Color','blue','FontSize',18)
end

% 3) plot reference site
geoshow(ref(2),ref(1),'DisplayType','point',...
    'Marker','s','MarkerSize',9,'MarkerFaceColor','m',...
    'MarkerEdgeColor','k','LineWidth',1.5)

% 4) plot Euler poles
% Add data label for Euler poles
indE=[1:1:length(Euler(:,1))]';
[GE,GNE]=grp2idx(indE);
for i = 1:length(Euler(:,1))
    textm(Euler(i,2),Euler(i,1),GNE(i),'Color','m','FontSize',18)
end


function [R2S,R2St2,plaRect2]=PEP_Rec(APWPt,plate,ref,Euler,flipcon,theta_M)

% Initiate R2S, R2St1, R2St2
R2S=zeros(length(Euler(:,1))+1,2);
R2St1=zeros(length(Euler(:,1))+1,2);
R2St2=zeros(length(Euler(:,1))+1,2);
R2S(1,:)=ref; R2St1(1,:)=ref; R2St2(1,:)=ref;

npts=length(APWPt(:,1));
% Initialize Euler parameters [lonE latE omega] 
% plot Euler pole
for j=1:length(Euler(:,1))
    if flipcon==2 % flip decided by software
        if min(distance(plate(:,2),plate(:,1),Euler(j,2),Euler(j,1)))>90
            [Euler(j,2),Euler(j,1)]=antipode(Euler(j,2),Euler(j,1));
            Euler(j,3)=-Euler(j,3);
            geoshow(Euler(j,2),Euler(j,1),'DisplayType','point',...
                'Marker','p','MarkerSize',9,'MarkerFaceColor',[.6 .2 .0],...
                'MarkerEdgeColor',[.6 .2 .0],'LineWidth',1.5)
            % record the flip of Euler pole: fliprec, 1:yes; 2:no
            fliprec(j)=1;
        else
            geoshow(Euler(j,2),Euler(j,1),'DisplayType','point',...
                'Marker','p','MarkerSize',9,'MarkerFaceColor','r',...
                'MarkerEdgeColor','r','LineWidth',1.5)
            % record the flip of Euler pole: fliprec, 1:yes; 2:no
            fliprec(j)=0;
        end
        
    elseif flipcon==1 % flip anyway
            % force flipping of the Euler pole
            [Euler(j,2),Euler(j,1)]=antipode(Euler(j,2),Euler(j,1));
            Euler(j,3)=-Euler(j,3);
            geoshow(Euler(j,2),Euler(j,1),'DisplayType','point',...
                'Marker','p','MarkerSize',9,'MarkerFaceColor',[.6 .2 .0],...
                'MarkerEdgeColor',[.6 .2 .0],'LineWidth',1.5)
            % record the flip of Euler pole: fliprec, 1:yes; 2:no
            fliprec(j)=1;
            
    elseif flipcon==0 % no flip
            geoshow(Euler(j,2),Euler(j,1),'DisplayType','point',...
                'Marker','p','MarkerSize',9,'MarkerFaceColor','r',...
                'MarkerEdgeColor','r','LineWidth',1.5)
            % record the flip of Euler pole: fliprec, 1:yes; 2:no
            fliprec(j)=0;        
    end


% rotate Plate
[lonMR,latMR]=Rot(plate(:,1),plate(:,2),Euler(j,1),Euler(j,2),Euler(j,3));
geoshow(latMR,lonMR,'DisplayType','line',...
    'linestyle','--','color','b','LineWidth',1.5)
% plate=[lonMR,latMR]

% rotate reference site somewhere in the plate
[R2S(j+1,1),R2S(j+1,2)]=Rot(ref(1),ref(2),Euler(j,1),Euler(j,2),Euler(j,3));
geoshow(R2S(j+1,2),R2S(j+1,1),'DisplayType','point',...
    'Marker','s','MarkerSize',9,'MarkerFaceColor','b',...
    'MarkerEdgeColor','k','LineWidth',1.5) 

% correct for the reconstructed position using co-latitude, theta
% theta_T: theta for GC/SC track; theta_M: real theta (mag co-latitude)
% radius of GC/SC circle
radius=distance(R2S(j,2),R2S(j,1),Euler(j,2),Euler(j,1));
% Calculate the azimuth for the refence site/plate contour
az1=azimuth('gc',Euler(j,2),Euler(j,1),R2S(j,2),R2S(j,1));
az11=azimuth('gc',Euler(j,2),Euler(j,1),R2S(j+1,2),R2S(j+1,1));

% position calculated from GC/SC track fitting
if fliprec(j)==1
    if Euler(j,3)>0
        [latMt,lonMt]=scircle1(Euler(j,2),Euler(j,1),radius,[az11 az1],[]);
    else
        [latMt,lonMt]=scircle1(Euler(j,2),Euler(j,1),radius,[az1 az11],[]);
    end
else
    if Euler(j,3)>0
        [latMt,lonMt]=scircle1(Euler(j,2),Euler(j,1),radius,[az11 az1],[]);
    else
        [latMt,lonMt]=scircle1(Euler(j,2),Euler(j,1),radius,[az1 az11],[]);
    end
    
end
% flip ratation into CCW +
latMt=fliplr(latMt'); lonMt=fliplr(lonMt');
latMt=latMt';lonMt=lonMt';
geoshow(latMt,lonMt,'DisplayType','line',...
    'linestyle','--','color','y','LineWidth',1.5)
if fliprec(j)==1
    if Euler(j,3)>0
        [latMt,lonMt]=scircle1(Euler(j,2),Euler(j,1),radius,[az11 az1],[],'degrees',2);
    else
        [latMt,lonMt]=scircle1(Euler(j,2),Euler(j,1),radius,[az1 az11],[],'degrees',2);
    end
else
    if Euler(j,3)>0
        [latMt,lonMt]=scircle1(Euler(j,2),Euler(j,1),radius,[az11 az1],[],'degrees',2);
    else
        [latMt,lonMt]=scircle1(Euler(j,2),Euler(j,1),radius,[az1 az11],[],'degrees',2);
    end
end
% flip ratation into CCW +
latMt=fliplr(latMt'); lonMt=fliplr(lonMt');
latMt=latMt';lonMt=lonMt';
geoshow(latMt,lonMt,'DisplayType','point',...
    'Marker','^','MarkerSize',9,'MarkerFaceColor','y',...
    'MarkerEdgeColor','k','LineWidth',1.5)

% calculate and plot APWP
radAPWP=distance(Euler(j,2),Euler(j,1),[APWPt(1,2) APWPt(npts,2)],[APWPt(1,1) APWPt(npts,1)]);

% Calculate the azimuth for APWP
az2=azimuth('gc',Euler(j,2),Euler(j,1),[APWPt(1,2) APWPt(npts,2)],[APWPt(1,1) APWPt(npts,1)]);
if fliprec(j)==1
    if Euler(j,3)>0
        [latAPWP,lonAPWP]=scircle1(Euler(j,2),Euler(j,1),radAPWP(1),[az2(1) az2(2)],[]);
    else
        [latAPWP,lonAPWP]=scircle1(Euler(j,2),Euler(j,1),radAPWP(1),[az2(2) az2(1)],[]);
    end
else
    if Euler(j,3)>0
        [latAPWP,lonAPWP]=scircle1(Euler(j,2),Euler(j,1),radAPWP(1),[az2(1) az2(2)],[]);
    else
        [latAPWP,lonAPWP]=scircle1(Euler(j,2),Euler(j,1),radAPWP(1),[az2(2) az2(1)],[]);
    end
end
% [latAPWP,lonAPWP]=track1(Euler(j,2),Euler(j,1),az);
geoshow(latAPWP,lonAPWP,'DisplayType','line',...
    'linestyle','--','color',[1 .69 .39],'LineWidth',1.5) % orange

% reconstruction from SC track
recT=[R2S(j,1) R2S(j,2);R2S(j+1,1) R2S(j+1,2)];

dist=distance(recT(:,2),recT(:,1),[APWPt(1,2);APWPt(npts,2)],[APWPt(1,1);APWPt(npts,1)]);
% disp('GC distance between APWP and restored track'),disp(dist)

% connect Euler pole and all reconstructed positions
% Lines connecting plate M1 & M2
% GC lines connecting APWP and Euler pole
plateM=track2('gc',APWPt(1,2),APWPt(1,1),Euler(j,2),Euler(j,1));
geoshow(plateM(:,1),plateM(:,2),'DisplayType','line',...
    'linestyle','--','color',[0 .5 0],'LineWidth',1.5) % green
plateM=track2('gc',APWPt(npts,2),APWPt(npts,1),Euler(j,2),Euler(j,1));
geoshow(plateM(:,1),plateM(:,2),'DisplayType','line',...
    'linestyle','--','color',[0 .5 0],'LineWidth',1.5) % green

% Azimuth defined by the colatitude line (WRT current reference site)
az2=azimuth('gc',[APWPt(1,2);APWPt(npts,2)],[APWPt(1,1);APWPt(npts,1)],recT(:,2),recT(:,1));
% distance between APWP and reconstructed positions: dist1
dist1=distance([APWPt(1,2);APWPt(npts,2)],[APWPt(1,1);APWPt(npts,1)],recT(:,2),recT(:,1));
    
for i=1:2
    % GC lines connecting Euler pole and restored track:GCTrack1
    GCTrack1=track2('gc',recT(i,2),recT(i,1),Euler(j,2),Euler(j,1));
    geoshow(GCTrack1(:,1),GCTrack1(:,2),'DisplayType','line',...
        'linestyle','--','color',[0 .75 .75],'LineWidth',1.5) % blue

    % Calculate the azimuth for the refence site/plate contour
    az1(i)=azimuth('gc',Euler(j,2),Euler(j,1),recT(i,2),recT(i,1));
        
    % find the GC center for lines connecting Euler and restored track:GCTrack1
    [latTrack1(i),lonTrack1(i),radiusTrack1(i)]=...
        gc2sc(Euler(j,2),Euler(j,1),az1(i));
   
end

% theta_T: theta for GC/SC track
azAX=azimuth('gc',APWPt(1,2),APWPt(1,1),recT(:,2),recT(:,1));
distAX=distance(APWPt(1,2),APWPt(1,1),recT(:,2),recT(:,1));

% Auxiliary lines
for i=1:2
    % GC lines connecting APWP and restored track:GCTrack2
    GCTrack2=track2('gc',APWPt(1,2),APWPt(1,1),recT(i,2),recT(i,1));
    geoshow(GCTrack2(:,1),GCTrack2(:,2),'DisplayType','line',...
        'linestyle','--','color',[.49 .49 .49],'LineWidth',1.5) %  grey
    
    % find the GC center for lines connecting APWP and restored track:GCTrack2
    [latTrack2(i),lonTrack2(i),radiusTrack2(i)]=...
        gc2sc(APWPt(1,2),APWPt(1,1),azAX(i));
    % visualize the fitted circles
    [lat111,lon111] = scircle1(latTrack2(i),lonTrack2(i),90);
    geoshow(lat111,lon111,'DisplayType','line',...
        'linestyle','--','color','g','LineWidth',1.5) % grey
    
end

% reconstruction from SC track
% corrected reconstruction position using real theta: theta_M
% theta_M=distance(ref(2),ref(1),[APWP(1,2);APWP(npts,2)],[APWP(1,1);APWP(npts,1)]);
theta_T=distAX;
delta=theta_T-theta_M;

% 2) correction along lines connecting APWP and restored track: GCTrack2
[lonMRt2,latMRt2]=Rot(lonMR,latMR,lonTrack2(2),latTrack2(2),delta(2));
geoshow(latMRt2,lonMRt2,'DisplayType','line',...
    'linestyle','--','color',[.49 .49 .49],'LineWidth',1.5) % grey
plaRect2=[lonMRt2',latMRt2'];

% rotate reference site in the originally recontructed plate
[lonSt2,latSt2]=Rot(R2S(j+1,1),R2S(j+1,2),lonTrack2(2),latTrack2(2),delta(2));
geoshow(latSt2,lonSt2,'DisplayType','point',...
    'Marker','^','MarkerSize',9,'MarkerFaceColor',[.49 .49 .49],...
    'MarkerEdgeColor','k','LineWidth',1.5) % grey

% combine results
R2St2(j+1,1)=lonSt2; R2St2(j+1,2)=latSt2;
R2S(1,:)=[]; R2St1(1,:)=[]; R2St2(1,:)=[];
    
end


function [RecSub,RecSubCorr]=...
           SubRotCorr(APWPt,ref,Euler,color1,color2,marker1,marker2,theta_M)

% if nargin <7
%     marker2=marker1; 
% end

%% connect reference site to APWP

% calculate the GC azimuth 
az3=azimuth('gc',Euler(2),Euler(1),APWPt(:,2),APWPt(:,1));
dist=distance('gc',Euler(2),Euler(1),APWPt(:,2),APWPt(:,1));
% GC lines connecting APWP and Euler pole:GCTrack1
for i=1:length(APWPt(:,1))
    GCTrack1=track1('gc',Euler(2),Euler(1),az3(i),dist(i),[],'degrees',100);
end

% rotate reference site in the originally recontructed plate
[lonS,latS]=Rot(ref(1),ref(2),Euler(1),Euler(2),-Euler(3));

% rotation angle for each section: Omega
Omega=zeros(length(APWPt(:,1))-1,1);
Omega1=zeros(length(APWPt(:,1))-1,1);
az3_1=unwrap(az3./(180/pi),pi).*(180/pi);
RecSub=zeros(length(APWPt(:,1)),2);
RecSub(1,1)=ref(1);RecSub(1,2)=ref(2);
for i=1:length(APWPt(:,1))-1
    Omega(i)=az3(i+1)-az3(i);
    Omega1(i)=az3_1(i+1)-az3_1(i);
    [RecSub(i+1,1) RecSub(i+1,2)]=...
        Rot(RecSub(i,1),RecSub(i,2),Euler(1),Euler(2),Omega1(i));
end
% RecSub(1,:)=[];

ColorCode(RecSub,color1,marker1)


%% Calculate the intermediate reconstructed positions for three types
% calculate the GC azimuth connecting APWP and Euler pole: az3
az4=azimuth('gc',RecSub(:,2),RecSub(:,1),APWPt(1,2),APWPt(1,1));
RecSubCorr=zeros(length(APWPt(:,1)),2);
RecSubCorr(1,1)=ref(1);RecSubCorr(1,2)=ref(2);

% GC lines connecting current magnetic pole and reconstructed positions:GCTrack2
for i=1:length(APWPt(:,1))
    GCTrack3=track2('gc',APWPt(1,2),APWPt(1,1),RecSub(i,2),RecSub(i,1));
    
    % find the GC center for lines GCTrack2
    [latTrack3(i),lonTrack3(i),radiusTrack3(i)]=...
        gc2sc(RecSub(i,2),RecSub(i,1),az4(i));   
end
    
%% corrected reconstruction position using real paleo-theta: theta_M
% theta_M=distance(ref(2),ref(1),APWP(:,2),APWP(:,1));
theta_T=distance(APWPt(1,2),APWPt(1,1),RecSub(:,2),RecSub(:,1));
delta=theta_T-theta_M;

% Calculate the corrected intermediate reconstructed positions
for i=2:length(APWPt(:,1))   
    [RecSubCorr(i,1) RecSubCorr(i,2)]=...
        Rot(RecSub(i,1),RecSub(i,2),lonTrack3(i),latTrack3(i),-delta(i));
end

ColorCode(RecSubCorr,color2,marker2)


function [lonMR,latMR]=Rot(lonM,latM,lonE,latE,omega)
% check distance between point M and Euler pole
dist=distance(latM,lonM,latE,lonE);
if min(dist)>90
    [latE,lonE]=antipode(latE,lonE);
    omega=-omega;
end

% convert Point M(lonM,latM) to cartesian coordinates:
[Mx,My,Mz]=sph2cart(lonM*pi/180,latM*pi/180,1);

% calculate the rotation matrix from Euler parameters (lonE,latE,omega)
RotMat=RotMatrix(lonE,latE,omega);

for i=1:length(lonM)
    % rotate the Point M to new position M'(lonMR,latMR)
    MR(:,i)=RotMat*[Mx(i);My(i);Mz(i)];
end

% coordinates converted back
[lonMR,latMR,rMR]=cart2sph(MR(1,:),MR(2,:),MR(3,:));
lonMR=lonMR*180/pi;
latMR=latMR*180/pi;

% if (lonMR<0)
%     lonMR=lonMR+360;
% end


function RotMat=RotMatrix(lonE,latE,omega)
% convert to cartesian coordinates:
[Ex,Ey,Ez]=sph2cart(lonE*pi/180,latE*pi/180,1);

% set up rotation matrix R
R11=Ex*Ex*(1-cosd(omega))+cosd(omega);
R12=Ex*Ey*(1-cosd(omega))-Ez*sind(omega);
R13=Ex*Ez*(1-cosd(omega))+Ey*sind(omega);
R21=Ey*Ex*(1-cosd(omega))+Ez*sind(omega);
R22=Ey*Ey*(1-cosd(omega))+cosd(omega);
R23=Ey*Ez*(1-cosd(omega))-Ex*sind(omega);
R31=Ez*Ex*(1-cosd(omega))-Ey*sind(omega);
R32=Ez*Ey*(1-cosd(omega))+Ex*sind(omega);
R33=Ez*Ez*(1-cosd(omega))+cosd(omega);

% combine results
RotMat=[R11 R12 R13;R21 R22 R23;R31 R32 R33];


function ColorCode(data,colortype,marker)
step=length(data(:,1));

% Define color for the map: jet, HSV, hot, cool, autumn
MapCol=colormap(colortype);

ind1=round(length(MapCol(:,1))/length(data(:,1)));
ind2=[1:ind1:length(MapCol(:,1))];
if length(data(:,1))-length(ind2)==1
    ind2=[ind2 length(MapCol(:,1))];
elseif length(data(:,1))-length(ind2)==2
    ind1=ind1-1;
    ind2=[1:ind1:length(MapCol(:,1))];
    if length(ind2)>length(data(:,1))
        ind2(length(ind2))=[];
    end
    if length(ind2)>length(data(:,1))
        ind2(length(ind2))=[];
    end
    if length(ind2)>length(data(:,1))
        ind2(length(ind2))=[];
    end
elseif length(ind2)>length(data(:,1))
    ind2(length(ind2))=[];
    if length(ind2)>length(data(:,1))
        ind2(length(ind2))=[];
    end
    if length(ind2)>length(data(:,1))
        ind2(length(ind2))=[];
    end    
end

% plot color coded dataset
for i=1:length(ind2)
    geoshow(data(i,2),data(i,1),'DisplayType','point','Marker',...
        marker,'MarkerSize',9,'MarkerFaceColor',MapCol(ind2(i),:),...
        'MarkerEdgeColor',MapCol(ind2(i),:),'LineWidth',1.5)
end


function [ind2,MapCol]=ColorCodeCal(data,colortype)
step=length(data(:,1));

% Define color for the map: jet, HSV, hot, cool, autumn
MapCol=colormap(colortype);

ind1=round(length(MapCol(:,1))/length(data(:,1)));
ind2=[1:ind1:length(MapCol(:,1))];
if length(data(:,1))-length(ind2)==1
    ind2=[ind2 length(MapCol(:,1))];
elseif length(data(:,1))-length(ind2)==2
    ind1=ind1-1;
    ind2=[1:ind1:length(MapCol(:,1))];
    if length(ind2)>length(data(:,1))
        ind2(length(ind2))=[];
    end
    if length(ind2)>length(data(:,1))
        ind2(length(ind2))=[];
    end
    if length(ind2)>length(data(:,1))
        ind2(length(ind2))=[];
    end
elseif length(ind2)>length(data(:,1))
    ind2(length(ind2))=[];
    if length(ind2)>length(data(:,1))
        ind2(length(ind2))=[];
    end
    if length(ind2)>length(data(:,1))
        ind2(length(ind2))=[];
    end    
end

% 10) calculate confidence ellipse
function [EllPara,Cov]=CovEllp(BootReSamp,Mu,conf)
X=[BootReSamp(:,1), BootReSamp(:,2)];
% substract mean
X0 = bsxfun(@minus, X, Mu);

% inverse chi-squared with dof=#dimensions
scale = chi2inv(conf,2);

Cov = cov(X0) * scale;
[V,D] = eig(Cov);

% eigen decomposition [sorted by eigenvalues]
[D,order] = sort(diag(D), 'descend');
D = diag(D);
V = V(:, order);

semimajor=sqrt(D(1,1));
semiminor=sqrt(D(2,2));
if semimajor==0 && semimajor==0
    semimajor=.01;
    semiminor=.01;
end
ecc=axes2ecc(semimajor,semiminor);
az=atand(V(1,1)/V(2,1));
EllPara=[semimajor,semiminor,ecc,az];


function BootAPWPnew=ReArrAPWP(BootAPWP,ResN,N)
% Rearrange the APWP sequence
value={'v';'v'};
ReArr=struct('f',value);

rng('default');
for i=1:ResN
    % resample unique sample of 
    ReArr(i).f=randperm(N)';
    
    for j=1:N
        k=ReArr(i).f(j);
        BootAPWPnew(1).f(i,j)=BootAPWP(1).f(i,k);
        BootAPWPnew(2).f(i,j)=BootAPWP(2).f(i,k);

    end
    
end


function InitMap(maptype,mapview)
if maptype==1
%     maptypeV='eqdcylin';
elseif maptype==2
    maptypeV='mollweid';
elseif maptype==3
    maptypeV='ortho';
elseif maptype==4
    maptypeV='eqdcylin';
elseif maptype==5
    maptypeV='sinusoid';
end

% mapview=[lat lon tilt];
axesm(maptypeV,'Origin',mapview)
framem on; gridm on; axis off; tightmap
s = ['viewpoint (' angl2str(mapview(1),'ns') ...
    ',' angl2str(mapview(2),'ew') ',' angl2str(mapview(3)),'D )'];
title(s)

% project coastlines
coast=load('coast');
geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none')


function [lonV, latV, D_SC, rSC]=LSQCircFit_SC(a1, a2, a3, N)

% resultant vector RV
RV=sqrt(sum(a1)^2+sum(a2)^2+sum(a3)^2);

%% initial guess of the small circle parameters SC0(x1_0,x2_0,x3_0,x4_0)
% direction cosines of the mean direction (aa1,aa2,aa3) as the initial
% estimate lambda
aa1=sum(a1)/RV;
aa2=sum(a2)/RV;
aa3=sum(a3)/RV;
lambda0=[aa1;aa2;aa3];

% data in direction cosine
XMatrix=[a1 a2 a3];
X=XMatrix';

%% main loop to calculate optimal small circle parameters (x1,x2,x3,phi)
% angular distance: cos(phi)=(a1,a2,a3)(x1;x2;x3); phi=90, great circle

lambda=[];
lambda(:,1)=lambda0;

for j=2:1e9
    
    % step 1: calculate j-th estimate of phi
    for i=1:N
        comp1_1(i)=sqrt(1-(X(:,i)'*lambda(:,j-1)).^2);
        comp1_2(i)=X(:,i)'*lambda(:,j-1);
    end
        
    phi(j)=atan2(sum(comp1_1),sum(comp1_2));
    
    
    % step 2: calculate the n vectors XX(k)
    for i=1:N
        XX(:,i)=((X(:,i)'*lambda(:,j-1))*X(:,i)-lambda(:,j-1))/...
            ((1-(X(:,i)'*lambda(:,j-1)).^2).^0.5);
    end
   
    % accessory vector Y
    Y=cos(phi(j))*[sum(a1);sum(a2);sum(a3)]-...
          sin(phi(j))*[sum(XX(1,:));sum(XX(2,:));sum(XX(3,:))];
          
    % j-th estimate of lambda
    lambda(:,j)=Y/(Y'*Y).^0.5;
    
    % step 3: 
    if1=acos(dot(lambda(:,j),lambda(:,j-1)));
    if2=abs(phi(j)-phi(j-1));
    if (if1<1e-5) && (if2<1e-5)
        break
    end
    
end

phi=phi';
lambda=lambda';
[row,col]=size(lambda);

% the position of the small circle pole
[lonV,latV]=cart2sph(lambda(row,1),lambda(row,2),lambda(row,3));
latV=latV*(180/pi);
lonV=lonV*(180/pi);

% if lonV<0
%     lonV=lonV+360;
% end
% angular distance D_SC
D_SC=phi(row)*(180/pi);

%% calculte the variance ratio Vr to make selection bwteen GC or SC
% residual for small circle fitting
for i=1:N
    RSC(i)=phi(row)-...
        acos(a1(i)*lambda(row,1)+a2(i)*lambda(row,2)+a3(i)*lambda(row,3));
end
% the sum rSC of the squares of residuals R(i)
rSC=sum(RSC.^2);


function [lonE latE omega]=LSQCircFit_EuraPar(lonE,latE,lonP,latP,n)

n=length(lonP);
p1=distance(latE,lonE,latP(1),lonP(1));
p2=distance(latE,lonE,latP(n),lonP(n));
s=distance(latP(1),lonP(1),latP(n),lonP(n));
omega = acosd((cosd(s)-cosd(p1)*cosd(p2))/(sind(p1)*sind(p2)));


function [lonV, latV, D_GC, rGC]=LSQCircFit_GC(a1, a2, a3, N)
% conditions for great circle fitting
aa1=0; aa2=0; aa3=0;

% least-square small circle matrix, LSQSCMatrix
LSQSCMatrix=zeros(3,3);
LSQSCMatrix(1,1)=sum(a1.*(a1-aa1));
LSQSCMatrix(1,2)=sum(a1.*(a2-aa2));
LSQSCMatrix(1,3)=sum(a1.*(a3-aa3));
LSQSCMatrix(2,1)=sum(a2.*(a1-aa1));
LSQSCMatrix(2,2)=sum(a2.*(a2-aa2));
LSQSCMatrix(2,3)=sum(a2.*(a3-aa3));
LSQSCMatrix(3,1)=sum(a3.*(a1-aa1));
LSQSCMatrix(3,2)=sum(a3.*(a2-aa2));
LSQSCMatrix(3,3)=sum(a3.*(a3-aa3));

% eigenvectors & eigenvalues of LSQSCMatrix
[LSQSCV,LSQSCD]=eig(LSQSCMatrix);

SC0=zeros(4,1);
% center of the least-square small circle, min eigenvector/eigenvalue
% [row,col]=find(LSQSCD==min(LSQSCD(:)));
SC0(1:3)=LSQSCV(:,1);

% distance D=cos(x4_0) of this plane from the center of the unit sphere
SC0(4)=aa1*SC0(1)+aa2*SC0(2)+aa3*SC0(3);
% the position of the small circle pole
[lonV,latV]=cart2sph(SC0(1),SC0(2),SC0(3));
latV=latV.*(180/pi);
lonV=lonV.*(180/pi);
% if latV<0
%     [latV,lonV]=antipode(latV,lonV);
% end
% if lonV<0
%     lonV=lonV+360;
% end

% angular distance D_GC
D_GC=acosd(SC0(4));

%% calculte the variance ratio Vr to make selection bwteen GC or SC
% residual for great circle fitting
for i=1:N
    RGC(i)=pi/2-acos(a1(i)*SC0(1)+a2(i)*SC0(2)+a3(i)*SC0(3));
end

% the sum r of the squares of residuals R(i)
rGC=sum(RGC.^2);


function [lonE latE omega]=step1_EulerPole_Wing(lonP,latP)

n=length(latP);
for i=1:n
    x(i)=cosd(latP(i))*cosd(lonP(i));
    y(i)=cosd(latP(i))*sind(lonP(i));
    z(i)=sind(latP(i));
end

% orientation matrix T
T=zeros(3,3);

T(1,1)=sum(x.^2);
T(1,2)=sum(x.*y);
T(1,3)=sum(x.*z);

T(2,1)=sum(x.*y);
T(2,2)=sum(y.^2);
T(2,3)=sum(y.*z);

T(3,1)=sum(x.*z);
T(3,2)=sum(y.*z);
T(3,3)=sum(z.^2);

[V,D]=eig(T);   %%% V-eigenvectors; D-eigenvalues

% Position of Euler Pole (latE, lonE): 
[lonE,latE,radiusE]=cart2sph(V(1,1),V(2,1),V(3,1));
lonE=lonE*180/pi;
latE=latE*180/pi;

% Mean position of the trap:
[lonT,latT,radiusT]=cart2sph(V(1,3),V(2,3),V(3,3));
lonT=lonT*180/pi;
latT=latT*180/pi;

% % convert longtitude to E
% if (lonE<0)
%     lonE=lonE+360;
% else
%     lonE=lonE;
% end
% 
% if (lonT<0)
%     lonT=lonT+360;
% else
%     lonT=lonT;
% end

p1=distance(latE,lonE,latP(1),lonP(1));
p2=distance(latE,lonE,latP(n),lonP(n));
s=distance(latP(1),lonP(1),latP(n),lonP(n));
omega = acosd((cosd(s)-cosd(p1)*cosd(p2))/(sind(p1)*sind(p2)));


function [Dm,Im,alpha95,kappa]=fishpar(D,I)

D=D./(180/pi);
I=I./(180/pi);
[x,y,z]=sph2cart(D,I,1);
N=length(x);

R2=(sum(x))^2+(sum(y))^2+(sum(z))^2;
R=sqrt(R2);

m1=(sum(x))/R;
m2=(sum(y))/R;
m3=(sum(z))/R;

% Fisherian Parameter: kappa(K); alpha95(A95)
kappa=(N-1)/(N-R);
alpha95=acosd(1-(N-R)/R*(((1/0.05)^(1/(N-1)))-1));

% Convert back to (Im,Dm)
[Dm,Im]=cart2sph(m1,m2,m3);
Dm=Dm.*(180/pi);
Im=Im.*(180/pi);

% % find the antipodes of the poles
% if Dm<0
%     Dm=Dm+360;
% end


function [R2S,R2St2]=PEP_BootRec(APWP,ref,Euler,flipcon)
% Initiate R2S, R2St1, R2St2
R2S=zeros(length(Euler(:,1))+1,2);
R2St1=zeros(length(Euler(:,1))+1,2);
R2St2=zeros(length(Euler(:,1))+1,2);
R2S(1,:)=ref; R2St1(1,:)=ref; R2St2(1,:)=ref;

npts=length(APWP(:,1));
% plot Euler pole
for j=1:length(Euler(:,1))
    if flipcon==2 % flip decided by software
        if min(distance(ref(:,2),ref(:,1),Euler(j,2),Euler(j,1)))>90
            [Euler(j,2),Euler(j,1)]=antipode(Euler(j,2),Euler(j,1));
            Euler(j,3)=-Euler(j,3);
            fliprec(j)=1;
        else
            fliprec(j)=0;
        end
        
    elseif flipcon==1 % flip anyway
            % force flipping of the Euler pole
            [Euler(j,2),Euler(j,1)]=antipode(Euler(j,2),Euler(j,1));
            Euler(j,3)=-Euler(j,3);
            fliprec(j)=1;
            
    elseif flipcon==0 % no flip
            fliprec(j)=0;        
    end

% rotate Plate
% rotate reference site somewhere in the plate
[R2S(j+1,1),R2S(j+1,2)]=Rot(ref(1),ref(2),Euler(j,1),Euler(j,2),Euler(j,3));

% radius of GC/SC circle
radius=distance(R2S(j,2),R2S(j,1),Euler(j,2),Euler(j,1));
% Calculate the azimuth for the refence site/plate contour
az1=azimuth('gc',Euler(j,2),Euler(j,1),R2S(j,2),R2S(j,1));
az11=azimuth('gc',Euler(j,2),Euler(j,1),R2S(j+1,2),R2S(j+1,1));

% position calculated from GC/SC track fitting
if fliprec(j)==1
    if Euler(j,3)>0
        [latMt,lonMt]=scircle1(Euler(j,2),Euler(j,1),radius,[az11 az1],[]);
    else
        [latMt,lonMt]=scircle1(Euler(j,2),Euler(j,1),radius,[az1 az11],[]);
    end
else
    if Euler(j,3)>0
        [latMt,lonMt]=scircle1(Euler(j,2),Euler(j,1),radius,[az11 az1],[]);
    else
        [latMt,lonMt]=scircle1(Euler(j,2),Euler(j,1),radius,[az1 az11],[]);
    end
    
end
% flip ratation into CCW +
latMt=fliplr(latMt'); lonMt=fliplr(lonMt');
latMt=latMt';lonMt=lonMt';

if fliprec(j)==1
    if Euler(j,3)>0
        [latMt,lonMt]=scircle1(Euler(j,2),Euler(j,1),radius,[az11 az1],[],'degrees',2);
    else
        [latMt,lonMt]=scircle1(Euler(j,2),Euler(j,1),radius,[az1 az11],[],'degrees',2);
    end
else
    if Euler(j,3)>0
        [latMt,lonMt]=scircle1(Euler(j,2),Euler(j,1),radius,[az11 az1],[],'degrees',2);
    else
        [latMt,lonMt]=scircle1(Euler(j,2),Euler(j,1),radius,[az1 az11],[],'degrees',2);
    end
end
% flip ratation into CCW +
latMt=fliplr(latMt'); lonMt=fliplr(lonMt');
latMt=latMt';lonMt=lonMt';

% calculate and plot APWP
radAPWP=distance(Euler(j,2),Euler(j,1),[APWP(1,2) APWP(npts,2)],[APWP(1,1) APWP(npts,1)]);
% radAPWP=distance(Euler(j,2),Euler(j,1),APWP(j,2),APWP(j,1));
% Calculate the azimuth for APWP
az2=azimuth('gc',Euler(j,2),Euler(j,1),[APWP(1,2) APWP(npts,2)],[APWP(1,1) APWP(npts,1)]);
if fliprec(j)==1
    if Euler(j,3)>0
        [latAPWP,lonAPWP]=scircle1(Euler(j,2),Euler(j,1),radAPWP(1),[az2(1) az2(2)],[]);
    else
        [latAPWP,lonAPWP]=scircle1(Euler(j,2),Euler(j,1),radAPWP(1),[az2(2) az2(1)],[]);
    end
else
    if Euler(j,3)>0
        [latAPWP,lonAPWP]=scircle1(Euler(j,2),Euler(j,1),radAPWP(1),[az2(1) az2(2)],[]);
    else
        [latAPWP,lonAPWP]=scircle1(Euler(j,2),Euler(j,1),radAPWP(1),[az2(2) az2(1)],[]);
    end
end

% reconstruction from SC track
recT=[R2S(j,1) R2S(j,2);R2S(j+1,1) R2S(j+1,2)];

dist=distance(recT(:,2),recT(:,1),[APWP(1,2);APWP(npts,2)],[APWP(1,1);APWP(npts,1)]);

% connect Euler pole and all reconstructed positions
% Lines connecting plate M1 & M2

% GC lines connecting APWP and Euler pole
plateM=track2('gc',APWP(1,2),APWP(1,1),Euler(j,2),Euler(j,1));

plateM=track2('gc',APWP(npts,2),APWP(npts,1),Euler(j,2),Euler(j,1));

% Azimuth defined by the colatitude line (WRT current reference site)
az2=azimuth('gc',[APWP(1,2);APWP(npts,2)],[APWP(1,1);APWP(npts,1)],recT(:,2),recT(:,1));
% distance between APWP and reconstructed positions: dist1
dist1=distance([APWP(1,2);APWP(npts,2)],[APWP(1,1);APWP(npts,1)],recT(:,2),recT(:,1));
    
for i=1:2
    % GC lines connecting Euler pole and restored track:GCTrack1
    GCTrack1=track2('gc',recT(i,2),recT(i,1),Euler(j,2),Euler(j,1));

    % Calculate the azimuth for the refence site/plate contour
    az1(i)=azimuth('gc',Euler(j,2),Euler(j,1),recT(i,2),recT(i,1));
      
    % find the GC center for lines connecting Euler and restored track:GCTrack1
    [latTrack1(i),lonTrack1(i),radiusTrack1(i)]=...
        gc2sc(Euler(j,2),Euler(j,1),az1(i));
 
end

% theta_T: theta for GC/SC track
azAX=azimuth('gc',APWP(1,2),APWP(1,1),recT(:,2),recT(:,1));
distAX=distance(APWP(1,2),APWP(1,1),recT(:,2),recT(:,1));

% Auxiliary lines
for i=1:2
    % GC lines connecting APWP and restored track:GCTrack2
    GCTrack2=track2('gc',APWP(1,2),APWP(1,1),recT(i,2),recT(i,1));

    % find the GC center for lines connecting APWP and restored track:GCTrack2
    [latTrack2(i),lonTrack2(i),radiusTrack2(i)]=...
        gc2sc(APWP(1,2),APWP(1,1),azAX(i));
    % visualize the fitted circles
    [lat111,lon111] = scircle1(latTrack2(i),lonTrack2(i),90);
    
end

% reconstruction from SC track
% corrected reconstruction position using real theta: theta_M
theta_M=distance(ref(2),ref(1),[APWP(1,2);APWP(npts,2)],[APWP(1,1);APWP(npts,1)]);
theta_T=distAX;
delta=theta_T-theta_M;

% rotate reference site in the originally recontructed plate
[lonSt2,latSt2]=Rot(R2S(j+1,1),R2S(j+1,2),lonTrack2(2),latTrack2(2),delta(2));

% combine and export results in R2S, R2St1, R2St2
% combine results
R2St2(j+1,1)=lonSt2; R2St2(j+1,2)=latSt2;
R2S(1,:)=[]; R2St1(1,:)=[]; R2St2(1,:)=[];
   
end


function [RecSub,RecSubCorr]=BootSubRotCorr(APWP,ref,Euler)
% calculate the GC azimuth 
az3=azimuth('gc',Euler(2),Euler(1),APWP(:,2),APWP(:,1));
dist=distance('gc',Euler(2),Euler(1),APWP(:,2),APWP(:,1));
% GC lines connecting APWP and Euler pole:GCTrack1
for i=1:length(APWP(:,1))
    GCTrack1=track1('gc',Euler(2),Euler(1),az3(i),dist(i),[],'degrees',100);
end

% rotate reference site in the originally recontructed plate
[lonS,latS]=Rot(ref(1),ref(2),Euler(1),Euler(2),-Euler(3));

% rotation angle for each section: Omega
Omega=zeros(length(APWP(:,1))-1,1);
Omega1=zeros(length(APWP(:,1))-1,1);
az3_1=unwrap(az3./(180/pi),pi).*(180/pi);
RecSub=zeros(length(APWP(:,1)),2);
RecSub(1,1)=ref(1);RecSub(1,2)=ref(2);
for i=1:length(APWP(:,1))-1
    Omega(i)=az3(i+1)-az3(i);
    Omega1(i)=az3_1(i+1)-az3_1(i);
    [RecSub(i+1,1) RecSub(i+1,2)]=...
        Rot(RecSub(i,1),RecSub(i,2),Euler(1),Euler(2),Omega1(i));
end

% Calculate the intermediate reconstructed positions for three types
% calculate the GC azimuth connecting APWP and Euler pole: az3
az4=azimuth('gc',RecSub(:,2),RecSub(:,1),APWP(1,2),APWP(1,1));
RecSubCorr=zeros(length(APWP(:,1)),2);
RecSubCorr(1,1)=ref(1);RecSubCorr(1,2)=ref(2);

% GC lines connecting current magnetic pole and reconstructed positions:GCTrack2
for i=1:length(APWP(:,1))
    GCTrack3=track2('gc',APWP(1,2),APWP(1,1),RecSub(i,2),RecSub(i,1));
    
    % find the GC center for lines GCTrack2
    [latTrack3(i),lonTrack3(i),radiusTrack3(i)]=...
        gc2sc(RecSub(i,2),RecSub(i,1),az4(i));
    
end
    
% corrected reconstruction position using real paleo-theta: theta_M
theta_M=distance(ref(2),ref(1),APWP(:,2),APWP(:,1));
theta_T=distance(APWP(1,2),APWP(1,1),RecSub(:,2),RecSub(:,1));
delta=theta_T-theta_M;

% Calculate the corrected intermediate reconstructed positions
for i=2:length(APWP(:,1))   
    [RecSubCorr(i,1) RecSubCorr(i,2)]=...
        Rot(RecSub(i,1),RecSub(i,2),lonTrack3(i),latTrack3(i),-delta(i));
end


function plateSub=SubRotPlateOnly(APWP,ref,Euler,plate)

plateSub=plate;

% connect reference site to APWP
% calculate the GC azimuth 
az3=azimuth('gc',Euler(2),Euler(1),APWP(:,2),APWP(:,1));
dist=distance('gc',Euler(2),Euler(1),APWP(:,2),APWP(:,1));
% GC lines connecting APWP and Euler pole:GCTrack1
for i=1:length(APWP(:,1))
    GCTrack1=track1('gc',Euler(2),Euler(1),az3(i),dist(i),[],'degrees',100);
end

% rotate reference site in the originally recontructed plate
[lonS,latS]=Rot(ref(1),ref(2),Euler(1),Euler(2),-Euler(3));

% rotation angle for each section: Omega
Omega=zeros(length(APWP(:,1))-1,1);
Omega1=zeros(length(APWP(:,1))-1,1);
az3_1=unwrap(az3./(180/pi),pi).*(180/pi);
RecSub=zeros(length(APWP(:,1)),2);
RecSub(1,1)=ref(1);RecSub(1,2)=ref(2);
plateAux=plate(1).f1;
plateSub1=zeros(length(plateAux(:,1)),2);
plateSub2=zeros(length(plateAux(:,1)),2);

for i=1:length(APWP(:,1))-1
    % rotate reference site
    Omega(i)=az3(i+1)-az3(i);
    Omega1(i)=az3_1(i+1)-az3_1(i);
    [RecSub(i+1,1) RecSub(i+1,2)]=...
        Rot(RecSub(i,1),RecSub(i,2),Euler(1),Euler(2),Omega1(i));
    
    % rotate plate
    [plateSub1(:,1) plateSub1(:,2)]=Rot(plateSub(i).f1(:,1),...
        plateSub(i).f1(:,2),Euler(1),Euler(2),Omega1(i));    
    plateSub(i+1).f1=[plateSub1(:,1) plateSub1(:,2)];   
end

% Calculate the intermediate reconstructed positions for three types
% calculate the GC azimuth connecting APWP and Euler pole: az3
az4=azimuth('gc',RecSub(:,2),RecSub(:,1),APWP(1,2),APWP(1,1));

% GC lines connecting current magnetic pole and reconstructed positions:GCTrack2
for i=1:length(APWP(:,1))
    GCTrack3=track2('gc',APWP(1,2),APWP(1,1),RecSub(i,2),RecSub(i,1));
    
    % find the GC center for lines GCTrack2
    [latTrack3(i),lonTrack3(i),radiusTrack3(i)]=...
        gc2sc(RecSub(i,2),RecSub(i,1),az4(i));
end
    
% corrected reconstruction position using real paleo-theta: theta_M
theta_M=distance(ref(2),ref(1),APWP(:,2),APWP(:,1));
theta_T=distance(APWP(1,2),APWP(1,1),RecSub(:,2),RecSub(:,1));
delta=theta_T-theta_M;

% Calculate the corrected intermediate reconstructed positions
for i=2:length(APWP(:,1))   
    % for the plate
    [plateSub2(:,1) plateSub2(:,2)]=Rot(plateSub(i).f1(:,1),...
        plateSub(i).f1(:,2),lonTrack3(i),latTrack3(i),-delta(i));
    plateSub(i).f2=[plateSub2(:,1) plateSub2(:,2)];
end

%-------------------------------------------------------------------------


% --- Executes on selection change in ExportInterm.
function ExportInterm_Callback(hObject, eventdata, handles)
% hObject    handle to ExportInterm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ExportInterm contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ExportInterm

ExportInterm=get(hObject,'Value');
switch ExportInterm
    case 1

    case 2
        if isfield(handles,'BootAPWP')==0
            disp('Please calculate Boot Euler first!');
        elseif isfield(handles,'BootAPWP')==1
            BootAPWP=handles.BootAPWP;
            [FileName,PathName]=uiputfile('*.mat','Save BootAPWP As');
            if FileName ~= 0
                nbfiles = 1;
            else
                nbfiles = 0;
            end
            
            if nbfiles==1
                FileName(length(FileName))=[];FileName(length(FileName))=[];
                FileName(length(FileName))=[];FileName(length(FileName))=[];
                FullName=[PathName,'BootAPWP','_',FileName,'.mat'];
                save(FullName, 'BootAPWP');
                disp('BootAPWP.mat exported.');
            elseif nbfiles==0
            end
        end
    case 3
        if isfield(handles,{'BootEuGC','BootEuSC'})==0
            disp('Please calculate Boot Euler first!');
        elseif isfield(handles,{'BootEuGC','BootEuSC'})==1
            BootEuGC=handles.BootEuGC;
            BootEuSC=handles.BootEuSC;
            [FileName,PathName]=uiputfile('*.mat','Save BootEuGC BootEuSC As');
            if FileName ~= 0
                nbfiles = 1;
            else
                nbfiles = 0;
            end
            
            if nbfiles==1
                FileName(length(FileName))=[];FileName(length(FileName))=[];
                FileName(length(FileName))=[];FileName(length(FileName))=[];
                FullName1=[PathName,'BootEuGC','_',FileName,'.mat'];
                FullName2=[PathName,'BootEuSC','_',FileName,'.mat'];
                save(FullName1, 'BootEuGC'); save(FullName2, 'BootEuSC');
                disp('BootEuGC.mat & BootEuSC.mat exported.');
            elseif nbfiles==0
            end
        end
    case 4
        if isfield(handles,'StrucEuAPWP')==0
            disp('Please calculate Boot Euler first!');
        elseif isfield(handles,'StrucEuAPWP')==1
            StrucEuAPWP=handles.StrucEuAPWP;
            [FileName,PathName]=uiputfile('*.mat','Save StrucEuAPWP As');
            if FileName ~= 0
                nbfiles = 1;
            else
                nbfiles = 0;
            end
            
            if nbfiles==1
                FileName(length(FileName))=[];FileName(length(FileName))=[];
                FileName(length(FileName))=[];FileName(length(FileName))=[];
                FullName=[PathName,'StrucEuAPWP','_',FileName,'.mat'];
                save(FullName, 'StrucEuAPWP');
                disp('StrucEuAPWP.mat exported.');
            elseif nbfiles==0
            end
        end
    case 5
        if isfield(handles,'BootEuAPWPnew')==0
            disp('Please calculate Boot Euler first!');
        elseif isfield(handles,'BootEuAPWPnew')==1
            BootEuAPWPnew=handles.BootEuAPWPnew;
            [FileName,PathName]=uiputfile('*.mat','Save BootEuAPWPnew As');
            if FileName ~= 0
                nbfiles = 1;
            else
                nbfiles = 0;
            end
            
            if nbfiles==1
                FileName(length(FileName))=[];FileName(length(FileName))=[];
                FileName(length(FileName))=[];FileName(length(FileName))=[];
                FullName=[PathName,'BootEuAPWPnew','_',FileName,'.mat'];
                save(FullName, 'BootEuAPWPnew');
                disp('BootEuAPWPnew.mat exported.');
            elseif nbfiles==0
            end
        end
    case 6
        if isfield(handles,'BootEuNewRG')==0
            disp('Please calculate Boot Euler first!');
        elseif isfield(handles,'BootEuNewRG')==1
            BootEuNewRG=handles.BootEuNewRG;
            [FileName,PathName]=uiputfile('*.mat','Save BootEuNewRG As');
            if FileName ~= 0
                nbfiles = 1;
            else
                nbfiles = 0;
            end
            
            if nbfiles==1
                FileName(length(FileName))=[];FileName(length(FileName))=[];
                FileName(length(FileName))=[];FileName(length(FileName))=[];
                FullName=[PathName,'BootEuNewRG','_',FileName,'.mat'];
                save(FullName, 'BootEuNewRG');
                disp('BootEuNewRG.mat exported.');
            elseif nbfiles==0
            end
        end
    case 7
        if isfield(handles,'BootRec')==0
            disp('Please calculate Boot Rec first!');
        elseif isfield(handles,'BootRec')==1
            BootRec=handles.BootRec;
            [FileName,PathName]=uiputfile('*.mat','Save BootRec As');
            if FileName ~= 0
                nbfiles = 1;
            else
                nbfiles = 0;
            end
            
            if nbfiles==1
                FileName(length(FileName))=[];FileName(length(FileName))=[];
                FileName(length(FileName))=[];FileName(length(FileName))=[];
                FullName=[PathName,'BootRec','_',FileName,'.mat'];
                save(FullName, 'BootRec');
                disp('BootRec.mat exported.');
            elseif nbfiles==0
            end
        end
    case 8
        if isfield(handles,'BootRecRG')==0
            disp('Please calculate Boot Rec first!');
        elseif isfield(handles,'BootRecRG')==1
            BootRecRG=handles.BootRecRG;
            [FileName,PathName]=uiputfile('*.mat','Save BootRecRG As');
            if FileName ~= 0
                nbfiles = 1;
            else
                nbfiles = 0;
            end
            
            if nbfiles==1
                FileName(length(FileName))=[];FileName(length(FileName))=[];
                FileName(length(FileName))=[];FileName(length(FileName))=[];
                FullName=[PathName,'BootRecRG','_',FileName,'.mat'];
                save(FullName, 'BootRecRG');
                disp('BootRecRG.mat exported.');
            elseif nbfiles==0
            end
        end
    otherwise
        
end


% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ExportInterm_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ExportInterm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PlotCalcs.
function PlotCalcs_Callback(hObject, eventdata, handles)
% hObject    handle to PlotCalcs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PlotCalcs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PlotCalcs

PlotCalcs=get(hObject,'Value');
switch PlotCalcs
    case 1
        
    case 2
        
        if isfield(handles,{'StrucEuAPWP'})==0
            disp('Please calculate bootstrap Euler parameters first!');
        elseif isfield(handles,{'StrucEuAPWP'})==1
            StrucEuAPWP=handles.StrucEuAPWP;
            BootEuNewRG=handles.BootEuNewRG;
            BootEuAPWPnew=handles.BootEuAPWPnew;
            Euler45=StrucEuAPWP(2).f3;
            % npts along APWP
            npts45=length(BootEuAPWPnew(1).f1(:,1));
            % decide the color code: [ind2,MapCol]=ColorCodeCal(data,colortype)
            % colormap: jet, hsv, hot, cool, spring, autumn, summer, winter, gray
            [ind,MapCol]=ColorCodeCal(zeros(npts45,1),handles.ColorCodeS);
            
            
            for k=1:npts45
                axes(handles.axes1);
                geoshow(BootEuNewRG(k).f2(:,2), BootEuNewRG(k).f2(:,1),'DisplayType','point',...
                    'Marker','o','MarkerEdgeColor',MapCol(ind(k),:),'MarkerSize',7);
                
                % Uncertainty ellipse estimation from covariance matrix
                % Fisher mean [Dm,Im,alpha95,kappa]=fishpar(D,I)
                [Dm,Im,alpha95,kappa]=fishpar(BootEuNewRG(k).f2(:,1), BootEuNewRG(k).f2(:,2));
                axes(handles.axes1);
                geoshow(Im,Dm,'DisplayType','point','Marker','p',...
                    'MarkerEdgeColor',MapCol(ind(k),:),'MarkerSize',14);
                geoshow(Euler45(k,2),Euler45(k,1),'DisplayType','point','Marker','p',...
                    'MarkerEdgeColor',MapCol(ind(k),:),'MarkerFaceColor',...
                    MapCol(ind(k),:),'MarkerSize',14);
                
                Mu=[Dm,Im];
                X=[BootEuNewRG(k).f2(:,1), BootEuNewRG(k).f2(:,2)];
                % calculate confidence ellipse
                % function [EllPara,Cov]=CovEllp(BootReSamp,Mu,conf)
                STD=2;
                
                % calculate the ellipse centered on Fisherian Means
                [EllPara1,Cov1]=CovEllp(X,Mu,2*normcdf(STD)-1);
                [elat1,elon1]=ellipse1(Mu(2),Mu(1),...
                    [EllPara1(1) EllPara1(3)],EllPara1(4));
                trigonom1=[elon1 elat1];
                
                % calculate the ellipse centered on Euler poles
                [EllPara2,Cov2]=CovEllp(X,Euler45(k,1:2),2*normcdf(STD)-1);
                % calculate the ellipse centered on Fisherian Means
                [elat2,elon2]=ellipse1(Euler45(k,2),Euler45(k,1),...
                    [EllPara2(1) EllPara2(3)],EllPara2(4));
                trigonom2=[elon2 elat2];
                
                axes(handles.axes1);
                % plot cov and major/minor axes
                geoshow(trigonom1(:,2), trigonom1(:,1),'LineStyle','--',...
                    'Color',MapCol(ind(k),:));
                % quiverm(Mu(1),Mu(2), VV(2,1),VV(1,1), 'Color','k');
                geoshow(trigonom2(:,2), trigonom2(:,1), 'Color',MapCol(ind(k),:));
                
            end
            caxis([1 npts45]); colormap(jet(npts45));
            axes(handles.axes1);
            % plot the trajectory of reconstructions
            geoshow(Euler45(:,2),Euler45(:,1),'LineStyle','--','color',...
                [.75 .0 .75],'linewidth',1.5);
            % Add data label
            ind=[1:1:length(Euler45(:,1))]';
            [G,GN]=grp2idx(ind);
            axes(handles.axes1);
            % Project text annotation on map axes
            for i = 1:length(Euler45(:,1))
                textm(Euler45(i,2),Euler45(i,1),GN(i),'Color',[.75 .0 .75],'FontSize',14);
            end
            disp('Bootstrap Euler poles plotted.');
        end

    case 3
        
        if isfield(handles,{'StrucEuAPWP'})==0
            disp('Please calculate bootstrap Euler parameters first!');
        elseif isfield(handles,{'StrucEuAPWP'})==1
            StrucEuAPWP=handles.StrucEuAPWP;
            BootEuNewRG=handles.BootEuNewRG;
            BootEuAPWPnew=handles.BootEuAPWPnew;
            Euler45=StrucEuAPWP(2).f3;
            % npts along APWP
            npts45=length(BootEuAPWPnew(1).f1(:,1));
            % decide the color code: [ind2,MapCol]=ColorCodeCal(data,colortype)
            % colormap: jet, hsv, hot, cool, spring, autumn, summer, winter, gray
            [ind,MapCol]=ColorCodeCal(zeros(npts45,1),handles.ColorCodeS);
            
            
            for k=1:npts45
                axes(handles.axes1);
                
                % Uncertainty ellipse estimation from covariance matrix
                % Fisher mean [Dm,Im,alpha95,kappa]=fishpar(D,I)
                [Dm,Im,alpha95,kappa]=fishpar(BootEuNewRG(k).f2(:,1), BootEuNewRG(k).f2(:,2));
                axes(handles.axes1);
                geoshow(Euler45(k,2),Euler45(k,1),'DisplayType','point','Marker','p',...
                    'MarkerEdgeColor',MapCol(ind(k),:),'MarkerFaceColor',...
                    MapCol(ind(k),:),'MarkerSize',14);
                
                Mu=[Dm,Im];
                X=[BootEuNewRG(k).f2(:,1), BootEuNewRG(k).f2(:,2)];
                % calculate confidence ellipse
                % function [EllPara,Cov]=CovEllp(BootReSamp,Mu,conf)
                STD=2;
                
                % calculate the ellipse centered on Fisherian Means
                [EllPara1,Cov1]=CovEllp(X,Mu,2*normcdf(STD)-1);
                [elat1,elon1]=ellipse1(Mu(2),Mu(1),...
                    [EllPara1(1) EllPara1(3)],EllPara1(4));
                trigonom1=[elon1 elat1];
                
                % calculate the ellipse centered on Euler poles
                [EllPara2,Cov2]=CovEllp(X,Euler45(k,1:2),2*normcdf(STD)-1);
                % calculate the ellipse centered on Fisherian Means
                [elat2,elon2]=ellipse1(Euler45(k,2),Euler45(k,1),...
                    [EllPara2(1) EllPara2(3)],EllPara2(4));
                trigonom2=[elon2 elat2];
                
                axes(handles.axes1);
                % plot cov and major/minor axes
                geoshow(trigonom2(:,2), trigonom2(:,1), 'Color',MapCol(ind(k),:));
                
            end

            caxis([1 npts45]); colormap(jet(npts45));
            axes(handles.axes1);
            % plot the trajectory of reconstructions
            geoshow(Euler45(:,2),Euler45(:,1),'LineStyle','--','color',...
                [.75 .0 .75],'linewidth',1.5);
            % Add data label
            ind=[1:1:length(Euler45(:,1))]';
            [G,GN]=grp2idx(ind);
            axes(handles.axes1);
            % Project text annotation on map axes
            for i = 1:length(Euler45(:,1))
                textm(Euler45(i,2),Euler45(i,1),GN(i),'Color',[.75 .0 .75],'FontSize',14);
            end
            disp('Bootstrap Euler poles plotted.');
        end
        
    case 4
        if isfield(handles,{'BootRec'})==0
            disp('Please calculate bootstrap reconstructions first!');
        elseif isfield(handles,{'BootRec'})==1
            BootRec=handles.BootRec;
            BootEuAPWPnew=handles.BootEuAPWPnew;
            BootRecRG=handles.BootRecRG;
            RecSt=handles.rec.RecSt;
            
            Ref6=RecSt(2).f4;
            % npts along APWP
            npts6=length(BootRec(1).f1(:,1));
            % decide the color code: [ind2,MapCol]=ColorCodeCal(data,colortype)
            % colormap: jet, hsv, hot, cool, spring, autumn, summer, winter, gray
            [ind,MapCol]=ColorCodeCal(zeros(npts6,1),handles.ColorCodeS);
            
            for k=1:npts6
                geoshow(BootRecRG(k).f2(:,2), BootRecRG(k).f2(:,1),'DisplayType','point',...
                    'Marker','o','MarkerEdgeColor',MapCol(ind(k),:),'MarkerSize',7);
                geoshow(Ref6(k,2), Ref6(k,1),'DisplayType','point','Marker','p',...
                    'MarkerEdgeColor',MapCol(ind(k),:),'MarkerFaceColor',...
                    MapCol(ind(k),:),'MarkerSize',14);
                
                % Uncertainty ellipse estimation from covariance matrix
                % Fisher mean [Dm,Im,alpha95,kappa]=fishpar(D,I)
                [Dm,Im,alpha95,kappa]=fishpar(BootRecRG(k).f2(:,1), BootRecRG(k).f2(:,2));
                geoshow(Im,Dm,'DisplayType','point','Marker','p',...
                    'MarkerEdgeColor',MapCol(ind(k),:),'MarkerSize',14);
                
                Mu=[Dm,Im];
                X=[BootRecRG(k).f2(:,1), BootRecRG(k).f2(:,2)];
                % calculate confidence ellipse
                % function [EllPara,Cov]=CovEllp(BootReSamp,Mu,conf)
                STD=2;
                
                % calculate the ellipse centered on Fisherian Means
                [EllPara1,Cov1]=CovEllp(X,Mu,2*normcdf(STD)-1);
                [elat1,elon1]=ellipse1(Mu(2),Mu(1),...
                    [EllPara1(1) EllPara1(3)],EllPara1(4));
                trigonom1=[elon1 elat1];
                
                % calculate the ellipse centered on Euler poles
                [EllPara2,Cov2]=CovEllp(X,Ref6(k,1:2),2*normcdf(STD)-1);
                % calculate the ellipse centered on Fisherian Means
                [elat2,elon2]=ellipse1(Ref6(k,2), Ref6(k,1),...
                    [EllPara2(1) EllPara2(3)],EllPara2(4));
                trigonom2=[elon2 elat2];
                
                % plot cov and major/minor axes
                geoshow(trigonom1(:,2), trigonom1(:,1),'LineStyle','--','Color',MapCol(ind(k),:));
                % quiverm(Mu(1),Mu(2), VV(2,1),VV(1,1), 'Color','k');
                geoshow(trigonom2(:,2), trigonom2(:,1), 'Color',MapCol(ind(k),:));
                
            end
            colormap(jet(npts6));
            caxis([min(handles.RecStAge) max(handles.RecStAge)]);
            % plot the trajectory of reconstructions
            geoshow(Ref6(:,2),Ref6(:,1),'LineStyle','--','color',...
                [.75 .0 .75],'linewidth',1.5);
            disp('Bootstrap reconstructions plotted.');
        end

    case 5
        if isfield(handles,{'BootRec'})==0
            disp('Please calculate bootstrap reconstructions first!');
        elseif isfield(handles,{'BootRec'})==1
            BootRec=handles.BootRec;
            BootEuAPWPnew=handles.BootEuAPWPnew;
            BootRecRG=handles.BootRecRG;
            RecSt=handles.rec.RecSt;
            
            Ref6=RecSt(2).f4;
            % npts along APWP
            npts6=length(BootRec(1).f1(:,1));
            % decide the color code: [ind2,MapCol]=ColorCodeCal(data,colortype)
            % colormap: jet, hsv, hot, cool, spring, autumn, summer, winter, gray
            [ind,MapCol]=ColorCodeCal(zeros(npts6,1),handles.ColorCodeS);
            
            for k=1:npts6
                geoshow(Ref6(k,2), Ref6(k,1),'DisplayType','point','Marker','p',...
                    'MarkerEdgeColor',MapCol(ind(k),:),'MarkerFaceColor',...
                    MapCol(ind(k),:),'MarkerSize',14);
                
                % Uncertainty ellipse estimation from covariance matrix
                % Fisher mean [Dm,Im,alpha95,kappa]=fishpar(D,I)
                [Dm,Im,alpha95,kappa]=fishpar(BootRecRG(k).f2(:,1), BootRecRG(k).f2(:,2));
                
                Mu=[Dm,Im];
                X=[BootRecRG(k).f2(:,1), BootRecRG(k).f2(:,2)];
                % calculate confidence ellipse
                % function [EllPara,Cov]=CovEllp(BootReSamp,Mu,conf)
                STD=2;
                
                % calculate the ellipse centered on Fisherian Means
                [EllPara1,Cov1]=CovEllp(X,Mu,2*normcdf(STD)-1);
                [elat1,elon1]=ellipse1(Mu(2),Mu(1),...
                    [EllPara1(1) EllPara1(3)],EllPara1(4));
                trigonom1=[elon1 elat1];
                
                % calculate the ellipse centered on Euler poles
                [EllPara2,Cov2]=CovEllp(X,Ref6(k,1:2),2*normcdf(STD)-1);
                % calculate the ellipse centered on Fisherian Means
                [elat2,elon2]=ellipse1(Ref6(k,2), Ref6(k,1),...
                    [EllPara2(1) EllPara2(3)],EllPara2(4));
                trigonom2=[elon2 elat2];
                
                % plot cov and major/minor axes
                geoshow(trigonom2(:,2), trigonom2(:,1), 'Color',MapCol(ind(k),:));
                
            end
            colormap(jet(npts6));
            caxis([min(handles.RecStAge) max(handles.RecStAge)]);
            % plot the trajectory of reconstructions
            geoshow(Ref6(:,2),Ref6(:,1),'LineStyle','--','color',...
                [.75 .0 .75],'linewidth',1.5);
            disp('Bootstrap reconstructions plotted.');
            
            
        end
        
        case 6
            if isfield(handles,'rec')==0
                disp('Please calculate reconstructed plate first!');
            elseif isfield(handles,'rec')==1
                RecSt=handles.rec.RecSt;
                [ind,MapCol]=ColorCodeCal(zeros(length(RecSt(2).f4(:,1)),1),...
                    handles.ColorCodeS);
                
                for i=1:length(RecSt(2).f4(:,1))
                    % plot reference site
                    geoshow(RecSt(2).f4(i,2), RecSt(2).f4(i,1),'DisplayType','point',...
                        'Marker','o','MarkerEdgeColor',MapCol(ind(i),:),'MarkerSize',7);
                    
                    % plot plate
                    geoshow(RecSt(i).f6(:,2), RecSt(i).f6(:,1),'DisplayType','line',...
                        'linestyle','-','color',MapCol(ind(i),:),'LineWidth',1.5);
                end
                
                colormap(jet(length(RecSt(2).f4(:,1))));
                caxis([min(handles.RecStAge) max(handles.RecStAge)]);
                disp('Reconstructed contour plotted.');
            end
    otherwise
        
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function PlotCalcs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlotCalcs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% save .pdf file
[FileName,PathName]=uiputfile('*.pdf','Save Figure As');
if FileName ~= 0
    nbfiles = 1;
else
    nbfiles = 0;
end

if nbfiles==1
    FullName=[PathName,FileName];
    printpdf(gcf, FullName);
    disp('Figure exported.');
elseif nbfiles==0
    disp('Please name the figure!')
end

guidata(hObject, handles);

% printpdf Prints image in PDF format without tons of white space
 function [filename] =  printpdf(fig, name)
% The width and height of the figure are found
% The paper is set to be the same width and height as the figure
% The figure's bottom left corner is lined up with
% the paper's bottom left corner

% Set figure and paper to use the same unit
set(fig, 'Units', 'centimeters')
set(fig, 'PaperUnits','centimeters');

% Position of figure is of form [left bottom width height]
% We only care about width and height
pos = get(fig,'Position');

% Set paper size to be same as figure size
set(fig, 'PaperSize', [pos(3) pos(4)]);

% Set figure to start at bottom left of paper
% This ensures that figure and paper will match up in size
set(fig, 'PaperPositionMode', 'manual');
set(fig, 'PaperPosition', [0 0 pos(3) pos(4)]);

% Print as pdf
print(fig, '-dpdf', name)

% Return full file name
filename = [name, '.pdf'];


% --- Executes on button press in ModifyRecSt.
function ModifyRecSt_Callback(hObject, eventdata, handles)
% hObject    handle to ModifyRecSt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile('*.mat');
if FileName ~= 0
    nbfiles = 1;
else
    nbfiles = 0;
end

if isfield(handles,{'Finite'})==0
    disp('Please load finite rotation file first!');
elseif isfield(handles,{'Finite'})==1
    Finite=handles.Finite;
    
    if nbfiles==0
    elseif nbfiles==1
        
        % FFPNPM=Full File Path Name of PM data
        FFPNPM = strcat(PathName,FileName);
        %     handles.RecStName1=FileName;
        % Rotation parameters
        load(FFPNPM);
        if exist('RecSt','var')==0
            disp('Please load the correct RecSt file!');
        elseif exist('RecSt','var')==1
            %  handles.rec.RecSt=RecSt;
            disp('RecSt.mat loaded.');
            
%-------------------------------------------------------------------------
            % Modify RecSt with know rotations
            %-------------------------------
            % RecSt=NewEulerAPWP(Euler,APWP)
            % 1) construct structural data
            % f1=[APWP; APWP tracks];
            % f2=[APWP tracks'];
            % f3=[PEP; PEP'; PEP_err; PEP'_err;];
            % f4=[ref, ref_cor (ref_adj), (ref_cor)];
            % f5=[plate];
            % f6=[plate_cor (plate_adj)];
            % f7=[(plate_cor)];
            % f8=[age,Velo,LatV,LonV]; from PMTec_PtKin
            % f9-f10: backup storage
            %-------------------------------          
            % move ref_cor from RecSt(2).f4 to RecSt(3).f4
            RecSt(3).f4=RecSt(2).f4;            
            
            % [lonMR,latMR]=step2_Wing_Rot(lonM,latM,lonE,latE,omega)
            for i=1:length(RecSt(2).f4(:,2))
                % copy plate_cor from RecSt.f6 to RecSt.f7
                RecSt(i).f7=RecSt(i).f6;
                                
                % adjust reference site in RecSt(2).f4
                [lonMR,latMR]=step2_Wing_Rot(RecSt(3).f4(i,1),...
                    RecSt(3).f4(i,2),Finite(i,2),Finite(i,3),Finite(i,4));
                RecSt(2).f4(i,:)=[lonMR,latMR];
                
                % adjust plate contour in RecSt.f6
                [lonPC,latPC]=step2_Wing_Rot(RecSt(i).f7(:,1),...
                    RecSt(i).f7(:,2),Finite(i,2),Finite(i,3),Finite(i,4));
                RecSt(i).f6=[lonPC',latPC'];
                
            end
            RecSt(i+1).f7=NaN;
%-------------------------------------------------------------------------
            save(FFPNPM,'RecSt');
            disp('RecSt modified and saved.');
        end
        
    end
end

guidata(hObject, handles);


% --- Executes on button press in LoadFinite.
function LoadFinite_Callback(hObject, eventdata, handles)
% hObject    handle to LoadFinite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uigetfile( ...
    {'*.xlsx;*.xls;*.txt;*.dat',...
    'Excel Workbook (*.xlsx,*.xls)';
    '*.txt',  'Tab delimited (*.txt)'; ...
    '*.dat','Data files (*.dat)'}, ...
    'Load Finite Poles For RecSt Modification [lonE, latE, Omega]');
if FileName ~= 0
    nbfiles = 1;
else
    nbfiles = 0;
end

if nbfiles==1
    FullName = strcat(PathName,FileName);
    % Finite rotations
    if FileName(length(FileName)-4:length(FileName))=='.xlsx'
        Finite=xlsread(FullName);
    elseif FileName(length(FileName)-3:length(FileName))=='.xls'
        Finite=xlsread(FullName);
    else
        Finite=importdata(FullName);
    end
    handles.Finite=Finite;
    disp('Finite rotation poles loaded.');
    
elseif nbfiles==0
end

guidata(hObject, handles);
