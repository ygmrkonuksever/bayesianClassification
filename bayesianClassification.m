clc
clear all
load('pattern1.mat');
%%
%•	Displaying the patterns in a 2D plot.
x1=patterns(1,1:440);
y1=patterns(2,1:440);
x2=patterns(1,441:580);
y2=patterns(2,441:580);
hold on
scatter(x1,y1,'red');
scatter(x2,y2,'blue');
hold off
%%
%•1D distribution of the x1 and x2 components and of the class variable w.
x1=patterns(1,:);
x2=patterns(2,:);
target=targets(1,:);
subplot(2,2,1);
histogram(x1);
title('x1');
subplot(2,2,2);
histogram(x2);
title('x2');
subplot(2,2,[3,4]);
histogram(target);
title('target');
%%
%•Class-conditional distributions which are x1|w0, x1|w1 and x2|w0, x2|w1. 
x1=patterns(1,1:440);
x1=normalize(x1, 'range', [0 1]);
y1=patterns(2,1:440);
y1=normalize(y1, 'range', [0 1]);
x2=patterns(1,441:580);
x2=normalize(x2, 'range', [0 1]);
y2=patterns(2,441:580);
y2=normalize(y2, 'range', [0 1]);
subplot(2,2,1);
histogram(x1);
title('x1|w1');  
subplot(2,2,2);
hist(y1);
title('y1|w1');  
subplot(2,2,3);
hist(x2);
title('x1|w0');  
subplot(2,2,4);
hist(y2);
title('y1|w0');  
%%
%Class-conditional mean vector
m1 = zeros(2,1);
m0 = zeros(2,1);
%For class w1
for i=1:440 
    m1(1,1)= m1(1,1)+patterns(1,i); %%x1
    m1(2,1)=m1(2,1)+patterns(2,i); %%x2
end
m1(1,1)=m1(1,1)/440;
m1(2,1)=m1(2,1)/440;
m1
%For class w0
for i=1:140 
    m0(1,1)= m0(1,1)+patterns(1,440+i); %%x1
    m0(2,1)=m0(2,1)+patterns(2,440+i); %%x2
end
m0(1,1)=m0(1,1)/140;
m0(2,1)=m0(2,1)/140;
m0

%Covariance matrix for the two classes.
cov1=zeros(2,2); % x1-x1  x1-x2  for class w1
                 % x2-x1  x2-x2

for i=1:440
    cov1(1,1)=cov1(1,1)+(patterns(1,i)-m1(1,1))^2; %%x1-x1
    cov1(2,2)=cov1(2,2)+(patterns(2,i)-m1(2,1))^2; %%x2-x2
    cov1(1,2)=cov1(1,2)+(patterns(1,i)-m1(1,1))*(patterns(2,i)-m1(2,1)); %%x1-x2
end
cov1(1,1)=cov1(1,1)/439;
cov1(2,2)=cov1(2,2)/439;
cov1(1,2)=cov1(1,2)/439;
cov1(2,1)=cov1(1,2);
cov1

cov0=zeros(2,2); % x1-x1  x1-x2  for class w0
                 % x2-x1  x2-x2
                 
for i=1:140
    cov0(1,1)=cov0(1,1)+(patterns(1,440+i)-m0(1,1))^2; %%x1-x1
    cov0(2,2)=cov0(2,2)+(patterns(2,440+i)-m0(2,1))^2; %%x2-x2
    cov0(1,2)=cov0(1,2)+(patterns(1,440+i)-m0(1,1))*(patterns(2,440+i)-m0(2,1)); %%x1-x2
end
cov0(1,1)=cov0(1,1)/139;
cov0(2,2)=cov0(2,2)/139;
cov0(1,2)=cov0(1,2)/139;
cov0(2,1)=cov0(1,2);
cov0
%%
dataset = textread('iris11.txt');
dataset
count1=0;
count2=0;
count3=0;
syms x1 x2 x3 x4;
for i=1:150
    if(dataset(i,5)==1)
        count1=count1+1;
    elseif(dataset(i,5)==2)
        count2=count2+1;
    elseif(dataset(i,5)==3)
        count3=count3+1;
    end
end

count1 %50
count2 %50
count3 %50 
%So the prior probability is equal all of them and 50/150=1/3=0.33



%Formula is gi(x)=p(x|wi)p(wi)
%gi(x)=lnp(x|wi)+lnp(wi)
%lnp(wi) is omitted because of they have equal priory.

%Calculate mean and covariance for each class
mu1=mean(dataset(1:50,1:4));
mu2=mean(dataset(51:100,1:4));
mu3=mean(dataset(101:150,1:4));
mu1
mu2
mu3
sigma1=cov(dataset(1:50,1:4));
sigma2=cov(dataset(51:100,1:4));
sigma3=cov(dataset(101:150,1:4));
sigma1
sigma2
sigma3

r=zeros(1,6);
result=ones(6,1);
for i=1:6
    randomnum=int16(1+ (150-1).*rand());
    r(1,i)=randomnum;
    g1=(-0.33)*(dataset(randomnum,1:4)-mu1')'*inv(sigma1)*(dataset(randomnum,1:4)-mu1')-log(2*pi)-0.33*log(det(sigma1));
    g2=(-0.33)*(dataset(randomnum,1:4)-mu2')'*inv(sigma2)*(dataset(randomnum,1:4)-mu2')-log(2*pi)-0.33*log(det(sigma2));
    g3=(-0.33)*(dataset(randomnum,1:4)-mu3')'*inv(sigma3)*(dataset(randomnum,1:4)-mu3')-log(2*pi)-0.33*log(det(sigma3));

    if(g1 > g2)
        if(g1>g3)
            result(i,1)=1;
        end
    elseif(g2 > g1)
          if(g2>g3)
            result(i,1)=2;
          end
    else
         result(i,1)=3;        
    end   
end
result
