%% code written for square matrix for simplicity, but can be converted to rectangular by just adding m and n wherever only n is mentioned.

n = 3 ;

A = magic(n) ; 

Q = zeros(n) ;

A_new = rot90(rot90(rot90(A))) ; 

for i=1:n
    temp = A_new(:,i) ; 
    Q(:,i) = temp ; 
    for j=i-1:-1:1
        Q(:,i) = Q(:,i) - (Q(:,j)'*temp)*Q(:,j) ; 
    end
    Q(:,i) = Q(:,i)/norm(Q(:,i)) ; 
end

Q = rot90(Q) ; 

R = A*Q';

disp("R =") ;
disp(R) ; 
disp("Q =") ; 
disp(Q) ; 


