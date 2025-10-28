function varargout = PMTec_PtKin(varargin)
% PMTEC_PTKIN MATLAB code for PMTec_PtKin.fig
%      PMTEC_PTKIN, by itself, creates a new PMTEC_PTKIN or raises the existing
%      singleton*.
%
%      H = PMTEC_PTKIN returns the handle to a new PMTEC_PTKIN or the handle to
%      the existing singleton*.
%
%      PMTEC_PTKIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PMTEC_PTKIN.M with the given input arguments.
%
%      PMTEC_PTKIN('Property','Value',...) creates a new PMTEC_PTKIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PMTec_PtKin_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PMTec_PtKin_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PMTec_PtKin

% Last Modified by GUIDE v2.5 05-Mar-2015 22:01:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PMTec_PtKin_OpeningFcn, ...
                   'gui_OutputFcn',  @PMTec_PtKin_OutputFcn, ...
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


% --- Executes just before PMTec_PtKin is made visible.
function PMTec_PtKin_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PMTec_PtKin (see VARARGIN)

% Choose default command line output for PMTec_PtKin
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
ylabel('Absolute Velocity (cm/yr)'),grid on

axes(handles.axes3); 
[handles.haxesP3,hlineP3a,hlineP3b]=plotyy(NaN,NaN,NaN,NaN);
axis([0 300 0 20]);
set(handles.haxesP3,'XTick',0:50:300); 
set(handles.haxesP3(1),'YTick',0:5:20);set(handles.haxesP3(2),'YTick',0:5:20);
set(handles.haxesP3(1),'YTickLabel',{'0','5','10','15','20'});
set(handles.haxesP3(2),'YTickLabel',{'0','5','10','15','20'});
ylabel(handles.haxesP3(1),'Lat Velocity (cm/yr)');
ylabel(handles.haxesP3(2),'Lon Velocity (cm/yr)');
grid on, hold off

axes(handles.axes4);
[handles.haxesP4,hlineP4a,hlineP4b]=plotyy(NaN,NaN,NaN,NaN);
axis([0 300 0 60]);
set(handles.haxesP4,'XTick',0:50:300);
set(handles.haxesP4(1),'YTick',0:15:60);set(handles.haxesP4(2),'YTick',0:15:60);
set(handles.haxesP4(1),'YTickLabel',{'0','15','30','45','60'});
ylabel(handles.haxesP4(1),'PaleoLatitude (^oN)');
ylabel(handles.haxesP4(2),'PaleoLongitude (^oE)');
xlabel('Age (Ma)'),grid on, hold off

% set up other initial parameters
set(handles.latR,'string','NaN');
set(handles.lonR,'string','NaN');
handles.ColorCodeS=jet; % autumn

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PMTec_PtKin wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PMTec_PtKin_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



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
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
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
    % FFPNPM=Full File Path Name of PM data
    FullName=[PathName,FileName];
    load(FullName);
    if exist('RecSt','var')==0
        disp('Please load the correct RecSt file!');
    elseif exist('RecSt','var')==1
               
        % pass the RecSt to text box of ref
        set(handles.lonR,'string',num2str(RecSt(2).f4(1,1)));
        set(handles.latR,'string',num2str(RecSt(2).f4(1,2)));
               
        % calculation of kinematic parameters: Velo, LatV, LonV (cm/yr)
        % make RecSt.f8=[age,Velo,LatV,LonV]
        LonV=NaN(length(RecSt(2).f4(:,2)),1);
        LatV=NaN(length(RecSt(2).f4(:,2)),1);
        Velo=NaN(length(RecSt(2).f4(:,2)),1);
        for i=1:length(RecSt(2).f4(:,2))-1
            LonV(i)=abs(deg2km(RecSt(2).f4(i+1,1)-RecSt(2).f4(i,1))/...
                (RecSt(1).f8(i+1,1)-RecSt(1).f8(i,1))*0.1);
            LatV(i)=abs(deg2km(RecSt(2).f4(i+1,2)-RecSt(2).f4(i,2))/...
                (RecSt(1).f8(i+1,1)-RecSt(1).f8(i,1))*0.1);
            Velo(i)=deg2km(distance(RecSt(2).f4(i+1,2),RecSt(2).f4(i+1,1),...
                RecSt(2).f4(i,2),RecSt(2).f4(i,1)))/...
                (RecSt(1).f8(i+1,1)-RecSt(1).f8(i,1))*0.1;
            RecSt(1).f8(i,2)=Velo(i);
            RecSt(1).f8(i,3)=LatV(i);
            RecSt(1).f8(i,4)=LonV(i);
        end
        RecSt(1).f8(i+1,2)=NaN; RecSt(1).f8(i+1,3)=NaN; RecSt(1).f8(i+1,4)=NaN;
        
        % make PlateRec=[ref,plate,[age,V,LatV,LonV]] from RecSt
        PlateRec=struct('f1',{NaN},'f2',{NaN},'f3',{NaN});
        PlateRec(1).f1=RecSt(2).f4;
        PlateRec(1).f3=RecSt(1).f8;
        for i=1:length(RecSt(2).f4(:,1))
            PlateRec(i).f2=RecSt(i).f6;
        end
        handles.PlateRec=PlateRec;
        
        % plot absolute velocity
        Tstep=50;
        axes(handles.axes2);
        % pink [1 .6 .78]; purple [.85 .7 1]; green [.47 .67 .19];
        
        handles.barV=bar(RecSt(1).f8(:,1),RecSt(1).f8(:,2),...
            'FaceColor',[1 .6 .78],'EdgeColor','k');
        set(handles.barV,'BarWidth',1); hold on;
        ymax2=ceil(max(RecSt(1).f8(:,2))/5)*5;
        AxiScale2=[min(RecSt(1).f8(:,1)) ...
           ceil(max(RecSt(1).f8(:,1))/Tstep)*Tstep  0 ymax2];
        axis(AxiScale2);
        xticks=[min(RecSt(1).f8(:,1)):Tstep:max(RecSt(1).f8(:,1))]';
        xticks=round(xticks/Tstep)*Tstep;
        set(gca,'XTick',xticks); set(gca,'XTickLabel',num2str(xticks))
        yticks2=[0:5:ymax2]'; yticks2=ceil(yticks2/5)*5;
        set(gca,'YTick',yticks2); set(gca,'YTickLabel',num2str(yticks2));
        ylabel('Absolute Velocity (cm/yr)'),grid on
                
        % plot latV and lonV
        cla(handles.axes3);axes(handles.axes3);
        [handles.haxesP3,hlatv,hlonv]=plotyy(RecSt(1).f8(:,1),RecSt(1).f8(:,3),...
            RecSt(1).f8(:,1),RecSt(1).f8(:,4));
        set(hlatv,'LineStyle','-','LineWidth',2);
        set(hlonv,'LineStyle','-','LineWidth',2);
        % axis(handles.haxesP3(1),AxiScale2);axis(handles.haxesP3(2),AxiScale2);
        handles.haxesP3(1).XLim=[AxiScale2(1) AxiScale2(2)];
        handles.haxesP3(2).XLim=[AxiScale2(1) AxiScale2(2)];
        set(handles.haxesP3(1),'XTick',xticks); set(handles.haxesP3(1),'XTickLabel',num2str(xticks))
        set(handles.haxesP3(2),'XTick',xticks); set(handles.haxesP3(2),'XTickLabel',num2str(xticks))
        ylabel(handles.haxesP3(1),'Lat Velocity (cm/yr)');
        ylabel(handles.haxesP3(2),'Lon Velocity (cm/yr)'); grid on
        
        % plot PLat and PLon
        cla(handles.axes4);axes(handles.axes4);
        [handles.haxesP4,hplat,hplon]=plotyy(RecSt(1).f8(:,1),RecSt(2).f4(:,2),...
            RecSt(1).f8(:,1),RecSt(2).f4(:,1));
        AxiScale4L=[AxiScale2(1) AxiScale2(2)...
            floor(min(RecSt(2).f4(:,2))/15)*15 ceil(max(RecSt(2).f4(:,2))/15)*15];
        AxiScale4R=[AxiScale2(1) AxiScale2(2)...
            floor(min(RecSt(2).f4(:,1))/15)*15 ceil(max(RecSt(2).f4(:,1))/15)*15];
        axis(handles.haxesP4(1),AxiScale4L);axis(handles.haxesP4(2),AxiScale4R);
        lim1=handles.haxesP4(1); lim2=handles.haxesP4(2);
        lim1Ystep=abs(lim1.YLim(2)-lim1.YLim(1))/20;
        lim2Ystep=abs(lim2.YLim(2)-lim2.YLim(1))/20;
        yticks2P4=linspace(lim2.YLim(1), lim2.YLim(2),4);
        set(handles.haxesP4(2),'YTick',yticks2P4);
        set(handles.haxesP4(2),'YTickLabel',num2str(yticks2P4'));
        yticks1P4=linspace(lim1.YLim(1), lim1.YLim(2),4);
        set(handles.haxesP4(1),'YTick',yticks1P4);
        set(handles.haxesP4(1),'YTickLabel',num2str(yticks1P4'));
        % lim1=handles.haxesP4(1), lim2=handles.haxesP4(2)
        set(hplat,'LineStyle','-','LineWidth',2);
        set(hplon,'LineStyle','-','LineWidth',2);
        ylabel(handles.haxesP4(1),'PaleoLatitude (^oN)');
        ylabel(handles.haxesP4(2),'PaleoLongitude (^oE)');
        xlabel('Age (Ma)'),grid on,
        
        % plot the ref and contour on axes1
        axes(handles.axes1);
        [ind,MapCol]=ColorCodeCal(zeros(length(RecSt(2).f4(:,2)),1),...
            handles.ColorCodeS);
        for i=1:length(RecSt(2).f4(:,2))
            % plot reference site
            geoshow(RecSt(2).f4(i,2), RecSt(2).f4(i,1),'DisplayType','point',...
                'Marker','o','MarkerEdgeColor',MapCol(ind(i),:),'MarkerSize',7);
            
            % plot plate contour
            geoshow(RecSt(i).f6(:,2), RecSt(i).f6(:,1),'DisplayType','line',...
                'linestyle','-','color',MapCol(ind(i),:),'LineWidth',1.5);
        end
        caxis([min(PlateRec(1).f3(:,1)) max(PlateRec(1).f3(:,1))]);
        % apply new colormap
        colormap(jet(length(RecSt(2).f4(:,2))));
        
        save(FullName,'RecSt');
        disp('RecSt loaded and plotted.');
    end
elseif nbfiles==0
%     disp('Please select a file!')
end

guidata(hObject, handles);


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% cla(handles.axes1);
cla(handles.axes2);cla(handles.axes3);cla(handles.axes4);

% handles.view1_ini=str2num(get(handles.view1,'String'));
% handles.view2_ini=str2num(get(handles.view2,'String'));
% handles.view3_ini=str2num(get(handles.view3,'String'));
% 
% mapview=[handles.view1_ini,...
%          handles.view2_ini,...
%          handles.view3_ini];
% 
% % initiate map axes and all the map background data
% axes(handles.axes1); axis off,axesm(handles.ProjT) % mollweid;
% setm(gca,'Origin', mapview), framem on; tightmap; gridm on
% % handles.ProjT='ortho';
% 
% % 2) load coastline
% coast=load('coast');
% handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
%     'FaceColor',[.83 .82 .78],'edgecolor','none');


% set(handles.view1,'string',num2str(60));
% set(handles.view2,'string',num2str(90));
% set(handles.view3,'string',num2str(30));

% 3) set up APWP kinematics
axes(handles.axes2); axis([0 300 0 20]);
set(gca,'XTick',0:50:300);
set(gca,'YTick',0:5:20); set(gca,'YTickLabel',{'0','5','10','15','20'})
ylabel('Absolute Velocity (cm/yr)'),grid on

axes(handles.axes3); 
[handles.haxesP3,hlineP3a,hlineP3b]=plotyy(NaN,NaN,NaN,NaN);
axis([0 300 0 20]);
set(handles.haxesP3,'XTick',0:50:300); 
set(handles.haxesP3(1),'YTick',0:5:20);set(handles.haxesP3(2),'YTick',0:5:20);
set(handles.haxesP3(1),'YTickLabel',{'0','5','10','15','20'});
set(handles.haxesP3(2),'YTickLabel',{'0','5','10','15','20'});
ylabel(handles.haxesP3(1),'Lat Velocity (cm/yr)');
ylabel(handles.haxesP3(2),'Lon Velocity (cm/yr)');
grid on, hold off

axes(handles.axes4);
[handles.haxesP4,hlineP4a,hlineP4b]=plotyy(NaN,NaN,NaN,NaN);
axis([0 300 0 60]);
set(handles.haxesP4,'XTick',0:50:300);
set(handles.haxesP4(1),'YTick',0:15:60);set(handles.haxesP4(2),'YTick',0:15:60);
set(handles.haxesP4(1),'YTickLabel',{'0','15','30','45','60'});
ylabel(handles.haxesP4(1),'PaleoLatitude (^oN)');
ylabel(handles.haxesP4(2),'PaleoLongitude (^oE)');
xlabel('Age (Ma)'),grid on, hold off

% set up other initial parameters
% set(handles.latR,'string','NaN');
% set(handles.lonR,'string','NaN');
% handles.ColorCodeS=jet; % autumn
disp('Reset kinematic plots.');
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in ExportResults.
function ExportResults_Callback(hObject, eventdata, handles)
% hObject    handle to ExportResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'PlateRec')==0
    disp('Please do the calculation first!');
elseif isfield(handles,'PlateRec')==1
    PlateRec=handles.PlateRec;
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
        disp('Reconstruction file PlateRec.mat exported.');
    elseif nbfiles==0
        %     disp('Please name the data!');
    end
end
guidata(hObject, handles);


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2



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


% --- Executes on button press in ExportStage.
function ExportStage_Callback(hObject, eventdata, handles)
% hObject    handle to ExportStage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'Stage')==0
    disp('Please calculate stage from finite poles first!');
elseif isfield(handles,'Stage')==1
    Stage=handles.Stage;
    
    % save .mat file
    [FileName,PathName]=uiputfile('*.txt','Save Stage Euler Parameters As');
    if FileName ~= 0
        nbfiles = 1;
    else
        nbfiles = 0;
    end
    
    if nbfiles==1
        FullName=[PathName,FileName];
        save(FullName,'Stage','-ascii','-tabs');
        disp('Calculated stage poles (.txt) exported.');
    elseif nbfiles==0
        disp('Please name the data!');
    end
end
guidata(hObject, handles);

% --- Executes on button press in ImportFinite.
function ImportFinite_Callback(hObject, eventdata, handles)
% hObject    handle to ImportFinite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% FNPM=Filename of PM data; FPPM=File Path of PM data
[FileName,PathName] = uigetfile( ...
{'*.xlsx;*.xls;*.txt;*.dat',...
 'Excel Workbook (*.xlsx,*.xls)';
   '*.txt',  'Tab delimited (*.txt)'; ...
   '*.dat','Data files (*.dat)'}, ...
   'Select a file [lonE, latE, Omega]');
if FileName ~= 0
    nbfiles = 1;
else
    nbfiles = 0;
end

if nbfiles==1
    FullName=[PathName,FileName];
    % Data of PM data
    if FileName(length(FileName)-4:length(FileName))=='.xlsx'
        Finite=xlsread(FullName);
    elseif FileName(length(FileName)-3:length(FileName))=='.xls'
        Finite=xlsread(FullName);
    else
        Finite=importdata(FullName);
    end
    handles.Finite=Finite;
    
    % convert finite to stage
    Stage=finite2stage(Finite(:,2:4));
    Stage=[Finite(:,1),Stage];
    handles.Stage=Stage;
    
    disp('Finite poles loaded and converted into stage poles.');
    
elseif nbfiles==0
    disp('Please select a file!')
end

guidata(hObject, handles);


% --- Executes on button press in ExportFinite.
function ExportFinite_Callback(hObject, eventdata, handles)
% hObject    handle to ExportFinite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'Finite')==0
    disp('Please calculate finite from stage poles first!');
elseif isfield(handles,'Finite')==1
    Finite=handles.Finite;
    
    % save .mat file
    [FileName,PathName]=uiputfile('*.txt','Save Finite Euler Parameters As');
    if FileName ~= 0
        nbfiles = 1;
    else
        nbfiles = 0;
    end
    
    if nbfiles==1
        FullName=[PathName,FileName];
        save(FullName, 'Finite','-ascii','-tabs');
        disp('Calculated finite poles (.txt) exported.');
    elseif nbfiles==0
        %     disp('Please name the data!');
    end
end
guidata(hObject, handles);

% --- Executes on button press in ImportStage.
function ImportStage_Callback(hObject, eventdata, handles)
% hObject    handle to ImportStage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% FNPM=Filename of PM data; FPPM=File Path of PM data
[FileName,PathName] = uigetfile( ...
{'*.xlsx;*.xls;*.txt;*.dat',...
 'Excel Workbook (*.xlsx,*.xls)';
   '*.txt',  'Tab delimited (*.txt)'; ...
   '*.dat','Data files (*.dat)'}, ...
   'Select a file [lonE, latE, Omega]');
if FileName ~= 0
    nbfiles = 1;
else
    nbfiles = 0;
end

if nbfiles==1
    FullName = strcat(PathName,FileName);
    % Data of PM data
    if FileName(length(FileName)-4:length(FileName))=='.xlsx'
        Stage=xlsread(FullName);
    elseif FileName(length(FileName)-3:length(FileName))=='.xls'
        Stage=xlsread(FullName);
    else
        Stage=importdata(FullName);
    end
    handles.Stage=Stage;
    
    % convert stage to finite
    Finite=stage2finite(Stage(:,2:4));
    Finite=[Stage(:,1),Finite];
    handles.Finite=Finite;
    
    disp('Stage poles loaded and converted into finite poles.');
    
elseif nbfiles==0
    disp('Please select a file!')
end

guidata(hObject, handles);


% --- Executes on button press in LoadFinite.
function LoadFinite_Callback(hObject, eventdata, handles)
% hObject    handle to LoadFinite (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% FNPM=Filename of PM data; FPPM=File Path of PM data
[FileName,PathName] = uigetfile( ...
{'*.xlsx;*.xls;*.txt;*.dat',...
 'Excel Workbook (*.xlsx,*.xls)';
   '*.txt',  'Tab delimited (*.txt)'; ...
   '*.dat','Data files (*.dat)'}, ...
   'Load Finite Poles For Reconstructions [lonE, latE, Omega]');
if FileName ~= 0
    nbfiles = 1;
else
    nbfiles = 0;
end

if nbfiles==1
    FullName = strcat(PathName,FileName);
    % Finite rotations
    if FileName(length(FileName)-4:length(FileName))=='.xlsx'
        FiniteR=xlsread(FullName);
    elseif FileName(length(FileName)-3:length(FileName))=='.xls'
        FiniteR=xlsread(FullName);
    else
        FiniteR=importdata(FullName);
    end
    handles.FiniteR=FiniteR;
    
    % convert finite to stage
    StageR=finite2stage(FiniteR(:,2:4));
    StageR=[FiniteR(:,1),StageR];
    handles.StageR=StageR;
    
    disp('Finite rotation poles loaded.');
    
elseif nbfiles==0
%     disp('Please select a file!')
end
guidata(hObject, handles);


function latR_Callback(hObject, eventdata, handles)
% hObject    handle to latR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of latR as text
%        str2double(get(hObject,'String')) returns contents of latR as a double
delete(handles.href);
axes(handles.axes1);
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



function lonR_Callback(hObject, eventdata, handles)
% hObject    handle to lonR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lonR as text
%        str2double(get(hObject,'String')) returns contents of lonR as a double
delete(handles.href);
axes(handles.axes1);
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


% --- Executes on button press in LoadGeometry.
function LoadGeometry_Callback(hObject, eventdata, handles)
% hObject    handle to LoadGeometry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% FNPM=Filename of PM data; FPPM=File Path of PM data
[FileName,PathName] = uigetfile( ...
{'*.xlsx;*.xls;*.txt;*.dat;*.shp',...
 'Excel Workbook (*.xlsx,*.xls)';
   '*.txt',  'Tab delimited (*.txt)'; ...
   '*.dat','Data files (*.dat)'; ...
   '*.shp','Shape files (*.shp)'}, ...
   'Load Plate Contour in [lon, lat]');
if FileName ~= 0
    nbfiles = 1;
else
    nbfiles = 0;
end

if nbfiles==1
    FullName=[PathName,FileName];
    if FileName(length(FileName)-4:length(FileName))=='.xlsx'
        LoadGeometry=xlsread(FullName);
    elseif FileName(length(FileName)-3:length(FileName))=='.xls'
        LoadGeometry=xlsread(FullName);
    elseif FileName(length(FileName)-3:length(FileName))=='.shp'
        LoadPlate2=shaperead(FullName);
        LoadPlate1X=[]; LoadPlate1Y=[];
        for i=1:length(LoadPlate2)
            LoadPlate1X=[LoadPlate1X,LoadPlate2(i).X];
            LoadPlate1Y=[LoadPlate1Y,LoadPlate2(i).Y];
        end
        LoadGeometry=[LoadPlate1X',LoadPlate1Y'];
    else
        LoadGeometry=importdata(FullName);
    end
    handles.LoadGeometry=LoadGeometry;
    
    % pass the LoadGeometry to text box of ref
    set(handles.lonR,'string',num2str(handles.LoadGeometry(1,1)));
    set(handles.latR,'string',num2str(handles.LoadGeometry(1,2)));
    
    % plot the contour
    axes(handles.axes1);
    handles.hContour=geoshow(LoadGeometry(:,2),LoadGeometry(:,1),'DisplayType',...
        'line','linestyle','--','color',[0 .5 0],'LineWidth',1.5);
    
    % plot the reference site
    axes(handles.axes1);
    handles.href=geoshow(str2num(get(handles.latR,'String')),...
        str2num(get(handles.lonR,'String')),...
        'DisplayType','point','Marker','o','MarkerSize',8,...
        'MarkerFaceColor',[1 .6 .78],'MarkerEdgeColor','k','LineWidth',1);
    
    disp('Plate contour loaded.');
    
elseif nbfiles==0
%     disp('Please select a file!')
end

guidata(hObject,handles);



% --- Executes on button press in CalcPlot.
function CalcPlot_Callback(hObject, eventdata, handles)
% hObject    handle to CalcPlot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,{'LoadGeometry','FiniteR','StageR'})==0
    disp('Please load plate contour and finite poles first!');
elseif isfield(handles,{'LoadGeometry','FiniteR','StageR'})==1
    LoadGeometry=handles.LoadGeometry;
    FiniteR=handles.FiniteR;
    StageR=handles.StageR;
    
    % pass the results to text box
    set(handles.lonR,'string',num2str(get(handles.lonR,'String')));
    set(handles.latR,'string',num2str(get(handles.latR,'String')));
    
    % make PlateRec.mat=[ref,plate,[age,V,LatV,LonV]]
    PlateRec=struct('f1',{NaN},'f2',{NaN},'f3',{NaN});
    
    % do reconstructions
    % [lonMR,latMR]=step2_Wing_Rot(lonM,latM,lonE,latE,omega)
    ref=NaN(length(FiniteR(:,2)),2);
    for i=1:length(FiniteR(:,2))
        % rotate reference site
        [lonMR,latMR]=step2_Wing_Rot(str2num(get(handles.lonR,'String')),...
            str2num(get(handles.latR,'String')),...
            FiniteR(i,2),FiniteR(i,3),FiniteR(i,4));
        ref(i,:)=[lonMR,latMR];
        
        % rotate plate contour
        [lonPC,latPC]=step2_Wing_Rot(LoadGeometry(:,1),LoadGeometry(:,2),...
            FiniteR(i,2),FiniteR(i,3),FiniteR(i,4));
        PlateRec(i).f2=[lonPC',latPC'];
        
    end
    
    PlateRec(1).f1=ref;
    PlateRec(1).f3=FiniteR(:,1);
    
    % make PlateRec.mat=[ref,plate,[age,V,LatV,LonV]]
    % calculation of kinematic parameters
    % Velo, LatV, LonV (cm/yr)
    LonV=NaN(length(PlateRec(1).f1(:,1)),1);
    LatV=NaN(length(PlateRec(1).f1(:,1)),1);
    Velo=NaN(length(PlateRec(1).f1(:,1)),1);
    for i=1:length(PlateRec(1).f1(:,1))-1
        LonV(i)=abs(deg2km(PlateRec(1).f1(i+1,1)-PlateRec(1).f1(i,1))/...
            (FiniteR(i+1,1)-FiniteR(i,1))*0.1);
        LatV(i)=abs(deg2km(PlateRec(1).f1(i+1,2)-PlateRec(1).f1(i,2))/...
            (FiniteR(i+1,1)-FiniteR(i,1))*0.1);
        Velo(i)=deg2km(distance(PlateRec(1).f1(i+1,2),PlateRec(1).f1(i+1,1),...
            PlateRec(1).f1(i,2),PlateRec(1).f1(i,1)))/...
            (FiniteR(i+1,1)-FiniteR(i,1))*0.1;
        PlateRec(1).f3(i,2)=Velo(i);
        PlateRec(1).f3(i,3)=LatV(i);
        PlateRec(1).f3(i,4)=LonV(i);
    end
    PlateRec(1).f3(i+1,2)=NaN;
    PlateRec(1).f3(i+1,3)=NaN;
    PlateRec(1).f3(i+1,4)=NaN;
    
    handles.PlateRec=PlateRec;
    
    % plot absolute velocity
    Tstep=50;
    axes(handles.axes2);
    % pink [1 .6 .78]; purple [.85 .7 1]; green [.47 .67 .19];
    
    % PlateRec.mat=[ref,plate,[age,V,LatV,LonV]]
    handles.barV=bar(FiniteR(:,1),PlateRec(1).f3(:,2),...
        'FaceColor',[1 .6 .78],'EdgeColor','k');
    set(handles.barV,'BarWidth',1); hold on;
    ymax2=ceil(max(PlateRec(1).f3(:,2))/2)*2;
%     AxiScale2=[min(FiniteR(:,1)) max(FiniteR(:,1)) 0 ymax2];
    AxiScale2=[min(FiniteR(:,1)) ceil(max(FiniteR(:,1))/Tstep)*Tstep  0 ymax2];
    axis(AxiScale2);
    xticks=[min(FiniteR(:,1)):Tstep:max(FiniteR(:,1))]';
    xticks=round(xticks/Tstep)*Tstep;
    set(gca,'XTick',xticks); set(gca,'XTickLabel',num2str(xticks))
    yticks2=[0:5:ymax2]'; yticks2=ceil(yticks2/5)*5;
    set(gca,'YTick',yticks2); set(gca,'YTickLabel',num2str(yticks2));
    ylabel('Absolute Velocity (cm/yr)'),grid on
    
    % plot latV and lonV
    cla(handles.axes3);axes(handles.axes3);
    [handles.haxesP3,hlatv,hlonv]=plotyy(FiniteR(:,1),PlateRec(1).f3(:,3),...
        FiniteR(:,1),PlateRec(1).f3(:,4));
    set(hlatv,'LineStyle','-','LineWidth',2);
    set(hlonv,'LineStyle','-','LineWidth',2);
    xticks3=[min(FiniteR(:,1)):Tstep:max(FiniteR(:,1))]';
    xticks3=round(xticks3/Tstep)*Tstep;
    set(handles.haxesP3,'XTick',min(FiniteR(:,1)):Tstep:max(FiniteR(:,1)));
    set(handles.haxesP3,'XTickLabel',num2str(xticks3));
    
    ylabel(handles.haxesP3(1),'Lat Velocity (cm/yr)');
    ylabel(handles.haxesP3(2),'Lon Velocity (cm/yr)'); grid on
    
    % plot PLat and PLon
    cla(handles.axes4);axes(handles.axes4);
    [handles.haxesP4,hplat,hplon]=plotyy(FiniteR(:,1),PlateRec(1).f1(:,2),...
        FiniteR(:,1),PlateRec(1).f1(:,1));
    set(hplat,'LineStyle','-','LineWidth',2);
    set(hplon,'LineStyle','-','LineWidth',2);
    xticks4=[min(FiniteR(:,1)):Tstep:max(FiniteR(:,1))]';
    xticks4=round(xticks4/Tstep)*Tstep;
    set(handles.haxesP4,'XTick',min(FiniteR(:,1)):Tstep:max(FiniteR(:,1)));
    set(handles.haxesP4,'XTickLabel',num2str(xticks4));
    ylabel(handles.haxesP4(1),'PaleoLatitude (^oN)');
    ylabel(handles.haxesP4(2),'PaleoLongitude (^oE)');
    xlabel('Age (Ma)'),grid on, hold off
    
    % plot the ref and contour on axes1
    axes(handles.axes1);
    [ind,MapCol]=ColorCodeCal(zeros(length(FiniteR(:,2)),1),...
        handles.ColorCodeS);
    for i=1:length(FiniteR(:,2))
        % plot reference site
        geoshow(PlateRec(1).f1(i,2), PlateRec(1).f1(i,1),'DisplayType','point',...
            'Marker','o','MarkerEdgeColor',MapCol(ind(i),:),'MarkerSize',7);
        
        % plot plate contour
        geoshow(PlateRec(i).f2(:,2), PlateRec(i).f2(:,1),'DisplayType','line',...
            'linestyle','-','color',MapCol(ind(i),:),'LineWidth',1.5);
        
    end
    caxis([min(PlateRec(1).f3(:,1)) max(PlateRec(1).f3(:,1))]);
    
    disp('Data plotted.');
end
guidata(hObject, handles);
 

%--------------------------------------------------------------------------
function finite=stage2finite(stage)
% Construct structure data for reconstructions
value1={NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
       NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
       NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
       NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
       NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN};
% value2={NaN,NaN,NaN};
RotMat=struct('f',value1);
RotMat_temp=RotMat;
finite=zeros(length(stage(:,1)),3);

% setup rotation matrix from Euler parameters
% RotMat=step2_Wing_RotMatrix(lonE,latE,omega)
for i=1:length(stage(:,1))
    RotMat(i).f=step2_Wing_RotMatrix(stage(i,1),stage(i,2),stage(i,3)); 
end

RotMat_temp(1).f=RotMat(1).f;
% calculate the finite rotation poles
for i=1:length(stage(:,1))
    RotMat_temp(i+1).f=RotMat(i+1).f*RotMat_temp(i).f;    
    
end

% Calculate Euler parameters from rotation matrix 
% [lonE,latE,omega]=step2_Wing_RotM2Euler(RotMat)
for i=1:length(stage(:,1))
    [lonE,latE,omega]=step2_Wing_RotM2Euler(RotMat_temp(i).f);
    finite(i,:)=[lonE,latE,omega];
end

function stage=finite2stage(finite)
% Construct structure data for reconstructions
value1={NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
       NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
       NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
       NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;...
       NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN;NaN};
% value2={NaN,NaN,NaN};
RotMat=struct('f',value1);
RotMat_temp=RotMat;
stage=zeros(length(finite(:,1)),3);

% setup rotation matrix from Euler parameters
% RotMat=step2_Wing_RotMatrix(lonE,latE,omega)
for i=1:length(finite(:,1))
    RotMat(i).f=step2_Wing_RotMatrix(finite(i,1),finite(i,2),finite(i,3));
end

RotMat_temp(1).f=RotMat(1).f;
% calculate the finite rotation poles
for i=1:length(finite(:,1))
    RotMat_temp(i+1).f=RotMat(i+1).f*transpose(RotMat(i).f);    
    
end

% Calculate Euler parameters from rotation matrix 
% [lonE,latE,omega]=step2_Wing_RotM2Euler(RotMat)
for i=1:length(finite(:,1))
    [lonE,latE,omega]=step2_Wing_RotM2Euler(RotMat_temp(i).f);
    stage(i,:)=[lonE,latE,omega];
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

% Euler pole latitude
latE=asind((RotMat(2,1)-RotMat(1,2))/...
    (sqrt((RotMat(3,2)-RotMat(2,3))^2+(RotMat(1,3)-RotMat(3,1))^2+...
    (RotMat(2,1)-RotMat(1,2))^2)));

% Finite rotation angle
omega=atan2d(sqrt((RotMat(3,2)-RotMat(2,3))^2+(RotMat(1,3)-RotMat(3,1))^2+...
    (RotMat(2,1)-RotMat(1,2))^2),RotMat(1,1)+RotMat(2,2)+RotMat(3,3)-1);

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

% BOUNDEDLINE Plot a line with shaded error/confidence bounds
function varargout=boundedline(varargin)
% Alpha flag

isalpha = cellfun(@(x) ischar(x) && strcmp(x, 'alpha'), varargin);
if any(isalpha)
    usealpha = true;
    varargin = varargin(~isalpha);
else
    usealpha = false;
end

% Axis

isax = cellfun(@(x) isscalar(x) && ishandle(x) && strcmp('axes', get(x,'type')), varargin);
if any(isax)
    hax = varargin{isax};
    varargin = varargin(~isax);
else
    hax = gca;
end

% Transparency

[found, trans, varargin] = parseparam(varargin, 'transparency');

if ~found
    trans = 0.2;
end

if ~isscalar(trans) || trans < 0 || trans > 1
    error('Transparency must be scalar between 0 and 1');
end

% Orientation

[found, orient, varargin] = parseparam(varargin, 'orientation');

if ~found
    orient = 'vert';
end

if strcmp(orient, 'vert')
    isvert = true;
elseif strcmp(orient, 'horiz')
    isvert = false;
else
    error('Orientation must be ''vert'' or ''horiz''');
end


% Colormap

[hascmap, cmap, varargin] = parseparam(varargin, 'cmap');


% X, Y, E triplets, and linespec

[x,y,err,linespec] = deal(cell(0));
while ~isempty(varargin)
    if length(varargin) < 3
        error('Unexpected input: should be x, y, bounds triplets');
    end
    if all(cellfun(@isnumeric, varargin(1:3)))
        x = [x varargin(1)];
        y = [y varargin(2)];
        err = [err varargin(3)];
        varargin(1:3) = [];
    else
        error('Unexpected input: should be x, y, bounds triplets');
    end
    if ~isempty(varargin) && ischar(varargin{1})
        linespec = [linespec varargin(1)];
        varargin(1) = [];
    else
        linespec = [linespec {[]}];
    end 
end    

%--------------------
% Reformat x and y
% for line and patch
% plotting
%--------------------

% Calculate y values for bounding lines

plotdata = cell(0,7);

htemp = figure('visible', 'off');
for ix = 1:length(x)
    
    % Get full x, y, and linespec data for each line (easier to let plot
    % check for properly-sized x and y and expand values than to try to do
    % it myself) 
    
    try
        if isempty(linespec{ix})
            hltemp = plot(x{ix}, y{ix});
        else
            hltemp = plot(x{ix}, y{ix}, linespec{ix});
        end
    catch
        close(htemp);
        error('X and Y matrices and/or linespec not appropriate for line plot');
    end
    
    linedata = get(hltemp, {'xdata', 'ydata', 'marker', 'linestyle', 'color'});
    
    nline = size(linedata,1);
    
    % Expand bounds matrix if necessary
    
    if nline > 1
        if ndims(err{ix}) == 3
            err2 = squeeze(num2cell(err{ix},[1 2]));
        else
            err2 = repmat(err(ix),nline,1);
        end
    else
        err2 = err(ix);
    end
    
    % Figure out upper and lower bounds
    
    [lo, hi] = deal(cell(nline,1));
    for iln = 1:nline
        
        x2 = linedata{iln,1};
        y2 = linedata{iln,2};
        nx = length(x2);
        
        if isvert
            lineval = y2;
        else
            lineval = x2;
        end
            
        sz = size(err2{iln});
        
        if isequal(sz, [nx 2])
            lo{iln} = lineval - err2{iln}(:,1)';
            hi{iln} = lineval + err2{iln}(:,2)';
        elseif isequal(sz, [nx 1])
            lo{iln} = lineval - err2{iln}';
            hi{iln} = lineval + err2{iln}';
        elseif isequal(sz, [1 2])
            lo{iln} = lineval - err2{iln}(1);
            hi{iln} = lineval + err2{iln}(2);
        elseif isequal(sz, [1 1])
            lo{iln} = lineval - err2{iln};
            hi{iln} = lineval + err2{iln};
        elseif isequal(sz, [2 nx]) % not documented, but accepted anyways
            lo{iln} = lineval - err2{iln}(:,1);
            hi{iln} = lineval + err2{iln}(:,2);
        elseif isequal(sz, [1 nx]) % not documented, but accepted anyways
            lo{iln} = lineval - err2{iln};
            hi{iln} = lineval + err2{iln};
        elseif isequal(sz, [2 1]) % not documented, but accepted anyways
            lo{iln} = lineval - err2{iln}(1);
            hi{iln} = lineval + err2{iln}(2);
        else
            error('Error bounds must be npt x nside x nline array');
        end 
            
    end
    
    % Combine all data (xline, yline, marker, linestyle, color, lower bound
    % (x or y), upper bound (x or y) 
    
    plotdata = [plotdata; linedata lo hi];
        
end
close(htemp);

% Override colormap

if hascmap
    nd = size(plotdata,1);
    cmap = repmat(cmap, ceil(nd/size(cmap,1)), 1);
    cmap = cmap(1:nd,:);
    plotdata(:,5) = num2cell(cmap,2);
end


%--------------------
% Plot
%--------------------

% Setup of x and y, plus line and patch properties

nline = size(plotdata,1);
[xl, yl, xp, yp, marker, lnsty, lncol, ptchcol, alpha] = deal(cell(nline,1));

for iln = 1:nline
    xl{iln} = plotdata{iln,1};
    yl{iln} = plotdata{iln,2};
    
    [xp{iln}, yp{iln}] = calcpatch(plotdata{iln,1}, plotdata{iln,2}, isvert, plotdata{iln,6}, plotdata{iln,7});
    
    marker{iln} = plotdata{iln,3};
    lnsty{iln} = plotdata{iln,4};
    
    if usealpha
        lncol{iln} = plotdata{iln,5};
        ptchcol{iln} = plotdata{iln,5};
        alpha{iln} = trans;
    else
        lncol{iln} = plotdata{iln,5};
        ptchcol{iln} = interp1([0 1], [1 1 1; lncol{iln}], trans);
        alpha{iln} = 1;
    end
end
    
% Plot patches and lines

if verLessThan('matlab', '8.4.0')
    [hp,hl] = deal(zeros(nline,1));
else
    [hp,hl] = deal(gobjects(nline,1));
end

axes(hax);
hold all;

for iln = 1:nline
    hp(iln) = patch(xp{iln}, yp{iln}, ptchcol{iln}, 'facealpha', alpha{iln}, 'edgecolor', 'none');
end

for iln = 1:nline
    hl(iln) = line(xl{iln}, yl{iln}, 'marker', marker{iln}, 'linestyle', lnsty{iln}, 'color', lncol{iln});
end

%--------------------
% Assign output
%--------------------

nargchk(0, 2, nargout);

if nargout >= 1
    varargout{1} = hl;
end

if nargout == 2
    varargout{2} = hp;
end

%--------------------
% Parse optional 
% parameters
%--------------------

function [found, val, vars] = parseparam(vars, param)

isvar = cellfun(@(x) ischar(x) && strcmpi(x, param), vars);

if sum(isvar) > 1
    error('Parameters can only be passed once');
end

if any(isvar)
    found = true;
    idx = find(isvar);
    val = vars{idx+1};
    vars([idx idx+1]) = [];
else
    found = false;
    val = [];
end

%----------------------------
% Calculate patch coordinates
%----------------------------

function [xp, yp] = calcpatch(xl, yl, isvert, lo, hi)

ismissing = any(isnan([xl;yl;lo;hi]),2);

if isvert
    xp = [xl fliplr(xl)];
    yp = [lo fliplr(hi)];
else
    xp = [lo fliplr(hi)];
    yp = [yl fliplr(yl)];
end

if any(ismissing)
    warning('NaNs in bounds; inpainting');
    xp = inpaint_nans(xp');
    yp = inpaint_nans(yp');
end

%--------------------------------------------------------------------------


% --- Executes on selection change in ColorCodeS.
function ColorCodeS_Callback(hObject, eventdata, handles)
% hObject    handle to ColorCodeS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ColorCodeS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ColorCodeS

ColorCodeS=get(hObject,'Value');
if isfield(handles,'PlateRec')==0
    disp('Please load PlateRec file first!');
elseif isfield(handles,'PlateRec')==1
    switch ColorCodeS
        case 1
            % initiate colormap
            handles.ColorCodeS=jet(length(handles.PlateRec(1).f3(:,1)));
        case 2
            handles.ColorCodeS=jet(length(handles.PlateRec(1).f3(:,1)));
        case 3
            handles.ColorCodeS=hsv(length(handles.PlateRec(1).f3(:,1)));
        case 4
            handles.ColorCodeS=hot(length(handles.PlateRec(1).f3(:,1)));
        case 5
            handles.ColorCodeS=cool(length(handles.PlateRec(1).f3(:,1)));
        case 6
            handles.ColorCodeS=spring(length(handles.PlateRec(1).f3(:,1)));
        case 7
            handles.ColorCodeS=summer(length(handles.PlateRec(1).f3(:,1)));
        case 8
            handles.ColorCodeS=autumn(length(handles.PlateRec(1).f3(:,1)));
        case 9
            handles.ColorCodeS=winter(length(handles.PlateRec(1).f3(:,1)));
        case 10
            handles.ColorCodeS=gray(length(handles.PlateRec(1).f3(:,1)));
        case 11
            handles.ColorCodeS=bone(length(handles.PlateRec(1).f3(:,1)));
        case 12
            handles.ColorCodeS=copper(length(handles.PlateRec(1).f3(:,1)));
        case 13
            handles.ColorCodeS=pink(length(handles.PlateRec(1).f3(:,1)));
        case 14
            handles.ColorCodeS=lines(length(handles.PlateRec(1).f3(:,1)));
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


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% save .pdf file
[FileName,PathName]=uiputfile('*.pdf','Save Figure As');
FullName=[PathName,FileName];
printpdf(gcf, FullName);
% printpdf(gcf, 'FisherMean');

disp('Figure exported.');
% close(gcf); %and close it
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2
