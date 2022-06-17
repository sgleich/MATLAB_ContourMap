%% Contour plot with map overlay
% By: Samantha Gleich
% Last updated: June 17, 2022
%
%
% This script will create a contour plot of chlorophyll a and overlay a map 
% of California onto the contours. Then, the San Pedro Ocean Time Series 
% (SPOT) site will be plotted over the contours. 
%% Load x, y, z data in as matrix 
chl= readmatrix("chla_june42022.csv");
%% Create x, y, z variables from chl matrix
% Remove NAs in dataframe (if you don't do this, contours will look wonky)
chl(any(isnan(chl),2),:) = []; 
%
% Longitude
x=chl(:,2); 
x=x*-1; % Multiply x by -1 because -x = positive longitude west
% Latitude
y=chl(:,3);
% Chla
z=chl(:,4); 
%% Calculate the min and max of the x and y vectors
minx=min(x); 
maxx=max(x);
miny=min(y); 
maxy=max(y);
%% Let's make sure we can access the map we'll want to overlay later. For this example, we want California
figure
cali = shaperead('usastatehi.shp', 'UseGeoCoords', true,...
        'Selector',{@(name) strcmpi(name,'California'), 'Name'}); % Notice how my California map object is called 'cali'. We will use this later.
geoshow(cali) % Looks good!
%% We need to create a polygon image of our 'cali' map object
hx = cali.Lon; % x values associated with cali shape
hy=cali.Lat; % y values associated with cali shape
hx=hx*-1; % Multiply x by -1 because -x = positive longitude west
hpoly=cali.Geometry;
pgon = polyshape([hx],[hy]); % Make polygon shape object. This is what will be overlayed on top of our contour plot
%% Make contour plot
figure
% Steps in the x and y direction. This tells MATLAB how often to calculate
% contours.
dx=0.1; dy=0.1;

% Create 2D grid for our contour
[xi,yi]=meshgrid(minx-dx:dx:maxx+dx,miny-dy:dy:maxy+dy);

% Interpolates scattered data
zi=griddata(x,y,z,xi,yi,'linear');

% Plot contours. The contourf command produces a filled contour plot. You
% can play with other contour commands if you want (e.g. contour)
[c,h]=contourf(xi,yi,zi,-0.5:0.01:0.7); % The 0.01 value here can be manipulated. 
% Increasing this number will result in thicker contours and decreasing the 
% number will result in thinner contours.

set(gca, 'XDir','reverse')
colormap(parula) % Color scale
xlabel('Longitude W', 'FontSize',24) % Specifications for axes
ylabel('Latitude N', 'FontSize', 24)

% Legend
hcb=colorbar
title(hcb,'Chl a (μg/L)')

% Limits 
% Limits here are important. I'm setting the x and y limits so we can be
% right around the spot station. 
xlim([117 118.66])
ylim([33.2 33.9])

hold on
%% Add map, points, and labels on to contour
plot(pgon,'FaceColor','black','FaceAlpha',1) % Map object
x2=[118.40]; % SPOT longitude
y2=[33.55]; % SPOT latitude
labels={'SPOT'}; % SPOT label
plot(x2,y2,'k.', 'MarkerSize', 24) 
text(x2,y2,labels,'VerticalAlignment','bottom', 'FontSize', 20,'FontWeight','bold')
