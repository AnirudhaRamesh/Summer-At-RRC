% Main 

% Get matching features 
[ip, p1, p2 ]= feature_eandm('img1.png','img2.png');
s = size(ip) ;
max_number_correct = 0 ; 
min_err= 0 ; 

%Calculate d and mu

d_p1 = p1.Location ;
d_p2 = p2.Location ;  
mean_x_1 = mean(d_p1(:,1)) ; 
mean_y_1 = mean(d_p1(:,2)) ; 
mean_x_2 = mean(d_p2(:,1)) ; 
mean_y_2 = mean(d_p2(:,2)) ; 
d1 = mean(sqrt((d_p1(:,1) - mean_x_1).^2  + (d_p1(:,2) - mean_y_1).^2));
d2 = mean(sqrt((d_p2(:,1) - mean_x_2).^2  + (d_p2(:,2) - mean_y_2).^2)); 


%RANSAC and F calculation 
for epochs = 1:500
    indices_picked = ceil(rand(1,8) .* s(1)) ;
    %indices_picked = 1:8 ; 
    x1 = zeros(8,3) ; 
    x2 = zeros(8,3) ; 
    f_x1 = zeros(8,1) ; 
    f_x2 = zeros(8,1) ;  
    
    for i = 1:8
        x1(i,1:2) = p1(indices_picked(1,i)).Location ; x1(i,3) = 1 ; 
        x2(i,1:2) = p2(indices_picked(1,i)).Location ; x2(i,3) = 1 ;
    end
    
    % Normalizing  x1 and x2 (which are the corresponding points in
    % question) 
    
    T_1 = [1.44/d1, 0, -1.44/d1 * mean_x_1; 0, 1.44/d1, -1.44/d1 * mean_y_1; 0, 0, 1] ; 
    for i = 1:8
        x1(i,:) = (T_1 * x1(i,:)')' ; 
    end
    
    
    T_2 = [1.44/d2, 0, -1.44/d2 * mean_x_2; 0, 1.44/d2, -1.44/d2 * mean_y_2; 0, 0, 1] ; 
    for i = 1:8
        x2(i,:) = (T_2 * x2(i,:)')' ;
    end
    
    % Getting F matrix 
    F = motion_estimation(x1,x2) ; 
    
    %Denormalizing F matrix 
    F = T_2'*F*T_1 ;
    K = [558.7087, 0.0, 310.3210; 0.0, 558.2827, 240.2395; 0.0, 0.0, 1.0] ; 
    
    all_corresponding_points_x1 = zeros(s(1),3) ; 
    all_corresponding_points_x2 = zeros(s(1),3) ; 
    
    number_correct = 0 ; 
    
    % Using coplanarity constraint to check how many points fit within
    % given constraint 
    for i = 1:s(1) 
        all_corresponding_points_x1(i,1:2) = p1(i).Location ; all_corresponding_points_x1(i,3) = 1 ; 
        all_corresponding_points_x2(i,1:2) = p2(i).Location ; all_corresponding_points_x2(i,3) = 1 ;
        val = all_corresponding_points_x2(i,:) * F * all_corresponding_points_x1(i,:)' ; 
        if val < 0.05 
            number_correct = number_correct +1 ; 
        end 
    end
    
    if number_correct > max_number_correct 
        max_number_correct = number_correct ; 
        Best_F = F ; 
        correspondind_x1 = x1 ; 
        correspondind_x2 = x2 ; 
    end
    
    disp(number_correct) ; 
end

% Predicted E matrix 
Epred = K'*Best_F*K ;

% Enforcing rank 2
[Ue Se Ve] = svd(Epred) ; 
Se = diag([1,1,0]) ;
E = Ue * Se * Ve' ;

% Denormalizing points 

for i = 1:8
    correspondind_x1(i,:) = (inv(T_1) * correspondind_x1(i,:)')' ; 
end

for i = 1:8
    correspondind_x2(i,:) = (inv(T_2) * correspondind_x2(i,:)')' ;
end


% Calculating Relative Camera Positions of the two given cameras after
% fixing one of them at origin.

K = [558.7087, 0.0, 310.3210; 0.0, 558.2827, 240.2395; 0.0, 0.0, 1.0] ; 
cam_intrinsic = cameraIntrinsics([558.7087,558.2827], [310.3210,240.2395], [480,640] ) ; 

[R,t] = relativeCameraPose(E,cam_intrinsic,correspondind_x1(:,1:2),correspondind_x2(:,1:2)) ; 

% Triangulation 
%f = [0 0 0 1]' ; 
%z = [relativeOrientation relativeLocation' ; 0 0 0 1] ; 
%g = z * f ; 
%f = f(1:3,:) ; 
%g = g(1:3,:) ; 

P1 = K * eye(3) * cat(2,eye(3), [0 0 0]');
P2 = K * R * cat(2,eye(3), t');

%P1 = K * [1 0 0 0; 0 1 0 0; 0 0 1 0] ; 
%P2 = K * [R, R*t' ] ; 

sz = size(p1,1);

m1 = p1.Location ; 
m2 = p2.Location ; 

Points = Triangulation(P1,P2,m1,m2, sz) ;

figure, visualizeCamera(R,t, 'r');
visualizeCamera(eye(3),[0 0 0], 'g');

scatter3(Points(:,1),Points(:,2),Points(:,3));

axis([-200 200 -200 200 -200 200]) ;
