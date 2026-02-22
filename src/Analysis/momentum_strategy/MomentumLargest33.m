T = 285;

K = 1498;

Ye = zeros(T,K);

for i=1:K

    Ye(:,i) = Y(:,i)-rf;

end




N = 36;

results_groups = zeros(T-N,2);

for t = 1:T-N

    % selecting only largest 33% stocks that have returns during past 12 months and
    % next 1 month

    active = zeros(1,K);

    for l = 1:K

        return_count = 0;

        for g = t+N-12:t+N

            if isnan(Ye(g,l))   
            else
                return_count = return_count + 1;
            end
        end

        if return_count == 12+1
            active(1,l) = 1;
        end

    end

    active_count = sum(active);

    %sort active stocks in MV order

    active_large = zeros(1,K);

    active_mv = zeros(1,K);

    for i = 1:K

        if isnan(MV(t+N-12,i))

        else

            active_mv(1,i) = active(1,i) * MV(t+N-12,i);

        end
    end
    
    active_mv(active_mv==0) = NaN;

    activemv_sorted = sort(active_mv);

    uppMV_bound = round((active_count * 0.333333) * 2);
    
    size_upp = activemv_sorted(uppMV_bound);
    
    for i = 1:K
    
        if active_mv(i) > size_upp
            
            active_large(i) = 1;
            
        else
            
            active_large(i) = 0;
    
        end
        
    end
    
    % active stocks in t-12:t+1 period

    active_count2 = sum(active_large);

    momentum = zeros(1,K);
    
    for i=1:K
    
       momentum(i) = sum(Ye(t+N-12:t+N-2,i)) * active_large(i);
    
    end


    momentum(momentum==0) = NaN;

    momentum1 = sort(momentum);
    
    low_bound = round(active_count2 * 0.33333);

    upp_bound = round((active_count2 * 0.33333) * 2);
    
    m_low = momentum1(low_bound);
    
    m_upp = momentum1(upp_bound);
    
    group1 = zeros(1,K);
    
    for i = 1:K
    
        if momentum(i) <= m_low
            
            group1(i) = 1;
            
        else
            
            group1(i) = 0;
    
        end
        
    end
    
    
    group2 = zeros(1,K);
    
    for i = 1:K
    
        if momentum(i) > m_upp
         
            group2(i) = 1;
        
        else
            
            group2(i) = 0;
    
        end
    
    end
    
    Ya = Ye;
    Ya(isnan(Ya))=0;
        
    portfolio_1 = (group1*Ya(N+t,:)')/sum(group1);
    
    portfolio_2 = (group2*Ya(N+t,:)')/sum(group2);
        
    results_groups(t,1) = portfolio_1;
    
    results_groups(t,2) = portfolio_2;
     
end
    
    momentum_portfolio = results_groups(:,2)-results_groups(:,1);
    
    montly_return = mean(momentum_portfolio)

    stdev = sqrt(var(momentum_portfolio))
    
    t_stat = mean(momentum_portfolio) / sqrt(var(momentum_portfolio)/(T-N))

    


