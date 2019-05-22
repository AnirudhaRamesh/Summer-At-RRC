
%% DLT

a = zeros(12,12) ; 
zero_array = [0 0 0 0] ;

for i=1:6
    a_x  = [ -1 * world_coordinates(i,:), -1 , zero_array, image_coordinates(i,1) * world_coordinates(i,:), image_coordinates(i,1) ] ; 
    a_y = [ zero_array, -1 * world_coordinates(i,:),-1, image_coordinates(i,2) * world_coordinates(i,:), image_coordinates(i,2) ] ; 
    a((2*i)-1,:) = a_x ; 
    a(2*i,:) = a_y ; 
end

[U,S,V] = svd(a) ; 

p = V(:,12) ; 

P = [ p(1:4)' ; p(5:8)' ; p(9:12)' ] ; 

%% Decompose P into RQ

    
x = P(:,1:3) ; 

[r q] = RQdecomposition(x); 

R = q ; 
K = r ; 

t = -inv(P(:,1:3))*P(:,4) ; 

final_mat = [ R R*(t) ; 0,0,0,1 ] ; 
final_mat = inv(final_mat) ; 

%% Rest implemented in python. Export final_mat to python. 


function [r q] = RQdecomposition(X)
    m = size(X,1);
    n = size(X,2);
    if m == n
        q = eye(n);
        i = n;
        temp2 = X;
        while i > 1
            j = i - 1;
            while j > 0
                if temp2(i,j) ~= 0
                   temp = eye(n);
                   costheta = temp2(i,i)/sqrt( temp2(i,j).^2 + temp2(i,i).^2 );
                   sintheta = temp2(i,j)/sqrt( temp2(i,j).^2 + temp2(i,i).^2 );
                   temp(i,j) = - sintheta; 
                   temp(i,i) = costheta;
                   temp(j,i) = sintheta;
                   temp(j,j) = costheta;
                   q = q*temp;
                   temp2 = temp2*temp;
                end
                j = j - 1;
            end
            i = i - 1;
        end
        r = temp2;
        q = q';
    else
        r = zeros(m,n);
        q = zeros(m,n);
    end
end

    
