function FileRename(localDirectory,remoteDirectory,HOSTNAME,USERNAME,PASSWORD)

% FileRename(Directory)
% Function to rename *.jpg files from generic filenames to more descriptive
% and meaningful representations. For now the function will strip the
% camera information from the image and use camera name as the filename
% suffix. This will be used in future to apply appropriate camera
% calibrations to the images. The function also may create new file
% directories to store the images along with a description of the test.
%
% File name indicates DateTime of image (yyyymmddhhmmss) and camera
% make/model
%
% Soon will be able to pull files off of media drive and transfer straight
% to remote server.
%
cd(localDirectory)
newremoteDirectory = remoteDirectory
% Get all JPG files in the current folder
files = dir('*.jpg*');
% Loop through each
for id = 1:length(files)
    % Get the file name (minus the extension)
    imageProperties = imfinfo(files(id).name);      % Get Image Structure
    imageCameraModel = imageProperties.Model;       % From Image Structure, get Camera Model
    imageCameraMake = imageProperties.Make;         % From Image Structure, get Camera Model
    imageTime = imageProperties.DateTime;            % From Image Structure, get Date&Time
                                                    
                                                    % Using the Make,Model,
                                                    % and DateTime, set the
                                                    % filename
                                                    % (DateTimeMakeModel)
                                                    % for example:
                                                    % 20140819111103GoProHERO3+B
    
    if imageCameraMake == 'GoPro'
        imageCameraModel = imageCameraModel(1:8);
        imageCameraModel(ismember(imageCameraModel,' ,.:;!')) = [];
        imageTime(ismember(imageTime,' :')) = [];
        cameraName = strcat(imageTime,imageCameraMake,imageCameraModel);
    elseif imageCameraMake == 'Canon'
        imageCameraModel = imageCameraModel(1:5);
        imageCameraModel(ismember(imageCameraModel,' ,.:;!')) = [];
        cameraName = strcat(imageCameraMake,imageCameraModel);
    end
    
folderCheck = ssh2_simple_command(HOSTNAME,USERNAME,PASSWORD,...
    ['ls ',remoteDirectory,imageTime(1:8)]);
if strmatch(folderCheck,{''}) == 1
    ssh2_simple_command(HOSTNAME,USERNAME,PASSWORD,...
    ['mkdir ',remoteDirectory,imageTime(1:8)]);
    newremoteDirectory = strcat(remoteDirectory,imageTime(1:8));
    disp('Folder Does Not Exist, Creating Folder')
    disp(newremoteDirectory)
else
   newremoteDirectory =  strcat(remoteDirectory,imageTime(1:8));
   disp('Folder Exists')
end
   scp_simple_put(HOSTNAME,USERNAME,PASSWORD,...
       files(id).name,newremoteDirectory,localDirectory,sprintf('%s.jpg',cameraName));
end

