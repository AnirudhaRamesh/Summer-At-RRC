D = 'dataset';
S = dir(fullfile(D,'*.jpg')); 
image_matrix = [] ;
for k = 2:numel(S)+1
    file1 = fullfile(D,S(k-1).name);
    disp(file1) ; 
    im1 = double(imread(file1));
    [m n] = size(im1) ; 
    temp = im2col(im1, [m n])' ; 
    image_matrix = [image_matrix ; temp] ; 
end

[p q] = size(image_matrix) ; 
mean_image_matrix = repelem(mean(image_matrix),p,1) ;
image_matrix_adjusted = image_matrix - mean_image_matrix ; 
pen = cov(image_matrix_adjusted') ; 