% mean 
T = 249;

t_stat=zeros(1,1);

X=[ones(T,1)];


b=(X'*X)^-1*X'*portfolio;

u=portfolio-X*b;

sigma2=(u'*u)/(T-1);

cov_b=sigma2*(X'*X)^-1;


    
t_stat=b/sqrt(cov_b);

 

alpha = b(1)

t_stat_aplha = t_stat(1)




% CAPM


t_stat=zeros(2,1);

X=[ones(T,1) FF3(:,1)];


b=(X'*X)^-1*X'*portfolio;

u=portfolio-X*b;

sigma2=(u'*u)/(T-3);

cov_b=sigma2*(X'*X)^-1;


for i=1:2
    
    t_stat(i)=b(i)/sqrt(cov_b(i,i));
end
 

alpha = b(1)

t_stat_aplha = t_stat(1)

beta = b(2)

t_stat_beta = t_stat(2)



% Fama French 3-factor model

t_stat=zeros(4,1);

X=[ones(T,1) FF3];


b=(X'*X)^-1*X'*portfolio;

u=portfolio-X*b;

sigma2=(u'*u)/(T-4);

cov_b=sigma2*(X'*X)^-1;


for i=1:4
    
    t_stat(i)=b(i)/sqrt(cov_b(i,i));
end
 

alpha = b(1)

t_stat_aplha = t_stat(1)



% Fama French 5-factor model

t_stat=zeros(6,1);

X=[ones(T,1) FF5];


b=(X'*X)^-1*X'*portfolio;

u=portfolio-X*b;

sigma2=(u'*u)/(T-6);

cov_b=sigma2*(X'*X)^-1;


for i=1:6
    
    t_stat(i)=b(i)/sqrt(cov_b(i,i));
end
 

alpha = b(1)

t_stat_aplha = t_stat(1)

