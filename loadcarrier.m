function [carrier,load,load_offset] = loadcarrier(filename,off,resolution,bottom_thickness,wall_thickness,support_ratio,rotation_axis,rotation_angle)
%LOADCARRIER Automatic shape generation for logistics load carriers
%
% Inputs:
% filename Path to load geometrys STL file
% off Clearance between load and carrier
% resolution Vector containing load carrier resolution [x y z]
% bottom_thickness Thickness of the carrier under the cargo
% wall_thickness Wall thickness of the load carrier
% support_ratio Amount of cargo surface area that is supported
% rotation_axis Vector defining the rotation axis [x y z]
% rotation_angle Angle the input geometry is turned around rotation_axis
% 
% Outputs: 
% carrier Structure containing the load carrier shape as faces and vertices
% load Structure containing the input geometry as faces and vertices
% load_offset Structure containing the offset input geometry as faces and vertices
% t_elapse Elapsed time during load carrier shape generation
%
% This implementation depends on following external scripts:
%     patchslim.m (https://de.mathworks.com/matlabcentral/fileexchange/29986-patch-slim--patchslim-m-)
%     stlread.m (https://de.mathworks.com/matlabcentral/fileexchange/22409-stl-file-reader)
%     findtria.m (https://www.mathworks.com/matlabcentral/fileexchange/48812-findtria-point-in-simplex-queries-in-d-dimensions)
%     mesh2tri.m (https://de.mathworks.com/matlabcentral/fileexchange/28327-mesh2tri)
%     surf2solid.m (https://de.mathworks.com/matlabcentral/fileexchange/42876-surf2solid-make-a-solid-volume-from-a-surface-for-3d-printing)
addpath include
%% load STL-file
tic
% helper_stl_check_filetype
[f,v,n]=stlread(filename);
[v, f]=patchslim(v, f);
v0=v; %save vertices without offset for later visualisation
helper_status_message('--> STL loaded.');

%% enlarge part by offset
if off>0
    v=enlargeByOffset(v,f,n,off);
    helper_status_message('--> part enlarged.');
end

%% rotation
if rotation_angle~=0
    R=helper_createRotationMatrix(rotation_axis,rotation_angle);
    v0=v0*R;
    v=v*R;
end
%% generate support structure
min_xyz = min(v);
max_xyz = max(v);
x=(min_xyz(1)-wall_thickness):resolution(1):(ceil(max_xyz(1))+wall_thickness);
y=(min_xyz(2)-wall_thickness):resolution(2):(ceil(max_xyz(2))+wall_thickness);
[px,py]=meshgrid(x,y);
p=[px(:),py(:)];
helper_status_message('--> grid points created.');

v_support = getIntersectionPoints(v,f,p,resolution(3),support_ratio);
v_support_meshgrid = reshape(v_support(:,3), size(px,1), size(px,2));
helper_status_message('--> determined intersection points.');

[f_final_support, v_final_support] = mesh2tri(px, py, v_support_meshgrid, 'b');
helper_status_message('--> surface triangulated.');

carrier_elevation = min(v_final_support(:,3))-bottom_thickness;
[f_final,v_final] = surf2solid(f_final_support, v_final_support, 'Elevation', carrier_elevation, 'Triangulation', 'b');
helper_status_message('--> boarder generated.');

[v_final, f_final] = patchslim(v_final, f_final);

load.faces = f;
load.vertices = v0;
load_offset.faces = f;
load_offset.vertices = v;
carrier.faces = f_final;
carrier.vertices = v_final;
helper_status_message('--> finished.');