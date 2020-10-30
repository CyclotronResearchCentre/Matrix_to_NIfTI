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
%     .pth_nii, provide path where to write the image(s), def. 'pwd'
%     .force2D, force writing of only 2D images, even if the input is 3D,
%               def. true
%     .dtype, data type for .nii file, def. float32 (see spm_type)
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
    'pth_nii', pwd, ... % path to output folder
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
Mo_sz = size(M);
% Number of images to write out: N_nii
switch numel(Mo_sz) 
    case 2,
        N_nii = 1;
        Mo_sz(3) = 1;
    case 3,
        if opts.force2D
            N_nii = Mo_sz(3);
            Mo_sz(3) = 1;
        else
            N_nii = 1;
        end
    otherwise
        error('mat2nii:M_size','Matrix must be 2D or 3D.');
end

% create full filename(s)
ffn = cell(N_nii,1);
if ~exist(opts.pth_nii,'dir'), mkdir(opts.pth_nii); end
if N_nii==1
    ffn{1} = fullfile(opts.pth_nii,opts.fn_nii);
else
    for ii = 1:N_nii
        ffn{ii} = fullfile(opts.pth_nii, ...
            spm_file(opts.fn_nii,'suffix',sprintf('_%03d',ii)));
    end
end
% Create the images image(s)
for ii = 1:N_nii
    V = struct( ...
        'fname', ffn{ii}, ...
        'dim', Mo_sz, ...
        'dt', [opts.dtype 0], ...
        'mat', eye(4) );
    if Mo_sz(3)>1 && N_nii==1
        Vo = spm_write_vol(V,M); % Single 3D image case
    else
        Vo = spm_write_vol(V,M(:,:,ii)); %#ok<*NASGU>
    end
end

%% Output
fn_out = char(ffn);

end