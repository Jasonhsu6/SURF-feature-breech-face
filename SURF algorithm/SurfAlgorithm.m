clc;clear;close all;

Case_dir ='C:\Users\Xugao\Documents\MATLAB\SURF feature\Breech face\*.mat';


Case_files = dir(Case_dir);%case directory


Filenum = size(Case_files,1);%number of files

BreechFace = cell(Filenum,1);

Bface = cell(20,1);%

refer=18;

m=0;

n =20;

for Ref =  1 : n 

    BreechFace{Ref} = load(['C:\Users\Xu Gaochong\Desktop\results\Breech face\',...
                         Case_files(Ref).name]);

                     
    Bface{Ref} = BreechFace{Ref}.hMatrix;

    Bface{Ref}(isnan(Bface{Ref})) = 0;%将所有图像中的NaN（空）值置0

end

% for i=1:20
%     for j=1:20
I=Bface{9};
J=Bface{10};
% 
% I=imresize(I);
% J=imresize(J);
% detect feature points
ISURFPoints = detectSURFFeatures(I,'MetricThreshold',6500,'NumOctaves',4,...
    'NumScaleLevels',8);
%I的SURF检测点

% %-----------------------------------------------------------------------%
% 参数说明
%     points = detectSURFFeatures(I,Name,Value) specifies additional
%     name-value pair arguments described below:
%  
%     'MetricThreshold'  A non-negative scalar which specifies a threshold
%                        for selecting the strongest features. Decrease it to
%                        return more blobs.
%       
%                        Default: 1000.0
%  矩阵阈值：一个特定的非负数量阈值来选择最强的特征，初始1000
%     'NumOctaves'       Integer scalar, NumOctaves >= 1. Number of octaves 
%                        to use. Increase this value to detect larger
%                        blobs. Recommended values are between 1 and 4.
%  
%                        Default: 3
%  Octave值：正量，》=1.使用的，提升以检测更大的blob算子。推荐值在1-4之间。初始为3
%     'NumScaleLevels'   Integer scalar, NumScaleLevels >= 3. Number of
%                        scale levels to compute per octave. Increase
%                        this number to detect more blobs at finer scale 
%                        increments. Recommended values are between 3 and 6.
%  
%                        Default: 4
%  ：整数值，》=3.每个octave计算的规模。提升以在一个更好的规模增量上的检测，推荐值为3-6
%     'ROI'              A vector of the format [X Y WIDTH HEIGHT],
%                        specifying a rectangular region in which corners
%                        will be detected. [X Y] is the upper left corner of
%                        the region.                      
%  
%                        Default: [1 1 size(I,2) size(I,1)]
% 方形区域：【X Y WIDTH HEIGHT】的向量，确定检测的矩形区域内的角点【XY】是区域右上角

%     -----
%     - Each octave spans a number of scales that are analyzed using varying
%       size filters:
%           octave     filter sizes
%           ------     ------------------------------
%             1        9x9,   15x15, 21x21, 27x27, ...
%             2        15x15, 27x27, 39x39, 51x51, ...
%             3        27x27, 51x51, 75x75, 99x99, ...
%             4        ....
%       Higher octaves use larger filters and sub-sample the image data.
%       Larger number of octaves will result in finding larger size blobs. 
%       'NumOctaves' should be selected appropriately for the image size.
%       For example, 50x50 image should not require NumOctaves > 2. The
%       number of filters used per octave is controlled by the parameter
%       'NumScaleLevels'. To analyze the data in a single octave, at least 3
%       levels are required.
%   %--------------------------------------------------------------%

StrongIFeatures=ISURFPoints.selectStrongest(int32(length(ISURFPoints)));
WeakIFeatures=ISURFPoints(end-300:end);
% Visualize
subplot(121);imshow(I);
hold on; plot(StrongIFeatures.selectStrongest(200));



% %SIFT检测点图
% ISIFTFeatures = detectFASTFeatures(I,'MinContrast',0.1);   %I的SIFT检测点
% ISIFT = insertMarker(I,ISIFTFeatures,'circle');
% subplot(122);imshow(ISIFT);

% %----------------------------------------------------------------------------------------------%
% %SURF参数调试
% ISurfAdjust = detectSURFFeatures(I,'MetricThreshold',1000,'NumOctaves',3,'NumScaleLevels',6);
% subplot(122);imshow(I); hold on;
% plot(ISurfAdjust.selectStrongest(50));
% %----------------------------------------------------------------------------------------------%


JSURFPoints = detectSURFFeatures(J,'MetricThreshold',6500,'NumOctaves',4,...
    'NumScaleLevels',8);
StrongJFeatures=JSURFPoints.selectStrongest(int32(length(JSURFPoints)*0.8));
WeakJFeatures=JSURFPoints(end-300:end);
subplot(122);imshow(J); 
hold on; plot(JSURFPoints.selectStrongest(200));




% Find Putative Point Matches
[ISURFFeatures, ISURFPoints] = extractFeatures(I, StrongIFeatures);
[JSURFFeatures, JSURFPoints] = extractFeatures(J, StrongJFeatures);

% [ISURFFeatures, ISURFPoints] = extractFeatures(I, WeakIFeatures);
% [JSURFFeatures, JSURFPoints] = extractFeatures(J, WeakJFeatures);

% Match the features using their descriptors
IPairs = matchFeatures(ISURFFeatures, JSURFFeatures,'Method','Exhaustive',...
    'MatchThreshold',1.0,'MaxRatio',0.6);
%     'Method'           A string used to specify how nearest neighbors
%                        between features1 and features2 are found.
%  
%                        'Exhaustive': Matches features1 to the nearest
%                                      neighbors in features2 by computing
%                                      the pair-wise distance between
%                                      feature vectors in features1 and
%                                      features2.
%  
%                        'Approximate': Matches features1 to the nearest
%                                       neighbors in features2 using an
%                                       efficient approximate nearest
%                                       neighbor search. Use this method for
%                                       large feature sets
%   
%                        Default: 'Exhaustive'
%  
%     'MatchThreshold'   A scalar T, 0 < T <= 100, that specifies the
%                        distance threshold required for a match. A pair of
%                        features are not matched if the distance between
%                        them is more than T percent from a perfect match.
%                        Increase T to return more matches.
%   
%                        Default: 10.0 for binary feature vectors 
%                                  1.0 otherwise
%  
%     'MaxRatio'         A scalar R, 0 < R <= 1, specifying a ratio threshold
%                        for rejecting ambiguous matches. Increase R to
%                        return more matches.
%  
%                        Default: 0.6
%  
%     'Metric'           A string used to specify the distance metric. This
%                        parameter is not applicable when features1 and
%                        features2 are binaryFeatures objects.
%  
%                        Possible values are:
%                          'SAD'         : Sum of absolute differences
%                          'SSD'         : Sum of squared differences 
%  
%                        Default: 'SSD'
%  
%                        Note: When features1 and features2 are
%                              binaryFeatures objects, Hamming distance is
%                              used to compute the similarity metric.
%  
%     'Unique'           A logical scalar. Set this to true to return only
%                        unique matches between features1 and features2.
%   
%                        Default: falseS
%  

% Display putatively matched features
matchedIPoints = ISURFPoints(IPairs(:, 1), :);
matchedJPoints = JSURFPoints(IPairs(:, 2), :);






figure;
showMatchedFeatures(I, J, matchedIPoints, ...
    matchedJPoints, 'montage');
title('Putatively Matched Points (Including Outliers)');

% % Display the matching point pairs with the outliers removed内围区
[tform, inlierIPoints, inlierJPoints,status] = ...
    estimateGeometricTransform(matchedIPoints, matchedJPoints, 'affine',...
    'MaxNumTrials',5000,'MaxDistance',10,'Confidence',99);
%     'MaxNumTrials'        A positive integer scalar specifying the maximum
%                           number of random trials for finding the inliers.
%                           Increasing this value will improve the robustness
%                           of the output at the expense of additional
%                           computation.
%   
%                           Default value: 1000
%    
%     'Confidence'          A numeric scalar, C, 0 < C < 100, specifying the
%                           desired confidence (in percentage) for finding
%                           the maximum number of inliers. Increasing this
%                           value will improve the robustness of the output
%                           at the expense of additional computation.
%  
%                           Default value: 99
%   
%     'MaxDistance'         A positive numeric scalar specifying the maximum
%                           distance in pixels that a point can differ from
%                           the projection location of its associated point.
%   
%                           Default value: 1.5
% % transformType can be 'similarity','affine', or 'projective'
figure;
showMatchedFeatures(I, J, inlierIPoints, ...
    inlierJPoints, 'blend');
%      'falsecolor' : Overlay the images by creating a composite red-cyan 
%                     image showing I1 as red and I2 as cyan.
%      'blend'      : Overlay I1 and I2 using alpha blending.
%      'montage'    : Place I1 and I2 next to each other in the same image.
title('Matched Points (Inliers Only)');
% A(i,j)=length(inlierIPoints);
%     end
% end




% 
% Compute the transformation matrix using RANSAC.

gte = vision.GeometricTransformEstimator;
gte.Transform = 'Nonreflective similarity';
[tform inlierJdx] = step(gte, matchedJPoints.Location, matchedIPoints.Location);
figure; showMatchedFeatures(I,J,matchedIPoints(inlierJdx),matchedJPoints(inlierJdx));
title('Matching inliers'); legend('inliersI', 'inliersJ');
%  
% Recover the original image.

agt = vision.GeometricTransformer;
Jrecover = step(agt, im2single(J), tform);
figure; imshow(Jrecover); title('Recovered image');
% 
% rematch
JrecoverSURFPoints = detectSURFFeatures(Jrecover,'MetricThreshold',1000,'NumOctaves',3,...
    'NumScaleLevels',8);
StrongJrecoverFeatures=JrecoverSURFPoints.selectStrongest(int32(length(JSURFPoints)*0.8));
[JrecoverSURFFeatures, JrecoverSURFPoints] = extractFeatures(Jrecover, StrongJrecoverFeatures);
IIPairs = matchFeatures(ISURFFeatures, JrecoverSURFFeatures,'Method','Exhaustive',...
    'MatchThreshold',1.0,'MaxRatio',0.6);
matchedIPoints = ISURFPoints(IIPairs(:, 1), :);
matchedJrecoverPoints = JrecoverSURFPoints(IIPairs(:, 2), :);
figure;
showMatchedFeatures(I, Jrecover, matchedIPoints, ...
    matchedJrecoverPoints, 'montage');
title('Putatively Matched Points (Including Outliers)');
[tform, inlierIPoints, inlierJrecoverPoints,status] = ...
    estimateGeometricTransform(matchedIPoints, matchedJrecoverPoints, 'affine',...
    'MaxNumTrials',5000,'MaxDistance',15,'Confidence',99);
figure;
showMatchedFeatures(I, Jrecover, inlierIPoints, ...
    inlierJrecoverPoints, 'montage');
title('Matched Points (Inliers Only)');
