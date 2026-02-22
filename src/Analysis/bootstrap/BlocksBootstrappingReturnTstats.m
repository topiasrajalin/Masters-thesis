T=249;

N=1;

K=1;

DRAWS=75;

n=200;

p=0.0909;

max_block=25;

W=[X1 Y];

B=5000;

B1_hat=zeros(N*K,B);

for b=1:B

    W_boot=[];

    for j=1:DRAWS

    c0=zeros(n,1);

        for i=1:n

            c1=rand(1,1) < p;

            if c1==0
                c0(i)=1;
            else
                break;
            end
        end
        c2=sum(c0);

        c4=min(c2,max_block);

        c5=(T-c4+1);

        c6=(1:c5);

        c7=randi(length(c6),1,1);

        W_boot=[W_boot; W(c7:c7+c4-1,:)];

    end

    W_boot1=W_boot(1:T,:);

    X2=[ones(T,1)];

    Y2=W_boot1(:,size(X1,2)+1);

    b_boot=(X2'*X2)^-1*X2'*Y2;

    B1_hat(:,b)=b_boot;

end


sample_average_beta=zeros(K,1);

for j2=1:K

    sample_average_beta(j2)=mean(B1_hat(j2,:));

end

covariance_matrix_boot=zeros(K,K);

for b=1:B

    CC=(B1_hat(:,b)-sample_average_beta)*(B1_hat(:,b)-sample_average_beta)';

    covariance_matrix_boot=covariance_matrix_boot+CC;
end

covariance_matrix_boot1=1/B*covariance_matrix_boot;

X11=[ones(T,1)];

b=(X11'*X11)^-1*X11'*Y;

boot_t_stats=zeros(K,1);

for i=1:K

    boot_t_stats(i)=b(i)/sqrt(covariance_matrix_boot1(i,i));
end

u_hat_standard=Y-X11*b;

sigma_residual=u_hat_standard'*u_hat_standard/(T-K);

standard_cov_beta=sigma_residual*(X11'*X11)^(-1);

standard_t_stats=zeros(K,1);

for i=1:K
    standard_t_stats(i)=b(i)/sqrt(standard_cov_beta(i,i));
end

coefficients = b';
stnd_tstats = standard_t_stats';
robust_t_stats = boot_t_stats';
