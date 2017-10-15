function vpv(varargin)

cmd='env LD_LIBRARY_PATH= vpv';
dir=[tempdir 'matlab/'];
<<<<<<< HEAD
if isscalar(varargin{1})
=======
if nargin > 0 && isscalar(varargin{1})
>>>>>>> 73ef3368dc160fcf543e2d4a43255c9471898208
    num=varargin{1};
    dir=[dir(1:end-1) '_' num2str(num) '/'];
    cmd=[cmd(1:4) 'WATCH=1 ' cmd(5:end)];
    varargin=varargin(2:end);
    isnumbered=true;
else
    isnumbered=false;
end
if ~exist(dir, 'dir')
    mkdir(dir);
    newwindow=true;
else
    newwindow=false;
end
j=1;
for i=1:nargin-double(isnumbered)
    o=varargin{i};
    if ischar(o)
        cmd=[cmd ' ' o];
    else
        if size(o, 4) == 1 % image
            name=[dir num2str(j) '.tiff'];
            imwrite_with_tiff(o, name);
        else % video
            name=[dir num2str(j)];
            if ~exist(name, 'dir')
                mkdir(name);
            end
            for k=1:size(o,4)
                imwrite_with_tiff(o(:,:,:,k), [name '/' num2str(k) '.tiff']);
            end
        end

        cmd=[cmd ' ' name];
        j=j+1;
    end
end
cmd = ['(' cmd ' ; rm -rf ' dir ') &'];
if ~isnumbered || newwindow
    disp(cmd);
    system(cmd);
elseif isnumbered
    disp(['vpv #' num2str(num) ' updated.']);
end

function imwrite_with_tiff(img, filename)
[~, ~, ext] = fileparts(filename);
if strcmp(ext, '.tiff')
    t = Tiff(filename, 'w');
    tagstruct.ImageLength = size(img, 1);
    tagstruct.ImageWidth = size(img, 2);
    tagstruct.Compression = Tiff.Compression.None;
    %tagstruct.Compression = Tiff.Compression.LZW;        % compressed
    tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP;
    tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
    tagstruct.BitsPerSample =  32;                        % float data
    tagstruct.SamplesPerPixel = size(img,3);
    tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
    t.setTag(tagstruct);
    t.write(single(img));
    t.close();
else
    imwrite(img, filename);
end
