% scr_test_mat2nii.m
% 
% Some little script to test the function turning matrices into NIfTI files
%
%__________________________________________________________________________
% Copyright (C) 2020 Cyclotron Research Centre

% Written by C. Phillips, 2020.
% GIGA Institute, University of Liege, Belgium

%% Examples of 
% 
% - single 2D matrix, square or rectangular, into 1 image
M_sq2d = rand(128);
opt.fn_nii = 'test_sq2D_matrix.nii';
fn_out = cp_mat2nii(M_sq2d,opt); %#ok<*NASGU>

M_re2d = rand(64,128);
opt.fn_nii = 'test_re2D_matrix.nii';
fn_out = cp_mat2nii(M_re2d,opt);

% - 3D matrix into series of 2D image or single 3D image, into subfolder
M_3d = rand(128,128,64);
opt.fn_nii = 'test_3Dto2D.nii';
opt.pth_nii = fullfile(pwd,'SomeSubfolder'); % -> specific subfolder
fn_out = cp_mat2nii(M_3d,opt);

opt.fn_nii = 'test_3D_matrix.nii';
opt.force2D = false; % -> keep the matrix 3D
fn_out = cp_mat2nii(M_3d,opt);

% - symmetric 2D connectvity matrix and some masks
M_sym2D = corrcoef(rand(128,32));
opt.fn_nii = 'test_conM.nii';
fn_out = cp_mat2nii(M_sym2D,opt);
fn_mask = cp_crtmask(fn_out);

