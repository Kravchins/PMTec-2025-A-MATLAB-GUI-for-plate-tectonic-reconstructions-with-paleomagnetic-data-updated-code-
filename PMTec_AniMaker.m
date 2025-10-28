function varargout = PMTec_AniMaker(varargin)
% PMTEC_ANIMAKER MATLAB code for PMTec_AniMaker.fig
%      PMTEC_ANIMAKER, by itself, creates a new PMTEC_ANIMAKER or raises the existing
%      singleton*.
%
%      H = PMTEC_ANIMAKER returns the handle to a new PMTEC_ANIMAKER or the handle to
%      the existing singleton*.
%
%      PMTEC_ANIMAKER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PMTEC_ANIMAKER.M with the given input arguments.
%
%      PMTEC_ANIMAKER('Property','Value',...) creates a new PMTEC_ANIMAKER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PMTec_AniMaker_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PMTec_AniMaker_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PMTec_AniMaker

% Last Modified by GUIDE v2.5 24-Jul-2015 00:37:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PMTec_AniMaker_OpeningFcn, ...
                   'gui_OutputFcn',  @PMTec_AniMaker_OutputFcn, ...
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


% --- Executes just before PMTec_AniMaker is made visible.
function PMTec_AniMaker_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PMTec_AniMaker (see VARARGIN)

% Choose default command line output for PMTec_AniMaker
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
handles.hCoast2=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor','none','EdgeColor',[.83 .82 .78],'linewidth',1);
set(handles.hCoast1,'Visible','on');
set(handles.hCoast2,'Visible','off');

set(handles.view1,'string',num2str(0));
set(handles.view2,'string',num2str(0));
set(handles.view3,'string',num2str(0));

set(handles.AgeIni,'string','NaN');
set(handles.AgeFin,'string','NaN');
set(handles.AgeVisual,'string','NaN');
set(handles.DepthRange,'string','Depth Range');
set(handles.Depth,'string','Depth');

set(handles.AgeLabelLat,'string',num2str(82));
set(handles.AgeLabelLon,'string',num2str(-10));

% setup maptype for Rec
handles.ProjTypes1=2; %'mollweid';
handles.ColorCodeS=jet; % autumn
handles.AgeSeq=-1; % backward
set(handles.Slice, 'UserData', 0);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PMTec_AniMaker wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PMTec_AniMaker_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in MakeMovie.
function MakeMovie_Callback(hObject, eventdata, handles)
% hObject    handle to MakeMovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'AnimRecs')==0
    disp('Please load PlateRec file(s) first!');
elseif isfield(handles,'AnimRecs')==1
    if isfield(handles,'hAnim')==0
        disp('Please load PlateRec file(s) first!');
    elseif isfield(handles,'hAnim')==1
        AnimRecs=handles.AnimRecs;
        hAnim=handles.hAnim;
        % AnimRecs=handles.AnimRecs;
        
        if handles.AgeSeq==-1 % backward
            for j=1:handles.Nloop
                axes(handles.axes1);
                set(hAnim(j,:),'Visible','on');
                hAno(j)=textm(str2num(get(handles.AgeLabelLat,'String')),...
                    str2num(get(handles.AgeLabelLon,'String')),...
                    [num2str(AnimRecs(1).f.PlateRec(1).f3(j,1)) ' Ma'],...
                    'FontSize',12,'HorizontalAlignment','center',...
                    'BackgroundColor',[.7 .9 .7],'Margin',5);
                handles.movie(:,j)=getframe;
                set(hAnim(j,:),'Visible','off');
                set(hAno(j),'Visible','off');
            end
            
        elseif handles.AgeSeq==1 % forward
            for j=1:handles.Nloop
                jj=handles.Nloop+1-j;
                axes(handles.axes1);
                set(hAnim(jj,:),'Visible','on');
                hAno(jj)=textm(str2num(get(handles.AgeLabelLat,'String')),...
                    str2num(get(handles.AgeLabelLon,'String')),...
                    [num2str(AnimRecs(1).f.PlateRec(1).f3(jj,1)) ' Ma'],...
                    'FontSize',12,'HorizontalAlignment','center',...
                    'BackgroundColor',[.7 .9 .7],'Margin',5);
                handles.movie(:,j)=getframe;
                set(hAnim(jj,:),'Visible','off');
                set(hAno(jj),'Visible','off');
            end
        end
        disp('Movie generated.');
    end
end
guidata(hObject, handles);


% --- Executes on button press in pushbutton27.
function pushbutton27_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton27 (see GCBO)
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
handles.hCoast2=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor','none','EdgeColor',[.83 .82 .78],'linewidth',1);
set(handles.hCoast1,'Visible','on');
set(handles.hCoast2,'Visible','off');

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
handles.hCoast2=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor','none','EdgeColor',[.83 .82 .78],'linewidth',1);
set(handles.hCoast1,'Visible','on');
set(handles.hCoast2,'Visible','off');

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
handles.hCoast2=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor','none','EdgeColor',[.83 .82 .78],'linewidth',1);
set(handles.hCoast1,'Visible','on');
set(handles.hCoast2,'Visible','off');

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


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5


% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


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
    FullName=[PathName,FileName];
    load(FullName);
    if exist('RecSt','var')==0
        disp('Please load the correct RecSt file!');
    elseif exist('RecSt','var')==1
        % make PlateRec=[ref,plate,[age,V,LatV,LonV]] from RecSt
        PlateRec=struct('f1',{NaN},'f2',{NaN},'f3',{NaN});
        PlateRec(1).f1=RecSt(2).f4;
        PlateRec(1).f3=RecSt(1).f8;
        for i=1:length(RecSt(2).f4(:,1))
            PlateRec(i).f2=RecSt(i).f6;
        end
        handles.PlateRec=PlateRec;
        
        disp('RecSt.mat loaded.');
    end
elseif nbfiles==0
%     disp('Please select a file!')
end
guidata(hObject, handles);


% --- Executes on button press in ExPlateRec.
function ExPlateRec_Callback(hObject, eventdata, handles)
% hObject    handle to ExPlateRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'PlateRec')==0
    disp('Please load RecSt.mat first!');
elseif isfield(handles,'PlateRec')==1
    PlateRec=handles.PlateRec;
    
    % save .txt file
    [FileName,PathName]=uiputfile('*.mat','Save PlateRec As');
    if FileName ~= 0
        nbfiles = 1;
    else
        nbfiles = 0;
    end
    
    if nbfiles==1
        FileName(length(FileName))=[];FileName(length(FileName))=[];
        FileName(length(FileName))=[];FileName(length(FileName))=[];
        FullName=[PathName,'PlateRec','_',FileName,'.mat'];
        save(FullName, 'PlateRec');
        disp('PlateRec.mat saved.');
    elseif nbfiles==0
%         disp('Please name the data!');
    end
end
guidata(hObject, handles);



% --- Executes on selection change in ColorCodeS.
function ColorCodeS_Callback(hObject, eventdata, handles)
% hObject    handle to ColorCodeS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ColorCodeS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ColorCodeS

% hObject    handle to ColorCodeS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ColorCodeS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ColorCodeS

ColorCodeS=get(hObject,'Value');
switch ColorCodeS
    case 1
        handles.ColorCodeS=jet;
    case 2
        color=NaN(64,3); color(:)=0.31; 
        handles.ColorCodeS=color;
    case 3
        handles.ColorCodeS=jet;
    case 4
        handles.ColorCodeS=hsv;
    case 5
        handles.ColorCodeS=hot;
    case 6
        handles.ColorCodeS=cool;
    case 7
        handles.ColorCodeS=spring;
    case 8
        handles.ColorCodeS=summer;
    case 9
        handles.ColorCodeS=autumn;
    case 10
        handles.ColorCodeS=winter;
    case 11
        handles.ColorCodeS=gray;
    case 12
        handles.ColorCodeS=bone;
    case 13
        handles.ColorCodeS=copper;
    case 14
        handles.ColorCodeS=pink;
    case 15
        handles.ColorCodeS=lines;
    otherwise
        
end
disp('Color map selected.');

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


% --- Executes on button press in pushbutton31.
function pushbutton31_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton32.
function pushbutton32_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



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
handles.hCoast2=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor','none','EdgeColor',[.83 .82 .78],'linewidth',1);
set(handles.hCoast1,'Visible','on');
set(handles.hCoast2,'Visible','off');
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


% --- Executes on button press in Reset.
function Reset_Callback(hObject, eventdata, handles)
% hObject    handle to Reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% initiate map axes and all the map background data

cla(handles.axes1);
axes(handles.axes1); axesm eqdcylin % mollweid;eqdcylin;
framem on; axis off; tightmap; gridm on,
handles.ProjT='eqdcylin';

% 2) load coastline
coast=load('coast');
handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none');
handles.hCoast2=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor','none','EdgeColor',[.83 .82 .78],'linewidth',1);
set(handles.hCoast1,'Visible','on');
set(handles.hCoast2,'Visible','off');

set(handles.view1,'string',num2str(0));
set(handles.view2,'string',num2str(0));
set(handles.view3,'string',num2str(0));

set(handles.AgeIni,'string','NaN');
set(handles.AgeFin,'string','NaN');
set(handles.AgeVisual,'string','NaN');
set(handles.DepthRange,'string','Depth Range');
set(handles.Depth,'string','Depth');

set(handles.AgeLabelLat,'string',num2str(82));
set(handles.AgeLabelLon,'string',num2str(-10));

% setup maptype for Rec
handles.ProjTypes1=2; %'mollweid';
handles.ColorCodeS=jet; % autumn

handles.hptomo=handles.hCoast2;
set(handles.hptomo,'Visible','off');

disp('Reset all.');
guidata(hObject, handles);


% --- Executes on selection change in AgeSeq.
function AgeSeq_Callback(hObject, eventdata, handles)
% hObject    handle to AgeSeq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns AgeSeq contents as cell array
%        contents{get(hObject,'Value')} returns selected item from AgeSeq
AgeSeq=get(hObject,'Value');
switch AgeSeq
    case 1
        % backward
        handles.AgeSeq=-1; 
    case 2
        % backward
        handles.AgeSeq=-1; disp('Backward reconstruction selected.');
    case 3
        % forward
        handles.AgeSeq=1; disp('Forward reconstruction selected.');
    otherwise     
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AgeSeq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AgeSeq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in LoadPlateRec.
function LoadPlateRec_Callback(hObject, eventdata, handles)
% hObject    handle to LoadPlateRec (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Open standard dialog box for retrieving files
[FileName,PathName,FilterIndex]=uigetfile('*.mat','Select file(s)',...
    'MultiSelect', 'on');
if iscell(FileName)
    handles.nbfiles = length(FileName);
elseif FileName ~= 0
    handles.nbfiles = 1;
else
    handles.nbfiles = 0;
end

% FFPNPM=Full File Path Name of PM data
FullName=[PathName,FileName];
AnimRecs=struct('f',{NaN});
if handles.nbfiles==1
    AnimRecs.f=load(FullName);
    disp(FileName);
    disp('loaded.');
    handles.AnimRecs=AnimRecs;
    
%-------------------------------------------------------------------------    
    % setup plots    
    handles.Nloop=length(AnimRecs.f.PlateRec(1).f1(:,1)); 
    AgeFin=max(AnimRecs.f.PlateRec(1).f3(:,1)); 
    AgeIni=min(AnimRecs.f.PlateRec(1).f3(:,1));
    hAnim=NaN(handles.Nloop,handles.nbfiles);

    [ind,MapCol]=ColorCodeCal(zeros(handles.Nloop,1),handles.ColorCodeS);
    for j=1:handles.Nloop
        for k=1:handles.nbfiles
            hAnim(j,k)=geoshow(AnimRecs.f.PlateRec(j).f2(:,2), ...
                AnimRecs.f.PlateRec(j).f2(:,1),'DisplayType','line',...
                'linestyle','-','color',MapCol(ind(j),:),'LineWidth',1.5);
            set(hAnim(j,k),'Visible','off');
        end
    end
    
    handles.hAnim=hAnim;
    set(hAnim(1,:),'Visible','on');
    
    % pass the LoadPlate to text box
    set(handles.AgeIni,'string',num2str(AgeIni));
    set(handles.AgeFin,'string',num2str(AgeFin));
    set(handles.AgeVisual,'string',num2str(AgeIni));
    handles.Tstep=length(AnimRecs.f.PlateRec(1).f3(:,1))-1;
    
%-------------------------------------------------------------------------    
elseif handles.nbfiles>1
    for i=1:handles.nbfiles
        AnimRecs(i).f=load([PathName,FullName{1,i+1}]);
        disp(FileName{1,i});
        FileName{1,i}(length(FileName{1,i})-3:length(FileName{1,i}))=[];
    end
    disp('loaded.');
    handles.AnimRecs=AnimRecs;
    
    % setup plots
    for k=1:handles.nbfiles
        agemax(k)=max(AnimRecs(k).f.PlateRec(1).f3(:,1));
        agemin(k)=min(AnimRecs(k).f.PlateRec(1).f3(:,1));
        Nmax(k)=length(AnimRecs(k).f.PlateRec(1).f1(:,1));
    end
    
    handles.Nloop=max(Nmax); AgeFin=max(agemax); AgeIni=min(agemin);
    hAnim=NaN(handles.Nloop,handles.nbfiles);

    % all reconstructions are shown in dark grey color
    color=NaN(64,3); color(:)=0.31;
    handles.ColorCodeS=color;
    [ind,MapCol]=ColorCodeCal(zeros(handles.Nloop,1),handles.ColorCodeS);
    for j=1:handles.Nloop
        for k=1:handles.nbfiles
            hAnim(j,k)=geoshow(AnimRecs(k).f.PlateRec(j).f2(:,2), ...
                AnimRecs(k).f.PlateRec(j).f2(:,1),'DisplayType','line',...
                'linestyle','-','color',MapCol(ind(j),:),'LineWidth',1.5);
            set(hAnim(j,k),'Visible','off');
        end
    end
    
    handles.hAnim=hAnim;
    set(hAnim(1,:),'Visible','on');
    
    % pass the LoadPlate to text box
    set(handles.AgeIni,'string',num2str(AgeIni));
    set(handles.AgeFin,'string',num2str(AgeFin));
    set(handles.AgeVisual,'string',num2str(AgeIni));
    handles.Tstep=length(AnimRecs(1).f.PlateRec(1).f3(:,1))-1;
    
elseif handles.nbfiles==0
end

guidata(hObject, handles);


function AgeIni_Callback(hObject, eventdata, handles)
% hObject    handle to AgeIni (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AgeIni as text
%        str2double(get(hObject,'String')) returns contents of AgeIni as a double


% --- Executes during object creation, after setting all properties.
function AgeIni_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AgeIni (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AgeFin_Callback(hObject, eventdata, handles)
% hObject    handle to AgeFin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AgeFin as text
%        str2double(get(hObject,'String')) returns contents of AgeFin as a double


% --- Executes during object creation, after setting all properties.
function AgeFin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AgeFin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function AgeVisual_Callback(hObject, eventdata, handles)
% hObject    handle to AgeVisual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AgeVisual as text
%        str2double(get(hObject,'String')) returns contents of AgeVisual as a double
if isfield(handles,'hAnim')==0
    disp('Please load PlateRec file(s) first!');
elseif isfield(handles,'hAnim')==1
    hAnim=handles.hAnim;
    AnimRecs=handles.AnimRecs;
    set(hAnim,'Visible','off');
    axes(handles.axes1);
    set(handles.slider1,'Min',min(AnimRecs(1).f.PlateRec(1).f3(:,1))/10);
    set(handles.slider1,'Max',max(AnimRecs(1).f.PlateRec(1).f3(:,1))/10);
    set(handles.slider1,'SliderStep',[1/handles.Tstep, 1/handles.Tstep]);
    
    % if str2num(get(handles.AgeVisual,'String'))<=handles.AgeFin
    [row,col]=find(AnimRecs(1).f.PlateRec(1).f3(:,1)==...
        str2num(get(handles.AgeVisual,'String')));
    set(hAnim(row,:),'Visible','on');
    set(handles.slider1,'Value',row-1);
    
    disp('Visual age specified.');
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function AgeVisual_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AgeVisual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
if isfield(handles,'hAnim')==0
    disp('Please load PlateRec file(s) first!');
elseif isfield(handles,'hAnim')==1
    hAnim=handles.hAnim;
    AnimRecs=handles.AnimRecs;
    Tstep=handles.Tstep;
    set(hAnim,'Visible','off');
    axes(handles.axes1);
    
    % setup slider step
    % Tstep=length(AnimRecs(1).f.PlateRec(1).f3(:,1))-1;
    set(handles.slider1,'Min',min(AnimRecs(1).f.PlateRec(1).f3(:,1))/10);
    set(handles.slider1,'Max',max(AnimRecs(1).f.PlateRec(1).f3(:,1))/10);
    set(handles.slider1,'SliderStep',[1/Tstep, 1/Tstep]);
    [row,col]=find(AnimRecs(1).f.PlateRec(1).f3(:,1)==...
        round(get(handles.slider1,'value'))*10);
    set(hAnim(row,:),'Visible','on');
    handles.sliderROW=row;
    % pass the LoadPlate to text box
    set(handles.AgeVisual,'string',num2str(round(get(handles.slider1,'value'))*10));
end
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
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
%     disp('Please name the figure!')
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

function varargout = cptcmap(varargin)
% Copyright 2011 Kelly Kearney
% File Exchange update: 4/12/2011

%------------------------------
% Parse input
%------------------------------

% The .cpt file folder.  By default, the cptfiles folder is located in
% the same place as the cptcmap.m file.  If you change this on your
% computer, change the cptpath definition to reflect the new location.
if ispc==1
    PMTecSysPath=[pwd '\PMTecSys\'];
else
    PMTecSysPath=[pwd '/PMTecSys/'];
end
cptpath=[PMTecSysPath];
% cptpath = fullfile(fileparts(which('cptcmap')), 'cptfiles');
if ~exist(cptpath, 'dir')
    error('You have moved the cptfiles directory.  Please modify the cptpath variable in this code to point to the directory where your.cpt files are stored');
end

if nargin < 1
    error('You must provide a colormap name');
end

% Check for 'showall' option first
if nargin == 1 && strcmp(varargin{1}, 'showall')
    plotcmaps(cptpath);
    return;
end

% Name of file
[blah, blah, ext] = fileparts(varargin{1});
if isempty(ext)
    varargin{1} = [varargin{1} '.cpt'];
end

if exist(varargin{1}, 'file')   % full filename and path given
    filename = varargin{1};
else                            % only file name given
    [blah,blah,ext] = fileparts(varargin{1});
    if ~isempty(ext)            % with extension
        filename = fullfile(cptpath, varargin{1});
    else                        % without extension
        filename = fullfile(cptpath, [varargin{1} '.cpt']);   
    end
    if ~exist(filename, 'file')
        error('Specified .cpt file not found');
    end
end

% Axes to which colormap will be applied
if nargin > 1 && isnumeric(varargin{2}) && all(ishandle(varargin{2}(:)))
    ax = varargin{2};
    pv = varargin(3:end);
    applycmap = true;
elseif nargout == 0
    ax = gca;
    pv = varargin(2:end);
    applycmap = true;
else
    pv = varargin(2:end);
    applycmap = false;
end

% Optional paramter/value pairs
p = inputParser;
p.addParamValue('mapping', 'scaled', @(x) any(strcmpi(x, {'scaled', 'direct'})));
p.addParamValue('ncol', NaN, @(x) isscalar(x) && isnumeric(x));
p.addParamValue('flip', false, @(x) isscalar(x) && islogical(x));

p.parse(pv{:});
Opt = p.Results;
     
% Calculate colormap and apply

[cmap, lims,ticks,bfncol,ctable] = cpt2cmap(filename, Opt.ncol);
if Opt.flip
    if strcmp(Opt.mapping, 'direct')
        warning('Flipping colormap with direct mapping may lead to odd color breaks');
    end
    cmap = flipud(cmap);
end

if applycmap
    for iax = 1:numel(ax)
        axes(ax(iax));
        if strcmp(Opt.mapping, 'direct')
            set(ax(iax), 'clim', lims);
        end
        colormap(cmap);
    end
end

% Output
allout = {cmap, lims, ticks, bfncol, ctable};
varargout(1:nargout) = allout(1:nargout);

function [cmap, lims, ticks, bfncol, ctable] = cpt2cmap(file, ncol)
% Read file
fid = fopen(file);
txt = textscan(fid, '%s', 'delimiter', '\n');
txt = txt{1};
fclose(fid);
isheader = strncmp(txt, '#', 1);
isfooter = strncmp(txt, 'B', 1) | strncmp(txt, 'F', 1) | strncmp(txt, 'N', 1); 

% Extract color data, ignore labels (errors if other text found)
ctabletxt = txt(~isheader & ~isfooter);
ctable = str2num(strvcat(txt(~isheader & ~isfooter)));
if isempty(ctable)
    nr = size(ctabletxt,1);
    ctable = cell(nr,1);
    for ir = 1:nr
        ctable{ir} = str2num(strvcat(regexp(ctabletxt{ir}, '[\d\.-]*', 'match')))';
    end
    try 
        ctable = cell2mat(ctable);
    catch
        error('Cannot parse this format .cpt file yet');
    end 
end

% Determine which color model is used (RGB, HSV, CMYK, names, patterns,
% mixed)
[nr, nc] = size(ctable);
iscolmodline = cellfun(@(x) ~isempty(x), regexp(txt, 'COLOR_MODEL'));
if any(iscolmodline)
    colmodel = regexprep(txt{iscolmodline}, 'COLOR_MODEL', '');
    colmodel = strtrim(lower(regexprep(colmodel, '[#=]', '')));
else
    if nc == 8
        colmodel = 'rgb';
    elseif nc == 10
        colmodel = 'cmyk';
    else
        error('Cannot parse this format .cpt file yet');
    end
end

% Reformat color table into one column of colors
cpt = zeros(nr*2, 4);
cpt(1:2:end,:) = ctable(:,1:4);
cpt(2:2:end,:) = ctable(:,5:8);

% Ticks
ticks = unique(cpt(:,1));

% Choose number of colors for output
if isnan(ncol)
    
    endpoints = unique(cpt(:,1));
    
    % For gradient-ed blocks, ensure at least 4 steps between endpoints
    issolid = all(ctable(:,2:4) == ctable(:,6:8), 2);
    
    for ie = 1:length(issolid)
        if ~issolid(ie)
            temp = linspace(endpoints(ie), endpoints(ie+1), 11)';
            endpoints = [endpoints; temp(2:end-1)];
        end
    end
    
    endpoints = sort(endpoints);
    
    % Determine largest step size that resolves all endpoints
    
    space = diff(endpoints);
    space = unique(space);
% To avoid floating point issues when converting to integers
    space = round(space*1e3)/1e3;
    
    nspace = length(space);
    if ~isscalar(space)
        
        fac = 1;
        tol = .001;
        while 1
            if all(space >= 1 & (space - round(space)) < tol)
                space = round(space);
                break;
            else
                space = space * 10;
                fac = fac * 10;
            end
        end
        
        pairs = nchoosek(space, 2);
        np = size(pairs,1);
        commonsp = zeros(np,1);
        for ip = 1:np
            commonsp(ip) = gcd(pairs(ip,1), pairs(ip,2));
        end
        
        space = min(commonsp);
        space = space/fac;
    end
            
    ncol = (max(endpoints) - min(endpoints))./space;
    ncol = min(ncol, 256);
    
end

% Remove replicates and mimic sharp breaks
isrep =  [false; ~any(diff(cpt),2)];
cpt = cpt(~isrep,:);

difc = diff(cpt(:,1));
minspace = min(difc(difc > 0));
isbreak = [false; difc == 0];
cpt(isbreak,1) = cpt(isbreak,1) + .01*minspace;

% Parse background, foreground, and nan colors
footer = txt(isfooter);
bfncol = nan(3,3);
for iline = 1:length(footer)
    if strcmp(footer{iline}(1), 'B')
        bfncol(1,:) = str2num(regexprep(footer{iline}, 'B', ''));
    elseif strcmp(footer{iline}(1), 'F')
        bfncol(2,:) = str2num(regexprep(footer{iline}, 'F', ''));
    elseif strcmp(footer{iline}(1), 'N')
        bfncol(3,:) = str2num(regexprep(footer{iline}, 'N', ''));
    end
end

% Convert to Matlab-format colormap and color limits
lims = [min(cpt(:,1)) max(cpt(:,1))];
endpoints = linspace(lims(1), lims(2), ncol+1);
midpoints = (endpoints(1:end-1) + endpoints(2:end))/2;

cmap = interp1(cpt(:,1), cpt(:,2:4), midpoints);

switch colmodel
    case 'rgb'
        cmap = cmap ./ 255;
        bfncol = bfncol ./ 255;
        ctable(:,[2:4 6:8]) = ctable(:,[2:4 6:8]) ./ 255;
        
    case 'hsv'
        cmap(:,1) = cmap(:,1)./300;
        cmap = hsv2rgb(cmap);
        
        bfncol(:,1) = bfncol(:,1)./300;
        bfncol = hsv2rgb(bfncol);
        
        ctable(:,2) = ctable(:,2)./300;
        ctable(:,6) = ctable(:,6)./300;
        
        ctable(:,2:4) = hsv2rgb(ctable(:,2:4));
        ctable(:,6:8) = hsv2rgb(ctable(:,6:8));
        
    case 'cmyk'
        error('CMYK color conversion not yet supported');
end

isnear1 = cmap > 1 & (abs(cmap-1) < 2*eps);
cmap(isnear1) = 1;

function plotcmaps(folder)
Files = dir(fullfile(folder, '*.cpt'));
nfile = length(Files);
ncol = 3; 
nr = ceil(nfile/ncol);
width = (1 - .05*2)/ncol;
height = (1-.05*2)/nr;
left = .05 + (0:ncol-1)*width;
bot = .05 + (0:nr-1)*height;
[l, b] = meshgrid(left, bot);
w = width * .8;
h = height * .4;
figure('color','w');
ax = axes('position', [0 0 1 1]);
hold on;

for ifile = 1:nfile
    [cmap,blah,blah,blah,ctable] = cptcmap(Files(ifile).name);
    [x,y,c] = ctable2patch(ctable);
    xtick = unique(x);
    dx = max(x(:)) - min(x(:));
    xsc = ((x-min(xtick))./dx).*w + l(ifile);
    ysc = y.*h + b(ifile);
    xrect = [0 1 1 0 0] .*w + l(ifile);
    yrect = [1 1 0 0 1] .*h + b(ifile);
    xticksc = ((xtick-min(xtick))./dx).*w + l(ifile);
    x0 = interp1(xtick, xticksc, 0);
    y0 = b(ifile) + [0 .2*h NaN .8*h h];
    x0 = ones(size(y0))*x0;
    lbl = sprintf('%s [%g, %g]',regexprep(Files(ifile).name,'\.cpt',''),...
        min(x(:)), max(x(:)));
    patch(xsc, ysc, c, 'edgecolor', 'none');
    line(xrect, yrect, 'color', 'k');
    line(x0, y0, 'color', 'k');
    text(l(ifile), b(ifile)+h, lbl, 'interpreter','none','fontsize',8,...
        'verticalalignment', 'bottom', 'horizontalalignment', 'left');
    
end

set(ax, 'ylim', [0 1], 'xlim', [0 1], 'visible', 'off');

% Determine patch coordinates
function [x,y,c] = ctable2patch(ctable)
np = size(ctable,1);
x = zeros(4, np);
y = zeros(4, np);
c = zeros(4, np, 3);
y(1:2,:) = 1;
for ip = 1:np
    x(:,ip) = [ctable(ip,1) ctable(ip,5) ctable(ip,5) ctable(ip,1)];
    c(:,ip,:) = [ctable(ip,2:4); ctable(ip,6:8); ctable(ip,6:8); ctable(ip,2:4)];
end

function movie2gif(mov, gifFile, varargin)
% ==================
% Matlab movie to GIF Converter.
%
% Syntax: movie2gif(mov, gifFile, prop, value, ...)
% =================================================
% The list of properties is the same like for the command 'imwrite' for the
% file format gif:
%
% 'BackgroundColor' - A scalar integer. This value specifies which index in
%                     the colormap should be treated as the transparent
%                     color for the image and is used for certain disposal
%                     methods in animated GIFs. If X is uint8 or logical,
%                     then indexing starts at 0. If X is double, then
%                     indexing starts at 1.
%
% 'Comment' - A string or cell array of strings containing a comment to be
%             added to the image. For a cell array of strings, a carriage
%             return is added after each row.
%
% 'DelayTime' - A scalar value between 0 and 655 inclusive, that specifies
%               the delay in seconds before displaying the next image.
%
% 'DisposalMethod' - One of the following strings, which sets the disposal
%                    method of an animated GIF: 'leaveInPlace',
%                    'restoreBG', 'restorePrevious', or 'doNotSpecify'.
%
% 'LoopCount' - A finite integer between 0 and 65535 or the value Inf (the
%               default) which specifies the number of times to repeat the
%               animation. By default, the animation loops continuously.
%               For a value of 0, the animation will be played once. For a
%               value of 1, the animation will be played twice, etc.
%
% 'TransparentColor' - A scalar integer. This value specifies which index
%                      in the colormap should be treated as the transparent
%                      color for the image. If X is uint8 or logical, then
%                      indexing starts at 0. If X is double, then indexing
%                      starts at 1
%
% *************************************************************************
% Copyright 2007-2013 by Nicolae Cindea.

if (nargin < 2)
    error('Too few input arguments');
end

if (nargin == 2)
    frameNb = size(mov, 2);
    isFirst = true;
    h = waitbar(0, 'Generate GIF file...');
    for i = 1:frameNb
        waitbar((i-1)/frameNb, h);
        [RGB, ~] = frame2im(mov(i));
        if (exist('rgb2ind', 'file'))
            [IND, map] = rgb2ind(RGB,256);
        else
            [IND, map] = aRGB2IND(RGB);
        end
        if isFirst
            imwrite(IND, map, gifFile, 'gif');
            isFirst=false;
        else
            imwrite(IND, map, gifFile, 'gif', 'WriteMode', 'append');
        end
    end
    close(h);
end

if (nargin > 2)
    h = waitbar(0, 'Generate GIF file...');
    frameNb = size(mov, 2);
    isFirst = true;
    for i = 1:frameNb
        waitbar((i-1)/frameNb, h);
        [RGB, ~] = frame2im(mov(i));
        if (exist('rgb2ind', 'file'))
            [IND, map] = rgb2ind(RGB,256);
        else
            [IND, map] = aRGB2IND(RGB);
        end
        if isFirst
            args = varargin;
            imwrite(IND, map, gifFile, 'gif', args{:});
            isFirst=false;
            
            % supress 'LoopCount' option from the args!!
            args = varargin;
            l = length(args);
            
            posLoopCount = 0;
            for ii = 1:l
                if(ischar(args{ii}))
                    if strcmp(args{ii}, 'LoopCount')
                        posLoopCount = ii;
                    end
                end
            end
            if (posLoopCount)
                args = {args{1:posLoopCount-1}, args{posLoopCount+2:end}};
            end
            
        else
            imwrite(IND, map, gifFile, 'gif', 'WriteMode', 'append', ...
                args{:});
        end
    end
    close(h);
end

function [X, map] = aRGB2IND(RGB, nc)
% Convert RGB image to indexed image
% More or less has the same syntax as rgb2ind 

if (nargin < 2)
	nc = 256;
end

m = size(RGB, 1);
n = size(RGB, 2);
X = zeros(m, n);
map(1,:) = RGB(1, 1, :)./nc;

for i = 1:m
    for j = 1:n
        RGBij = double(reshape(RGB(i,j,:), 1, 3)./nc);
        isNotFound = true;
        k = 0;
        while isNotFound && k < size(map, 1)
            k = k + 1;
            if map(k,:) ==  RGBij
                isNotFound = false;
            end
        end
        if isNotFound
            map = [map; RGBij];
        end
        X(i,j) = double(k);
    end
end
map = double(map);


% plot TOMOp model (horizontal)
function [yi1,xi1,zi1]=plotTOMOp(data,gridm,gridn,method)

if nargin <2
    gridm=0.5; gridn=0.5;
elseif nargin <4
    method='cubic';
end

lon=data(:,1); lat=data(:,2); velocity=data(:,3);
% gridm=0.5; gridn=0.5;

[xi1,yi1]=meshgrid((min(lon)):gridm:(max(lon)),...
                 (min(lat)):gridn:(max(lat))); 

% gridding method: 'linear', 'natural', 'nearest', 'v4', 'cubic'
% method='cubic';
zi1 = griddata(lon,lat,velocity,xi1,yi1,method);
Vmax=max(max(zi1)); Vmin=min(min(zi1));
%-------------------------------------------------------------------------


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8
% load StructData.mat;
if ispc==1
    PMTecSysPath=[pwd '\PMTecSys\'];
else
    PMTecSysPath=[pwd '/PMTecSys/'];
end
handles.StructDataPath=[PMTecSysPath 'StructData150723.mat'];
load(handles.StructDataPath);

handles.hTOMOmodel=get(hObject,'Value');
switch handles.hTOMOmodel
    case 1
        disp('Please select a tomography model.');
    case 2
        disp('GAP-P1 (Obayashi et al., 2006 in EPSL) is selected.');
        % pass the LoadPlate to text box
        set(handles.DepthRange,'string',...
            [num2str(StructData(3).f4(1)) '-' num2str(StructData(3).f4(end))]);
    case 3
        disp('GyPSuM10p (Simmons et al., 2010 in JGR) is selected.');
        % pass the LoadPlate to text box
        set(handles.DepthRange,'string',...
            [num2str(StructData(3).f9(1)) '-' num2str(StructData(3).f9(end))]);
    case 4
        disp('GyPSuM10s (Simmons et al., 2010 in JGR) is selected.');
        % pass the LoadPlate to text box
        set(handles.DepthRange,'string',...
            [num2str(StructData(3).f11(1)) '-' num2str(StructData(3).f11(end))]);
    case 5
        disp('LLNL_G3Dv3_Vp (Simmons et al., 2012 in JGR) is selected.');
        % pass the LoadPlate to text box
        set(handles.DepthRange,'string',...
            [num2str(StructData(3).f13(1)) '-' num2str(StructData(3).f13(end))]);
    case 6
        disp('MIT08p (Li et al., 2008 in G3) is selected.');
        % pass the LoadPlate to text box
        set(handles.DepthRange,'string',...
            [num2str(StructData(3).f15(1)) '-' num2str(StructData(3).f15(end))]);
    otherwise
        
end
    
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SClear.
function SClear_Callback(hObject, eventdata, handles)
% hObject    handle to SClear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of SClear
if isfield(handles,{'TOMOline'})==0
    disp('Please make a slice first!');
elseif isfield(handles,{'TOMOline'})==1
    set(handles.TOMOline,'Visible','off');
    set(handles.TOMOlineTxt,'Visible','off');
    set(handles.TOMOTicks,'Visible','off');
end
guidata(hObject, handles);


% --- Executes on button press in Slice.
function Slice_Callback(hObject, eventdata, handles)
% hObject    handle to Slice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Slice

% load StructData.mat
if isfield(handles,'hTOMOmodel')==0
    disp('Please load tomography model first!');
elseif isfield(handles,'hTOMOmodel')==1
    load(handles.StructDataPath);
    if handles.hTOMOmodel==2  % GAP-P1
        Depth=str2num(get(handles.Depth,'String'));
        dV=StructData(3).f3; DepRange=StructData(3).f4;
    end
    if handles.hTOMOmodel==3  % GyPSuM10p
        Depth=str2num(get(handles.Depth,'String'));
        dV=StructData(3).f8; DepRange=StructData(3).f9;
    end
    if handles.hTOMOmodel==4  % GyPSuM10s
        Depth=str2num(get(handles.Depth,'String'));
        dV=StructData(3).f10; DepRange=StructData(3).f11;
    end
    if handles.hTOMOmodel==5  % LLNL_G3Dv3_Vp
        Depth=str2num(get(handles.Depth,'String'));
        dV=StructData(3).f12; DepRange=StructData(3).f13;
    end
    if handles.hTOMOmodel==6  % MIT08p
        Depth=str2num(get(handles.Depth,'String'));
        dV=StructData(3).f14; DepRange=StructData(3).f15;
    end
    
    R=6371-DepRange; bottom=DepRange(end);
    
    % PART1: choose vertical profile
    counter=get(hObject, 'UserData') + 1;
    set(hObject, 'UserData', counter);
    
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
    figure(counter)
    % CROSS SECTION
    lat1 = latIP(1);  lat2 = latIP(2);
    lon1 = lonIP(1);  lon2 = lonIP(2);
    
    dep = bottom;
    % dep=str2num(get(handles.BottomDep,'String'));
    LON = unique(dV(:,1))';
    LAT = unique(dV(:,2))';
    
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
    
    plot3(lonAx,latAx,(6371-410)*ones(1,7),'k--');
    plot3(lonAx,latAx,(6371-660)*ones(1,7),'k--');
    
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
    
end
guidata(hObject, handles);


% --- Executes on button press in Play.
function Play_Callback(hObject, eventdata, handles)
% hObject    handle to Play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'movie')==0
    disp('Please generate movie first!');
elseif isfield(handles,'movie')==1
    movie(handles.movie,1,1);
end
guidata(hObject, handles);


% --------------------------------------------------------------------
function uipushtool3_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'movie')==0
    disp('Please generate movie first!');
elseif isfield(handles,'movie')==1
    movie=handles.movie;
    
    % save .txt file
    [FileName,PathName]=uiputfile( ...
        {'*.avi;*.gif',...
        'AVI movie (*.avi)';
        '*.gif','GIF movie (*.gif)'}, ...
        'Save movie As');
    if FileName ~= 0
        nbfiles = 1;
    else
        nbfiles = 0;
    end
    
    if nbfiles==1
        FullName=strcat(PathName,FileName);
        if FileName(length(FileName)-3:length(FileName))=='.avi'
            FileName(length(FileName))=[];FileName(length(FileName))=[];
            FileName(length(FileName))=[];FileName(length(FileName))=[];
            FullName=[PathName,'movie','_',FileName,'.avi'];
            movie2avi(movie,FullName,'compression','none','fps',1);
            disp('AVI movie saved.');
        
        elseif FileName(length(FileName)-3:length(FileName))=='.gif'
            FileName(length(FileName))=[];FileName(length(FileName))=[];
            FileName(length(FileName))=[];FileName(length(FileName))=[];
            FullName=[PathName,'movie','_',FileName,'.gif'];
            movie2gif(movie,FullName,'LoopCount',60000);
            disp('GIF movie saved.');        

        end
    elseif nbfiles==0

    end
end

guidata(hObject, handles);



function AgeLabelLat_Callback(hObject, eventdata, handles)
% hObject    handle to AgeLabelLat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AgeLabelLat as text
%        str2double(get(hObject,'String')) returns contents of AgeLabelLat as a double


% --- Executes during object creation, after setting all properties.
function AgeLabelLat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AgeLabelLat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function AgeLabelLon_Callback(hObject, eventdata, handles)
% hObject    handle to AgeLabelLon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of AgeLabelLon as text
%        str2double(get(hObject,'String')) returns contents of AgeLabelLon as a double


% --- Executes during object creation, after setting all properties.
function AgeLabelLon_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AgeLabelLon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton38.
function pushbutton38_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton38 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function Depth_Callback(hObject, eventdata, handles)
% hObject    handle to Depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Depth as text
%        str2double(get(hObject,'String')) returns contents of Depth as a double
if isfield(handles,'hptomo')==1
    set(handles.hptomo,'Visible','off');
end
    
set(handles.hCoast1,'Visible','off');
load(handles.StructDataPath);
if isfield(handles,'hTOMOmodel')==0
    disp('Please load tomography model first!');
elseif isfield(handles,'hTOMOmodel')==1
    if handles.hTOMOmodel==2  % GAP-P1
        Depth=str2num(get(handles.Depth,'String'));
        dV=StructData(3).f3; DepRange=StructData(3).f4;
    end
    if handles.hTOMOmodel==3  % GyPSuM10p
        Depth=str2num(get(handles.Depth,'String'));
        dV=StructData(3).f8; DepRange=StructData(3).f9; 
    end
    if handles.hTOMOmodel==4  % GyPSuM10s
        Depth=str2num(get(handles.Depth,'String'));
        dV=StructData(3).f10; DepRange=StructData(3).f11;
    end
    if handles.hTOMOmodel==5  % LLNL_G3Dv3_Vp
        Depth=str2num(get(handles.Depth,'String'));
        dV=StructData(3).f12; DepRange=StructData(3).f13;
    end
    if handles.hTOMOmodel==6  % MIT08p
        Depth=str2num(get(handles.Depth,'String'));
        dV=StructData(3).f14; DepRange=StructData(3).f15;
    end
    
    % Sort the rows in descending order using the values in column 1.
    dV = sortrows(dV,[1 2]);
    LON = unique(dV(:,1));
    LAT = unique(dV(:,2));
    [lonG,latG,DepRangeG]=meshgrid(LON,LAT,DepRange);
    
    mapV = reshape(dV(:,3:end),[],1);
    mapV = reshape(mapV,[length(LAT),length(LON),length(DepRange)]);
    
    %Number of steps in interpolation
    NX = 1000;
    lats=linspace(min(LAT),max(LAT),NX);
    lons=linspace(min(LON),max(LON),NX);
    
    [xd,yd]=meshgrid(lons,lats);
    zd=ones(NX)*Depth;
    
    % gridding method: 'linear', 'natural', 'nearest', 'v4', 'cubic'
    method='linear';
    % vd = interp3(lonG,latG,DepRangeG,mapV,xd,yd,zd,method);
    vd = interp3(lonG,latG,DepRangeG,mapV,xd,yd,zd,method);
    
    % Grid type: surface, mesh, texturemap, contour
    axes(handles.axes1);
    handles.hptomo=geoshow(yd,xd,vd, 'DisplayType','texturemap');
    uistack(handles.hptomo,'bottom');
    
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
    caxis([-dvmax,dvmax]);
    % colorbar
    % contourcbar('Location','southoutside');
    set(handles.hCoast2,'Visible','on'); uistack(handles.hCoast2,'top');
end

% if isfield(handles,'hAnim')==1 
%     if isfield(handles,'sliderROW')==1
%         set(handles.hAnim(handles.sliderROW,:),'Visible','on');
%         uistack(handles.hAnim(handles.sliderROW,:),'top');
%     end
% end
    
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function Depth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Depth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function DepthRange_Callback(hObject, eventdata, handles)
% hObject    handle to DepthRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DepthRange as text
%        str2double(get(hObject,'String')) returns contents of DepthRange as a double


% --- Executes during object creation, after setting all properties.
function DepthRange_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DepthRange (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
