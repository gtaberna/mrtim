function varargout = net(varargin)


%=======================================================================
% spm('Dir',Mfile)
%-----------------------------------------------------------------------
if nargin<2, Mfile = 'net'; else Mfile = varargin{2}; end
NET_folder = which(Mfile);
addpath( genpath(NET_folder) );

if isempty(NET_folder)             %-Not found or full pathname given
    if exist(Mfile,'file')==2  %-Full pathname
        NET_folder = Mfile;
    else
        error(['Can''t find ',Mfile,' on MATLABPATH']);
    end
end
NET_folder    = fileparts(NET_folder);
varargout = {NET_folder};

