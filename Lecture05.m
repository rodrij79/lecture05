clear all; close all; clc;

StartingFrame =1;
EndingFrame = 489;

Xcentroid = [];
Ycentroid = [];

for b = 1:1:3
    ball(b).Xcentroid =[];
    ball(b).Ycentroid =[];
end

for k = StartingFrame : EndingFrame-1
 k
rgb = imread(['juggle/img',sprintf('%2.3d',k),'.jpg']);
imshow(rgb);
BW = createMask(rgb);


SE = strel('disk',2,8);            
BW1 = imopen(BW,SE);

[labels,number] = bwlabel(BW,8); 

if number > 0
    Istats = regionprops(labels,'basic','Centroid'); 
    [values, index] = sort([Istats.Area],'descend');
    [maxVal,maxIndex] = max([Istats.Area]); 

    for b = 1:1:3
        
        det(b).Xcentroid = Istats(index(b)).Centroid(1);
        det(b).Ycentroid = Istats(index(b)).Centroid(2);
    end
    
    if k ==1;
        
        for b = 1:1:3
            
            ball(b).Xcentroid = [ball(b).Xcentroid det(b).Xcentroid];
            ball(b).Ycentroid = [ball(b).Ycentroid det(b).Ycentroid];
        end 
                  
    else
        for b =1:1:3
            for d = 1:1:3
            dist(d,b) = hypot(...
                abs(ball(b).Xcentroid(1)-det(b).Xcentroid),...
                abs(ball(b).Ycentroid(1)-det(b).Ycentroid));
            end
        end
        
        [minValue, minIndex] = min(dist);
        
        for b =1:1:3
            ball(b).Xcentroid = [ball(b).Xcentroid det(minIndex(d)).Xcentroid];
            ball(b).Ycentroid = [ball(b).Ycentroid det(minIndex(d)).Ycentroid];
        end
    end
end
 
hold on; 
rectangle('Position',[Istats(index(1)).BoundingBox],'LineWidth',2,'EdgeColor','y');
rectangle('Position',[Istats(index(2)).BoundingBox],'LineWidth',2,'EdgeColor','b');
rectangle('Position',[Istats(index(3)).BoundingBox],'LineWidth',2,'EdgeColor','m');
pause(0.00000000001);

end        
    