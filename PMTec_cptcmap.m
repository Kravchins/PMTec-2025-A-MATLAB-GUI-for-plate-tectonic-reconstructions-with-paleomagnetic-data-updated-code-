function varargout = PMTec_cptcmap(varargin)
% The MIT License (MIT)
% Copyright (c) 2015 Kelly Kearney
% https://kakearney.github.io/2015/12/18/cptcmap.html
% Permission is hereby granted, free of charge, to any person obtaining a copy of
% this software and associated documentation files (the "Software"), to deal in
% the Software without restriction, including without limitation the rights to
% use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
% the Software, and to permit persons to whom the Software is furnished to do so,
% subject to the following conditions:
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
% FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
% COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
% IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
% CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
% 
% The script is slightly modified to meet PMTec needs
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
% cptpath=[PMTecSysPath 'cptfiles'];
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
end 

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

% Parse topo2, foreground, and nan colors
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
    end

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
end

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
end
