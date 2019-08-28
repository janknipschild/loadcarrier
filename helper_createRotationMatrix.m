function M_rot = helper_createRotationMatrix(axis, angle)
%HELPER_CREATEROTATIONMATRIX creates a rotation matrix
%
% axis Rotation axis [x y z]
% angle Rotation angle
lcMat = zeros(3,3,3);
lcMat([8 12 22]) = 1;
lcMat([6 16 20]) = -1;

M_rot = zeros(3,3);
for i=1:3
    for j=1:3
        M_rot(i,j) = (1-cos(angle))*axis(i)*axis(j) + cos(angle)*eq(i,j) + sin(angle)*dot(lcMat(i,:,j),axis);
    end
end
end

