T = 285;

K = 1645;

Ye = zeros(T,K);

for i=1:K

    Ye(:,i) = Y(:,i)-rf;

end





T = 285;

N = 36;

results_groups = zeros(T-N,2);


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
    
    uppMV_bound = round((active_count * 0.333333) * 2);
    
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
    
       low_vola(i) = Vola(t,i) * active_large(i); %low_vola(i) = std(Ye(t:t+N-1,i)) * active(i);
    
    end

    low_vola(low_vola==0) = NaN;

    low_vola1 = sort(low_vola);
    
    low_bound = round(active_count2 * 0.333333);

    upp_bound = round((active_count2 * 0.333333) * 2);
    
    m_low = low_vola1(low_bound);
    
    m_upp = low_vola1(upp_bound);
    
    group1 = zeros(1,K);
    
    for i = 1:K
    
        if low_vola(i) <= m_low
            
            group1(i) = 1;
            
        else
            
            group1(i) = 0;
    
        end
        
    end
    
    
    group2 = zeros(1,K);
    
    for i = 1:K
    
        if low_vola(i) > m_upp
         
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
    
    low_vola_portfolio = results_groups(:,1); % - results_groups(:,2);

    montly_return = mean(low_vola_portfolio)

    stdev = sqrt(var(low_vola_portfolio))
    
    t_stat = mean(low_vola_portfolio) / sqrt(var(low_vola_portfolio)/(T-N))


