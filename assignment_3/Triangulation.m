function [Points] = Triangulation(P1,P2,m1,m2,sz) 
    Points = zeros(sz,4) ; 
    for i=1:sz
        A =[m1(i,1).*P1(3,:) - P1(1,:);...
            m1(i,2).*P1(3,:) - P1(2,:);...
            m2(i,1).*P2(3,:) - P2(1,:);...
            m2(i,2).*P2(3,:) - P2(2,:)];
        [U, S, V] = svd(A);

        Points(i,:) = V(:,4)./V(4,4);
    end
end 