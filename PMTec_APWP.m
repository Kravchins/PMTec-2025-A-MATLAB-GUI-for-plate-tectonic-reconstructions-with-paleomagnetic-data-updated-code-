function varargout = PMTec_APWP(varargin)
% PMTEC_APWP MATLAB code for PMTec_APWP.fig
%      PMTEC_APWP, by itself, creates a new PMTEC_APWP or raises the existing
%      singleton*.
%
%      H = PMTEC_APWP returns the handle to a new PMTEC_APWP or the handle to
%      the existing singleton*.
%
%      PMTEC_APWP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PMTEC_APWP.M with the given input arguments.
%
%      PMTEC_APWP('Property','Value',...) creates a new PMTEC_APWP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PMTec_APWP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PMTec_APWP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PMTec_APWP

% Last Modified by GUIDE v2.5 22-May-2014 00:25:32

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PMTec_APWP_OpeningFcn, ...
                   'gui_OutputFcn',  @PMTec_APWP_OutputFcn, ...
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


% --- Executes just before PMTec_APWP is made visible.
function PMTec_APWP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PMTec_APWP (see VARARGIN)

% Choose default command line output for PMTec_APWP
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

% initiate map axes and all the map background data
axes(handles.axes1); axis off,axesm ortho % mollweid;
setm(gca,'Origin', mapview), framem on; tightmap; 
handles.ProjT='ortho';

% 2) load coastline
coast=load('coast');
handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none');
gridm on

set(handles.view1,'string',num2str(60));
set(handles.view2,'string',num2str(90));
set(handles.view3,'string',num2str(30));

% 3) set up APWP kinematics
axes(handles.axes2); axis([0 300 0 20]);
set(gca,'YTick',0:5:20); set(gca,'YTickLabel',{'0','5','10','15','20'})
ylabel('APWP Velocity (cm/yr)'),grid on

axes(handles.axes3); axis([0 300 0 60])
set(gca,'YTick',0:15:60)
set(gca,'YTickLabel',{'Eq','15N','30N','45N','60N'})
ylabel('Paleolatitude (^oN)'),grid on

axes(handles.axes4); axis([0 300 -2 2]); set(gca,'YTick',-2:1:2)
set(gca,'YTickLabel',{'-2','-1','0','1','2'})
xlabel('Age (Ma)'),ylabel('Angular Rotation (^o/yr)'),grid on

% set initial state of bootstrap parameters
set(handles.Increment,'string',num2str(5));
set(handles.Window,'string',num2str(20));
set(handles.Smooth,'string',num2str(200));
set(handles.Interpolation,'string',num2str(5));
set(handles.lonR,'string',num2str(0));
set(handles.latR,'string',num2str(0));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PMTec_APWP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PMTec_APWP_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

axes(handles.axes1); axis off;
ProjTypes=get(hObject,'Value');
switch ProjTypes
    case 1
        % initiate map: mollweid, ortho
        cla(handles.axes1); axesm ortho; handles.ProjT='ortho';
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
setm(gca,'Origin', mapview), framem on; tightmap; 

% load coastline
coast=load('coast');
handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none');
gridm on

disp('Projection map changed.');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
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
    % FFPNPM=Full File Path Name of PM data
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
    LoadPMdata=sortrows(LoadPMdata,1);
    handles.LoadPMdata=LoadPMdata;
    
    axes(handles.axes1);
    % 1) plot the PM data
    handles.hPMdata=geoshow(LoadPMdata(:,3),LoadPMdata(:,2),'DisplayType',...
        'point','Marker', 'o',...
        'MarkerFaceColor',[1 .6 .78],'MarkerEdgeColor','k','markersize',5);
    
    % 2) A95 for the paleopoles
    PMGstructA95=[NaN,NaN];
    for i = 1:length(LoadPMdata(:,2))
        [IncSC,DecSC]= scircle1(LoadPMdata(i,3),LoadPMdata(i,2),LoadPMdata(i,4));
        PMGstructA95=[PMGstructA95;[IncSC,DecSC];[NaN,NaN]];
    end
    handles.hPMdataA95=geoshow(PMGstructA95(:,1),PMGstructA95(:,2),...
        'DisplayType','line','linestyle',':',...
        'Color',[1 .6 .78],'LineWidth',1);
    
    % 3) Add data label for paleopoles
    indP=[1:1:length(LoadPMdata(:,2))]';
    [GP,GNP]=grp2idx(indP);
    handles.hAnot=textm(LoadPMdata(:,3)+.3,LoadPMdata(:,2),...
        num2str(LoadPMdata(:,1)),'Color','r','FontSize',8);
    set([handles.hPMdata;handles.hPMdataA95;...
        handles.hAnot],'Visible','off');
    
    
    % prepare PM data for calculation
    LoadPMdata=handles.LoadPMdata;
    age=LoadPMdata(:,1);
    lonP=LoadPMdata(:,2);
    latP=LoadPMdata(:,3);
    A95=LoadPMdata(:,4);
    Q=7./LoadPMdata(:,6);  % (Torsvik 2012 in ESR P329)
    N=length(lonP);
    
    % pass parameters from text boxes
    Tinv=str2num(get(handles.Increment,'String'));
    S=str2num(get(handles.Smooth,'String'));
    intp=str2num(get(handles.Interpolation,'String'));
    window=str2num(get(handles.Window,'String'));
    latR=str2num(get(handles.latR,'String'));
    lonR=str2num(get(handles.lonR,'String'));
    
    % calculate running means and spline
    [dataRMM,dataRWNN,dataRWNN_intp,dataAuxRWNN_intp]=...
        RunMeanSpline(age,lonP,latP,A95,Q,N,Tinv,S,intp,window);
    [dataRMM,dataRWNN,dataRWNN_intp,dataAuxRWNN_intp]=...
        RunMeanSpline(age,lonP,latP,A95,Q,N,Tinv,S,intp,window);
    % calculate the parameters for running mean and interpolated spine
    [AgeRecRM,PlatRM,deltaPlatRM,AVRM,RotRM,RotVRM]=...
        PlatVRot(lonR,latR,dataRMM(:,1),dataRMM(:,2),dataRMM(:,3),dataRMM(:,4));
    [AgeRecS_intp,PlatS_intp,deltaPlatS_intp,AVS_intp,RotS_intp,RotVS_intp]=...
        PlatVRot(lonR,latR,dataAuxRWNN_intp(:,1),dataAuxRWNN_intp(:,2),...
        dataAuxRWNN_intp(:,3),zeros(length(dataAuxRWNN_intp(:,3))));
    
    handles.dataRMM=dataRMM;
    handles.dataRWNN=dataRWNN;
    handles.dataRWNN_intp=dataRWNN_intp;
    handles.dataAuxRWNN_intp=dataAuxRWNN_intp;
    handles.kinematicsRM.AgeRecRM=AgeRecRM;
    handles.kinematicsRM.PlatRM=PlatRM;
    handles.kinematicsRM.deltaPlatRM=deltaPlatRM;
    handles.kinematicsRM.AVRM=AVRM;
    handles.kinematicsRM.RotRM=RotRM;
    handles.kinematicsRM.RotVRM=RotVRM;
    handles.kinematicsSP.AgeRecS_intp=AgeRecS_intp;
    handles.kinematicsSP.PlatS_intp=PlatS_intp;
    handles.kinematicsSP.deltaPlatS_intp=deltaPlatS_intp;
    handles.kinematicsSP.AVS_intp=AVS_intp;
    handles.kinematicsSP.RotS_intp=RotS_intp;
    handles.kinematicsSP.RotVS_intp=RotVS_intp;
    
    % set axes properties
    % 1) APWP velocity
    xmax2=round(max([max(AgeRecRM(~isinf(AgeRecRM))),...
        max(AgeRecS_intp(~isinf(AgeRecS_intp)))]/50))*50;
    xmin2=floor(min([min(AgeRecRM(~isinf(AgeRecRM))),...
        min(AgeRecS_intp(~isinf(AgeRecS_intp)))]/10))*10;
    if xmin2<0
        xmin2=0;
    end
    ymax2=ceil(max([max(AVRM(~isinf(AVRM))),...
        max(AVS_intp(~isinf(AVS_intp)))]/1))*1;
    axes(handles.axes2);grid on, AxiScale2=[xmin2 xmax2 0 ymax2];
    % save axes property settings
    handles.xmax2=xmax2;
    handles.xmin2=xmin2;
    handles.ymax2=ymax2;
    
    % 2) paleolatitude variation
    ymin3=floor(min([min(PlatRM(~isinf(PlatRM))),...
        min(PlatS_intp(~isinf(PlatS_intp)))]/5))*5;
    ymax3=ceil(max([max(PlatRM(~isinf(PlatRM))),...
        max(PlatS_intp(~isinf(PlatS_intp)))]/5))*5;
    axes(handles.axes3);grid on, AxiScale3=[xmin2 xmax2 ymin3 ymax3];
    % save axes property settings
    handles.ymax3=ymax3;
    handles.ymin3=ymin3;
    
    % 3) rotation rate for reference site
    ymin4=floor(min([min(RotVRM(~isinf(RotVRM))),...
        min(RotVS_intp(~isinf(RotVS_intp)))]/.5))*.5;
    ymax4=ceil(max([max(RotVRM(~isinf(RotVRM))),...
        max(RotVS_intp(~isinf(RotVS_intp)))]/.5))*.5;
    axes(handles.axes4);grid on, AxiScale4=[xmin2 xmax2 ymin4 ymax4];
    % save axes property settings
    handles.ymax4=ymax4;
    handles.ymin4=ymin4;
    
    disp('PaleoMag data file successfully loaded.');
    
elseif nbfiles==0
%     disp('Please select a file!')
end

% Update handles structure
guidata(hObject,handles);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1)
cla(handles.axes2)
cla(handles.axes3)
cla(handles.axes4)

handles.view1_ini=str2num(get(handles.view1,'String'));
handles.view2_ini=str2num(get(handles.view2,'String'));
handles.view3_ini=str2num(get(handles.view3,'String'));

mapview=[handles.view1_ini,...
         handles.view2_ini,...
         handles.view3_ini];

% initiate map axes and all the map background data
axes(handles.axes1); axis off,axesm ortho % mollweid;
setm(gca,'Origin', mapview), framem on; tightmap; gridm on
handles.ProjT='ortho';

% 2) load coastline
coast=load('coast');
handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none');


set(handles.view1,'string',num2str(60));
set(handles.view2,'string',num2str(90));
set(handles.view3,'string',num2str(30));

% 3) set up APWP kinematics
axes(handles.axes2); axis([0 300 0 20]);
set(gca,'YTick',0:5:20); set(gca,'YTickLabel',{'0','5','10','15','20'})
ylabel('APWP Velocity (cm/yr)'),grid on

axes(handles.axes3); axis([0 300 0 60])
set(gca,'YTick',0:15:60)
set(gca,'YTickLabel',{'Eq','15N','30N','45N','60N'})
ylabel('Paleolatitude (^oN)'),grid on

axes(handles.axes4); axis([0 300 -2 2]); set(gca,'YTick',-2:1:2)
set(gca,'YTickLabel',{'-2','-1','0','1','2'})
xlabel('Age (Ma)'),ylabel('Angular Rotation (^o/yr)'),grid on

% set initial state of bootstrap parameters
set(handles.Increment,'string',num2str(5));
set(handles.Window,'string',num2str(20));
set(handles.Smooth,'string',num2str(200));
set(handles.Interpolation,'string',num2str(5));
set(handles.lonR,'string',num2str(0));
set(handles.latR,'string',num2str(0));

disp('Reset all.');
% Update handles structure
guidata(hObject, handles);



function Increment_Callback(hObject, eventdata, handles)
% hObject    handle to Increment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Increment as text
%        str2double(get(hObject,'String')) returns contents of Increment as a double


% --- Executes on button press in clearSP.
function clearSP_Callback(hObject, eventdata, handles)
% hObject    handle to clearSP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,{'hleg21','hleg22','hleg23','hleg24',...
        'bar21','bar22','bar23'})==0
    disp('No spline path to clear!')
elseif isfield(handles,'LoadPMdata')==1
    set(handles.hleg21,'visible','off');
    set(handles.hleg22,'visible','off');
    set(handles.hleg22Ano,'visible','off');
    set(handles.bar21,'visible','off');
    set(handles.bar22,'visible','off');
    set(handles.bar23,'visible','off');
    
    disp('Spline path cleared.');
end
% Update handles structure
guidata(hObject,handles);


% --- Executes on button press in clearRM.
function clearRM_Callback(hObject, eventdata, handles)
% hObject    handle to clearRM (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isfield(handles,{'hleg11','hleg12','hleg13','hleg14',...
        'bar11','bar12','bar13'})==0
    disp('No running mean path to clear!');
elseif isfield(handles,'LoadPMdata')==1
    set(handles.hleg11,'visible','off');
    set(handles.hleg12,'visible','off');
    set(handles.hleg13,'visible','off');
    set(handles.hleg14,'visible','off');
    set(handles.bar11,'visible','off');
    set(handles.bar12,'visible','off');
    set(handles.bar13,'visible','off');
    
    disp('Running mean path cleared.');
end
% Update handles structure
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function Increment_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Increment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Window_Callback(hObject, eventdata, handles)
% hObject    handle to Window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Window as text
%        str2double(get(hObject,'String')) returns contents of Window as a double


% --- Executes during object creation, after setting all properties.
function Window_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Smooth_Callback(hObject, eventdata, handles)
% hObject    handle to Increment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Increment as text
%        str2double(get(hObject,'String')) returns contents of Increment as a double


% --- Executes during object creation, after setting all properties.
function Smooth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Increment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Interpolation_Callback(hObject, eventdata, handles)
% hObject    handle to Window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Window as text
%        str2double(get(hObject,'String')) returns contents of Window as a double


% --- Executes during object creation, after setting all properties.
function Interpolation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lonR_Callback(hObject, eventdata, handles)
% hObject    handle to lonR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lonR as text
%        str2double(get(hObject,'String')) returns contents of lonR as a double


% prepare PM data for calculation
LoadPMdata=handles.LoadPMdata;
age=LoadPMdata(:,1);
lonP=LoadPMdata(:,2);
latP=LoadPMdata(:,3);
A95=LoadPMdata(:,4);
Q=7./LoadPMdata(:,6);  % (Torsvik 2012 in ESR P329)
N=length(lonP);

% pass parameters from text boxes
Tinv=str2num(get(handles.Increment,'String'));
S=str2num(get(handles.Smooth,'String'));
intp=str2num(get(handles.Interpolation,'String'));
window=str2num(get(handles.Window,'String'));
latR=str2num(get(handles.latR,'String'));
lonR=str2num(get(handles.lonR,'String'));

% calculate running means and spline
[dataRMM,dataRWNN,dataRWNN_intp,dataAuxRWNN_intp]=...
    RunMeanSpline(age,lonP,latP,A95,Q,N,Tinv,S,intp,window);
[dataRMM,dataRWNN,dataRWNN_intp,dataAuxRWNN_intp]=...
    RunMeanSpline(age,lonP,latP,A95,Q,N,Tinv,S,intp,window);
% calculate the parameters for running mean and interpolated spine
[AgeRecRM,PlatRM,deltaPlatRM,AVRM,RotRM,RotVRM]=...
    PlatVRot(lonR,latR,dataRMM(:,1),dataRMM(:,2),dataRMM(:,3),dataRMM(:,4));
[AgeRecS_intp,PlatS_intp,deltaPlatS_intp,AVS_intp,RotS_intp,RotVS_intp]=...
    PlatVRot(lonR,latR,dataAuxRWNN_intp(:,1),dataAuxRWNN_intp(:,2),...
    dataAuxRWNN_intp(:,3),zeros(length(dataAuxRWNN_intp(:,3))));

handles.dataRMM=dataRMM;
handles.dataRWNN=dataRWNN;
handles.dataRWNN_intp=dataRWNN_intp;
handles.dataAuxRWNN_intp=dataAuxRWNN_intp;
handles.kinematicsRM.AgeRecRM=AgeRecRM;
handles.kinematicsRM.PlatRM=PlatRM;
handles.kinematicsRM.deltaPlatRM=deltaPlatRM;
handles.kinematicsRM.AVRM=AVRM;
handles.kinematicsRM.RotRM=RotRM;
handles.kinematicsRM.RotVRM=RotVRM;
handles.kinematicsSP.AgeRecS_intp=AgeRecS_intp;
handles.kinematicsSP.PlatS_intp=PlatS_intp;
handles.kinematicsSP.deltaPlatS_intp=deltaPlatS_intp;
handles.kinematicsSP.AVS_intp=AVS_intp;
handles.kinematicsSP.RotS_intp=RotS_intp;
handles.kinematicsSP.RotVS_intp=RotVS_intp;

% set axes properties
% 1) APWP velocity
xmax2=round(max([max(AgeRecRM(~isinf(AgeRecRM))),...
    max(AgeRecS_intp(~isinf(AgeRecS_intp)))]/50))*50;
xmin2=floor(min([min(AgeRecRM(~isinf(AgeRecRM))),...
    min(AgeRecS_intp(~isinf(AgeRecS_intp)))]/10))*10;
if xmin2<0
    xmin2=0;
end
ymax2=ceil(max([max(AVRM(~isinf(AVRM))),...
    max(AVS_intp(~isinf(AVS_intp)))]/1))*1;
axes(handles.axes2);grid on, AxiScale2=[xmin2 xmax2 0 ymax2];
% save axes property settings
handles.xmax2=xmax2;
handles.xmin2=xmin2;
handles.ymax2=ymax2;

% 2) paleolatitude variation
ymin3=floor(min([min(PlatRM(~isinf(PlatRM))),...
    min(PlatS_intp(~isinf(PlatS_intp)))]/5))*5;
ymax3=ceil(max([max(PlatRM(~isinf(PlatRM))),...
    max(PlatS_intp(~isinf(PlatS_intp)))]/5))*5;
axes(handles.axes3);grid on, AxiScale3=[xmin2 xmax2 ymin3 ymax3];
% save axes property settings
handles.ymax3=ymax3;
handles.ymin3=ymin3;

% 3) rotation rate for reference site
ymin4=floor(min([min(RotVRM(~isinf(RotVRM))),...
    min(RotVS_intp(~isinf(RotVS_intp)))]/.5))*.5;
ymax4=ceil(max([max(RotVRM(~isinf(RotVRM))),...
    max(RotVS_intp(~isinf(RotVS_intp)))]/.5))*.5;
axes(handles.axes4);grid on, AxiScale4=[xmin2 xmax2 ymin4 ymax4];
% save axes property settings
handles.ymax4=ymax4;
handles.ymin4=ymin4;

% Update handles structure
guidata(hObject,handles);


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

% prepare PM data for calculation
LoadPMdata=handles.LoadPMdata;
age=LoadPMdata(:,1);
lonP=LoadPMdata(:,2);
latP=LoadPMdata(:,3);
A95=LoadPMdata(:,4);
Q=7./LoadPMdata(:,6);  % (Torsvik 2012 in ESR P329)
N=length(lonP);

% pass parameters from text boxes
Tinv=str2num(get(handles.Increment,'String'));
S=str2num(get(handles.Smooth,'String'));
intp=str2num(get(handles.Interpolation,'String'));
window=str2num(get(handles.Window,'String'));
latR=str2num(get(handles.latR,'String'));
lonR=str2num(get(handles.lonR,'String'));

% calculate running means and spline
[dataRMM,dataRWNN,dataRWNN_intp,dataAuxRWNN_intp]=...
    RunMeanSpline(age,lonP,latP,A95,Q,N,Tinv,S,intp,window);
[dataRMM,dataRWNN,dataRWNN_intp,dataAuxRWNN_intp]=...
    RunMeanSpline(age,lonP,latP,A95,Q,N,Tinv,S,intp,window);
% calculate the parameters for running mean and interpolated spine
[AgeRecRM,PlatRM,deltaPlatRM,AVRM,RotRM,RotVRM]=...
    PlatVRot(lonR,latR,dataRMM(:,1),dataRMM(:,2),dataRMM(:,3),dataRMM(:,4));
[AgeRecS_intp,PlatS_intp,deltaPlatS_intp,AVS_intp,RotS_intp,RotVS_intp]=...
    PlatVRot(lonR,latR,dataAuxRWNN_intp(:,1),dataAuxRWNN_intp(:,2),...
    dataAuxRWNN_intp(:,3),zeros(length(dataAuxRWNN_intp(:,3))));

handles.dataRMM=dataRMM;
handles.dataRWNN=dataRWNN;
handles.dataRWNN_intp=dataRWNN_intp;
handles.dataAuxRWNN_intp=dataAuxRWNN_intp;
handles.kinematicsRM.AgeRecRM=AgeRecRM;
handles.kinematicsRM.PlatRM=PlatRM;
handles.kinematicsRM.deltaPlatRM=deltaPlatRM;
handles.kinematicsRM.AVRM=AVRM;
handles.kinematicsRM.RotRM=RotRM;
handles.kinematicsRM.RotVRM=RotVRM;
handles.kinematicsSP.AgeRecS_intp=AgeRecS_intp;
handles.kinematicsSP.PlatS_intp=PlatS_intp;
handles.kinematicsSP.deltaPlatS_intp=deltaPlatS_intp;
handles.kinematicsSP.AVS_intp=AVS_intp;
handles.kinematicsSP.RotS_intp=RotS_intp;
handles.kinematicsSP.RotVS_intp=RotVS_intp;

% set axes properties
% 1) APWP velocity
xmax2=round(max([max(AgeRecRM(~isinf(AgeRecRM))),...
    max(AgeRecS_intp(~isinf(AgeRecS_intp)))]/50))*50;
xmin2=floor(min([min(AgeRecRM(~isinf(AgeRecRM))),...
    min(AgeRecS_intp(~isinf(AgeRecS_intp)))]/10))*10;
if xmin2<0
    xmin2=0;
end
ymax2=ceil(max([max(AVRM(~isinf(AVRM))),...
    max(AVS_intp(~isinf(AVS_intp)))]/1))*1;
axes(handles.axes2);grid on, AxiScale2=[xmin2 xmax2 0 ymax2];
% save axes property settings
handles.xmax2=xmax2;
handles.xmin2=xmin2;
handles.ymax2=ymax2;

% 2) paleolatitude variation
ymin3=floor(min([min(PlatRM(~isinf(PlatRM))),...
    min(PlatS_intp(~isinf(PlatS_intp)))]/5))*5;
ymax3=ceil(max([max(PlatRM(~isinf(PlatRM))),...
    max(PlatS_intp(~isinf(PlatS_intp)))]/5))*5;
axes(handles.axes3);grid on, AxiScale3=[xmin2 xmax2 ymin3 ymax3];
% save axes property settings
handles.ymax3=ymax3;
handles.ymin3=ymin3;

% 3) rotation rate for reference site
ymin4=floor(min([min(RotVRM(~isinf(RotVRM))),...
    min(RotVS_intp(~isinf(RotVS_intp)))]/.5))*.5;
ymax4=ceil(max([max(RotVRM(~isinf(RotVRM))),...
    max(RotVS_intp(~isinf(RotVS_intp)))]/.5))*.5;
axes(handles.axes4);grid on, AxiScale4=[xmin2 xmax2 ymin4 ymax4];
% save axes property settings
handles.ymax4=ymax4;
handles.ymin4=ymin4;

% Update handles structure
guidata(hObject,handles);


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


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
if isfield(handles,{'hPMdata','hAnot'})==0
    disp('Please load paleomag data first!');
elseif isfield(handles,{'hPMdata','hAnot'})==1
    axes(handles.axes1);
    
    % ------------------------
    % if this button is selected
    if (get(handles.radiobutton1,'Value') == get(handles.radiobutton1,'Max'))
        set([handles.hPMdata;handles.hAnot],'Visible','on');
    elseif (get(handles.radiobutton1,'Value') == get(handles.radiobutton1,'Min'))
        set([handles.hPMdata;handles.hAnot],'Visible','off');
    end
    
end
% Update handles structure
guidata(hObject,handles);


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
 
 
% --- Executes on button press in ExportAPWP.
function ExportAPWP_Callback(hObject, eventdata, handles)
% hObject    handle to ExportAPWP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,{'LoadPMdata','dataRMM','dataRWNN','dataRWNN_intp',...
        'dataAuxRWNN_intp','kinematicsRM','kinematicsSP'})==0
    disp('Please calculate APWP first!');
elseif isfield(handles,{'LoadPMdata','dataRMM','dataRWNN','dataRWNN_intp',...
        'dataAuxRWNN_intp','kinematicsRM','kinematicsSP'})==1
    LoadPMdata=handles.LoadPMdata;
    dataRMM=handles.dataRMM;
    dataRWNN=handles.dataRWNN;
    dataRWNN_intp=handles.dataRWNN_intp;
    dataAuxRWNN_intp=handles.dataAuxRWNN_intp;
    AgeRecRM=handles.kinematicsRM.AgeRecRM;
    PlatRM=handles.kinematicsRM.PlatRM;
    deltaPlatRM=handles.kinematicsRM.deltaPlatRM;
    AVRM=handles.kinematicsRM.AVRM;
    RotRM=handles.kinematicsRM.RotRM;
    RotVRM=handles.kinematicsRM.RotVRM;
    AgeRecS_intp=handles.kinematicsSP.AgeRecS_intp;
    PlatS_intp=handles.kinematicsSP.PlatS_intp;
    deltaPlatS_intp=handles.kinematicsSP.deltaPlatS_intp;
    AVS_intp=handles.kinematicsSP.AVS_intp;
    RotS_intp=handles.kinematicsSP.RotS_intp;
    RotVS_intp=handles.kinematicsSP.RotVS_intp;
    
    % combine results
    % dataRMM=[age,lon,lat,A95,K,N]
    % dataAuxRWNN_intp=[age,lon,lat]
    % APWP_temp=[dataRMM;dataAuxRWNN_intp;...
    % [AgeRecRM,PlatRM,AVRM,RotRM,RotVRM];...
    % [AgeRecS_intp,PlatS_intp,AVS_intp,RotS_intp,RotVS_intp]]
    APWP_temp=struct('f',{NaN});
    APWP_temp(1).f=dataRMM(:,1:6);
    APWP_temp(2).f=dataAuxRWNN_intp;
    APWP_temp(3).f(:,1)=AgeRecRM;
    APWP_temp(3).f(:,2)=PlatRM;
    APWP_temp(3).f(:,3)=AVRM;
    APWP_temp(3).f(:,4)=RotRM;
    APWP_temp(3).f(:,5)=RotVRM;
    APWP_temp(4).f(:,1)=AgeRecS_intp;
    APWP_temp(4).f(:,2)=PlatS_intp;
    APWP_temp(4).f(:,3)=AVS_intp;
    APWP_temp(4).f(:,4)=RotS_intp;
    APWP_temp(4).f(:,5)=RotVS_intp;
    
    APWP=struct('f1',{NaN},'f2',{NaN},'f3',{NaN},'f4',{NaN});
    APWP.f1=APWP_temp(1).f; APWP.f2=APWP_temp(2).f;
    APWP.f3=APWP_temp(3).f; APWP.f4=APWP_temp(4).f;
        
    % save .mat file
    [FileName,PathName]=uiputfile('*.mat','Save APWP As');
    if FileName ~= 0
        nbfiles = 1;
    else
        nbfiles = 0;
    end
    
    if nbfiles==1
        FullName=[PathName,FileName];
        save(FullName, 'APWP');
        disp('APWP data file saved.');
    elseif nbfiles==0
        %     disp('Please name the data!')
    end
end
guidata(hObject, handles);



% --- Executes on button press in Spline.
function Spline_Callback(hObject, eventdata, handles)
% hObject    handle to Spline (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% prepare PM data for calculation
if isfield(handles,'LoadPMdata')==0
    disp('Please load paleomag data first!');
elseif isfield(handles,'LoadPMdata')==1
    LoadPMdata=handles.LoadPMdata;
    age=LoadPMdata(:,1);
    lonP=LoadPMdata(:,2);
    latP=LoadPMdata(:,3);
    A95=LoadPMdata(:,4);
    Q=7./LoadPMdata(:,6);  % (Torsvik 2012 in ESR P329)
    N=length(lonP);
    
    % pass parameters from text boxes
    Tinv=str2num(get(handles.Increment,'String'));
    S=str2num(get(handles.Smooth,'String'));
    intp=str2num(get(handles.Interpolation,'String'));
    window=str2num(get(handles.Window,'String'));
    latR=str2num(get(handles.latR,'String'));
    lonR=str2num(get(handles.lonR,'String'));
    
    % calculate running means and spline
    [dataRMM,dataRWNN,dataRWNN_intp,dataAuxRWNN_intp]=...
        RunMeanSpline(age,lonP,latP,A95,Q,N,Tinv,S,intp,window);
    
    % calculate the parameters for interpolated spine
    [AgeRecS_intp,PlatS_intp,deltaPlatS_intp,AVS_intp,RotS_intp,RotVS_intp]=...
        PlatVRot(lonR,latR,dataAuxRWNN_intp(:,1),dataAuxRWNN_intp(:,2),...
        dataAuxRWNN_intp(:,3),zeros(length(dataAuxRWNN_intp(:,3))));
    
    
    axes(handles.axes1);
    % plot dataAuxRWW_intp (Jupp & Kent, 1987) [.0 .5 .0] green
    handles.hleg21=geoshow(dataRWNN_intp(:,3), dataRWNN_intp(:,2), 'Color',...
        [.0 .5 .0],'LineWidth',4);
    handles.hleg22=geoshow(dataRWNN_intp(:,3),dataRWNN_intp(:,2),'DisplayType',...
        'point','Marker','o','MarkerFaceColor','w','MarkerEdgeColor','k','markersize',7);
    % Add data label for weighted data point
    % Create index vector from grouping variable
    indAno=1:5:length(dataRWNN_intp(:,3));
    handles.hleg22Ano=textm(dataRWNN_intp(indAno,3)+.3,dataRWNN_intp(indAno,2),...
        num2str(dataRWNN_intp(indAno,1)),'Color',[.0 .5 .0],'FontSize',10);
    
    
    % save data
    handles.dataRMM=dataRMM;
    handles.dataRWNN=dataRWNN;
    handles.dataRWNN_intp=dataRWNN_intp;
    handles.dataAuxRWNN_intp=dataAuxRWNN_intp;
    handles.kinematicsSP.AgeRecS_intp=AgeRecS_intp;
    handles.kinematicsSP.PlatS_intp=PlatS_intp;
    handles.kinematicsSP.deltaPlatS_intp=deltaPlatS_intp;
    handles.kinematicsSP.AVS_intp=AVS_intp;
    handles.kinematicsSP.RotS_intp=RotS_intp;
    handles.kinematicsSP.RotVS_intp=RotVS_intp;
    
    % plot the relevant APWP parameters
    % 1) APWP velocity
    xmax2=handles.xmax2;
    xmin2=handles.xmin2;
    ymax2=ceil(max(handles.ymax2)/2)*2;
    
    axes(handles.axes2);AxiScale2=[xmin2 xmax2 0 ymax2];
    K=1;
    handles.bar21=bar(AgeRecS_intp,AVS_intp,'FaceColor',[.47 .67 .19],...
        'EdgeColor','k');
    set(handles.bar21,'BarWidth',K); hold on;
    
    axis(AxiScale2);
    xticks=[xmin2:50:xmax2]'; xticks=round(xticks/50)*50;
    set(gca,'XTick',xticks); set(gca,'XTickLabel',num2str(xticks))
    yticks=[0:5:ymax2]'; yticks=ceil(yticks/5)*5;
    set(gca,'YTick',yticks); set(gca,'YTickLabel',num2str(yticks))
    ylabel('APWP Velocity (cm/yr)'),grid on,
    
    % 2) paleolatitude variation
    ymax3=handles.ymax3;
    ymin3=handles.ymin3;
    axes(handles.axes3);AxiScale3=[xmin2 xmax2 ymin3 ymax3];
    
    handles.bar22=plot(AgeRecS_intp,PlatS_intp,'LineWidth',2.5,...
        'Color',[.47 .67 .19]);hold on;
    
    axis(AxiScale3);
    xticks=[xmin2:50:xmax2]'; xticks=round(xticks/50)*50;
    set(gca,'XTick',xticks); set(gca,'XTickLabel',num2str(xticks))
    yticks3=[ymin3:10:ymax3]'; yticks3=round(yticks3/10)*10;
    set(gca,'YTick',yticks3); set(gca,'YTickLabel',num2str(yticks3))
    ylabel('Paleolatitude (^oN)'),grid on,
    
    % 3) rotation rate for reference site
    ymax4=handles.ymax4;
    ymin4=handles.ymin4;
    axes(handles.axes4); AxiScale4=[xmin2 xmax2 ymin4 ymax4];
    
    handles.bar23=bar(AgeRecS_intp,RotVS_intp,'FaceColor',[.47 .67 .19],...
        'EdgeColor','k');
    set(handles.bar23,'BarWidth',K); hold on;
    
    axis(AxiScale4);
    xticks=[xmin2:50:xmax2]'; xticks=round(xticks/50)*50;
    set(gca,'XTick',xticks); set(gca,'XTickLabel',num2str(xticks))
    yticks4=[ymin4:1:ymax4]'; yticks4=ceil(yticks4/1)*1;
    set(gca,'YTick',yticks4); set(gca,'YTickLabel',num2str(yticks4))
    ylabel('Angular Rotation (^o/yr)'),grid on,
    
    disp('Spline path plotted.');
end
% Update handles structure
guidata(hObject,handles);


% --- Executes on button press in RunMean.
function RunMean_Callback(hObject, eventdata, handles)
% hObject    handle to RunMean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% prepare PM data for calculation
if isfield(handles,'LoadPMdata')==0
    disp('Please load paleomag data first!');
elseif isfield(handles,'LoadPMdata')==1
    LoadPMdata=handles.LoadPMdata;
    age=LoadPMdata(:,1);
    lonP=LoadPMdata(:,2);
    latP=LoadPMdata(:,3);
    A95=LoadPMdata(:,4);
    Q=7./LoadPMdata(:,6);  % (Torsvik 2012 in ESR P329)
    N=length(lonP);
    
    % pass parameters from text boxes
    Tinv=str2num(get(handles.Increment,'String'));
    S=str2num(get(handles.Smooth,'String'));
    intp=str2num(get(handles.Interpolation,'String'));
    window=str2num(get(handles.Window,'String'));
    latR=str2num(get(handles.latR,'String'));
    lonR=str2num(get(handles.lonR,'String'));
    
    % calculate running means and spline
    [dataRMM,dataRWNN,dataRWNN_intp,dataAuxRWNN_intp]=...
        RunMeanSpline(age,lonP,latP,A95,Q,N,Tinv,S,intp,window);
    
    % calculate the parameters for running mean
    [AgeRecRM,PlatRM,deltaPlatRM,AVRM,RotRM,RotVRM]=...
        PlatVRot(lonR,latR,dataRMM(:,1),dataRMM(:,2),dataRMM(:,3),dataRMM(:,4));
    
    axes(handles.axes1);
    % plot data in running window
    handles.hleg11=geoshow(dataRMM(:,3),dataRMM(:,2),'Color',[.75 .0 .75],...
        'LineWidth',2);
    handles.hleg12=geoshow(dataRMM(:,3),dataRMM(:,2), 'DisplayType','point',...
        'Marker','p','MarkerFaceColor',[.85 .7 1],'MarkerEdgeColor','k','markersize',12);
    % Add data label for weighted data point
    % Create index vector from grouping variable
    handles.hleg13=textm(dataRMM(:,3)+.3,dataRMM(:,2),...
        num2str(dataRMM(:,1)),'Color',[.75 .0 .75],'FontSize',10);
    % plot uncertainty for running mean A95RW
    dataRMMA95=[NaN,NaN];
    for i = 1:length(dataRMM(:,2))
        [IncSC,DecSC]= scircle1(dataRMM(i,3),dataRMM(i,2),dataRMM(i,4));
        dataRMMA95=[dataRMMA95;[IncSC,DecSC];[NaN,NaN]];
    end
    handles.hleg14=geoshow(dataRMMA95(:,1),dataRMMA95(:,2),...
        'DisplayType','line','linestyle','-',...
        'Color',[.75 .0 .75],'LineWidth',1);
    
    % save data
    handles.dataRMM=dataRMM;
    handles.dataRWNN=dataRWNN;
    handles.dataRWNN_intp=dataRWNN_intp;
    handles.dataAuxRWNN_intp=dataAuxRWNN_intp;
    handles.kinematicsRM.AgeRecRM=AgeRecRM;
    handles.kinematicsRM.PlatRM=PlatRM;
    handles.kinematicsRM.deltaPlatRM=deltaPlatRM;
    handles.kinematicsRM.AVRM=AVRM;
    handles.kinematicsRM.RotRM=RotRM;
    handles.kinematicsRM.RotVRM=RotVRM;
    
    % plot the relevant APWP parameters [.75 .0 .75]
    % 1) APWP velocity
    xmax2=handles.xmax2;
    xmin2=handles.xmin2;
    ymax2=ceil(max(handles.ymax2)/2)*2;
    axes(handles.axes2);AxiScale2=[xmin2 xmax2 0 ymax2];
    K=1;
    handles.bar11=bar(AgeRecRM,AVRM,'FaceColor',[.75 .0 .75], 'EdgeColor', 'k');
    set(handles.bar11,'BarWidth',K); hold on;
    
    axis(AxiScale2);
    xticks=[xmin2:50:xmax2]'; xticks=round(xticks/50)*50;
    set(gca,'XTick',xticks); set(gca,'XTickLabel',num2str(xticks))
    yticks=[0:5:ymax2]'; yticks=ceil(yticks/5)*5;
    set(gca,'YTick',yticks); set(gca,'YTickLabel',num2str(yticks))
    ylabel('APWP Velocity (cm/yr)'),grid on,
    
    % 2) paleolatitude variation
    ymax3=handles.ymax3;
    ymin3=handles.ymin3;
    axes(handles.axes3);AxiScale3=[xmin2 xmax2 ymin3 ymax3];
    
    handles.bar12=plot(AgeRecRM,PlatRM,'LineWidth',2.5,'Color',[.75 .0 .75]);
    hold on;
    
    axis(AxiScale3);
    xticks=[xmin2:50:xmax2]'; xticks=round(xticks/50)*50;
    set(gca,'XTick',xticks); set(gca,'XTickLabel',num2str(xticks))
    yticks3=[ymin3:10:ymax3]'; yticks3=round(yticks3/10)*10;
    set(gca,'YTick',yticks3); set(gca,'YTickLabel',num2str(yticks3))
    ylabel('Paleolatitude (^oN)'),grid on,
    
    % 3) rotation rate for reference site
    ymax4=ceil(max(handles.ymax4)/1)*1;
    ymin4=handles.ymin4;
    axes(handles.axes4); AxiScale4=[xmin2 xmax2 ymin4 ymax4];
    
    handles.bar13=bar(AgeRecRM,RotVRM,'FaceColor',[.75 .0 .75],'EdgeColor','k');
    set(handles.bar13,'BarWidth',K); hold on;
    
    axis(AxiScale4);
    xticks=[xmin2:50:xmax2]'; xticks=round(xticks/50)*50;
    set(gca,'XTick',xticks); set(gca,'XTickLabel',num2str(xticks))
    yticks4=[ymin4:1:ymax4]'; yticks4=ceil(yticks4/1)*1;
    set(gca,'YTick',yticks4); set(gca,'YTickLabel',num2str(yticks4))
    ylabel('Angular Rotation (^o/yr)'),grid on,
    
    disp('Running mean path plotted.');
end
% Update handles structure
guidata(hObject,handles);





% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
if isfield(handles,{'hPMdata','hAnot'})==0
    disp('Please load paleomag data first!');
elseif isfield(handles,{'hPMdata','hAnot'})==1
    axes(handles.axes1);
    
    % ------------------------
    % if this button is selected
    if (get(handles.radiobutton3,'Value') == get(handles.radiobutton3,'Max'))
        set(handles.hPMdataA95,'Visible','on');
    elseif (get(handles.radiobutton3,'Value') == get(handles.radiobutton3,'Min'))
        set(handles.hPMdataA95,'Visible','off');
    end
end

% Update handles structure
guidata(hObject,handles);


%-------------------------------------------------------------------------
function [dataRMM,dataRWNN,dataRWNN_intp,dataAuxRWNN_intp]=...
    RunMeanSpline(age,lonP,latP,A95,Q,N,Tinv,S,intp,window)
% count the number of poles in each time interval
Tstep=round((age(N)-age(1))/Tinv)+2;
Index=zeros(Tstep,1);
ageRW=zeros(Tstep,1);
for j=1:Tstep
    % assign the age interval for smoothing & interpolation process
    % Round down to the nearest multiple of Tinv
    ageRW(j)=floor((round(age(1)+Tinv*(j-1))-Tinv)/Tinv)*Tinv;
    
    if ageRW(j)<0
        ageRW(j)=0;  % ageRW(j)=0;
    end
    
end

if ageRW(1)==0 && ageRW(2)==0
    ageRW(1)=[]; Index(1)=[]; Tstep=Tstep-1;
end

IndexT=NaN(length(ageRW),4);
IndTi=NaN;
for j=1:length(ageRW)
    counter=0;
    for i=1:N
        if age(i)<ageRW(j)+floor(window/2*10)/10 ...
                && age(i)>=ageRW(j)-floor(window/2*10)/10
            counter=counter+1; IndTi=i;
        end
        
    end
    
    Index(j)=counter;
    % IndexT=[ageRW,counter,counterSTART,counterEND]
    IndexT(j,:)=[ageRW(j),counter,IndTi-counter+1,IndTi];
end

% unwrap data as suggested in the paper
lonPUW = lonP; latPUW=latP;

for i=2:length(lonPUW)
    if abs(lonPUW(i)-lonPUW(i-1))>270
        lonPUW(i)=lonPUW(i)+360;
    end
    if lonPUW(i)>450
        lonPUW(i)=lonPUW(i)-360;
    end
end

% Running average
dataRM=NaN(Tstep,5);
lonPRWN=zeros(Tstep,1);
latPRWN=zeros(Tstep,1);
QRW=zeros(Tstep,1);

Tctrl=floor(window/Tinv)-1;
dataRM=NaN(Tstep,5);
number= Index(1);

for k=1:Tstep
    number= Index(k);
    
    if number==0
        lonP_temp(k)=NaN;
        latP_temp(k)=NaN;
        lonPRW(k)=lonP_temp(k);
        latPRW(k)=latP_temp(k);
        A95RW(k)=NaN;
        KRW(k)=NaN;
        dataRM(k,:)=[lonPRW(k),latPRW(k),A95RW(k),KRW(k),number];
        lonPRWN(k)=NaN;
        latPRWN(k)=NaN;
        
    elseif number==1
        lonP_temp(k)=lonP(IndexT(k,3));
        latP_temp(k)=latP(IndexT(k,3));
        lonPRW(k)=lonP_temp(k);
        latPRW(k)=latP_temp(k);
        A95RW(k)=0;
        KRW(k)=0;
        dataRM(k,:)=[lonPRW(k),latPRW(k),A95RW(k),KRW(k),number];
        lonPRWN(k)=lonPUW(IndexT(k,3));
        latPRWN(k)=latPUW(IndexT(k,3));
        
    else
        
        [lonPRW,latPRW,A95RW,KRW,NRW]=...
            FishSpl(lonP(IndexT(k,3):IndexT(k,4)),...
            latP(IndexT(k,3):IndexT(k,4)));
        dataRM(k,:)=[lonPRW,latPRW,A95RW,KRW,NRW];
       
        % [DmW,ImW,QRW]=FishSplW(D,I,QT12)
        [DmW,ImW,QRWW]=FishSplW(lonPUW(IndexT(k,3):IndexT(k,4)),...
            latPUW(IndexT(k,3):IndexT(k,4)),Q(IndexT(k,3):IndexT(k,4)));
        lonPRWN(k)=DmW; latPRWN(k)=ImW; QRW(k)=QRWW;

    end
end


% combine averaged poles
dataRM=[ageRW,dataRM,Index];
dataRWN=[ageRW Index QRW lonPRWN latPRWN];

% romove the row with kappa=inf and NaN
dataRMM= dataRM(0== sum(isnan(dataRM), 2), :);

% fix the possible bug in the counter
if ageRW(1)==ageRW(2) && ageRW(1)==0 && Index(1)>0
    % newly average pole suggsted in the paper
    dataRWN(2,4)=sum(lonPUW(1:sum(Index(1:2)))./Q(1:sum(Index(1:2))))...
        /(sum(1./Q(1:sum(Index(1:2)))));
    dataRWN(2,5)=sum(latPUW(1:sum(Index(1:2)))./Q(1:sum(Index(1:2))))/...
        (sum(1./Q(1:sum(Index(1:2)))));
    dataRWN(2,3)=sum(1./Q(1:sum(Index(1:2))));
    dataRWN(2,2)=sum(Index(1:2));
    dataRWN(1,:)=[];
end

% remove all the rows where at least one column includes NaN
dataRWNN=dataRWN(0== sum(isnan(dataRWN), 2), :);

% calculate the GC distance between the means
GCD2=NaN(length(dataRWNN(:,1))-1,1);
for i=1:length(dataRWNN(:,1))-1
    GCD2(i)=distance(dataRWNN(i,5),dataRWNN(i,4),...
        dataRWNN(i+1,5),dataRWNN(i+1,4));
end

% trace a GC track connecting the nearest two points with GC>20;
for i=1:length(GCD2)
    if GCD2(i)>=10
        [latAuxRWNN,lonAuxRWNN]=track2('gc',dataRWNN(i,5),dataRWNN(i,4),...
            dataRWNN(i+1,5),dataRWNN(i+1,4),[],'degrees',3);
        if lonAuxRWNN(2)<0
            lonAuxRWNN(2)=lonAuxRWNN(2)+360;
        end
        AuxRWNN_temp(i,:)=[dataRWNN(i,1)+0.5*(dataRWNN(i+1,1)-dataRWNN(i,1)),...
            lonAuxRWNN(2),latAuxRWNN(2),...
            (dataRWNN(i,3)+dataRWNN(i+1,3))/2];
    else
        AuxRWNN_temp(i,:)=[dataRWNN(i,1)+0.5*(dataRWNN(i+1,1)-dataRWNN(i,1)),...
            NaN NaN NaN];
    end
end


% add the auxillary data to the running means and spline means
% AuxRWW=NaN(2*length(dataRWW(:,1)),3);
AuxRWNN_temp=[AuxRWNN_temp;NaN(1,4)];
for i=1:length(dataRWNN(:,1))
    AuxRWNN(2*i-1,:)=[dataRWNN(i,1),dataRWNN(i,4) dataRWNN(i,5) dataRWNN(i,3)];
    AuxRWNN(2*i,:)=AuxRWNN_temp(i,:);
end
dataAuxRWNN=AuxRWNN(0== sum(isnan(AuxRWNN), 2), :);

%  smooth & interpolate the newly weighted poles in the time axis
% defined time interval & step for interpolation
age_intp=age(1):intp:age(N)+Tinv;
% Round down to the nearest multiple of Tinv
% age_intp=floor(age_intp);
age_intp=(floor((round(age_intp)-intp)/intp)+1)*intp;

% data_intp=sphspl(ageP,lonP,latP,Q,age_intp,S)
% data_intp=[age_intp' lonPwrap_intp' latPwrap_intp'];
dataRWNN_intp=sphspl(dataRWNN(:,1),dataRWNN(:,4),dataRWNN(:,5),...
    dataRWNN(:,3),age_intp,S);

dataAuxRWNN_intp=sphspl(dataAuxRWNN(:,1),dataAuxRWNN(:,2),...
    dataAuxRWNN(:,3),dataAuxRWNN(:,4),age_intp,S);


% do spline
function data_intp=sphspl(ageP,lonP,latP,Q,age_intp,S)
% wrap the data to sphere
lonP=unwrap(lonP./(180/pi),pi).*(180/pi);

% Interpolate data with weight using cubic smoothing spline
lonP_intp=csaps(ageP,lonP,1/S,age_intp,Q);
latP_intp=csaps(ageP,latP,1/S,age_intp,Q);

% wrap the data to sphere
% [lonPW_intp,latPW_intp]=toDegrees('radians',lonPW_intp,latPW_intp);
lonPwrap_intp=(lonP_intp);
latPwrap_intp=latP_intp;
data_intp=[age_intp' lonPwrap_intp' latPwrap_intp'];


% calculate fisher parameters
function [Dm,Im,alpha95,kappa,N]=FishSpl(D,I)

D=D./(180/pi);
I=I./(180/pi);
[x,y,z]=sph2cart(D,I,1);
N=length(x);

if N>1
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
elseif N==1
    Dm=D; Im=I; alpha95=0; kappa=0;N=1;
elseif N==0
    Dm=NaN; Im=NaN; alpha95=NaN; kappa=NaN;N=0;
end

if Dm<0
    Dm=Dm+360;
end

% special trick for poles in range [0,10] for APWP construction
if Dm>=0 && Dm<=10
    Dm=Dm+360;
end

% calculate weighted means (Jupp & Kent 1987)
function [DmW,ImW,QRW]=FishSplW(D,I,QT12)

D=D./(180/pi);
I=I./(180/pi);
[x,y,z]=sph2cart(D,I,1);
N=length(x);

if N>1
R2=(sum(x))^2+(sum(y))^2+(sum(z))^2;
R=sqrt(R2);

% weighted means
m1=sum(x./QT12)/(sum(1./QT12));
m2=sum(y./QT12)/(sum(1./QT12));
m3=sum(z./QT12)/(sum(1./QT12));
QRW=1/sum(1./QT12);

% Convert back to (Im,Dm)
[DmW,ImW]=cart2sph(m1,m2,m3);
DmW=DmW.*(180/pi);
ImW=ImW.*(180/pi);
elseif N==1
    DmW=D; ImW=I; alpha95=0; kappa=0;N=1;
elseif N==0
    DmW=NaN; ImW=NaN; alpha95=NaN; kappa=NaN;N=0;
end

if DmW<0
    DmW=DmW+360;
end

% wrap poles in range [0,10]
if DmW>=0 && DmW<=10
    DmW=DmW+360;
end


% parameters calculation
function [AgeRec, Plat, deltaPlat, AV, Rot, RotV]=...
                  PlatVRot(lonR,latR,AgeRec,lonPRec,latPRec,A95Rec)

% import data
NRec=length(lonPRec);

% calculating the paleolatitude & rotation for SCB
OS=zeros(NRec,1);
Plat=zeros(NRec,1);
deltaPlat=zeros(NRec,1);
Dec=zeros(NRec,1);
Rot=zeros(NRec,1);
AV=zeros(NRec,1);
deltaRot=zeros(NRec,1);
betaRec=zeros(NRec,1);

for i=1:NRec
    % angular distance SR from reference site to paleopole
    OS(i)=distance(latR,lonR,latPRec(i),lonPRec(i));
    % expected inclination I & expected declination D
    Inc(i)=180/pi*atan2(2,tand(OS(i)));
    % longitudinal difference between pole and site
	betaRec(i)=lonPRec(i)-lonR;
    Dec(i)=azimuth(latR,lonR,latPRec(i),lonPRec(i));
    Rot(i)=0-Dec(i);
    deltaRot(i)=A95Rec(i);
    Plat(i)=90-OS(i);  % paleolatitude
    deltaPlat(i)=A95Rec(i);
end

% calculate the drift (AV) and rotation (RotV) velocity variation
RotV(1)=Dec(1)/AgeRec(1);
for i=1:NRec-1
    % angular distance between nearest two poles
    AD(i)=distance(latPRec(i+1),lonPRec(i+1),latPRec(i),lonPRec(i));
    % convert into cm/yr
    AV(i) = deg2km(AD(i))/(AgeRec(i+1)-AgeRec(i))*1e5/1e6;
    RotV(i+1)=(Dec(i)-Dec(i+1))/(AgeRec(i+1)-AgeRec(i));
end


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

%--------------------------------------------------------------------------
