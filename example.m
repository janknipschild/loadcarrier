[carrierFV,loadFV,loadOffFV] = loadcarrier('geometry/bunny_scaled.stl',1.5,[0.1 0.1 0.1],3,3,1,[0 0 0],0);
%% visualization
vc=carrierFV.vertices;
fc=carrierFV.faces;
v0=loadFV.vertices;
f=loadFV.faces;
v=loadOffFV.vertices;
clf;
helper_patchplot(vc,fc);
hold on
lift=(max(vc(:,3))-min(v0(:,3)))+1;
v0_raised=v0;
v0_raised(:,3)=v0(:,3)+lift;
v_raised=v;
v_raised(:,3)=v(:,3)+lift;
patch('Faces',f,'Vertices',v0_raised,'FaceColor','r','EdgeColor','none');
h=patch('Faces',f,'Vertices',v_raised,'FaceColor',[211/254 211/254 211/254],'EdgeColor','none');
h.FaceAlpha='flat';
h.FaceVertexAlphaData=0.1;
hold off
set(gca,'visible','off')
view(-50,37.5)
print('out.png','-dpng','-r300')
%% save output
% stlwrite.m (https://de.mathworks.com/matlabcentral/fileexchange/20922-stlwrite-write-ascii-or-binary-stl-files)
stlwrite('output.stl',f,v)