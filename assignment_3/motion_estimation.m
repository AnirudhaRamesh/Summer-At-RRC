function [F] = motion_estimation(x1,x2)

%for each x1,x2 pair do
x = zeros(8,9) ; 
for i = 1:8
    x(i,:) = kron(x2(i,:),x1(i,:)) ;
end

% xf = 0 

[U S V] = svd(x) ;

F_1 = reshape(V(:,9),3,3)' ;

[U_f, S_f, V_f] = svd(F_1) ; 

F = U_f * diag([S_f(1,1), S_f(2,2), 0]) * V_f' ; 

end