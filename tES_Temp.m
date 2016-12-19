% check slice data

function tES_Temp (xmax,ymax)

if nargin<2
    xmax = 0;
    ymax = 0;
end

gmfile = '.\data\c1sHive_03-0301-00003-000001-01_1.nii';
GMvol = spm_vol(gmfile);
GMimg = spm_read_vols (GMvol);
Slice = rot90(squeeze(GMimg(:,150,:)));

% mask of image
BW = zeros(size(Slice));
BW(find(Slice>.9))=1;
% get point on boundary
dim = size(BW);
col = round(dim(2)/2);
row = min(find(BW(:,col)));
% trace boundary
% boundary = bwtraceboundary(BW,[row, col],'N');
% size(boundary)
% newboundary = [];
% for i=1:size(boundary,1)
%     B = boundary(i,:);
%     if ((B(1)>ymax)||(B(2)>xmax))
%         % do nothing
%     else
%         newboundary = [newboundary; B];
%     end
% end
% boundary = [newboundary; ymax xmax];

% Skull proxy
skull = [col-100 row-40; col-100 row+100; col+100 row+100; col+100 row-40];
% Good bounding box - does it need to be complete?

[B,L] = bwboundaries(imbinarize(BW),'noholes');
boundary = B{1};
boundary = [boundary; boundary(1,:)];
size(boundary)
% imshow(label2rgb(L, @jet, [.5 .5 .5]))
% hold on
% for k = 1:1 %:length(B)
%    by = B{k};
%    plot(by(:,2), by(:,1), 'w', 'LineWidth', 2)
%    text (by(1,2),by(1,1),num2str(k))
% end
% waitforbuttonpress
% % bwperim(BW)
% % waitforbuttonpress
% % 
% % % plots
% % Plot boundary on brain slice
% imshow(Slice)
% hold on;
% plot (boundary(:,2),boundary(:,1),'g',...
%     'LineWidth',2)
% plot (skull(:,1),skull(:,2),'r',...
%     'LineWidth',2)
% hold off; waitforbuttonpress


surface = [2; size(boundary,1); boundary(:,1); boundary(:,2)];
scalplayer = [2; size(skull,1); skull(:,2); skull(:,1); zeros(size(surface,1)-size(skull,1)-6,1)];
% size(surface)
% size(scalplayer)
gstat_surface = csgchk(surface)
gstat_scalp = csgchk(scalplayer)
G = [scalplayer surface];
ns = char('scalp','brain'); ns=ns';
sf = 'scalp-brain';
% sf = 'scalp';
[dl,bt,dl1,bt1,msb] = decsg(G,sf,ns);

