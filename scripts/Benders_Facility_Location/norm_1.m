function [value] =  norm_1(M0)

% ee1 = ones(size(M0,1),1);
% ee2 = ones(size(M0,2),1);
% M = abs(M0);
% value = ee1'*M*ee2;

value = sum(abs(M0(:)));

end