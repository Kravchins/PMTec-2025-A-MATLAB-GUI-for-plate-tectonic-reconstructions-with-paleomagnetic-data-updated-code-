function varargout = PMTec_Euler(varargin)
% PMTEC_EULER MATLAB code for PMTec_Euler.fig
%      PMTEC_EULER, by itself, creates a new PMTEC_EULER or raises the existing
%      singleton*.
%
%      H = PMTEC_EULER returns the handle to a new PMTEC_EULER or the handle to
%      the existing singleton*.
%
%      PMTEC_EULER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PMTEC_EULER.M with the given input arguments.
%
%      PMTEC_EULER('Property','Value',...) creates a new PMTEC_EULER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PMTec_Euler_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PMTec_Euler_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PMTec_Euler

% Last Modified by GUIDE v2.5 07-Aug-2015 19:04:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PMTec_Euler_OpeningFcn, ...
                   'gui_OutputFcn',  @PMTec_Euler_OutputFcn, ...
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


% --- Executes just before PMTec_Euler is made visible.
function PMTec_Euler_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PMTec_Euler (see VARARGIN)

% Choose default command line output for PMTec_Euler
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

% 1) set up inital paramters
set(handles.track1,'string',num2str(1));
set(handles.track2,'string',num2str(3));
set(handles.view1,'string',num2str(90));
set(handles.view2,'string',num2str(0));
set(handles.view3,'string',num2str(0));
set(handles.GC1,'string',num2str(NaN));
set(handles.GC2,'string',num2str(NaN));
set(handles.GC3,'string',num2str(NaN));
set(handles.GC4,'string',num2str(NaN));
set(handles.SC1,'string',num2str(NaN));
set(handles.SC2,'string',num2str(NaN));
set(handles.SC3,'string',num2str(NaN));
set(handles.SC4,'string',num2str(NaN));
set(handles.CritValue,'string',num2str(NaN));
set(handles.PreferFit,'string',num2str(NaN));
set(handles.Number,'string',num2str(NaN));
handles.ProjWin=0;

% 2) Initially defined parameters:
handles.view1_ini=str2num(get(handles.view1,'String'));
handles.view2_ini=str2num(get(handles.view2,'String'));
handles.view3_ini=str2num(get(handles.view3,'String'));

mapview=[handles.view1_ini,...
         handles.view2_ini,...
         handles.view3_ini];

% 3) initiate map axes and all the map background data
axes(handles.axes1); axis off,axesm ortho % mollweid;
setm(gca,'Origin', mapview), framem on; tightmap; gridm on
handles.ProjT='ortho';

% load coastline
coast=load('coast');
handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none');

% initiate map axes and all the map background data
axes(handles.axes2); axis off,axesm ortho % mollweid;
setm(gca,'Origin', mapview), framem on; tightmap; gridm on

% load coastline
coast=load('coast');
handles.hCoast2=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PMTec_Euler wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PMTec_Euler_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%------------------------------------------------------------------------- 
% 1) printpdf Prints image in PDF format without tons of white space
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


% 2) plot the PM data
function [hPMdata,hPMdataA95,hAnot,hPMline]=PMplot(LoadPMdata)
% 1) plot the PM data
hPMdata=geoshow(LoadPMdata(:,3),LoadPMdata(:,2),'DisplayType',...
     'point','Marker','o','MarkerSize',7,'MarkerFaceColor',[.73 .83 .95],...
     'MarkerEdgeColor','k','LineWidth',1);
set(hPMdata,'Visible','on');
hPMline=geoshow(LoadPMdata(:,3),LoadPMdata(:,2),'Color',[.73 .83 .95],...
     'LineWidth',1);
set(hPMline,'Visible','off');

% 2) A95 for the paleopoles
PMGstructA95=[NaN,NaN];
for i = 1:length(LoadPMdata(:,2))
    [IncSC,DecSC]= scircle1(LoadPMdata(i,3),LoadPMdata(i,2),LoadPMdata(i,4));
    PMGstructA95=[PMGstructA95;[IncSC,DecSC];[NaN,NaN]];
end
hPMdataA95=geoshow(PMGstructA95(:,1),PMGstructA95(:,2),...
    'Color',[0 .45 .74],'LineWidth',1);
set(hPMdataA95,'Visible','off');

% 3) Add data label for paleopoles
indP=[1:1:length(LoadPMdata(:,2))]';
[GP,GNP]=grp2idx(indP);
GNP(length(GNP))=[];GNP=['0';GNP];
hAnot=textm(LoadPMdata(:,3),LoadPMdata(:,2),num2str(LoadPMdata(:,1)),...
                           'Color',[.08 .17 .55],'FontSize',12); % age
% hAnot=textm(LoadPMdata(:,3),LoadPMdata(:,2),num2str(indP),...
%                            'Color',[.08 .17 .55],'FontSize',12); % number
set(hAnot,'Visible','on');


% 3) GC and GC fitting
function [EuParaGC,D_GC,EuParaSC,D_SC,Vr,CriValue]=GCSCfit(data)

Dec=data(:,2);
Inc=data(:,3);
% alpha95=data(:,4);
N=length(Dec);

% convert [Dec Inc] into direction cosine (a1, a2, a3), where
% a1^2+a2^2+a3^2=1
[a1, a2, a3]=sph2cart(Dec./(180/pi), Inc./(180/pi), 1);

% least-square small circle fitting
[lonV_SC, latV_SC, D_SC, rSC]=LSQCircFit_SC(a1, a2, a3, N);

% least-square great circle fitting
[lonV_GC, latV_GC, D_GC, rGC]=LSQCircFit_GC(a1, a2, a3, N);

% select better fitting method by computing the variance ratio Vr
% see definition in Gray et al., 1980 in MG
Vr=(N-3)*((rGC-rSC)/rSC);


%% data fitting with GC or SC (recommended)
% compare Vr with F(1,N-3) distribution table on alpha=0.05
% Find a value that should exceed 95% of the samples from an
% F distribution with 1 degrees of freedom in the numerator and N degrees
% of freedomin the denominator:
CriValue = finv(0.95,1,N-3);
if Vr>CriValue
    lonVRC=lonV_SC; latVRC=latV_SC; DRC=D_SC;
    % recommended rotation parameters [lonVRC, latVRC, DRC]
    Result=[lonVRC, latVRC, DRC];
    index='SC';
    % small circle parameters
    [lonE latE omega]=LSQCircFit_EuraPar(lonV_SC,latV_SC,Dec,Inc,N);
    EuParaSC=[lonE latE omega];

else
    lonVRC=lonV_GC; latVRC=latV_GC; DRC=D_GC;
    if latVRC<0
        [latVRC,lonVRC]=antipode(latVRC,lonVRC);
    end
    if lonVRC<0
        lonVRC=lonVRC+360;
    end
    % recommended rotation parameters [lonVRC, latVRC, DRC]
    Result=[lonVRC, latVRC, DRC];
    index='GC';
    % find the GC Euler parameters
    [lonE latE omega]=step1_EulerPole_Wing(Dec, Inc);
    EuParaGC=[lonE latE omega];
    
end

if index=='SC'
    [lonE latE omega]=step1_EulerPole_Wing(Dec, Inc);
    EuParaGC=[lonE latE omega];
    
elseif index=='GC'
    % small circle parameters
    [lonE latE omega]=LSQCircFit_EuraPar(lonV_SC,latV_SC,Dec,Inc,N);
    EuParaSC=[lonE latE omega];
       
end


% 4) SC fitting
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


% 5) GC fitting
function [lonV, latV, D_GC, rGC]=LSQCircFit_GC(a1, a2, a3, N)
%% initial guess of the small circle parameters SC0(x1_0,x2_0,x3_0,x4_0)
% which minimize the sum of the squares of the residuals R, or 
% the perpendicular distances from the datapoints to a SC plane 
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
latV=latV.*(180/pi); lonV=lonV.*(180/pi);
for i=1:length(lonV)
    if latV(i)<0
        [latVant,lonVant]=antipode(latV(i),lonV(i));
        latV(i)=latVant; lonV(i)=lonVant;
    end
    if lonV(i)<0
        lonV(i)=lonV(i)+360;
    end
end

% angular distance D_GC
D_GC=acosd(SC0(4));

%% calculte the variance ratio Vr to make selection bwteen GC or SC
% residual for great circle fitting
for i=1:N
    RGC(i)=pi/2-acos(a1(i)*SC0(1)+a2(i)*SC0(2)+a3(i)*SC0(3));
end

% the sum r of the squares of residuals R(i)
rGC=sum(RGC.^2);


% 6) calculate the great circle distance
function [lonE latE omega]=LSQCircFit_EuraPar(lonE,latE,lonP,latP,n)

n=length(lonP);
p1=distance(latE,lonE,latP(1),lonP(1));
p2=distance(latE,lonE,latP(n),lonP(n));
s=distance(latP(1),lonP(1),latP(n),lonP(n));
omega = acosd((cosd(s)-cosd(p1)*cosd(p2))/(sind(p1)*sind(p2)));


% 7) Rotation angle
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

% V-eigenvectors; D-eigenvalues
[V,D]=eig(T);

% Position of Euler Pole (latE, lonE): 
[lonE,latE,radiusE]=cart2sph(V(1,1),V(2,1),V(3,1));
lonE=lonE*180/pi;
latE=latE*180/pi;

% Mean position of the trap:
[lonT,latT,radiusT]=cart2sph(V(1,3),V(2,3),V(3,3));
lonT=lonT*180/pi;
latT=latT*180/pi;

% convert longtitude to E
if (lonE<0)
    lonE=lonE+360;
else
    lonE=lonE;
end

if (lonT<0)
    lonT=lonT+360;
else
    lonT=lonT;
end

% For the calculation of angular distance(Buter,1992):
% p1:distance between rotation pole and the first pole of a track
% p2:distance between rotation pole and the last pole of a track
% s:angular distance of the track between the first and the last pole
% omega: finite rotation angle
p1=distance(latE,lonE,latP(1),lonP(1));
p2=distance(latE,lonE,latP(n),lonP(n));
s=distance(latP(1),lonP(1),latP(n),lonP(n));
omega = acosd((cosd(s)-cosd(p1)*cosd(p2))/(sind(p1)*sind(p2)));


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

%------------------------------------------------------------------------- 


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function track1_Callback(hObject, eventdata, handles)
% hObject    handle to track1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of track1 as text
%        str2double(get(hObject,'String')) returns contents of track1 as a double
disp('Starting pole selected.');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function track1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to track1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function track2_Callback(hObject, eventdata, handles)
% hObject    handle to track2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of track2 as text
%        str2double(get(hObject,'String')) returns contents of track2 as a double
disp('Ending pole selected.');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function track2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to track2 (see GCBO)
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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function view1_Callback(hObject, eventdata, handles)
% hObject    handle to view1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of view1 as text
%        str2double(get(hObject,'String')) returns contents of view1 as a double
if handles.ProjWin==1
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
    
elseif handles.ProjWin==2
    cla(handles.axes2);
    
    % 2) Initially defined parameters:
    mapview=[str2num(get(handles.view1,'String')),...
        str2num(get(handles.view2,'String')),...
        str2num(get(handles.view3,'String'))];
    
    axes(handles.axes2); axis off, axesm(handles.ProjT) % mollweid;ortho;eqdcylin
    setm(gca,'Origin', mapview), framem on; tightmap; gridm on
    
    % load coastline
    coast=load('coast');
    handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
        'FaceColor',[.83 .82 .78],'edgecolor','none');
    
else
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
    
    cla(handles.axes2);
    axes(handles.axes2); axis off, axesm(handles.ProjT) % mollweid;ortho;eqdcylin
    setm(gca,'Origin', mapview), framem on; tightmap; gridm on
    
    % load coastline
    coast=load('coast');
    handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
        'FaceColor',[.83 .82 .78],'edgecolor','none');
    
end

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
if handles.ProjWin==1
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
    
elseif handles.ProjWin==2
    cla(handles.axes2);
    
    % 2) Initially defined parameters:
    mapview=[str2num(get(handles.view1,'String')),...
        str2num(get(handles.view2,'String')),...
        str2num(get(handles.view3,'String'))];
    
    axes(handles.axes2); axis off, axesm(handles.ProjT) % mollweid;ortho;eqdcylin
    setm(gca,'Origin', mapview), framem on; tightmap; gridm on
    
    % load coastline
    coast=load('coast');
    handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
        'FaceColor',[.83 .82 .78],'edgecolor','none');
    
else
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
    
    cla(handles.axes2);
    axes(handles.axes2); axis off, axesm(handles.ProjT) % mollweid;ortho;eqdcylin
    setm(gca,'Origin', mapview), framem on; tightmap; gridm on
    
    % load coastline
    coast=load('coast');
    handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
        'FaceColor',[.83 .82 .78],'edgecolor','none');
    
end


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
if handles.ProjWin==1
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
    
elseif handles.ProjWin==2
    cla(handles.axes2);
    
    % 2) Initially defined parameters:
    mapview=[str2num(get(handles.view1,'String')),...
        str2num(get(handles.view2,'String')),...
        str2num(get(handles.view3,'String'))];
    
    axes(handles.axes2); axis off, axesm(handles.ProjT) % mollweid;ortho;eqdcylin
    setm(gca,'Origin', mapview), framem on; tightmap; gridm on
    
    % load coastline
    coast=load('coast');
    handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
        'FaceColor',[.83 .82 .78],'edgecolor','none');
    
else
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
    
    cla(handles.axes2);
    axes(handles.axes2); axis off, axesm(handles.ProjT) % mollweid;ortho;eqdcylin
    setm(gca,'Origin', mapview), framem on; tightmap; gridm on
    
    % load coastline
    coast=load('coast');
    handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
        'FaceColor',[.83 .82 .78],'edgecolor','none');
    
end


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
    FullName = strcat(PathName,FileName);
    % Data of PM data
    if FileName(length(FileName)-4:length(FileName))=='.xlsx'
        LoadPMdata=xlsread(FullName);
    elseif FileName(length(FileName)-3:length(FileName))=='.xls'
        LoadPMdata=xlsread(FullName);
    else
        LoadPMdata=importdata(FullName);
    end
    handles.LoadPMdata=LoadPMdata;

    % 1) plot the PM data
    axes(handles.axes1)
    [hPMdata,hPMdataA95,hAnot,hPMline]=PMplot(handles.LoadPMdata);
    handles.hPMdata_GC=hPMdata;
    handles.hPMdataA95_GC=hPMdataA95;
    handles.hAnot_GC=hAnot;
    handles.hPMline_GC=hPMline;
    axes(handles.axes2)
    [hPMdata,hPMdataA95,hAnot,hPMline]=PMplot(handles.LoadPMdata);
    handles.hPMdata_SC=hPMdata;
    handles.hPMdataA95_SC=hPMdataA95;
    handles.hAnot_SC=hAnot;
    handles.hPMline_SC=hPMline;
    disp('PaleoMag data file loaded.');
    
elseif nbfiles==0
%     disp('Please select a file!')
end

guidata(hObject, handles);


function GC1_Callback(hObject, eventdata, handles)
% hObject    handle to track1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of track1 as text
%        str2double(get(hObject,'String')) returns contents of track1 as a double


% --- Executes during object creation, after setting all properties.
function GC1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to track1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function GC2_Callback(hObject, eventdata, handles)
% hObject    handle to track2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of track2 as text
%        str2double(get(hObject,'String')) returns contents of track2 as a double


% --- Executes during object creation, after setting all properties.
function GC2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to track2 (see GCBO)
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


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ExportSingleFit.
function ExportSingleFit_Callback(hObject, eventdata, handles)
% hObject    handle to ExportSingleFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'PEPSingle')==0
    disp('Please calculate Euler parameters first!');
elseif isfield(handles,'PEPSingle')==1
    EulerPara=handles.PEPSingle;
    
    % save .txt file
    [FileName,PathName]=uiputfile('*.txt','Save Euler Parameters As');
    if FileName ~= 0
        nbfiles = 1;
    else
        nbfiles = 0;
    end
    
    if nbfiles==1
        FullName=[PathName,'PEPSingle_',FileName];
        save(FullName, 'EulerPara','-ascii');
        disp('Euler parameters exported.');
    elseif nbfiles==0
%         disp('Please name the data!');
    end
end
guidata(hObject, handles);


% --- Executes on button press in FitInBatch.
function FitInBatch_Callback(hObject, eventdata, handles)
% hObject    handle to FitInBatch (see GCBO)
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
    FullName = strcat(PathName,FileName);
    % Data of PM data
    if FileName(length(FileName)-4:length(FileName))=='.xlsx'
        EulerCtrl=xlsread(FullName);
    elseif FileName(length(FileName)-3:length(FileName))=='.xls'
        EulerCtrl=xlsread(FullName);
    else
        EulerCtrl=importdata(FullName);
    end
    
    data=handles.LoadPMdata;
    
    % decide the color code: [ind2,MapCol]=ColorCodeCal(data,colortype)
    % colormap: jet, hsv, hot, cool, spring, autumn, summer, winter, gray
    npts=length(EulerCtrl(:,1));
    [ind,MapCol]=ColorCodeCal(zeros(npts,1),jet);
    indE=[1:1:length(EulerCtrl(:,1))]';
    [GE,GNE]=grp2idx(indE);
    
    % EulerCtrl=[pole1, pole2, signGC, signSC] (sign for direction);
    handles.EulerCtrl=EulerCtrl;
    pole1=EulerCtrl(:,1); pole2=EulerCtrl(:,2);
    signGC=EulerCtrl(:,3); signSC=EulerCtrl(:,4);
    
    % PEPBatch=[EuParaGC,EuParaSC,Combinations]
    PEPBatch=struct('f1',{NaN},'f2',{NaN},'f3',{NaN});
    for i=1:length(EulerCtrl(:,1))
        
        [EuParaGC,D_GC,EuParaSC,D_SC,Vr,CriValue]=...
            GCSCfit(data(pole1(i):pole2(i),:));
        EuParaGC(3)=signGC(i)*EuParaGC(3);
        EuParaSC(3)=signSC(i)*EuParaSC(3);
        PEPBatch(1).f1(i,1:6)=[EuParaGC,abs(pole2(i)-pole1(i)+1),signGC(i),10];
        PEPBatch(1).f2(i,1:6)=[EuParaSC,abs(pole2(i)-pole1(i)+1),signSC(i),-10];
        PEPBatch(1).f3(i,1:13)=[EuParaGC,D_GC,EuParaSC,D_SC,...
            abs(pole2(i)-pole1(i)+1),signGC(i),signSC(i),Vr,CriValue];
        
        % plot the fitted GC and SC
        axes(handles.axes1)
        geoshow(EuParaGC(2), EuParaGC(1),'DisplayType','point','Marker','p',...
            'MarkerSize',12,'MarkerEdgeColor',MapCol(ind(i),:),'LineWidth',1);
%         textm(EuParaGC(2), EuParaGC(1),GNE(i),...
%             'Color',MapCol(ind(i),:),'FontSize',13);
        textm(EuParaGC(2), EuParaGC(1),GNE(i),'Color','k','FontSize',13);
        [IncGC,DecGC] = scircle1(EuParaGC(2), EuParaGC(1),D_GC);
        geoshow(IncGC,DecGC,'Color',MapCol(ind(i),:),'LineWidth',1.5);
        
        axes(handles.axes2)
        geoshow(EuParaSC(2), EuParaSC(1),'DisplayType','point','Marker','p',...
            'MarkerSize',12,'MarkerEdgeColor',MapCol(ind(i),:),'LineWidth',1);
%         textm(EuParaSC(2), EuParaSC(1),GNE(i),...
%             'Color',MapCol(ind(i),:),'FontSize',13);
        textm(EuParaSC(2), EuParaSC(1),GNE(i),'Color','k','FontSize',13);
        [IncSC,DecSC] = scircle1(EuParaSC(2), EuParaSC(1),D_SC);
        geoshow(IncSC,DecSC,'Color',MapCol(ind(i),:),'LineWidth',1.5);
        
    end
    
    handles.PEPBatch=PEPBatch;
    % save PEPBatch.mat PEPBatch
    disp('Circle fitting in batch completed.');
    caxis([1 length(EulerCtrl(:,1))]);
    % apply new colormap
    colormap(jet(length(EulerCtrl(:,1))));
%     colorbar('southoutside'); 
    
elseif nbfiles==0
%     disp('Please select a file!')
end
 guidata(hObject, handles);
 

% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% printpdf(gcf, 'EulerPar');

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
cla(handles.axes1); cla(handles.axes2); 

set(handles.track1,'string',num2str(1));
set(handles.track2,'string',num2str(3));
% set(handles.view1,'string',num2str(90));
% set(handles.view2,'string',num2str(0));
% set(handles.view3,'string',num2str(0));
set(handles.GC1,'string',num2str(NaN));
set(handles.GC2,'string',num2str(NaN));
set(handles.GC3,'string',num2str(NaN));
set(handles.GC4,'string',num2str(NaN));
set(handles.SC1,'string',num2str(NaN));
set(handles.SC2,'string',num2str(NaN));
set(handles.SC3,'string',num2str(NaN));
set(handles.SC4,'string',num2str(NaN));
set(handles.Vr,'string',num2str(NaN));
set(handles.CritValue,'string',num2str(NaN));
set(handles.PreferFit,'string',num2str(NaN));
set(handles.Number,'string',num2str(NaN));

% 2) Initially defined parameters:
% handles.view1_ini=str2num(get(handles.view1,'String'));
% handles.view2_ini=str2num(get(handles.view2,'String'));
% handles.view3_ini=str2num(get(handles.view3,'String'));
% 
% mapview=[handles.view1_ini,...
%          handles.view2_ini,...
%          handles.view3_ini];
mapview=[str2num(get(handles.view1,'String')),...
    str2num(get(handles.view2,'String')),...
    str2num(get(handles.view3,'String'))];

% 3) initiate map axes and all the map background data
axes(handles.axes1); axis off,axesm ortho % mollweid;
setm(gca,'Origin', mapview), framem on; tightmap; gridm on

% load coastline
coast=load('coast');
handles.hCoast1=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none');

% initiate map axes and all the map background data
axes(handles.axes2); axis off,axesm ortho % mollweid;
setm(gca,'Origin', mapview), framem on; tightmap; gridm on

% load coastline
coast=load('coast');
handles.hCoast2=geoshow(coast.lat,coast.long,'DisplayType','polygon',...
    'FaceColor',[.83 .82 .78],'edgecolor','none');


% --- Executes on button press in SingleFit.
function SingleFit_Callback(hObject, eventdata, handles)
% hObject    handle to SingleFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pole1=str2num(get(handles.track1,'String'));
pole2=str2num(get(handles.track2,'String'));

if get(handles.SignGC,'String')=='+'
    signGC=1;
elseif get(handles.SignGC,'String')=='-'
    signGC=-1;
else
    disp('Problem in rotation direction assignment! + means CCW.')
end
if get(handles.SignSC,'String')=='+'
    signSC=1;
elseif get(handles.SignSC,'String')=='-'
    signSC=-1;
else
    disp('Problem in rotation direction assignment! + means CCW.')
end

if isfield(handles,'LoadPMdata')==0
    disp('Please load paleomag data first!');
elseif isfield(handles,'LoadPMdata')==1
    data=handles.LoadPMdata;
    [EuParaGC,D_GC,EuParaSC,D_SC,Vr,CriValue]=GCSCfit(data(pole1:pole2,:));
    EuParaGC(3)=signGC*EuParaGC(3);
    EuParaSC(3)=signSC*EuParaSC(3);
    handles.PEPSingle=[EuParaGC,D_GC,EuParaSC,D_SC,...
        abs(pole2-pole1+1),signGC,signSC,Vr,CriValue];
    
    % pass the results to text box
    set(handles.GC1,'string',num2str(EuParaGC(1)));
    set(handles.GC2,'string',num2str(EuParaGC(2)));
    set(handles.GC3,'string',num2str(D_GC));
    set(handles.GC4,'string',num2str(EuParaGC(3)));
    
    set(handles.SC1,'string',num2str(EuParaSC(1)));
    set(handles.SC2,'string',num2str(EuParaSC(2)));
    set(handles.SC3,'string',num2str(D_SC));
    set(handles.SC4,'string',num2str(EuParaSC(3)));
    set(handles.Vr,'string',num2str(Vr));
    set(handles.CritValue,'string',num2str(CriValue));
    set(handles.Number,'string',num2str(pole2-pole1+1));
    
    % plot the fitted GC and SC
    axes(handles.axes1)
    geoshow(EuParaGC(2), EuParaGC(1),'DisplayType','point',...
        'Marker','p','MarkerSize',12,'MarkerEdgeColor','r','LineWidth',1);
    [IncGC,DecGC] = scircle1(EuParaGC(2), EuParaGC(1),D_GC);
    geoshow(IncGC,DecGC,'Color','r','LineWidth',1.5);
    
    axes(handles.axes2)
    geoshow(EuParaSC(2), EuParaSC(1),'DisplayType','point',...
        'Marker','p','MarkerSize',12,'MarkerEdgeColor','r','LineWidth',1);
    [IncSC,DecSC] = scircle1(EuParaSC(2), EuParaSC(1),D_SC);
    geoshow(IncSC,DecSC,'Color','r','LineWidth',1.5);
    
    % assisting the decision of better fitting
    if Vr>CriValue
        set(handles.PreferFit,'string','SC');
    else
        set(handles.PreferFit,'string','GC');
    end
    
    disp('Single circle fitting completed.');
end
guidata(hObject, handles);
 

function GC3_Callback(hObject, eventdata, handles)
% hObject    handle to GC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GC1 as text
%        str2double(get(hObject,'String')) returns contents of GC1 as a double


% --- Executes during object creation, after setting all properties.
function GC3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GC1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SC1_Callback(hObject, eventdata, handles)
% hObject    handle to GC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GC2 as text
%        str2double(get(hObject,'String')) returns contents of GC2 as a double


% --- Executes during object creation, after setting all properties.
function SC1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GC2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SC2_Callback(hObject, eventdata, handles)
% hObject    handle to GC3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GC3 as text
%        str2double(get(hObject,'String')) returns contents of GC3 as a double


% --- Executes during object creation, after setting all properties.
function SC2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GC3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function SC3_Callback(hObject, eventdata, handles)
% hObject    handle to SC3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SC3 as text
%        str2double(get(hObject,'String')) returns contents of SC3 as a double


% --- Executes during object creation, after setting all properties.
function SC3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SC3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function Vr_Callback(hObject, eventdata, handles)
% hObject    handle to Vr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Vr as text
%        str2double(get(hObject,'String')) returns contents of Vr as a double


% --- Executes during object creation, after setting all properties.
function Vr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Vr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function GC4_Callback(hObject, eventdata, handles)
% hObject    handle to GC4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of GC4 as text
%        str2double(get(hObject,'String')) returns contents of GC4 as a double


% --- Executes during object creation, after setting all properties.
function GC4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GC4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SC4_Callback(hObject, eventdata, handles)
% hObject    handle to SC4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SC4 as text
%        str2double(get(hObject,'String')) returns contents of SC4 as a double


% --- Executes during object creation, after setting all properties.
function SC4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SC4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in PMDataA95.
function PMDataA95_Callback(hObject, eventdata, handles)
% hObject    handle to PMDataA95 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of PMDataA95

% ------------------------
% if this button is selected
if isfield(handles,{'hPMdataA95_GC','hPMdataA95_SC'})==0
    disp('Please load paleomag data first!');
elseif isfield(handles,{'hPMdataA95_GC','hPMdataA95_SC'})==1
    if (get(handles.PMDataA95,'Value') == get(handles.PMDataA95,'Max'))
        set(handles.hPMdataA95_GC,'Visible','on')
        set(handles.hPMdataA95_SC,'Visible','on')
    elseif (get(handles.PMDataA95,'Value') == get(handles.PMDataA95,'Min'))
        set(handles.hPMdataA95_GC,'Visible','off')
        set(handles.hPMdataA95_SC,'Visible','off')
    end
end

% Update handles structure
guidata(hObject,handles);


% --- Executes on button press in Line.
function Line_Callback(hObject, eventdata, handles)
% hObject    handle to Line (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Line
% ------------------------
% if this button is selected
if isfield(handles,{'hPMline_GC','hPMline_SC'})==0
    disp('Please load paleomag data first!');
elseif isfield(handles,{'hPMline_GC','hPMline_SC'})==1
    if (get(handles.Line,'Value') == get(handles.Line,'Max'))
        set(handles.hPMline_GC,'Visible','on')
        set(handles.hPMline_SC,'Visible','on')
    elseif (get(handles.Line,'Value') == get(handles.Line,'Min'))
        set(handles.hPMline_GC,'Visible','off')
        set(handles.hPMline_SC,'Visible','off')
    end
end

% Update handles structure
guidata(hObject,handles);


function CritValue_Callback(hObject, eventdata, handles)
% hObject    handle to CritValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CritValue as text
%        str2double(get(hObject,'String')) returns contents of CritValue as a double


% --- Executes during object creation, after setting all properties.
function CritValue_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CritValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit29_Callback(hObject, eventdata, handles)
% hObject    handle to CritValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of CritValue as text
%        str2double(get(hObject,'String')) returns contents of CritValue as a double


% --- Executes during object creation, after setting all properties.
function edit29_CreateFcn(hObject, eventdata, handles)
% hObject    handle to CritValue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function uipanel7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function Number_Callback(hObject, eventdata, handles)
% hObject    handle to Number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Number as text
%        str2double(get(hObject,'String')) returns contents of Number as a double


% --- Executes during object creation, after setting all properties.
function Number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function PreferFit_Callback(hObject, eventdata, handles)
% hObject    handle to PreferFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PreferFit as text
%        str2double(get(hObject,'String')) returns contents of PreferFit as a double


% --- Executes during object creation, after setting all properties.
function PreferFit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PreferFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SignGC_Callback(hObject, eventdata, handles)
% hObject    handle to SignGC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SignGC as text
%        str2double(get(hObject,'String')) returns contents of SignGC as a double
disp('Rotation direction for GC specified.');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function SignGC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SignGC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function SignSC_Callback(hObject, eventdata, handles)
% hObject    handle to SignSC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SignSC as text
%        str2double(get(hObject,'String')) returns contents of SignSC as a double
disp('Rotation direction for SC specified.');
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function SignSC_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SignSC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Projection1.
function Projection1_Callback(hObject, eventdata, handles)
% hObject    handle to Projection1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Projection1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Projection1
cla(handles.axes1);
axes(handles.axes1); axis off;
ProjTypes=get(hObject,'Value');
switch ProjTypes
    case 1
        % initiate map: mollweid, ortho
        cla(handles.axes1); axesm ortho; handles.ProjT='ortho';
        handles.ProjWin=1;
    case 2
        cla(handles.axes1); axesm mollweid; handles.ProjT='mollweid';
        handles.ProjWin=1;
    case 3
        cla(handles.axes1); axesm ortho; handles.ProjT='ortho';
        handles.ProjWin=1;
    case 4
        cla(handles.axes1); axesm robinson; handles.ProjT='robinson';
        handles.ProjWin=1;
    case 5
        cla(handles.axes1); axesm mercator; handles.ProjT='mercator';
        handles.ProjWin=1;
    case 6
        cla(handles.axes1); axesm sinusoid; handles.ProjT='sinusoid';
        handles.ProjWin=1;
    case 7
        cla(handles.axes1); axesm eqdcylin; handles.ProjT='eqdcylin';
        handles.ProjWin=1;
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

disp('Projection 1 in use.');

 guidata(hObject, handles);
 

% --- Executes during object creation, after setting all properties.
function Projection1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Projection1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ExportBatchFit.
function ExportBatchFit_Callback(hObject, eventdata, handles)
% hObject    handle to ExportBatchFit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'PEPBatch')==0
    disp('Please calculate Euler parameters first!');
elseif isfield(handles,'PEPBatch')==1
    PEPBatch=handles.PEPBatch;
    % save .mat file
    [FileName,PathName]=uiputfile('*.mat','Save Euler Parameters As');
    if FileName ~= 0
        nbfiles = 1;
    else
        nbfiles = 0;
    end
    
    if nbfiles==1
        FullName=[PathName,'PEPBatch_',FileName];
        save(FullName, 'PEPBatch');
        disp('GC & SC Euler parameters exported.');
    elseif nbfiles==0
%         disp('Please name the data!');
    end
end
guidata(hObject, handles);


% --- Executes on selection change in Projection2.
function Projection2_Callback(hObject, eventdata, handles)
% hObject    handle to Projection2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Projection2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Projection2
cla(handles.axes2);
axes(handles.axes2); axis off;
ProjTypes=get(hObject,'Value');
switch ProjTypes
    case 1
        % initiate map: mollweid, ortho
        cla(handles.axes2); axesm ortho; handles.ProjT='ortho';
        handles.ProjWin=2;
    case 2
        cla(handles.axes2); axesm mollweid; handles.ProjT='mollweid';
        handles.ProjWin=2;
    case 3
        cla(handles.axes2); axesm ortho; handles.ProjT='ortho';
        handles.ProjWin=2;
    case 4
        cla(handles.axes2); axesm robinson; handles.ProjT='robinson';
        handles.ProjWin=2;
    case 5
        cla(handles.axes2); axesm mercator; handles.ProjT='mercator';
        handles.ProjWin=2;
    case 6
        cla(handles.axes2); axesm sinusoid; handles.ProjT='sinusoid';
        handles.ProjWin=2;
    case 7
        cla(handles.axes2); axesm eqdcylin; handles.ProjT='eqdcylin';
        handles.ProjWin=2;
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

disp('Projection 2 in use.');
guidata(hObject, handles);
 

% --- Executes during object creation, after setting all properties.
function Projection2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Projection2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
