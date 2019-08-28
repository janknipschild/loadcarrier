function v_support = getIntersectionPoints(v,f,p,resolution_z,support_ratio)
%GETINTERSECTIONPOINTS returns intersection points used as support between
% a dexel grid and triangulated surfaces.
%
% v face vertices
% f face connection list
% p [x,y] coordinates of dexel grid
% resolution_z resolution of dexel depth
% support_ratio defines the fraction of possible dexels used for support

%% intersection points barycentric coordinates
% projet faces onto xy-plane
tp = v(:,1:2);
% create triangulation object to use cartesianToBarycentric later
t = triangulation(f,tp);
[out_p,out_i] = findtria(tp,f,p);

% find dexels without
idx_p_eq_zero = find(out_p(:,1)==0);
% find dexel with interseciton
idx_p_neq_zero = find(out_p(:,1));
% relevant facets and dexels
out_p_relevant = out_p(idx_p_neq_zero,:);
p_relevant = p(idx_p_neq_zero,:);
% intervall lenght in out_p
out_p_relevant_intervall = out_p_relevant(:,2)-out_p_relevant(:,1)+1;

% expand grid points for use with cartesianToBarycentric
% p_expanded(out_p_relevant(i,1):out_p_relevant(i,2)) = p_relevant(i)
p_expanded = [repelem(p_relevant(:,1), out_p_relevant_intervall) repelem(p_relevant(:,2), out_p_relevant_intervall)];
% intersection points expressed through barycentric coordinates
coeff_barycentric = cartesianToBarycentric(t,out_i,p_expanded);
%% interpolate height for intersection point
% vertices' z-coordinates sorted by intersected faces
f_linear = reshape(f(out_i,:), [], 1);
v_linear_z = v(f_linear,3);
v_z = reshape(v_linear_z,[],3);
% interpolation at intersection point
z_intersection = dot(coeff_barycentric, v_z,2);
% find minimal intersection z-coordinate
z_min = cellfun(@min, mat2cell(z_intersection, out_p_relevant_intervall, 1));

%% support_ratio and reduce resolution
% calculate maximal carrier height
z_min_sort=sort(z_min);
h_max=z_min_sort(round(size(z_min_sort,1)*support_ratio));
z_min(z_min>h_max)=h_max;
% reduce resolution
z_min=floor(z_min./resolution_z)*resolution_z;
% z-coordinates of intersecting dexels
p(idx_p_neq_zero,3) = z_min;
% z-coordinates of not intersecting dexels
p(idx_p_eq_zero,3) = h_max; %#ok<FNDSB>

v_support = p;
end

