function varargout = PMTec_Fish(varargin)
% FISHERM MATLAB code for PMTec_Fish.fig
%      FISHERM, by itself, creates a new FISHERM or raises the existing
%      singleton*.
%
%      H = FISHERM returns the handle to a new FISHERM or the handle to
%      the existing singleton*.
%
%      FISHERM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FISHERM.M with the given input arguments.
%
%      FISHERM('Property','Value',...) creates a new FISHERM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FisherM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FisherM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PMTec_Fish

% Last Modified by GUIDE v2.5 04-May-2014 22:21:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PMTec_Fish_OpeningFcn, ...
                   'gui_OutputFcn',  @PMTec_Fish_OutputFcn, ...
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


% --- Executes just before PMTec_Fish is made visible.
function PMTec_Fish_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PMTec_Fish (see VARARGIN)

% Choose default command line output for PMTec_Fish
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
axes(handles.axes1); axis equal;  axis off; 
eqareaFrame

% set initial state of bootstrap parameters
set(handles.edit1,'string',num2str(0));
set(handles.edit2,'string',num2str(0));
set(handles.edit3,'string',num2str(0));
set(handles.edit4,'string',num2str(0));

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PMTec_Fish wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PMTec_Fish_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%-------------------------------------------------------------------------
function eqarea(lonP,latP,A95,Pmark,Pcol,A95col,Plabel)
%% Plotting paleo poles
if nargin <5
    Pcol=[1 .6 .78];
    A95col=[1 .6 .78];
    Plabel=1;
end

r=1;
% Calculate Cartesian coordinates of projection and plot 
azP = (lonP)*pi/180; % pole Longitude (azimuth)
dipP = abs(latP)*pi/180; % pole Latitude (dipping)

xP = sqrt(2)*r*sin(pi/4 - dipP/2).*sin(azP); % x-coord of projection
yP = sqrt(2)*r*sin(pi/4 - dipP/2).*cos(azP); % y-coord of projection

% 'Marker','o','MarkerSize',9,'MarkerFaceColor',[1 .6 .78],...
%      'MarkerEdgeColor','k','LineWidth',1.5

% upper sphere: solid cyan cicle; lower sphere: open white circle
for i=1:length(latP)
    if latP(i)<0
        plot(xP(i),yP(i),Pmark,'LineWidth',1.5,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor','w',...
                'markersize',8)
    else
        plot(xP(i),yP(i),Pmark,'LineWidth',1.5,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',Pcol,...
                'markersize',8)
    end
end
hold on

% Add data label for paleopoles
% Create index vector from grouping variable
if Plabel==1
    indP=[1:1:length(xP)]';
    [GP,GNP]=grp2idx(indP);
    for i = 1:length(xP)
        text(xP(i)+0.02, yP(i),GNP(i),'Color','m','FontSize',11);
    end
else
    
end

% add annotation
for i=1:length(A95)
    [latA95,lonA95] = scircle1(latP(i),lonP(i),A95(i));
    
    % Calculate Cartesian coordinates of projection and plot
    azA95 = (lonA95)*pi/180; % pole Longitude (azimuth)
    dipA95 = abs(latA95)*pi/180; % pole Latitude (dipping)
    
    xA95 = sqrt(2)*r*sin(pi/4 - dipA95/2).*sin(azA95); % x-coord of projection
    yA95 = sqrt(2)*r*sin(pi/4 - dipA95/2).*cos(azA95); % y-coord of projection
    % upper sphere: dash red cicle; lower sphere: solid red circle
    
    if latP(i)<0
        line(xA95,yA95,'LineStyle','--','color',A95col,'LineWidth',1.2)
    else
        line(xA95,yA95,'color',A95col,'LineWidth',1.2)
    end
    %             end
end


function eqareaFrame
% initiate map axes and all the map background data

%% initialize and scale plot
% % hold plot
hold on 
% equal scaling in x and y, no axes or box
axis equal; axis off; box off; 
% sets scaling for x- and y-axes
axis ([-1 1 -1 1]) 

%% plot Cartesian coordinates and reference circle 
% set background color to be write
%set(gcf, 'color', 'w'); % gcf: returns the handle of the current figure
plot([-1 1],[0 0],'w:',[0 0],[-1 1],'w:') % plot x- and y-axes
plot(0,0,'k+','markersize',12,'linewidth',2); % plot the center cross of the circle
% plot crosses at N,S,W,E
plot(.999,0,'k+',-.999,0,'k+',0,.999,'k+',0,-.999,...
    'k+','markersize',10,'linewidth',1.5);

r = 1; % radius of reference circle
TH = linspace(0,2*pi,3601); % polar angle, range 2 pi, 1/10 degree increment
% plot the boundary line for the circle
[X,Y] = pol2cart(TH,r); % Cartesian coordinates of reference circle
plot(X,Y,'k','linewidth',2);
% text(1.04,0,'90','fontsize',12); text(-1.12,0,'270','fontsize',12);
% text(-.01,1.06,'0','fontsize',12); text(-.045,-1.06,'180','fontsize',12);
text(1.05,0,'90','fontsize',12); text(-1.2,0,'270','fontsize',12);
text(-.08,-1.08,'180','fontsize',12); text(-.02,1.08,'0','fontsize',12);

%Plotting reference ticks(+) for small and great circles
for i=10:10:80 % 10?stepwise
    for j=0
        for k=90
            % plot vertical ticks(+)
            a = j*pi/180;  % convert to radians
            Dip = i*pi/180;
            x = sqrt(2)*r*sin(pi/4 - Dip/2).*sin(a); % x-coord of projection
            y = sqrt(2)*r*sin(pi/4 - Dip/2).*cos(a); % y-coord of projection
            plot(x,y,'k+');plot(x,-y,'k+');
            
            % plot horizontal ticks(+)
            a=k*pi/180;
            x = sqrt(2)*r*sin(pi/4 - Dip/2).*sin(a); % x-coord of projection
            y = sqrt(2)*r*sin(pi/4 - Dip/2).*cos(a); % y-coord of projection
            plot(x,y,'k+');plot(-x,y,'k+');
        end
    end
end
% Viewpoint specification
view([0 90])


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
% if Im<0
%     [Im,Dm]=antipode(Im,Dm);
% end
% 
% if Dm<0
%     Dm=Dm+360;
% end


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


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
guidata(hObject, handles);

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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in OpenFile.
function OpenFile_Callback(hObject, eventdata, handles)
% hObject    handle to OpenFile (see GCBO)
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
    
    [Dm,Im,alpha95,kappa]=fishpar(LoadPMdata(:,2),LoadPMdata(:,3));
    handles.result=[Dm,Im,alpha95,kappa];
    
    % pass the results to text box
    set(handles.edit1,'string',num2str(Dm))
    set(handles.edit2,'string',num2str(Im))
    set(handles.edit3,'string',num2str(alpha95))
    set(handles.edit4,'string',num2str(kappa))
    
    % make plot
    % eqarea(lonP,latP,A95,Pmark,Pcol,A95col,Plabel)
    eqarea(LoadPMdata(:,2),LoadPMdata(:,3),LoadPMdata(:,4),'o');
    eqarea(Dm,Im,alpha95,'D',[0 .75 .75],[0 .75 .75],0);
    disp('Directional data file loaded.');
    
elseif nbfiles==0
%     disp('Please select a file!')
end

guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ExportData.
function ExportData_Callback(hObject, eventdata, handles)
% hObject    handle to ExportData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'result')==0
    disp('Please calculate Fisher mean first!');
elseif isfield(handles,'result')==1
    FisherMean=handles.result;
    
    % save .txt file
    [FileName,PathName]=uiputfile('*.txt','Save Euler Parameters As');
    if FileName ~= 0
        nbfiles = 1;
    else
        nbfiles = 0;
    end
    
    if nbfiles==1
        FullName=[PathName,FileName];
        save(FullName, 'FisherMean','-ascii');
        disp('Fisher Mean file saved.');
    elseif nbfiles==0
%         disp('Please name the data!');
    end
end
guidata(hObject, handles);

 
% --- Executes on button press in ExportFigure.
function ExportFigure_Callback(hObject, eventdata, handles)
% hObject    handle to ExportFigure (see GCBO)
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
 

% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1); eqareaFrame
% set initial state of bootstrap parameters
set(handles.edit1,'string',num2str(0));
set(handles.edit2,'string',num2str(0));
set(handles.edit3,'string',num2str(0));
set(handles.edit4,'string',num2str(0));

disp('Reset all.');
