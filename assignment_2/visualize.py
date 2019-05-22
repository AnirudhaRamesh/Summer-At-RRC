from matplotlib import pyplot as plt
from mpl_toolkits.mplot3d.art3d import Poly3DCollection, Line3DCollection
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
from math import sin, cos, radians
from itertools import product, combinations

fig = plt.figure()
# ax = fig.gca(projectio    n='3d')
ax = fig.add_subplot(111, projection='3d')
ax.set_aspect("equal")

# draw cube
r = [0,57]
for s, e in combinations(np.array(list(product(r, r, r))), 2):
    if np.sum(np.abs(s-e)) == r[1]-r[0]:
        ax.plot3D(*zip(s-[57,0,57], e-[57,0,57]), color="b")

# fill alpha, beta, gamma, i here
alpha = radians(0) 
beta = radians(45)
gamma = radians(45)  
i = 1

vertices = [[-10, -10, -10, 1], [10, -10, -10, 1], [10, 10, -10, 1],  [-10, 10, -10, 1], [0, 0, 0, 1]]
# vertices of a pyramid
v = np.array(vertices)
ax.scatter3D(v[:, 0], v[:, 1], v[:, 2])

# final_mat = [
#     [0.7632   ,-0.3079    ,0.5680  ,11.6502],
#     [0.6371    ,0.5050   ,-0.5823   ,-18.6902],
#    [-0.1075    ,0.8063    ,0.5816  ,15.8895],
#     [     0     ,    0    ,     0    ,1.0000]
# ]

final_mat = [ 
   [0.7619,   -0.3149,    0.5660 ,  11.9507],
    [0.6396,    0.5032,   -0.5811,  -18.4913],
   [-0.1019,    0.8047,    0.5848,   15.4452],
    [     0,         0 ,        0,    1.0000]
]

f_m = np.array(final_mat)
v = v.transpose() 
v = np.matmul(f_m,v) 

v = v.transpose()
new_v = [[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]]
for i in range(0,5):
    new_v[i] = [ v[i][0] , v[i][1], v[i][2] ] 

# generate list of sides' polygons of our pyramid
verts = [ [new_v[0],new_v[1],new_v[4]], [new_v[0],new_v[3],new_v[4]],
 [new_v[2],new_v[1],new_v[4]], [new_v[2],new_v[3],new_v[4]], [new_v[0],new_v[1],new_v[2],new_v[3]]]

# plot sides
ax.add_collection3d(Poly3DCollection(verts, 
 facecolors='cyan', linewidths=1, edgecolors='r', alpha=.25))

# Rot_matrix_alpha = np.array([[1,0,0],[0,cos(alpha),-sin(alpha)],[0,sin(alpha),cos(alpha)]])
# Rot_matrix_beta = np.array([[cos(beta),0,sin(beta)],[0,1,0],[-sin(beta),0,cos(beta)]])
# Rot_matrix_gamma = np.array([[cos(gamma),-sin(gamma),0],[sin(gamma),cos(gamma),0],[0,0,1]])

# v = v.transpose() 
# if i == 0 : 
#     Rot_matrix = np.matmul(Rot_matrix_alpha,Rot_matrix_beta)  
#     Rot_matrix = np.matmul(Rot_matrix,Rot_matrix_gamma) 
#     v = np.matmul(Rot_matrix, v) 
# else:
#     v = np.matmul(Rot_matrix_gamma, v) 
#     v = np.matmul(Rot_matrix_beta,v)  
#     v = np.matmul(Rot_matrix_alpha,v) 

# # generate list of sides' polygons of our pyramid
# v = v.transpose()
# verts = [ [v[0],v[1],v[4]], [v[0],v[3],v[4]],
#  [v[2],v[1],v[4]], [v[2],v[3],v[4]], [v[0],v[1],v[2],v[3]]]

# # plot sides
# ax.add_collection3d(Poly3DCollection(verts, 
#  facecolors='cyan', linewidths=1, edgecolors='r', alpha=.25))

plt.show()
