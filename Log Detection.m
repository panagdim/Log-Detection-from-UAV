%% Pre-processing 

% Step 1 - Read and show the image 
im = imread('enterfileName.png'); 
figure(1)
imshow(img);
drawnow;

% Step2 - Convert the above image to gray
img_g = rgb2gray(img);
figure(2);
imshow(img_g);
drawnow;

a = (lagmatrix(img_g',3))';
a(isnan(a)) = 0;
c = double(a)-double(img_g);
c = c>20;
figure(3);
imshow(c);
drawnow;

% Step 3 - bwareaopen function to remove small objects fewer than 150 pxls
rmp = bwareaopen(c,130);
figure(4);
imshow(rmp);

% Step 4 - Segment image, retatining only 'n' objects with large areas
BW1 = bwareafilt(rmp,55);
imshow(BW1);
drawnow;

% Step 5 - Dilation of the leftover objects (optional)
str = strel('disk',2);
BW2 = imdilate(BW1,str);
imshow(BW2);
drawnow;
thImage = bwmorph(BW1, 'clean');
imshow(thImage);
drawnow;

% Step 6 - Merge disconnected line pixel areas by checking the neighboor
str = strel('disk', 15);  % The number 15 denotes the number of pixels that we want to look for
clBW = imclose(BW1,str);
imshow(clBW);
drawnow;

%% Processing 
I = imread('enterfileName.png');
I = rescale(I);

% Next line is optional
rot = imrotate(I,120,'crop');

figure(1);
subplot(1,2,1);
imshow(I);
title('i.e., Binary threshold image');

% Extract edges using in this case the Canny edge detector
edg = edge(I, 'canny');
subplot(1,2,2);
imshow(edg,'Colormap', [1 1 1; 0 0 1]);
zoom on;

% Calculate Hough transform
[H, theta, rho] = hough(edg);
title('i.e., Edge detection');
figure(2);

% Design the accumulator
imshow(H,[], 'XData',theta,'YData',rho, 'InitialMagnification','fit');
xlabel('\theta');
ylabel('\rho');
title('enterName');
axis on; 
axis normal; 
hold on;
colormap(gca, hot);
P = houghpeaks(H,710,'threshold', ceil(0.05*max(H(:))));
x = theta(P(:,2));
y = rho(P(:,1));
plot(x,y,'s','Color', 'white');

% Finally, find the lines and plot them
lines = houglines(edg, theta, rho, P,'FillGap',4.2,'MinLength',52);
figure;
imshow(I); 
hold on; 
zoom on;
maximum_length = 0;

% Iterate 
for k=1:length(lines)
    xy = [lines(k).point1; lines(k).point2];
    plot(xy(:,1), xy(:,2), 'LineWidth', 3, 'Color', 'green');

    % In here you can plot the beginning and the end of each line
    plot(xy(1,1), xy(1,2),'x','LineWidth', 2, 'Color', 'yellow');
    plot(xy(2,1), xy(2,2),'x','LineWidth', 2, 'Color', 'red');

    % Here you can determine the longest line segment by using the norm distance estimator
    length  = norm(lines(k).point1 - lines(k).point2);
    if (length > maximum_length)
    maximum_length = length;
    longest_xy = xy;
end

% Visualize the output
imshow(y);
legend('enterName');  % i.e., Stem detection
title('enterName');   % i.e., Automated stem detection
plot(longest_xy(:,1), longest_xy(:,2),'LineWidth', 2, 'Color','cyan');
