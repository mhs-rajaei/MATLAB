

mimg=imread('lena.jpg');

[M,N]=size(mimg);
cnt=0;
for i=1:M-3
    for j=1:N-3
        cnt=cnt+1;
        mpatch=mimg(i:i+2,j:j+2);
        mpatch=mpatch(:);
        npatch=nimg(i:i+2,j:j+2);
        npatch=npatch(:);
        patches(:,cnt)=npatch;
        opatches(:,cnt)=mpatch;
    end
end