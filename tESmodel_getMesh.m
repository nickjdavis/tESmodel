function [p,e,t] = tESmodel_getMesh(brainsurface,scalp)

surface = [2; size(brainsurface,1); brainsurface(:,1); brainsurface(:,2)];
scalplayer = [2; size(scalp,1); scalp(:,2); scalp(:,1); zeros(size(surface,1)-size(scalp,1)-10,1)];
% s = [3 4 25 25 ymax ymax 62 xmax xmax 62 zeros(1,size(b,1)-10)]';
% size(surface)
% size(scalplayer)
G = [scalplayer surface];
ns = char('scalp','brain'); ns=ns';
sf = 'scalp-brain';
[dl,bt] = decsg(G,sf,ns);
% pdegplot(dl,'EdgeLabels','on','SubdomainLabels','on')
% waitforbuttonpress
gstat = csgchk(surface);
if any(gstat>0)
    disp('csgchk error')
end
[p,e,t] = initmesh(dl,'Jiggle','on');