# SURF-feature-breech-face

## Overview of breechface

Breech face: The **breechface** is the front part of the breechblock that makes contact with the cartridge in a firearm. Ballistic impression, like breechface, plays an important role in cracking down cases involving file arms.

See the figure below, when the firing pin strike the bullet, a firearm's characteristics will be transferred to the breechface with the form of concave or a pit on it. So one kind of firearm should have similar characteristics with each other. When there's a match from ballistic impression, it would be great help solving shooting cases.

![Left one is the image of bottom of cartridge case. Breech face impression (shown as BF) is the area between two red circles. FP indicates impression left by the firing pin. Right one is the image of breech face after trimming.](https://www.researchgate.net/profile/Robert_Thompson31/publication/279290946/figure/fig1/AS:687431238045700@1540907787738/Left-one-is-the-image-of-bottom-of-cartridge-case-Breech-face-impression-shown-as-BF.png)



## Dataset

Directory: Breech face

There are 20 brands of firearms, the two adjacent breechface come from one same brand (e.g. 1 and 2 are from the same, 3 and 4 are, 5 and 6...). Altogether 40 breech faces were in the dataset. Each breechface is a 3D image with length and width ranging between 2000 - 3200 pixels. 

## SURF feature

As stated above, one image would have like 600k pixels. Considering these much information, SURF feature was used to extract the feature from breech face.

SURF (Speed-up robust feature) is a speed-up version of SIFT (Scale-invariant feature transform) . It is a keypoint (blob) feature detection using approximate Laplace of Gaussian (LoG) with Box Filter.

Please see this [Link](https://opencv-python-tutroals.readthedocs.io/en/latest/py_tutorials/py_feature2d/py_surf_intro/py_surf_intro.html) for more details.

## Process

The general process is first extract all of the SURF features in images. See the figure below, note that only 200 SURF points are shown. (The size of the circle represents the feature vector or the blob size).

![](C:\Users\Xugao\AppData\Roaming\Typora\typora-user-images\1556851799395.png)

After detecting SURF features of 2 images, make a primary match. See the figure below, the left and right are group 4 (7 and 8). The match is not satisfiable since the lines are very chaotic. 

![1556852482293](C:\Users\Xugao\AppData\Roaming\Typora\typora-user-images\1556852482293.png)

To further improve the match and exclude outliers, use [RANSAC](https://en.wikipedia.org/wiki/Random_sample_consensus) to get better matched features of SURF. The figure shows the result after RANSAC.

![1556852605236](C:\Users\Xugao\AppData\Roaming\Typora\typora-user-images\1556852605236.png)

Another match is as follows. You can access all the matches in folder:

[Scale 8 level 4 threshold 1000 matching](https://github.com/Jasonhsu6/SURF-feature-breech-face/tree/master/Scale 8 level 4 threshold 1000 matching) 

With Scale 8, Gassian smoothing level 4, Hessian threshold 1000

[Scale 8 level 4 threshold 6500 matching](https://github.com/Jasonhsu6/SURF-feature-breech-face/tree/master/Scale 8 level 4 threshold 6500 matching)

With Scale 8, Gassian smoothing level 4, Hessian threshold 6500 (exclude edge features)

![1556852704603](C:\Users\Xugao\AppData\Roaming\Typora\typora-user-images\1556852704603.png)

Also, the matched results (total pairs of matched feature points) can be accessed in excel files

## Notes:

SURF feature is scale invariant, normally rotate, zoom, or flip will not affect SURF performance. The factors that matter are scales, gaussian smoothing levels, and hessian thresholds.

