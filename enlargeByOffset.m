function v_offset = enlargeByOffset(v,f,n,off)
%ENLAGRGEBYOFFSET offsets a triangulated surface by a given amount
% The implementes algorithm is described as "Average Weighted by Angle"
% in Thuermer, Grit; Wuethrich, Charles A. (1998): Computing vertex normals 
% from polygonal facets. In: Journal of Graphics Tools 3 (1), S. 43–46.
%
% v Face vertices
% f Face connection list
% n Face normal vectors
% off Offset amount

% only works without duplicate vertices
if (size(unique(v,'rows'),1) ~= size(v,1))
    error('v contains duplicate vertices!');
end

%% sort f by the vertices
% reshape f, sort and unique
f_linear = reshape(f', [], 1);
[f_linear_sorted, f_idx] = sort(f_linear);
[~,ia_start,~] = unique(f_linear_sorted);

% determine index segments per v(i,:)
ia_end = circshift(ia_start,-1)-1;
ia_end(end) = length(f_linear_sorted);
ia_end_incl = ia_end + 1;
ia_intervall_length = ia_end_incl-ia_start;

f_vector = fix((f_idx+2)./3); % first dimension index in f 
v_place_in_f = mod(f_idx-1,3)+1; % second dimension index in f
f_sorted = f(f_vector,:);
n_sorted = n(f_vector,:)';

% vertices used to calculate direction vectors as second dimension indices of f
v_direction_vector = (repmat(1:3,length(v_place_in_f),1)-v_place_in_f);
v_direction_vector = reshape(nonzeros(v_direction_vector'), 2, [])' + v_place_in_f;

% get the coordinates
rows = (1 : size(f_sorted, 1)) .';
idx_lin_1 = sub2ind(size(f_sorted), rows, v_direction_vector(:,1));
idx_lin_2 = sub2ind(size(f_sorted), rows, v_direction_vector(:,2));
v_direction_1 = v(f_sorted(idx_lin_1),:)';
v_direction_2 = v(f_sorted(idx_lin_2),:)';

% calculate angle between direction vectors
angle = atan2(norm(cross(v_direction_1,v_direction_2)),dot(v_direction_2,v_direction_1));
% weight the normal vector with the angle
m_addend = angle .* n_sorted;
% calculate vertex offset direction vectors
m = cell2mat(cellfun(@(cfvar)sum(cfvar,2), mat2cell(m_addend, 3, ia_intervall_length), 'UniformOutput', 0))';
m_norm = vecnorm(m,2,2);
m = m./m_norm;

if (~isempty(find(m_norm == 0, 1)))
    m(m_norm == 0,:) = 0;
end

v_offset = v + m*off;
end

