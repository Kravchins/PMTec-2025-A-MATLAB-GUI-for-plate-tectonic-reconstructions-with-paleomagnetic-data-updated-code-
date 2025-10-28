function varargout = PMTec_BootRes(varargin)
% PMTEC_BOOTRES MATLAB code for PMTec_BootRes.fig
%      PMTEC_BOOTRES, by itself, creates a new PMTEC_BOOTRES or raises the existing
%      singleton*.
%
%      H = PMTEC_BOOTRES returns the handle to a new PMTEC_BOOTRES or the handle to
%      the existing singleton*.
%
%      PMTEC_BOOTRES('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PMTEC_BOOTRES.M with the given input arguments.
%
%      PMTEC_BOOTRES('Property','Value',...) creates a new PMTEC_BOOTRES or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PMTec_BootRes_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PMTec_BootRes_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PMTec_BootRes

% Last Modified by GUIDE v2.5 17-Sep-2014 05:51:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PMTec_BootRes_OpeningFcn, ...
                   'gui_OutputFcn',  @PMTec_BootRes_OutputFcn, ...
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


% --- Executes just before PMTec_BootRes is made visible.
function PMTec_BootRes_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PMTec_BootRes (see VARARGIN)

% Choose default command line output for PMTec_BootRes
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

axes(handles.axes1); eqareaFrame;

set(handles.view1,'string',num2str(60));
set(handles.view2,'string',num2str(90));
set(handles.view3,'string',num2str(30));
mapview=[60, 90, 30];

% initiate map axes and all the map background data
axes(handles.axes2); axis off,axesm ortho % mollweid;
setm(gca,'Origin', mapview), framem on; tightmap; gridm on

% load coastline
coast=load('coast');
handles.hCoast2=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none');

% set initial state of bootstrap parameters
set(handles.edit1,'string',num2str(60));
set(handles.edit2,'string',num2str(60));
set(handles.edit3,'string',num2str(100));
set(handles.edit4,'string',num2str(100));
set(handles.edit5,'string',num2str(10));
handles.ColorCodeS=jet; % autumn

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PMTec_BootRes wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PMTec_BootRes_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%------------------------------------------------------------------------  

% 1) Main routine for doing bootstrap resampling
function [ReSamp,BootReMeanPar,EllPara0]=doboot(D,I,kappa,N)
% 1: for D and I
D_mean=zeros(N,1);
I_mean=zeros(N,1);

% 2: for D0=D and I0=0
D_mean0=zeros(N,1);
I_mean0=zeros(N,1);
D0=D; I0=0;
for j=1:N
      
    % n: resampling times for a single direction [D,I]
    n=500;  
    for i=1:n
        
        % 1) send kappa to fshdev
        [Dec, Inc]=fshdev(kappa);
        [drot,irot]=dodirot(Dec,Inc,D,I);
        
        % calculate fisher parameters for the resampled data set
        % [drot,irot]
        [Dm,Im,alpha95,k]=fishpar(drot,irot);

        % 2) send kappa to fshdev
        [drot0,irot0]=dodirot(Dec,Inc,D0,I0);
        
        % calculate fisher parameters for the resampled data set
        % [drot,irot]
        [Dm0,Im0,alpha950,k0]=fishpar(drot0,irot0);
    end
    
    D_mean(j)=Dm;
    I_mean(j)=Im;
    
    D_mean0(j)=Dm0;
    I_mean0(j)=Im0;    
end

% produce the same random numbers for each use
rng('default');

[MD,MI,MA95,Mk]=fishpar(D_mean,I_mean);
BootReMeanPar=[MD,MI,MA95,Mk];
ReSamp=[D_mean, I_mean];

[MD0,MI0,MA950,Mk0]=fishpar(D_mean0,I_mean0);
BootReMeanPar0=[MD0,MI0,MA950,Mk0];
ReSamp0=[D_mean0, I_mean0];
EllPara0=CovEllp(ReSamp0,[BootReMeanPar0(1),BootReMeanPar0(2)],.99);


% 2) subroutine for projecting equal area frame
function eqareaFrame
% initiate map axes and all the map background data

% initialize and scale plot
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


% 3) subroutine for calculating fisherian mean
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


% 4) subroutine for find the antipode
% Copyright: Tauxe et al., 2010
function [drot, irot]=dodirot(D,I,Dbar,Ibar)

[d, irot]=dogeo(D,I,Dbar,90-Ibar);
drot=d-180;


% 5) subroutine for returning a direction from distribution with 
% TM=0,90 & kappa
function [Dec, Inc]=fshdev(kappa)

% generate a random floating point number in the range [0,1]
R1=rand(1);
R2=rand(1);

L=exp(-2*kappa);
a=R1*(1-L)+L;
fac=sqrt(-log(a)./(2*kappa));
Inc=90-2*asind(fac);
Dec=2*pi*R2*180/pi;


% 6) subroutine for equal area projection
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
        plot(xP(i),yP(i),Pmark,'MarkerEdgeColor',Pcol,'MarkerSize',7)
            
    else
        plot(xP(i),yP(i),Pmark,'MarkerEdgeColor','k',...
        'MarkerFaceColor',Pcol,'markersize',7,'LineWidth',1)
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

end


function eqarealine(lonP,latP,Lcol)
%% Plotting paleo poles
if nargin <3
    Lcol='b';
end

r=1;
% Calculate Cartesian coordinates of projection and plot 
azP = (lonP)*pi/180; % pole Longitude (azimuth)
dipP = abs(latP)*pi/180; % pole Latitude (dipping)

xP = sqrt(2)*r*sin(pi/4 - dipP/2).*sin(azP); % x-coord of projection
yP = sqrt(2)*r*sin(pi/4 - dipP/2).*cos(azP); % y-coord of projection
plot(xP,yP,'LineStyle','-','color',Lcol,'LineWidth',1);


% 7) subroutine for rotating Dec, Inc into geographic coordinates using 
% az,pl (azimuth,plunge) of the X direction (az,pl)=(D,I)
function [Drot, Irot]=dogeo(Dec, Inc, az, pl)

% direction cosines from Dec & Inc 
Dec=Dec.*(pi/180);
Inc=Inc.*(pi/180);
[xX,yX,zX]=sph2cart(Dec,Inc,1);  % set length to unity
X=[xX,yX,zX];

% set up rotation matrix
az=az.*(pi/180);
pl=pl.*(pi/180);
[xA1,yA1,zA1]=sph2cart(az,pl,1);
[xA2,yA2,zA2]=sph2cart(az+pi/2,0,1);
[xA3,yA3,zA3]=sph2cart(az-pi,pi/2-pl,1);
A1=[xA1,yA1,zA1];
A2=[xA2,yA2,zA2];
A3=[xA3,yA3,zA3];

% do the rotation
xp=A1(1)*X(1)+A2(1)*X(2)+A3(1)*X(3);
yp=A1(2)*X(1)+A2(2)*X(2)+A3(2)*X(3);
zp=A1(3)*X(1)+A2(3)*X(2)+A3(3)*X(3);

% transform back to spherical coordinates
[Drot, Irot]=cart2sph(xp,yp,zp);
Drot=Drot.*(180/pi);
Irot=Irot.*(180/pi);


% 8) color code
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

% 9) printpdf Prints image in PDF format without tons of white space
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

% 10) calculate confidence ellipse
function EllPara=CovEllp(BootReSamp,Mu,conf)
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
ecc=axes2ecc(semimajor,semiminor);
az=atand(V(1,1)/V(2,1));
EllPara=[semimajor,semiminor,ecc,az];
%------------------------------------------------------------------------


% --- Executes on button press in reset.
function reset_Callback(hObject, eventdata, handles)
% hObject    handle to reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cla(handles.axes1); cla(handles.axes2);
axes(handles.axes1); eqareaFrame;

mapview=[str2num(get(handles.view1,'String')),...
    str2num(get(handles.view2,'String')),...
    str2num(get(handles.view3,'String'))];

% initiate map axes and all the map background data
axes(handles.axes2); axis off,axesm ortho % mollweid;
setm(gca,'Origin', mapview), framem on; tightmap; gridm on

% load coastline
coast=load('coast');
handles.hCoast2=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none');

disp('Reset all.');


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


% --- Executes on button press in ExportData.
function ExportData_Callback(hObject, eventdata, handles)
% hObject    handle to ExportData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'BootReSamp')==0
    disp('Please do bootstrap resampling first!');
elseif isfield(handles,'BootReSamp')==1
    BootRes=handles.BootReSamp;
    
    % save .mat file
    [FileName,PathName]=uiputfile('*.mat','Save Plate Contour As');
    if FileName ~= 0
        nbfiles = 1;
    else
        nbfiles = 0;
    end
    
    if nbfiles==1
        % FullName=[PathName,FileName];
        FullName=[PathName,'APWPboot','_',FileName];
        save(FullName, 'BootRes')
        disp('Boot results successfully exported.');
    elseif nbfiles==0
        %     disp('Please name the data!')
    end
end
guidata(hObject, handles);


% --- Executes on button press in BootBatch.
function BootBatch_Callback(hObject, eventdata, handles)
% hObject    handle to BootBatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

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
    
    disp('Directional data file loaded.');   
    disp('Bootstrap Resampling in batch... Be Patient... O(*_*)O');
    
    npts=length(LoadPMdata(:,2));
    handles.npts=npts;
    D=LoadPMdata(:,2);
    I=LoadPMdata(:,3);
    a95=LoadPMdata(:,4);
    kappa=LoadPMdata(:,5);
    N=str2num(get(handles.edit4,'String'));
    
    % construct structure data for storing [BootReSamp_m,BootReMeanPar_m]
    handles.BootReSamp=struct('f1',{NaN},'f2',{NaN});
    
    % decide the color code: [ind2,MapCol]=ColorCodeCal(data,colortype)
    % colormap: jet, hsv, hot, cool, spring, autumn, summer, winter, gray
    [ind,MapCol]=ColorCodeCal(D,handles.ColorCodeS);
    
    % plot APWP and A95s
    axes(handles.axes1);
    eqarealine(D,I,'b');
    axes(handles.axes2);
    geoshow(I,D,'Color','b','LineWidth',1);    

    for i=1:npts
        [IncA95,DecA95]=scircle1(I(i),D(i),a95(i));
        axes(handles.axes1);
        eqarealine(DecA95,IncA95,MapCol(ind(i),:));
        
        axes(handles.axes2);
        geoshow(IncA95,DecA95,'Color',MapCol(ind(i),:),'LineWidth',1);
    end
    
    for i=1:npts
        % do bootstrap resampling
        [BootReSamp_m,BootReMeanPar_m,EllPara0_m]=doboot(D(i),I(i),kappa(i),N);
               
        handles.BootReSamp(i).f1=BootReSamp_m;
        handles.BootReSamp(i).f2=BootReMeanPar_m;
        handles.BootReSamp(1).f3(i,:)=EllPara0_m;
        
        % plot the bootstrapped data
        % eqarea(lonP,latP,A95,Pmark,Pcol,A95col,Plabel)
        axes(handles.axes1);
        eqarea(BootReSamp_m(:,1),BootReSamp_m(:,2),zeros(N),'o',...
            MapCol(ind(i),:),[.73 .83 .95],0)
        
        axes(handles.axes2);
        geoshow(BootReSamp_m(:,2),BootReSamp_m(:,1),'DisplayType',...
            'point','Marker','o','MarkerSize',7,...
            'MarkerEdgeColor',MapCol(ind(i),:),'LineWidth',1);
        
    end
    caxis([1 npts]);
    disp('Resampling is done.');
elseif nbfiles==0
%     disp('Please select a file!')
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
%     disp('Please name the figure!')
end

guidata(hObject, handles);


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


function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in SingleBoot.
function SingleBoot_Callback(hObject, eventdata, handles)
% hObject    handle to SingleBoot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

disp('Single Bootstrap Resampling... Be Patient... O(*_*)O')
disp('... ... ...')
% pass bootstrap parameters from text boxes
D=str2num(get(handles.edit1,'String'));
I=str2num(get(handles.edit2,'String'));
kappa=str2num(get(handles.edit3,'String'));
N=str2num(get(handles.edit4,'String'));
a95=str2num(get(handles.edit5,'String'));

% do bootstrap resampling
% function: EllPara=CovEllp(BootReSamp,Mu,conf)
% EllPara=[semimajor,semiminor,ecc,az];
[BootReSamp,BootReMeanPar,EllPara0]=doboot(D,I,kappa,N);
handles.BootReSamp=BootReSamp;
[elat,elon]=ellipse1(BootReMeanPar(2),BootReMeanPar(1),...
    [EllPara0(1) EllPara0(3)],EllPara0(4));
ErrEllp=[elon elat];
%-------------------------------------------------------------------------

axes(handles.axes1);
% plot the bootstrapped data
% eqarea(lonP,latP,A95,Pmark,Pcol,A95col,Plabel)
% eqarealine(lonP,latP,Lcol)
eqarea(BootReSamp(:,1),BootReSamp(:,2),zeros(N),'o',...
       [.75 .0 .75],[.75 .0 .75],0);

eqarealine(ErrEllp(:,1),ErrEllp(:,2),'b');
eqarea(BootReMeanPar(1),BootReMeanPar(2),BootReMeanPar(3),...
       'o',[.0 .5 .0],[.0 .5 .0],0);
eqarea(D,I,a95,'o','r','r',0);

% plot on ortho
axes(handles.axes2);
% resampled data
geoshow(BootReSamp(:,2),BootReSamp(:,1),'DisplayType',...
     'point','Marker','o','MarkerSize',7,'MarkerFaceColor',[.75 .0 .75],...
     'MarkerEdgeColor','k','LineWidth',1);
% mean position of resampled data
geoshow(BootReMeanPar(2),BootReMeanPar(1),'DisplayType',...
     'point','Marker','o','MarkerSize',7,'MarkerFaceColor',[.0 .5 .0],...
     'MarkerEdgeColor','k','LineWidth',1);
[IncBSM,DecBSM]= scircle1(BootReMeanPar(2),BootReMeanPar(1),BootReMeanPar(3));
geoshow(IncBSM,DecBSM,'Color',[.0 .5 .0],'LineWidth',1);
geoshow(ErrEllp(:,2), ErrEllp(:,1),'Color','b','LineWidth',1);
% original data
geoshow(I,D,'DisplayType','point','Marker','o','MarkerSize',7,...
    'MarkerFaceColor','r','MarkerEdgeColor','k','LineWidth',1);
[IncOri,DecOri]= scircle1(I,D,a95);
geoshow(IncOri,DecOri,'Color','r','LineWidth',1);

disp('Resampling is done.')
 guidata(hObject, handles);
  

function view1_Callback(hObject, eventdata, handles)
% hObject    handle to view1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of view1 as text
%        str2double(get(hObject,'String')) returns contents of view1 as a double
cla(handles.axes2);

% 2) Initially defined parameters:
mapview=[str2num(get(handles.view1,'String')),...
         str2num(get(handles.view2,'String')),...
         str2num(get(handles.view3,'String'))];


% 3) initiate map axes and all the map background data
axes(handles.axes2); axis off, axesm ortho % mollweid;ortho;eqdcylin
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
cla(handles.axes2);

% 2) Initially defined parameters:
mapview=[str2num(get(handles.view1,'String')),...
         str2num(get(handles.view2,'String')),...
         str2num(get(handles.view3,'String'))];


% 3) initiate map axes and all the map background data
axes(handles.axes2); axis off, axesm ortho % mollweid;ortho;eqdcylin
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
cla(handles.axes2);

% 2) Initially defined parameters:
mapview=[str2num(get(handles.view1,'String')),...
         str2num(get(handles.view2,'String')),...
         str2num(get(handles.view3,'String'))];


% 3) initiate map axes and all the map background data
axes(handles.axes2); axis off, axesm ortho % mollweid;ortho;eqdcylin
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


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on selection change in ColorCodeS.
function ColorCodeS_Callback(hObject, eventdata, handles)
% hObject    handle to ColorCodeS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ColorCodeS contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ColorCodeS
ColorCodeS=get(hObject,'Value');
if isfield(handles,'npts')==0
    disp('Please load directions file first!');
elseif isfield(handles,'npts')==1
    switch ColorCodeS
        case 1
            % initiate colormap
            handles.ColorCodeS=jet(handles.npts);
        case 2
            handles.ColorCodeS=jet(handles.npts);
        case 3
            handles.ColorCodeS=hsv(handles.npts);
        case 4
            handles.ColorCodeS=hot(handles.npts);
        case 5
            handles.ColorCodeS=cool(handles.npts);
        case 6
            handles.ColorCodeS=spring(handles.npts);
        case 7
            handles.ColorCodeS=summer(handles.npts);
        case 8
            handles.ColorCodeS=autumn(handles.npts);
        case 9
            handles.ColorCodeS=winter(handles.npts);
        case 10
            handles.ColorCodeS=gray(handles.npts);
        case 11
            handles.ColorCodeS=bone(handles.npts);
        case 12
            handles.ColorCodeS=copper(handles.npts);
        case 13
            handles.ColorCodeS=pink(handles.npts);
        case 14
            handles.ColorCodeS=lines(handles.npts);
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
function uitoggletool4_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
