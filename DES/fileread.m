mydata='E:\DES\mydata.txt';
%text1 = fileread('mydata')
fid = fopen(mydata, 'r');
M = fread(fid,'*char')'
fclose(fid)
mydata1='E:\DES\mydata1.txt';
fid1=fopen(mydata1,'w');
fwrite(fid1,M)
