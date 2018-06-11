% Master function for tESmodel project
%
% New version for TwoSlice branch - healthy and atrophied
%
% Based on testImProcSectionNew() from Royal Society meeting

function tESmodel()

%% Get image data
gmfile1 = '.\data\c1sHive_03-0301-00003-000001-01_1.nii';
Slice1 = tESmodel_getImageData(gmfile1);



%% Image processing - get boundary and prepare as polygon
[boundary,pts] = tESmodel_getBrainSurface(Slice1);
% Skull proxy
%pts = [62 96; 62 60; 72, 50; 85, 40; 100 32; 120 28; 126 28; 126 96];



%% Set up geometry for PDE
[p,e,t] = tESmodel_getMesh(boundary,pts);


%% Specify boundary conditions and solve PDE
U = assempde(@pdeb,p,e,t,1,0,1); % for Poisson, c=1,a=0,f=1
[ux,uy] = pdegrad(p,t,U); % Calculate gradient
ugrad = [ux;uy];
% figure
% pdeplot(p,e,t,'xydata',U,...
%     'colormap','jet','colorbar','off')
% figure
% pdeplot(p,e,t,'flowdata',ugrad)
figure
pdeplot(p,e,t,'xydata',U,'flowdata',ugrad,...
    'colormap','jet','colorbar','off')
% figure
% pdeplot(p,e,t,'flowdata',ugrad)



%% IMAGES
%{
% Plot boundary on brain slice
imshow(Slice)
hold on;
plot (boundary(:,2),boundary(:,1),'g',...
    'LineWidth',2)
plot (pts(:,1),pts(:,2),'r',...
    'LineWidth',2)
hold off; waitforbuttonpress
%}

%{ 
% Plot geometry and mesh
pdegplot(dl,'edgeLabels','on')
axis equal
waitforbuttonpress
pdeplot(p,e,t);%,'edgeLabels','on')
axis equal
waitforbuttonpress
%}




%% PDE boundary function
function [qmatrix,gmatrix,hmatrix,rmatrix] = pdeb(p,e,u,time)
ne = size(e,2);
qmatrix = zeros(1,ne);
gmatrix = qmatrix;
hmatrix = zeros(1,2*ne);
rmatrix = hmatrix;
for k=1:ne
    x1 = p(1,e(1,k)); % x at first point in segment
    x2 = p(1,e(2,k)); % x at second point in segment
    xm = (x1 + x2)/2; % x at segment midpoint
    y1 = p(2,e(1,k)); % y at first point in segment
    y2 = p(2,e(2,k)); % y at second point in segment
    ym = (y1 + y2)/2; % y at segment midpoint
    switch e(5,k)
        case {2}
            % Fill in hmatrix,rmatrix or qmatrix,gmatrix
            hmatrix(k) = 1;
            hmatrix(k+ne) = 1;
            rmatrix(k) =1;
            rmatrix(k+ne)=1;
        otherwise
            % Fill in hmatrix,rmatrix or qmatrix,gmatrix
            hmatrix(k) = 0;
            hmatrix(k+ne)=0;
            rmatrix(k)=0;
            rmatrix(k+ne)=0;
    end
end