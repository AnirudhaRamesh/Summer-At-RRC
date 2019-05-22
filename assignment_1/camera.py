from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection, Line3DCollection
import numpy as np
from math import sin, cos, radians

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# fill alpha, beta, gamma, i here
alpha = radians(0) 
beta = radians(45)
gamma = radians(45)  
i = 1

vertices = [[-1, -1, -1], [1, -1, -1], [1, 1, -1],  [-1, 1, -1], [0, 0, 0]]
# vertices of a pyramid
v = np.array(vertices)
ax.scatter3D(v[:, 0], v[:, 1], v[:, 2])

# generate list of sides' polygons of our pyramid
verts = [ [v[0],v[1],v[4]], [v[0],v[3],v[4]],
 [v[2],v[1],v[4]], [v[2],v[3],v[4]], [v[0],v[1],v[2],v[3]]]

# plot sides
ax.add_collection3d(Poly3DCollection(verts, 
 facecolors='cyan', linewidths=1, edgecolors='r', alpha=.25))

Rot_matrix_alpha = np.array([[1,0,0],[0,cos(alpha),-sin(alpha)],[0,sin(alpha),cos(alpha)]])
Rot_matrix_beta = np.array([[cos(beta),0,sin(beta)],[0,1,0],[-sin(beta),0,cos(beta)]])
Rot_matrix_gamma = np.array([[cos(gamma),-sin(gamma),0],[sin(gamma),cos(gamma),0],[0,0,1]])

v = v.transpose() 
if i == 0 : 
    Rot_matrix = np.matmul(Rot_matrix_alpha,Rot_matrix_beta)  
    Rot_matrix = np.matmul(Rot_matrix,Rot_matrix_gamma) 
    v = np.matmul(Rot_matrix, v) 
else:
    v = np.matmul(Rot_matrix_gamma, v) 
    v = np.matmul(Rot_matrix_beta,v)  
    v = np.matmul(Rot_matrix_alpha,v) 

# generate list of sides' polygons of our pyramid
v = v.transpose()
verts = [ [v[0],v[1],v[4]], [v[0],v[3],v[4]],
 [v[2],v[1],v[4]], [v[2],v[3],v[4]], [v[0],v[1],v[2],v[3]]]

# plot sides
ax.add_collection3d(Poly3DCollection(verts, 
 facecolors='cyan', linewidths=1, edgecolors='r', alpha=.25))

plt.show()
