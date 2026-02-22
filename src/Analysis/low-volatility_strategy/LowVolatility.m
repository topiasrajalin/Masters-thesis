T = 285;

K = 1645;

Ye = zeros(T,K);

for i=1:K

    Ye(:,i) = Y(:,i)-rf;

end



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

    % active stocks in t-12:t+1 period
    active_count = sum(active);

    low_vola = zeros(1,K);
    
    for i=1:K
    
       low_vola(i) = Vola(t,i) * active(i); %low_vola(i) = std(Ye(t:t+N-1,i)) * active(i);
    
    end
    low_vola(low_vola==0) = NaN;

    low_vola1 = sort(low_vola);
    
    low_bound = round(active_count * 0.33333);

    upp_bound = round((active_count * 0.33333) * 2);
    
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
    
    LMH = results_groups(:,1)-results_groups(:,2);
	
    LowVol = results_groups(:,1);

    HighVol = results_groups(:,2);
    
    montly_return = mean(LMH)

    stdev = sqrt(var(LMH))
    
    t_stat = mean(LMH) / sqrt(var(LMH)/(T-N))



