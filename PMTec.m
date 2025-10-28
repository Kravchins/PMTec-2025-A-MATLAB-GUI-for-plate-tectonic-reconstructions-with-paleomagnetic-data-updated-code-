function varargout = PMTec(varargin)
% PMTEC MATLAB code for PMTec.fig
%      PMTEC, by itself, creates a new PMTEC or raises the existing
%      singleton*.
%
%      H = PMTEC returns the handle to a new PMTEC or the handle to
%      the existing singleton*.
%
%      PMTEC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PMTEC.M with the given input arguments.
%
%      PMTEC('Property','Value',...) creates a new PMTEC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PMTec_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PMTec_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to reset (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PMTec

% Last Modified by GUIDE v2.5 25-Jul-2015 00:21:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PMTec_OpeningFcn, ...
                   'gui_OutputFcn',  @PMTec_OutputFcn, ...
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


% --- Executes just before PMTec is made visible.
function PMTec_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PMTec (see VARARGIN)

% Choose default command line output for PMTec
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

% initiate map axes and all the map topo2 data
axes(handles.axes1); 
axesm mercator % mollweid;
% axesm('mercator','MeridianLabel','on','ParallelLabel','on');
framem on; axis off; tightmap; gridm on

% % 2) load coastline
% coast=load('coast');
% handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
%     'FaceColor',[.83 .82 .78],'edgecolor','none');
% handles.hCoast2=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
%     'FaceColor','none','linewidth',1);
% set(handles.hCoast1,'Visible','off')
% set(handles.hCoast2,'Visible','off')

% 2) load coastline (R2024b-compatible)
try
    % Preferred modern dataset
    S = load('coastlines.mat');            % returns coastlat, coastlon
    lat = S.coastlat;
    lon = S.coastlon;

    handles.hCoast1 = geoshow(lat, lon, 'DisplayType','polygon', ...
        'FaceColor',[.83 .82 .78], 'EdgeColor','none');
    handles.hCoast2 = geoshow(lat, lon, 'DisplayType','polygon', ...
        'FaceColor','none', 'LineWidth',1);

catch
    % Fallback: use shapefile shipped with Mapping Toolbox
    land = shaperead('landareas', 'UseGeoCoords', true);  % lat/lon in struct
    handles.hCoast1 = geoshow(land, 'FaceColor',[.83 .82 .78], 'EdgeColor','none');
    handles.hCoast2 = geoshow(land, 'FaceColor','none', 'LineWidth',1);
end

set(handles.hCoast1,'Visible','off');
set(handles.hCoast2,'Visible','off');


% load StructData.mat;
if ispc==1
    PMTecSysPath=[pwd '\PMTecSys\'];
else
    PMTecSysPath=[pwd '/PMTecSys/'];
end
handles.StructDataPath=[PMTecSysPath 'StructData150723.mat'];
load(handles.StructDataPath);

% 3) plate boundary
PlateB1=StructData(3).f1;
PlateB2=StructData(3).f2;
handles.hPlateBD1=geoshow(StructData(3).f1(:,2),StructData(3).f1(:,1),...
    'DisplayType','line','Color',[.68 .92 1],'LineWidth',3);
handles.hPlateBD2=geoshow(StructData(3).f2(:,2),StructData(3).f2(:,1),...
    'DisplayType','line','Color',[.68 .92 1],'LineWidth',3);
set(handles.hPlateBD1,'Visible','off')
set(handles.hPlateBD2,'Visible','off')

% 4) ancient subduction zones
handles.SBZ=geoshow(StructData(3).f6(:,2),StructData(3).f6(:,1),...
    'Color',[0 .5 0],'LineWidth',1.5);
set(handles.SBZ,'Visible','off')

% TOPO2
refvec = [7.5, 90, -180];
Z = StructData(3).f7;
R = refvec2georefcells(refvec, size(Z));
handles.TOPO2 = meshm(Z, R);  hold on
set(handles.TOPO2,'Visible','off');
        
% 5) Initially defined parameters:
handles.viewp1_ini=str2num(get(handles.view1,'String'));
handles.viewp2_ini=str2num(get(handles.view2,'String'));
handles.viewp3_ini=str2num(get(handles.view3,'String'));
s = ['viewpoint: (' angl2str(handles.viewp1_ini,'ns') ...
    ',' angl2str(handles.viewp2_ini,'ew')...
    ',' angl2str(handles.viewp3_ini),'D )'];
title(s)

handles.ProjT='mercator';
handles.polyg=0;
set(handles.BottomDep,'string','2733');

% 6) define the grid for lat and lon
set(handles.Slice, 'UserData', 0);

axes(handles.axes2);
handles.PMTecICON=[PMTecSysPath 'logoUA.png'];
imshow(handles.PMTecICON);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PMTec wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PMTec_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%------------------------------------------------------------------------- 
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

%------------------------------------------------------------------------- 



% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1);
% initiate map axes and all the map topo2 data
axes(handles.axes1); axesm mercator % mollweid;
framem on; axis off; tightmap; gridm on

% 2) load coastline
handles = loadCoastlinesIntoAxes(handles);

load(handles.StructDataPath);

% 3) plate boundary
PlateB1=StructData(3).f1;
PlateB2=StructData(3).f2;
handles.hPlateBD1=geoshow(StructData(3).f1(:,2),StructData(3).f1(:,1),...
    'DisplayType','line','Color',[.68 .92 1],'LineWidth',3);
handles.hPlateBD2=geoshow(StructData(3).f2(:,2),StructData(3).f2(:,1),...
    'DisplayType','line','Color',[.68 .92 1],'LineWidth',3);
set(handles.hPlateBD1,'Visible','off')
set(handles.hPlateBD2,'Visible','off')

% 4) ancient subduction zones
handles.SBZ=geoshow(StructData(3).f6(:,2),StructData(3).f6(:,1),...
    'Color',[0 .5 0],'LineWidth',1.5);
set(handles.SBZ,'Visible','off')

% 5) Initially defined parameters:
handles.viewp1_ini=str2num(get(handles.view1,'String'));
handles.viewp2_ini=str2num(get(handles.view2,'String'));
handles.viewp3_ini=str2num(get(handles.view3,'String'));
s = ['viewpoint: (' angl2str(handles.viewp1_ini,'ns') ...
    ',' angl2str(handles.viewp2_ini,'ew')...
    ',' angl2str(handles.viewp3_ini),'D )'];
title(s)

handles.ProjT='mercator';
handles.polyg=0;
% set(handles.BottomDep,'string','2733');

% TOPO2
refvec = [7.5, 90, -180];
Z = StructData(3).f7;
R = refvec2georefcells(refvec, size(Z));
handles.TOPO2 = meshm(Z, R);  hold on
set(handles.TOPO2,'Visible','off');

disp('Reset all.');
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white topo2 on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot.
function plot_Callback(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function plot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes during object deletion, before destroying properties.
function plot_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to plot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%--------------------------------------------------------------------------

function view1_Callback(hObject, eventdata, handles)
% hObject    handle to view1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.view1=str2double(get(handles.view1,'String'));


% Hints: get(hObject,'String') returns contents of view1 as text
%        str2double(get(hObject,'String')) returns contents of view1 as a double
% Update handles structure

cla(handles.axes1);

% 2) Initially defined parameters:
mapview=[str2num(get(handles.view1,'String')),...
         str2num(get(handles.view2,'String')),...
         str2num(get(handles.view3,'String'))];
s = ['viewpoint: (' angl2str(mapview(1),'ns') ...
    ',' angl2str(mapview(2),'ew')...
    ',' angl2str(mapview(3)),'D )'];
title(s)

% 3) initiate map axes and all the map topo2 data
axes(handles.axes1); axis off, axesm(handles.ProjT) % mollweid;ortho;eqdcylin
setm(gca,'Origin', mapview), framem on; tightmap; 

% 4) load coastline
handles = loadCoastlinesIntoAxes(handles);

load(handles.StructDataPath);

% ancient subduction zones
handles.SBZ=geoshow(StructData(3).f6(:,2),StructData(3).f6(:,1),...
    'Color',[0 .5 0],'LineWidth',1.5);
set(handles.SBZ,'Visible','off')

% TOPO2
refvec = [7.5, 90, -180];
Z = StructData(3).f7;
R = refvec2georefcells(refvec, size(Z));
handles.TOPO2 = meshm(Z, R);  hold on
set(handles.TOPO2,'Visible','off');

% 5) plate boundary
PlateB1=StructData(3).f1;
PlateB2=StructData(3).f2;
handles.hPlateBD1=geoshow(StructData(3).f1(:,2),StructData(3).f1(:,1),...
    'DisplayType','line','Color',[.68 .92 1],'LineWidth',3);
handles.hPlateBD2=geoshow(StructData(3).f2(:,2),StructData(3).f2(:,1),...
    'DisplayType','line','Color',[.68 .92 1],'LineWidth',3);
set(handles.hPlateBD1,'Visible','off')
set(handles.hPlateBD2,'Visible','off')

 guidata(hObject, handles);
 

% --- Executes during object creation, after setting all properties.
function view1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to view1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white topo2 on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function view2_Callback(hObject, eventdata, handles)
% hObject    handle to view2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.view2=str2double(get(handles.view2,'String'));

% Hints: get(hObject,'String') returns contents of view2 as text
%        str2double(get(hObject,'String')) returns contents of view2 as a double
% Update handles structure

cla(handles.axes1);

% 2) Initially defined parameters:
mapview=[str2num(get(handles.view1,'String')),...
         str2num(get(handles.view2,'String')),...
         str2num(get(handles.view3,'String'))];
s = ['viewpoint: (' angl2str(mapview(1),'ns') ...
    ',' angl2str(mapview(2),'ew')...
    ',' angl2str(mapview(3)),'D )'];
title(s)

% 3) initiate map axes and all the map topo2 data
axes(handles.axes1); axis off, axesm(handles.ProjT) % mollweid;ortho;eqdcylin
setm(gca,'Origin', mapview), framem on; tightmap; 

% 4) load coastline
handles = loadCoastlinesIntoAxes(handles);

load(handles.StructDataPath);

% ancient subduction zones
handles.SBZ=geoshow(StructData(3).f6(:,2),StructData(3).f6(:,1),...
    'Color',[0 .5 0],'LineWidth',1.5);
set(handles.SBZ,'Visible','off')

% TOPO2
refvec = [7.5, 90, -180];
Z = StructData(3).f7;
R = refvec2georefcells(refvec, size(Z));
handles.TOPO2 = meshm(Z, R);  hold on
set(handles.TOPO2,'Visible','off');

% 5) plate boundary
PlateB1=StructData(3).f1;
PlateB2=StructData(3).f2;
handles.hPlateBD1=geoshow(StructData(3).f1(:,2),StructData(3).f1(:,1),...
    'DisplayType','line','Color',[.68 .92 1],'LineWidth',3);
handles.hPlateBD2=geoshow(StructData(3).f2(:,2),StructData(3).f2(:,1),...
    'DisplayType','line','Color',[.68 .92 1],'LineWidth',3);
set(handles.hPlateBD1,'Visible','off')
set(handles.hPlateBD2,'Visible','off')

guidata(hObject, handles);
 
 
% --- Executes during object creation, after setting all properties.
function view2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to view2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white topo2 on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function view3_Callback(hObject, eventdata, handles)
% hObject    handle to view3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.view3=str2double(get(handles.view3,'String'));

% Hints: get(hObject,'String') returns contents of view3 as text
%        str2double(get(hObject,'String')) returns contents of view3 as a double
% Update handles structure


cla(handles.axes1);

% 2) Initially defined parameters:
mapview=[str2num(get(handles.view1,'String')),...
         str2num(get(handles.view2,'String')),...
         str2num(get(handles.view3,'String'))];
s = ['viewpoint: (' angl2str(mapview(1),'ns') ...
    ',' angl2str(mapview(2),'ew')...
    ',' angl2str(mapview(3)),'D )'];
title(s)

% 3) initiate map axes and all the map topo2 data
axes(handles.axes1); axis off, axesm(handles.ProjT) % mollweid;ortho;eqdcylin
setm(gca,'Origin', mapview), framem on; tightmap; 

% 4) load coastline
handles = loadCoastlinesIntoAxes(handles);

load(handles.StructDataPath);

% ancient subduction zones
handles.SBZ=geoshow(StructData(3).f6(:,2),StructData(3).f6(:,1),...
    'Color',[0 .5 0],'LineWidth',1.5);
set(handles.SBZ,'Visible','off')

% TOPO2
refvec = [7.5, 90, -180];                         % keep your existing setting
Z      = StructData(3).f7;
R      = refvec2georefcells(refvec, size(Z));
handles.TOPO2 = meshm(Z, R);  hold on
set(handles.TOPO2,'Visible','off');

% 5) plate boundary
PlateB1=StructData(3).f1;
PlateB2=StructData(3).f2;
handles.hPlateBD1=geoshow(StructData(3).f1(:,2),StructData(3).f1(:,1),...
    'DisplayType','line','Color',[.68 .92 1],'LineWidth',3);
handles.hPlateBD2=geoshow(StructData(3).f2(:,2),StructData(3).f2(:,1),...
    'DisplayType','line','Color',[.68 .92 1],'LineWidth',3);
set(handles.hPlateBD1,'Visible','off')
set(handles.hPlateBD2,'Visible','off')

guidata(hObject, handles);
 
% --- Executes during object creation, after setting all properties.
function view3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to view3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white topo2 on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Backgroud_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Backgroud (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in ProjType.
function ProjType_Callback(hObject, eventdata, handles)
% hObject    handle to ProjType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ProjType contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ProjType
axes(handles.axes1);
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
        
end

disp('Projection map selected.');

% 1) set up mapview [lat,lon,tilt]
% mapview=[0,0,0];
handles.viewp1_fin=handles.viewp1_ini;
handles.viewp2_fin=handles.viewp2_ini;
handles.viewp3_fin=handles.viewp3_ini;

handles.viewp1_med=str2num(get(handles.view1,'String'));
handles.viewp2_med=str2num(get(handles.view2,'String'));
handles.viewp3_med=str2num(get(handles.view3,'String'));

% determine the change in the viewpoint
delta1=handles.viewp1_med-handles.viewp1_ini;
delta2=handles.viewp2_med-handles.viewp2_ini;
delta3=handles.viewp3_med-handles.viewp3_ini;

mapview=[handles.viewp1_ini+delta1,...
         handles.viewp2_ini+delta2,...
         handles.viewp3_ini+delta3];
     
setm(gca,'Origin', mapview)%, 'MLineLimit', [75 -75])%,...
% 'MLineException',[0 90 180 270])
framem on; axis off; tightmap; % gridm on;

s = ['viewpoint: (' angl2str(mapview(1),'ns') ...
    ',' angl2str(mapview(2),'ew') ',' angl2str(mapview(3)),'D )'];
title(s)

% 2) load coastline
handles = loadCoastlinesIntoAxes(handles);

load(handles.StructDataPath);

% 3) plate boundary
PlateB1=StructData(3).f1;
PlateB2=StructData(3).f2;
handles.hPlateBD1=geoshow(StructData(3).f1(:,2),StructData(3).f1(:,1),...
    'DisplayType','line','Color',[.68 .92 1],'LineWidth',3);
handles.hPlateBD2=geoshow(StructData(3).f2(:,2),StructData(3).f2(:,1),...
    'DisplayType','line','Color',[.68 .92 1],'LineWidth',3);
set(handles.hPlateBD1,'Visible','off')
set(handles.hPlateBD2,'Visible','off')

% 4) ancient subduction zones
handles.SBZ=geoshow(StructData(3).f6(:,2),StructData(3).f6(:,1),...
    'Color',[0 .5 0],'LineWidth',1.5);
set(handles.SBZ,'Visible','off')
set(handles.BottomDep,'string','2733');

% TOPO2
refvec = [7.5, 90, -180];
Z = StructData(3).f7;
R = refvec2georefcells(refvec, size(Z));
handles.TOPO2 = meshm(Z, R);  hold on
set(handles.TOPO2,'Visible','off');

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function ProjType_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ProjType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white topo2 on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Coastline.
function Coastline_Callback(hObject, eventdata, handles)
% hObject    handle to Coastline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Coastline contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Coastline
Coastline=get(hObject,'Value');

switch Coastline
    case 1
        set(handles.hCoast1,'Visible','off'),
        set(handles.hCoast2,'Visible','off'),disp('Coastline cleared.');
    case 2
        set(handles.hCoast1,'Visible','off'),
        set(handles.hCoast2,'Visible','off'),
        set(handles.hCoast1,'Visible','on'),disp('Coastline loaded.');
        uistack(handles.hCoast1,'top');
    case 3
        set(handles.hCoast1,'Visible','off'),
        set(handles.hCoast2,'Visible','off'),        
        set(handles.hCoast2,'Visible','on'),disp('Coastline loaded.');
        uistack(handles.hCoast2,'top');
    otherwise
        
end


% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function Coastline_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Coastline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white topo2 on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in Gridlines.
function Gridlines_Callback(hObject, eventdata, handles)
% hObject    handle to Gridlines (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
button_state = get(handles.Gridlines,'Value');
if button_state == get(handles.Gridlines,'Max')
    axes(handles.axes1),gridm on;
elseif button_state == get(handles.Gridlines,'Min')  
    axes(handles.axes1),gridm off;
end
% Hint: get(hObject,'Value') returns toggle state of Gridlines
% Update handles structure
guidata(hObject, handles);



% --- Executes on selection change in PlateBound.
function PlateBound_Callback(hObject, eventdata, handles)
% hObject    handle to PlateBound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PlateBound contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PlateBound
PlateBound=get(hObject,'Value');


switch PlateBound
    case 1
        set(handles.hPlateBD1,'Visible','off'),
        set(handles.hPlateBD2,'Visible','off'),
        disp('Plate boundaries cleared.');
    case 2
        set(handles.hPlateBD1,'Visible','off'),
        set(handles.hPlateBD2,'Visible','off'),
        set(handles.hPlateBD1,'Visible','on'),
        disp('Plate boundaries loaded.');
    case 3
        set(handles.hPlateBD1,'Visible','off'),
        set(handles.hPlateBD2,'Visible','off'),        
        set(handles.hPlateBD2,'Visible','on'),
        disp('Plate boundaries loaded.');

    otherwise
        
end

guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function PlateBound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PlateBound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white topo2 on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Slice.
function Slice_Callback(hObject, eventdata, handles)
% hObject    handle to Slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Slice

counter=get(hObject, 'UserData') + 1;
set(hObject, 'UserData', counter);

% PART1: interactively select two points along a rhumb line
load(handles.StructDataPath);

axes(handles.axes1);
disp('Calculating TOMO slice...');
[latIP, lonIP]=inputm(2);
az=azimuth('rh',latIP(1),lonIP(1),latIP(2),lonIP(2));
% geoshow(latIP,lonIP,'Color','b','LineWidth',2); % incorrect
handles.TOMOlineTxt=textm(latIP,lonIP+5,['A1';'A2'],'Color','b','FontSize',12);

% Find the (mid-)points of the GC track
[latAx,lonAx]=track2('rh',latIP(1),lonIP(1),latIP(2),lonIP(2),[],'degree',7);
GCtrack=[lonAx,latAx];
handles.TOMOline=geoshow(latAx,lonAx,'Color','k','LineWidth',1);

handles.TOMOTicks=geoshow(latAx,lonAx,'DisplayType','point',...
     'Marker','o','MarkerSize',7,'MarkerEdgeColor','k','LineWidth',1);

%-------------------------------------------------------------------------
% PART2: load the model
dV=StructData(3).f3;
figure(counter)
bottom=StructData(3).f4(end);

% CROSS SECTION
lat1 = latIP(1);  lat2 = latIP(2);   
lon1 = lonIP(1);  lon2 = lonIP(2);   

% dep = 1700;
dep=str2num(get(handles.BottomDep,'String'));

LON = unique(dV(:,1))';
LAT = unique(dV(:,2))';
R = 6371-StructData(3).f4;

[lon lat r]=meshgrid(LON,LAT,R);

map = reshape(dV(:,3:end),[],1);
map = reshape(map,[length(LAT),length(LON),length(R)]);

NX = 500;   %Number of steps in interpolation

lats=linspace(lat1,lat2,NX);
lons=linspace(lon1,lon2,NX);
deps=linspace(6371,6371-dep,NX);

[xd yd]=meshgrid(lons,lats);
yd=yd';
zd = deps'*ones(1,NX);

slc=interp3(lon,lat,r,map,xd,yd,zd);
surf(xd,yd,zd,slc,'Linestyle','none');hold on

if az<90
   view([az,0])
elseif az==90
    view([0,0])
else
view([az+180,0])
end
depthF=6371-[200:200:floor(dep/200)*200]';

text([lonAx(1) lonAx(end)],[latAx(1) latAx(end)],6500*ones(1,2),...
    ['A1';'A2'],'Color','b','FontSize',12);
text(lonAx(4),latAx(4),6271-dep,[num2str(dep) ' km'],'Color','b','FontSize',12);
% tick labels
% text(lonAx(1)*ones(1,length(depthF))-8,latAx(1)*ones(1,length(depthF)),...
%     depthF,num2str([200:200:floor(dep/200)*200]'),'Color','k','FontSize',10);
% text(lonAx(end)*ones(1,length(depthF))+5,latAx(end)*ones(1,length(depthF)),...
%     depthF,num2str([200:200:floor(dep/200)*200]'),'Color','k','FontSize',10);

plot3(lonAx,latAx,(6371-dep)*ones(1,7),'k-');
plot3(lonAx,latAx,6371*ones(1,7),'k-');
scatter3(lonAx,latAx,6371*ones(1,7),'MarkerEdgeColor','k'); % RF
plot3(lonAx(1)*ones(1,2),latAx(1)*ones(1,2),[6371,6371-dep],'k-');
scatter3(lonAx(1)*ones(1,length(depthF)),latAx(1)*ones(1,length(depthF)),...
    depthF,'k+');
plot3(lonAx(end)*ones(1,2),latAx(end)*ones(1,2),[6371,6371-dep],'k-');
scatter3(lonAx(end)*ones(1,length(depthF)),latAx(end)*ones(1,length(depthF)),...
    depthF,'k+');

htz1=plot3(lonAx,latAx,(6371-410)*ones(1,7),'k--');
htz2=plot3(lonAx,latAx,(6371-660)*ones(1,7),'k--');
uistack(htz1,'top'); uistack(htz2,'top');

grid off;axis off

% colormap setup
dvmax=.8;
dvori=[-dvmax:0.1:dvmax]';
dvscale=linspace(-dvmax,dvmax,64)';
cmap=NaN(length(dvscale),3);
cmap(:,1) = interp1(dvori,StructData(5).f3(:,1),dvscale);
cmap(:,2) = interp1(dvori,StructData(5).f3(:,2),dvscale);
cmap(:,3) = interp1(dvori,StructData(5).f3(:,3),dvscale);
% colormap(flipud(cmap));
colormap(cmap);
caxis([-dvmax,dvmax])
% contourcbar('Location','eastoutside')

guidata(hObject, handles);

%--------------------------------------------------------------------------
% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObjectLG, eventdataLG, handlesLG)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LoadPMData.
function LoadPMData_Callback(hObject, eventdata, handles)
% hObject    handle to LoadPMData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% FNPM=Filename of PM data; FPPM=File Path of PM data
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
    %FFPNPM=Full File Path Name of PM data
    FFPNPM = strcat(PathName,FileName);
    % Data of PM data
    if FileName(length(FileName)-4:length(FileName))=='.xlsx'
        LoadPMdata=xlsread(FFPNPM);
    elseif FileName(length(FileName)-3:length(FileName))=='.xls'
        LoadPMdata=xlsread(FFPNPM);
    else
        LoadPMdata=importdata(FFPNPM);
    end
    
    % pass the data to the handle of push button: PMdata
    handles.LoadPMdata=LoadPMdata;
    
    axes(handles.axes1);
    % 1) plot the PM data
    handles.hPMdata=geoshow(LoadPMdata(:,3),LoadPMdata(:,2),'DisplayType',...
        'point','Marker','o','MarkerSize',8,'MarkerFaceColor',[1 .6 .78],...
        'MarkerEdgeColor','k','LineWidth',2);
    set(handles.hPMdata,'Visible','off')
    
    % 2) A95 for the paleopoles
    PMGstructA95=[NaN,NaN];
    for i = 1:length(LoadPMdata(:,2))
        [IncSC,DecSC]=scircle1(LoadPMdata(i,3),LoadPMdata(i,2),LoadPMdata(i,4));
        PMGstructA95=[PMGstructA95;[IncSC,DecSC];[NaN,NaN]];
    end
    handles.hPMdataA95=geoshow(PMGstructA95(:,1),PMGstructA95(:,2),...
        'Color',[1 .6 .78],'LineWidth',1);
    set(handles.hPMdataA95,'Visible','off')
    
    % 3) plot the PM data
    handles.hConData=geoshow(LoadPMdata(:,3),LoadPMdata(:,2),'Color',...
        [1 .6 .78],'LineWidth',1);
    set(handles.hConData,'Visible','off')
    
    % 4) Add data label for paleopoles
    indP=[1:1:length(LoadPMdata(:,2))]';
    [GP,GNP]=grp2idx(indP);
    handles.hAnot=textm(LoadPMdata(:,3)+.3,LoadPMdata(:,2),...
        num2str(LoadPMdata(:,1)),'Color','r','FontSize',10);    
    set(handles.hAnot,'Visible','off')
    disp('PaleoMag data loaded.');
    
elseif nbfiles==0
%     disp('Please select a file!')
end

% Update handles structure
guidata(hObject,handles);



% --- Executes on button press in PMData.
function PMData_Callback(hObject, eventdata, handles)
% hObject    handle to PMData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PMData
axes(handles.axes1);

if isfield(handles,'hPMdata')==0
    disp('Please load paleomag data first!');
elseif isfield(handles,'hPMdata')==1
    if (get(handles.PMData,'Value') == get(handles.PMData,'Max'))
        set(handles.hPMdata,'Visible','on')
    elseif (get(handles.PMData,'Value') == get(handles.PMData,'Min'))
        set(handles.hPMdata,'Visible','off')
    end
end

% Update handles structure
guidata(hObject,handles);



% --- Executes on button press in A95.
function A95_Callback(hObject, eventdata, handles)
% hObject    handle to A95 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);

if isfield(handles,'hPMdataA95')==0
    disp('Please load paleomag data first!');
elseif isfield(handles,'hPMdataA95')==1
    if (get(handles.A95,'Value') == get(handles.A95,'Max'))
        set(handles.hPMdataA95,'Visible','on')
    elseif (get(handles.A95,'Value') == get(handles.A95,'Min'))
        set(handles.hPMdataA95,'Visible','off')
    end
end
% Update handles structure
guidata(hObject,handles);


% --- Executes on button press in ConnectData.
function ConnectData_Callback(hObject, eventdata, handles)
% hObject    handle to ConnectData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% GET DATA FROM PM data FILE
axes(handles.axes1);
if isfield(handles,'hConData')==0
    disp('Please load paleomag data first!');
elseif isfield(handles,'hConData')==1
    if (get(handles.ConnectData,'Value') == get(handles.ConnectData,'Max'))
        set(handles.hConData,'Visible','on');
    elseif (get(handles.ConnectData,'Value') == get(handles.ConnectData,'Min'))
        set(handles.hConData,'Visible','off') ;
    end
end
% Hint: get(hObject,'Value') returns toggle state of ConnectData
% Update handles structure
guidata(hObject,handles);


% --- Executes on button press in Anotation.
function Anotation_Callback(hObject, eventdata, handles)
% hObject    handle to Anotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);
if isfield(handles,'hAnot')==0
    disp('Please load paleomag data first!');
elseif isfield(handles,'hAnot')==1
    if (get(handles.Anotation,'Value') == get(handles.Anotation,'Max'))
        set(handles.hAnot,'Visible','on');
    elseif (get(handles.Anotation,'Value') == get(handles.Anotation,'Min'))
        set(handles.hAnot,'Visible','off') ;
    end
end
guidata(hObject,handles);


% --- Executes on button press in PMupdate.
function PMupdate_Callback(hObject, eventdata, handles)
% hObject    handle to PMupdate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% handles.PMGData.hPMData=hPMdata;
% hPMdata=handles.PMGData.hPMdata;

% if this button is selected
if (get(handles.PMData,'Value') == get(handles.PMData,'Max')) 
    set(handles.hPMData,'Visible','on')
else
    set(handles.hPMData,'Visible','off')
end

% Update handles structure
guidata(hObject,handles);


% --- Executes on button press in APWPCon.
function APWPCon_Callback(hObject, eventdata, handles)
% hObject    handle to APWPCon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PMTec_APWP
disp('PMTec_APWP initiated.');
% Hint: get(hObject,'Value') returns toggle state of APWPCon


% --- Executes on button press in CircFit.
function CircFit_Callback(hObject, eventdata, handles)
% hObject    handle to CircFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PMTec_Euler
disp('PMTec_Euler initiated.');
% Hint: get(hObject,'Value') returns toggle state of CircFit


% --- Executes on button press in Reconstruction.
function Reconstruction_Callback(hObject, eventdata, handles)
% hObject    handle to Reconstruction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PMTec_Reconstr
disp('PMTec_Reconstr initiated.');
% Hint: get(hObject,'Value') returns toggle state of Reconstruction


% --- Executes on button press in PlateID.
function PlateID_Callback(hObject, eventdata, handles)
% hObject    handle to PlateID (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PMTec_PlateID
disp('PMTec_PlateID initiated.');
% Hint: get(hObject,'Value') returns toggle state of PlateID



% --- Executes on button press in LoadStruct.
function LoadStruct_Callback(hObject, eventdata, handles)
% hObject    handle to LoadStruct (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in Output.
function Output_Callback(hObject, eventdata, handles)
% hObject    handle to Output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Output contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Output



% --- Executes on button press in BootResam.
function BootResam_Callback(hObject, eventdata, handles)
% hObject    handle to BootResam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PMTec_BootRes
disp('PMTec_BootRes initiated.');
% Hint: get(hObject,'Value') returns toggle state of BootResam


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% --------------------------------------------------------------------
function uitoggletool2_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1);



% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in FisherMean.
function FisherMean_Callback(hObject, eventdata, handles)
% hObject    handle to FisherMean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PMTec_Fish
disp('PMTec_Fish initiated.');
% Hint: get(hObject,'Value') returns toggle state of FisherMean


% --- Executes on button press in AniMaker.
function AniMaker_Callback(hObject, eventdata, handles)
% hObject    handle to AniMaker (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PMTec_AniMaker
disp('PMTec_AniMaker initiated.');


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
    [FileName,PathName]=uiputfile('*.pdf','Save Figure As');
    FullName=[PathName,FileName];
    printpdf(gcf, FullName);
    disp('Figure exported.');
elseif nbfiles==0
end
% close(gcf); %and close it
 guidata(hObject, handles);

% --- Executes on button press in Kinematics.
function Kinematics_Callback(hObject, eventdata, handles)
% hObject    handle to Kinematics (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PMTec_PtKin
disp('PMTec_PtKin initiated.');
% Hint: get(hObject,'Value') returns toggle state of Kinematics


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PMTec_cptcmap('GMT_globe', 'mapping', 'direct');

%% -------------------------------------------------------------------------

% --- Executes on button press in OpenGeometries.
function OpenGeometries_Callback(hObject, eventdata, handles)
% hObject    handle to OpenGeometries (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of OpenGeometries

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
    % FFPNPM
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
    handles.LoadINdata=LoadINdata;
    disp('Geometric data file loaded.');
    
elseif nbfiles==0
%     disp('Please select a file!')
end

guidata(hObject,handles);


% --- Executes on button press in PlotPoints.
function PlotPoints_Callback(hObject, eventdata, handles)
% hObject    handle to PlotPoints (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PlotPoints
if isfield(handles,'LoadINdata')==0
    disp('Please load geometry data first!');
elseif isfield(handles,'LoadINdata')==1
    LoadINdata=handles.LoadINdata;
    axes(handles.axes1);
    handles.pts=geoshow(LoadINdata(:,2),LoadINdata(:,1),'DisplayType','point',...
        'Marker','.','MarkerEdgeColor','m');
    uistack(handles.pts,'top');
    
    disp('Geometric data plotted as points.');
end
guidata(hObject,handles);


% --- Executes on button press in PlotPolygons.
function PlotPolygons_Callback(hObject, eventdata, handles)
% hObject    handle to PlotPolygons (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PlotPolygons
if isfield(handles,'LoadINdata')==0
    disp('Please load geometry data first!');
elseif isfield(handles,'LoadINdata')==1
    LoadINdata=handles.LoadINdata;
    axes(handles.axes1);
    handles.polyg=geoshow(LoadINdata(:,2),LoadINdata(:,1),...
        'Color','m','LineWidth',1.5);
    uistack(handles.polyg,'top');
    
    disp('Geometric data plotted as polygons.');
end
guidata(hObject,handles);


% --- Executes on button press in PlotInputData.
function PlotInputData_Callback(hObject, eventdata, handles)
% hObject    handle to PlotInputData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,'polyg')==0
    disp('Please load geometry data first!');
elseif isfield(handles,'pts')==0  
    disp('Please load geometry data first!');
elseif isfield(handles,{'polyg','pts'})==1
    set(handles.polyg,'Visible','off');
    set(handles.pts,'Visible','off');
    disp('Geometric data cleared.');
end
guidata(hObject,handles);


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7
load(handles.StructDataPath);

Depth=get(hObject,'Value');
switch Depth
    case 1

    case 2
        layer=1; 
    case 3
        layer=2; 
    case 4
        layer=3; 
    case 5
        layer=4; 
    case 6
        layer=5; 
    case 7
        layer=6; 
    case 8
        layer=7; 
    case 9
        layer=8; 
    case 10
        layer=9; 
    case 11
        layer=10; 
    case 12
        layer=11; 
    case 13
        layer=12;  
    case 14
        layer=13; 
    case 15
        layer=14; 
    case 16
        layer=15; 
    case 17
        layer=16; 
    case 18
        layer=17; 
    case 19
        layer=18; 
    case 20
        layer=19; 
    case 21
        layer=20; 
    case 22
        layer=21; 
    case 23
        layer=22; 
    case 24
        layer=23; 
    case 25
        layer=24; 
    case 26
        layer=25; 
    case 27
        layer=26; 
    case 28
        layer=27; 
    case 29
        layer=28; 
    case 30
        layer=29; 
        
    otherwise
        
end

lonM=StructData(3).f3(:,1); latM=StructData(3).f3(:,2); 
velocity=StructData(3).f3(:,layer+2);
% 1) plot TOMO at different depths
gridxy=0.5;
[xi1,yi1]=meshgrid((min(lonM)):gridxy:(max(lonM)),...
                 (min(latM)):gridxy:(max(latM))); 
             
% points defined by x and y
% gridding method: 'linear', 'natural', 'nearest', 'v4', 'cubic'
method='linear';
zi1 = griddata(lonM,latM,velocity,xi1,yi1,method);
Vmax=max(max(zi1)); Vmin=min(min(zi1));

% Grid type: surface, mesh, texturemap, contour
axes(handles.axes1);
handles.hptomo=geoshow(yi1,xi1,zi1, 'DisplayType','texturemap');
% uistack(handles.hptomo,'bottom');

% colormap setup
dvmax=.8;
dvori=[-dvmax:0.1:dvmax]';
dvscale=linspace(-dvmax,dvmax,64)';
cmap=NaN(length(dvscale),3);
cmap(:,1) = interp1(dvori,StructData(5).f3(:,1),dvscale);
cmap(:,2) = interp1(dvori,StructData(5).f3(:,2),dvscale);
cmap(:,3) = interp1(dvori,StructData(5).f3(:,3),dvscale);
% colormap(flipud(cmap));
colormap(cmap);
caxis([-dvmax,dvmax])

mapview=[str2num(get(handles.view1,'String')),...
         str2num(get(handles.view2,'String')),...
         str2num(get(handles.view3,'String'))];
title(['viewpoint: (' angl2str(mapview(1),'ns') ...
    ',' angl2str(mapview(2),'ew') ',' angl2str(mapview(3)),'D)  '...
    StructData(layer+2).f5 '  (GAP-P1)']);
% contourcbar('Location','eastoutside')
guidata(hObject, handles);
 

% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white topo2 on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton18.
function togglebutton18_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton18
if isfield(handles,{'TOMOline'})==0
    disp('Please make a slice first!');
elseif isfield(handles,{'TOMOline'})==1
    set(handles.TOMOline,'Visible','off');
    set(handles.TOMOlineTxt,'Visible','off');
    set(handles.TOMOTicks,'Visible','off');
end
guidata(hObject, handles);


% --- Executes on selection change in SBZMeer10.
function SBZMeer10_Callback(hObject, eventdata, handles)
% hObject    handle to SBZMeer10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns SBZMeer10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SBZMeer10
load(handles.StructDataPath);

AgeDepth=get(hObject,'Value');
switch AgeDepth
    case 1
        set(handles.SBZ,'Visible','off')
    case 2
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(3).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 3
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(4).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 4
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(5).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 5
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(6).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 6
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(7).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 7
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(8).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 8
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(9).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 9
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(10).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 10
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(11).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 11
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(12).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 12
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(13).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 13
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(14).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 14
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(15).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 15
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(16).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 16
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(17).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 17
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(18).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 18
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(19).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 19
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(20).f6; axes(handles.axes1);
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    case 20
        set(handles.SBZ,'Visible','off')
        SBZdata=StructData(21).f6; axes(handles.axes1);  
        handles.SBZ=geoshow(SBZdata(:,2),SBZdata(:,1),...
            'Color',[0 .5 0],'LineWidth',1.5);
        uistack(handles.SBZ,'top');set(handles.SBZ,'Visible','on')
    otherwise
        
end
    
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function SBZMeer10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SBZMeer10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white topo2 on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function BottomDep_Callback(hObject, eventdata, handles)
% hObject    handle to BottomDep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of BottomDep as text
%        str2double(get(hObject,'String')) returns contents of BottomDep as a double


% --- Executes during object creation, after setting all properties.
function BottomDep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BottomDep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white topo2 on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in TOPO2.
function TOPO2_Callback(hObject, eventdata, handles)
% hObject    handle to TOPO2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns TOPO2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from TOPO2
axes(handles.axes1);
BGdata=get(hObject,'Value');

switch BGdata
    case 1
        set(handles.TOPO2,'Visible','off');
    case 2
        set(handles.TOPO2,'Visible','on');
        PMTec_cptcmap('GMT_globe', 'mapping', 'direct'); 
%         lightm(45,115,1); material([1,.5,.8]); lighting Gouraud; hold on
        uistack(handles.TOPO2,'bottom');
        disp('Topography loaded.');
    case 3
        set(handles.TOPO2,'Visible','off');
        disp('Topography removed.');
    otherwise
        
end

guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function TOPO2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TOPO2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white topo2 on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit13_Callback(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit13 as text
%        str2double(get(hObject,'String')) returns contents of edit13 as a double


% --- Executes during object creation, after setting all properties.
function edit13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double


% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% ----helper-------
function R = refvec2georefcells(refvec, rasterSize)
% Convert legacy [cellsPerDeg, northLat, westLon] to a GeographicCellsReference
cellsPerDeg = refvec(1);
ddeg        = 1 / cellsPerDeg;           % cell size in degrees
north       = refvec(2);
west        = refvec(3);
M = rasterSize(1);
N = rasterSize(2);

latlim = [north - M*ddeg, north];        % rows start at north
lonlim = [west,           west + N*ddeg];% cols start at west

R = georefcells(latlim, lonlim, rasterSize);

function handles = loadCoastlinesIntoAxes(handles)
    % assumes current axes is handles.axes1 and a map axes exists
    % Clean up old coastline handles if they exist
    if isfield(handles,'hCoast1') && isgraphics(handles.hCoast1), delete(handles.hCoast1); end
    if isfield(handles,'hCoast2') && isgraphics(handles.hCoast2), delete(handles.hCoast2); end

    try
        % Preferred dataset in newer MATLAB (Mapping Toolbox)
        S   = load('coastlines.mat');   % provides coastlat, coastlon
        lat = S.coastlat;
        lon = S.coastlon;
        handles.hCoast1 = geoshow(lat, lon, 'DisplayType','polygon', ...
            'FaceColor',[.83 .82 .78], 'EdgeColor','none');
        handles.hCoast2 = geoshow(lat, lon, 'DisplayType','polygon', ...
            'FaceColor','none', 'LineWidth',1);
    catch
        % Fallback: land area polygons that ship with Mapping Toolbox
        land = shaperead('landareas', 'UseGeoCoords', true);
        handles.hCoast1 = geoshow(land, 'FaceColor',[.83 .82 .78], 'EdgeColor','none');
        handles.hCoast2 = geoshow(land, 'FaceColor','none', 'LineWidth',1);
    end

    set(handles.hCoast1,'Visible','off');
    set(handles.hCoast2,'Visible','off');

