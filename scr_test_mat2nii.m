% Some little script to test the function turning matrices into NIfTI files
%

% Example of simple square 2D matrix
M_2d = rand(100);
opt.fn_nii = 'test_2D_matrix.nii';
fn_out = cp_mat2nii(M_2d,opt);

