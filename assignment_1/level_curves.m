x = linspace(-3,3) ; 
y = linspace(-3,3) ;
[X Y] = meshgrid(x,y) ; 
Z = X.^2 - Y.^2 ; 

contour(X,Y,Z, 15,'ShowText','on') ; 

hold on 

[U V] = gradient(Z) ; 

quiver(X,Y,U,V,1.5)

hold off