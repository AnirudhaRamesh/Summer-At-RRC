function [indexPairs, matchedPoints1, matchedPoints2]  = feature_eandm(im1,im2)
im1 = rgb2gray(imread(im1)) ; 
im2 = rgb2gray(imread(im2)) ; 

%points1 = detectHarrisFeatures(im1) ; 
%points2 = detectHarrisFeatures(im2) ;

points1 = detectSURFFeatures(im1);
points2 = detectSURFFeatures(im2);

[features1,valid_points1] = extractFeatures(im1,points1);
[features2,valid_points2] = extractFeatures(im2,points2);

indexPairs = matchFeatures(features1,features2);
matchedPoints1 = valid_points1(indexPairs(:,1),:);
matchedPoints2 = valid_points2(indexPairs(:,2),:);

figure; showMatchedFeatures(im1,im2,matchedPoints1,matchedPoints2,'montage','Parent', axes );





