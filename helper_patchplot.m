function h = helper_patchplot( v,f )
%HELPER_PATCHPLOT creates a shaded patchplot of geometry defined by faces
%and vertices
%
% v Vertices
% f Faces

h = patch('Faces', f, 'Vertices', v, 'FaceColor',[0.8 0.8 1.0], 'EdgeColor',  'none',  'FaceLighting', 'gouraud',  'AmbientStrength', 0.15);
camlight('headlight');
material('dull');
axis('image');
view([1 1 1])
grid
xlabel x
ylabel y
zlabel z
end

