function fn_out = cp_crtmask(fn_in,varargin)
% Function that creates some "mask" images based on a 2D input image.
% Different mask images are created:
% - full mask, just 1's every where
% - lower half mask, just the lower half matrix (if input matrix is square)
% - row ROI, each row has a single value corresponding to its index
% One can aslo require to exclude the diagonal from mask and row_ROI, only
% of the input matrix is square.
%
% FORMAT
%   fn_out = cp_crtmask(fn_in,opt)
%
% INPUT
%   fn_in, filename of single 2D image to get the size information
%
% OUTPUT
%  fn_out, filenames of mask images created
%  opt, option structure or list of keyword/values pairs
%     .fn_msk, basename of the mask filenames, def. the fn_in
%     .pth_msk, provide path where to write the image(s), def. 'pwd'
%     .remD, remove the diagonal values from the masks, def. true if square
%__________________________________________________________________________
% Copyright (C) 2020 Cyclotron Research Centre

% Written by C. Phillips, 2020.
% GIGA Institute, University of Liege, Belgium

%% Deal with the options
if nargin<1
    error('crtMask:input','You must at least provide a filename.');
end

%-Options (struct array or key/value pairs)
%--------------------------------------------------------------------------
opts = struct( ...
    'fn_msk', fn_in, ... % input filename
    'pth_msk', pwd, ... % path to output folder
    'remD', true ...  % force 2D input
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

% Removing any preceding path and setting ext to .nii
opts.fn_msk = spm_file(opts.fn_msk,'filename');
opts.fn_msk = spm_file(opts.fn_msk,'ext','nii');

%% Create the masks
Vin = spm_vol(fn_in);
M_sz = Vin.dim;

if M_sz(1)==M_sz(2)
    flag_sq = true;
else
    flag_sq = false;
end

% Full matrix
Msk_full = ones(M_sz(1:2));
if flag_sq && opts.remD
    Msk_full = Msk_full - eye(M_sz(1:2));
end
V = struct( ...
    'fname', fullfile(opts.pth_msk, ...
        spm_file(opts.fn_msk,'suffix','_fMsk') ), ...
    'dim', [M_sz(1:2) 1], ...
    'dt', [2 0], ...
    'mat', eye(4) );
Vo = spm_write_vol(V,Msk_full);
fn_out = Vo.fname;

% Row ROI
ROI_row = (1:M_sz(1))' * ones(1,M_sz(2));
if flag_sq && opts.remD
    ROI_row = ROI_row .* (ones(M_sz(1:2)) - eye(M_sz(1:2)));
end
V = struct( ...
    'fname', fullfile(opts.pth_msk, ...
        spm_file(opts.fn_msk,'suffix','_rROI') ), ...
    'dim', [M_sz(1:2) 1], ...
    'dt', [4 0], ...
    'mat', eye(4) );
Vo = spm_write_vol(V,ROI_row);
fn_out = char(fn_out,Vo.fname);

% Lower half mask
if flag_sq
    Msk_lh = tril(ones(M_sz(1:2)));
    if opts.remD
        Msk_lh = Msk_lh - eye(M_sz(1:2));
    end
    V = struct( ...
        'fname', fullfile(opts.pth_msk, ...
            spm_file(opts.fn_msk,'suffix','_hMsk') ), ...
        'dim', [M_sz(1:2) 1], ...
        'dt', [2 0], ...
        'mat', eye(4) );
    Vo = spm_write_vol(V,Msk_lh);
    fn_out = char(fn_out,Vo.fname);
end

end