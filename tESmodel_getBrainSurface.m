% TODO
% - fix limits of slice
% - auto fix for crossings
% - note changes ready for skull merge

function [boundary,skull] = tESmodel_getBrainSurface(Slice)

% Horrible fix
% was 96, 126
ymax=96; xmax=126;


% mask of image
BW = zeros(size(Slice));
BW(find(Slice>.9))=1;
% get point on boundary
dim = size(BW);
col = round(dim(2)/2);
row = min(find(BW(:,col)));
% trace boundary
boundary = bwtraceboundary(BW,[row, col],'N');
newboundary = [];
for i=1:size(boundary,1)
    B = boundary(i,:);
    if ((B(1)>ymax)||(B(2)>xmax))
        % do nothing
    else
        newboundary = [newboundary; B];
    end
end
boundary = [newboundary; ymax xmax];


% Skull proxy
skull = [62 ymax+1; 62 60; 72, 50; 85, 40; 100 32; 120 28; xmax+1 28; xmax+1 ymax+1];


%  SAVE FOR LATER - SKULL
%{
 % Skull slice
BW = zeros(size(Skull));
BW(find(Skull>.9))=1;
% get point on boundary
dim = size(BW);
col = round(dim(2)/2);
row = min(find(BW(:,col)));
% trace boundary
skboundary = bwtraceboundary(BW,[row, col],'N');
newboundary = [];
ymax=96; xmax=126;
for i=1:size(skboundary,1)
    B = skboundary(i,:);
    if ((B(1)>ymax)||(B(2)>xmax))
        % do nothing
    else
        newboundary = [newboundary; B];
    end
end
skboundary = [newboundary; ymax xmax];
%}
