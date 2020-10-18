function [b_result] = G10_Poisson_Equation_Axb(i,j,param)

if (isfield(param, 'driving'))
    b_result = param.driving(i, j);
else
    b_result = 0;
end


