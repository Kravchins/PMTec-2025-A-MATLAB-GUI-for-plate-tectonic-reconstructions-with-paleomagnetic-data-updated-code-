function varargout = PMTec_PlateID(varargin)
% PMTEC_PLATEID MATLAB code for PMTec_PlateID.fig
%      PMTEC_PLATEID, by itself, creates a new PMTEC_PLATEID or raises the existing
%      singleton*.
%
%      H = PMTEC_PLATEID returns the handle to a new PMTEC_PLATEID or the handle to
%      the existing singleton*.
%
%      PMTEC_PLATEID('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PMTEC_PLATEID.M with the given input arguments.
%
%      PMTEC_PLATEID('Property','Value',...) creates a new PMTEC_PLATEID or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PMTec_PlateID_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PMTec_PlateID_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PMTec_PlateID

% Last Modified by GUIDE v2.5 21-Sep-2014 22:35:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PMTec_PlateID_OpeningFcn, ...
                   'gui_OutputFcn',  @PMTec_PlateID_OutputFcn, ...
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


% --- Executes just before PMTec_PlateID is made visible.
function PMTec_PlateID_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PMTec_PlateID (see VARARGIN)

% Choose default command line output for PMTec_PlateID
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

handles.view1_ini=str2num(get(handles.view1,'String'));
handles.view2_ini=str2num(get(handles.view2,'String'));
handles.view3_ini=str2num(get(handles.view3,'String'));

mapview=[handles.view1_ini,...
         handles.view2_ini,...
         handles.view3_ini];
     
% 1) setup map projection
axes(handles.axes1); axesm eqdcylin % mollweid;eqdcylin;mercator
framem on; axis off; tightmap; gridm on
handles.ProjT='eqdcylin';

% load coastline
coast=load('coast');
handles.hCoast=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none');

set(handles.view1,'string',num2str(0));
set(handles.view2,'string',num2str(0));
set(handles.view3,'string',num2str(0));

% 2) set up inital paramters
handles.hPlate=NaN;
set(handles.DESCR,'string','Plate Name');
set(handles.PlateID,'string',num2str(NaN));
set(handles.RecID,'string',num2str(001));
set(handles.FROMAGE,'string',num2str(550));
set(handles.TOAGE,'string',num2str(0));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PMTec_PlateID wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PMTec_PlateID_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in OpenGeometry.
function OpenGeometry_Callback(hObject, eventdata, handles)
% hObject    handle to OpenGeometry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% FNPM=Filename of PM data; FPPM=File Path of PM data
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
    % FFPNPM=Full File Path Name of PM data
    FFPNPM = strcat(PathName,FileName);
    % Data of PM data
    if FileName(length(FileName)-4:length(FileName))=='.xlsx'
        handles.LoadCTdata=xlsread(FFPNPM);
    elseif FileName(length(FileName)-3:length(FileName))=='.xls'
        handles.LoadCTdata=xlsread(FFPNPM);
    elseif FileName(length(FileName)-3:length(FileName))=='.txt'
        handles.LoadCTdata=importdata(FFPNPM);
    elseif FileName(length(FileName)-3:length(FileName))=='.shp'
        LoadINdata2=shaperead(FFPNPM);
        LoadINdata1X=[]; LoadINdata1Y=[];
        for i=1:length(LoadINdata2)
            LoadINdata1X=[LoadINdata1X,LoadINdata2(i).X];
            LoadINdata1Y=[LoadINdata1Y,LoadINdata2(i).Y];
        end
        handles.LoadCTdata=[LoadINdata1X',LoadINdata1Y'];
    else
        handles.LoadCTdata=importdata(FFPNPM);
    end
    
    disp('Plate contour file loaded.');
    
    % plot the contour
    handles.hPlate=geoshow(handles.LoadCTdata(:,2),handles.LoadCTdata(:,1),...
        'DisplayType','line','linestyle','--','color',[0 .5 0],'LineWidth',1.5);
    
elseif nbfiles==0
%     disp('Please select a file!')
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ClearGeometry.
function ClearGeometry_Callback(hObject, eventdata, handles)
% hObject    handle to ClearGeometry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% if isfield(handles,'hPlate')==0
%     disp('Please load plate contour first!');
% elseif isfield(handles,'hPlate')==1
    delete(handles.hPlate);
    set(handles.DESCR,'string','IDPlate');
    set(handles.PlateID,'string',num2str(NaN));
    set(handles.RecID,'string',num2str(001));
    set(handles.FROMAGE,'string',num2str(550));
    set(handles.TOAGE,'string',num2str(0));
    
    disp('Contour cleared.');
% end
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



function DESCR_Callback(hObject, eventdata, handles)
% hObject    handle to DESCR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DESCR as text
%        str2double(get(hObject,'String')) returns contents of DESCR as a double


% --- Executes during object creation, after setting all properties.
function DESCR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DESCR (see GCBO)
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


% --- Executes on button press in MakeShape.
function MakeShape_Callback(hObject, eventdata, handles)
% hObject    handle to MakeShape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,{'LoadCTdata','PlateType'})==0
    disp('Please load plate contour first!');
elseif isfield(handles,{'LoadCTdata','PlateType'})==1
    
    % Block contour
    lonBlock=handles.LoadCTdata(:,1);
    latBlock=handles.LoadCTdata(:,2);
    
    % The first field by convention is Geometry (dimensionality).
    % As Geometry is the same for all elements, assign it with deal:
    % deal copies the single input to all the requested outputs
    [contour.Geometry] = deal(handles.PlateType);
    
    % construct the BoundingBox
    [contour.BoundingBox] = [min(lonBlock) min(latBlock);
        max(lonBlock) max(latBlock)];
    
    % assign coordinate vector
    [contour.X] = lonBlock;
    [contour.Y] = latBlock;
    
    % assign shapefile attributes:
    [contour.DESCR] = get(handles.DESCR,'String');
    [contour.PLATEID1] = str2num(get(handles.PlateID,'String'));
    [contour.FROMAGE] = str2num(get(handles.FROMAGE,'String'));
    [contour.TOAGE] = str2num(get(handles.TOAGE,'String'));
    [contour.TYPE] = 'CO';
    [contour.RecID] = str2num(get(handles.RecID,'String'));
    
    % write shapefile
    [FileName,PathName]=uiputfile('*.shp','Save Plate Contour As');
    if FileName ~= 0
        nbfiles = 1;
    else
        nbfiles = 0;
    end
    
    if nbfiles==1
        FullName=[PathName,FileName];
        shapewrite(contour, FullName);
        disp('Shape file made and saved');
    elseif nbfiles==0
        %     disp('Please name the shape file!');
    end
end
% Update handles structure
guidata(hObject, handles);


function PlateID_Callback(hObject, eventdata, handles)
% hObject    handle to PlateID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PlateID as text
%        str2double(get(hObject,'String')) returns contents of PlateID as a double


% --- Executes during object creation, after setting all properties.
function PlateID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlateID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FROMAGE_Callback(hObject, eventdata, handles)
% hObject    handle to FROMAGE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FROMAGE as text
%        str2double(get(hObject,'String')) returns contents of FROMAGE as a double


% --- Executes during object creation, after setting all properties.
function FROMAGE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FROMAGE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on selection change in type.
function type_Callback(hObject, eventdata, handles)
% hObject    handle to type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns type contents as cell array
%        contents{get(hObject,'Value')} returns selected item from type
type=get(hObject,'Value');

switch type
    case 1
        
    case 2
        handles.PlateType='Polygon';
    case 3
        handles.PlateType='Points';
    otherwise
        
end
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function type_CreateFcn(hObject, eventdata, handles)
% hObject    handle to type (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function RecID_Callback(hObject, eventdata, handles)
% hObject    handle to RecID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RecID as text
%        str2double(get(hObject,'String')) returns contents of RecID as a double


% --- Executes during object creation, after setting all properties.
function RecID_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RecID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function TOAGE_Callback(hObject, eventdata, handles)
% hObject    handle to TOAGE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TOAGE as text
%        str2double(get(hObject,'String')) returns contents of TOAGE as a double


% --- Executes during object creation, after setting all properties.
function TOAGE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TOAGE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



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


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
axes(handles.axes1); axis off;
ProjTypes=get(hObject,'Value');
switch ProjTypes
    case 1
        % initiate map: mollweid, ortho
        cla(handles.axes1); axesm eqdcylin; handles.ProjT='eqdcylin';
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
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
