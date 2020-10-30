function fn_out = cp_mat2nii(M,varargin)
% Function that turns a matrix M into a NIfTI format image.
% Some options can also be specified, e.g. desired filename. When a 3D
% matrix is provided with the 'force2D' option, then each "slice" along the
% 3rd dimension is used to generate a series of 2D images whose filenamef 
% includes are indexed, e.g. 'image_001.nii' to 'image_037.nii'.
% 
% FORMAT
%   fn_out = cp_mat2nii(M,opt)
% 
% INPUT
%   M,   matrix to write out in NIfTI format iamge
%   opt, option structure or list of keyword/values pairs
%     .fn_nii, filename of the .nii file, def. 'image.nii'
%     .force2D, force writing of only 2D images, even if the input is 3D,
%               def. true
%     .dtype, data type for .nii file, def. float32 (see spm_type)
% 
% Dependences:
% This function relies on some SPM functions, mainly 'spm_vol.' and
% 'spm_write_vol.m', thus SPM's main folder must be on Matlab's path.
%__________________________________________________________________________
% Copyright (C) 2020 Cyclotron Research Centre

% Written by C. Phillips, 2020.
% GIGA Institute, University of Liege, Belgium

%% Deal with the options
if nargin<1
    error('mat2nii:input','You must at least provide a matrix.');
end

%-Options (struct array or key/value pairs)
%--------------------------------------------------------------------------
opts = struct( ...
    'fn_nii', 'image.nii', ... % filename
    'force2D', true, ...  % force 2D input
    'dtype', 16 ... % data type (float32)
    ) ;
if nargin > 1
    if isstruct(varargin{1})
        opt = varargin{1};
    else
        opt = struct;
        for ii=1:2:numel(varargin)
            opt.(varargin{ii}) = varargin{ii+1};
        end
    end
else
    opt = struct([]);
end
fn = fieldnames(opt);
for ii=1:numel(fn)
    %     if ~isfield(opts,fn{ii})
    %         warning('Unknown option "%s".',fn{ii});
    %     end
    opts.(fn{ii}) = opt.(fn{ii});
end

%% Deal with the matrix
M_sz = size(M);
% Number of images to write out: N_nii
switch numel(M_sz) 
    case 2,
        N_nii = 1;
        M_sz(3) = 1;
    case 3,
        if opts.force2D
            N_nii = M_sz(3);
            M_sz(3) = 1;
        else
            N_nii = 1;
        end
    otherwise
        error('mat2nii:M_size','Matrix must be 2D or 3D.');
end

% Create a single image
V = struct( ...
    'fname', opts.fn_nii, ...
    'dim', M_sz, ...
    'dt', [opts.dtype 0], ...
    'mat', eye(4) );
Vo = spm_write_vol(V,M);

%% Output
fn_out = Vo.fname;

end