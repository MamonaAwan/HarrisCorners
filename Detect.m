%reading image
I = imread('img1.png');
[rows,cols]=size(I);
k = input('Enter Value of k: ');
thresh = 9*10^7;
sigma = 1;
radius=1;

%taking window for gaussian
[x,y] = meshgrid(-1:1,-1:1);
xyGaus = exp(-(x.^ 2 + y.^2)/(2*sigma^2));
xGaus = x.*exp(-(x.^2 + y.^2)/(2*sigma^2));
yGaus = y.*exp(-(x.^2 + y.^2)/(2*sigma^2));

%taking x and y derivatives of image
Ix = conv2(xGaus, I);
Iy = conv2(yGaus, I);

%taking square and product of derivatives
Imagx2 = Ix .^ 2;
Imagy2 = Iy .^ 2;
Imagxy = Ix .* Iy;

%taking sums
Sumx2 = conv2(xyGaus, Imagx2);
Sumy2 = conv2(xyGaus, Imagy2);
Sumxy = conv2(xyGaus, Imagxy);

%calculating matrix M and then calculating R
crnrs = zeros(rows, cols);
for x=1:rows,
   for y=1:cols,
       M = [Sumx2(x, y) Sumxy(x, y); Sumxy(x, y) Sumy2(x, y)];
       R = det(M) - k * (trace(M) ^ 2);
       if (R > thresh)              %applying threshold
          crnrs(x, y) = R;
       end
   end
end

%applying non maximum suppression
Corners = crnrs > imdilate(crnrs, [1 1 1; 1 0 1; 1 1 1]);
figure, imshow(I);
for x=1:rows,
   for y=1:cols,
       if (Corners(x,y) > 0)
          hold on;
          plot(y,x,'r+');
       end
   end
end
