function visualizeCamera(R, t, c)
    pyramid = [0,0,0; 1,1,1; -1,1,1; 1,-1,1; -1,-1,1];
    pyramid = R * pyramid' + R * t';
    pyramid = double(-pyramid');
    pyramid = 1 .* pyramid ; 
    shape = alphaShape(pyramid(:,1),pyramid(:,2),pyramid(:,3));
    s1 = plot(shape);
    s1.FaceColor = c;
    hold on;
end