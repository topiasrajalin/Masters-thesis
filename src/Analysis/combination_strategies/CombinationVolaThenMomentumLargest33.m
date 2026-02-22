T = 285;

K = 1645;

Ye = zeros(T,K);

for i=1:K

    Ye(:,i) = Y(:,i)-rf;

end





N = 36;

combination_results_groups = zeros(T-N,2);


for t=1:T-N

    active = zeros(1,K);

    for l = 1:K

        return_count = 0;

        for g = t:t+N

            if isnan(Ye(g,l))   
            else
                return_count = return_count + 1;
            end
        end

        if return_count == N+1
            active(1,l) = 1;
        end

    end

    active_count = sum(active);

    %sort active stocks in MV order

    active_large = zeros(1,K);

    active_mv = zeros(1,K);

    for i = 1:K

        if isnan(MV(t,i))

        else

            active_mv(1,i) = active(1,i) * MV(t,i);

        end
    end
    
    active_mv(active_mv==0) = NaN;

    activemv_sorted = sort(active_mv);
    
    uppMV_bound = round((active_count * 0.3333333) * 2);
    
    size_upp = activemv_sorted(uppMV_bound);
    
    for i = 1:K
    
        if active_mv(i) > size_upp
            
            active_large(i) = 1;
            
        else
            
            active_large(i) = 0;
    
        end
        
    end

    % active stocks 
    active_count2 = sum(active_large);

    low_vola = zeros(1,K);
    
    for i=1:K
    
       low_vola(i) = Vola(t,i) * active_large(i);
    
    end

    low_vola(low_vola==0) = NaN;

    low_vola1 = sort(low_vola);
    
    vola_bound = round(active_count2 * 0.5);
    
    vola_measure = low_vola1(vola_bound);
    
    low_vola_group = zeros(1,K);
    
    for i = 1:K
    
        if low_vola(i) <= vola_measure
            
            low_vola_group(i) = 1;
            
        else
            
            low_vola_group(i) = 0;
    
        end
        
    end
    
    
    high_vola_group = zeros(1,K);
    
    for i = 1:K
    
        if low_vola(i) > vola_measure
         
            high_vola_group(i) = 1;
        
        else
            
            high_vola_group(i) = 0;
    
        end
    
    end
    

    high_momentum_low_vola = zeros(1,K);
    
    for i=1:K
    
       high_momentum_low_vola(i) = sum(Ye(t+N-12:t+N-2,i)) * low_vola_group(i);
    
    end


    high_momentum_low_vola(high_momentum_low_vola==0) = NaN;

    high_momentum_low_vola1 = sort(high_momentum_low_vola);
    
    momentum_upp_bound = round((sum(low_vola_group) * 0.2) * 4);

    momentum_upp = high_momentum_low_vola1(momentum_upp_bound);
    
    momentum_long = zeros(1,K);
    
    for i = 1:K
    
        if high_momentum_low_vola(i) > momentum_upp
            
            momentum_long(i) = 1;
            
        else
            
            momentum_long(i) = 0;
    
        end
        
    end
    

    % High vola low momentum 

    low_momentum_high_vola = zeros(1,K);
    
    for i=1:K
    
       low_momentum_high_vola(i) = sum(Ye(t+N-12:t+N-2,i)) * high_vola_group(i);
    
    end

    low_momentum_high_vola(low_momentum_high_vola==0) = NaN;

    low_momentum_high_vola1 = sort(low_momentum_high_vola);

    momentum_low_bound = round(sum(high_vola_group) * 0.2);

    momentum_low = low_momentum_high_vola1(momentum_low_bound);

    momentum_short = zeros(1,K);
    
    for i = 1:K
    
        if low_momentum_high_vola(i) <= momentum_low
         
            momentum_short(i) = 1;
        
        else
            
            momentum_short(i) = 0;
    
        end
    
    end
    
    Ya2 = Ye;
    Ya2(isnan(Ya2))=0;
        
    portfolio_long = (momentum_long*Ya2(N+t,:)')/sum(momentum_long);
    
    portfolio_short = (momentum_short*Ya2(N+t,:)')/sum(momentum_short);
        
    combination_results_groups(t,1) = portfolio_long;
    
    combination_results_groups(t,2) = portfolio_short;
     
end


long_short =  combination_results_groups(:,1)-combination_results_groups(:,2);

long = combination_results_groups(:,1);

short = combination_results_groups(:,2);



montly_return = mean(long_short)

stdev = sqrt(var(long_short))
    
t_stat = mean(long_short) / sqrt(var(long_short)/(T-N))
