T = 285;

K = 1645;

Ye = zeros(T,K);

for i=1:K

    Ye(:,i) = Y(:,i)-rf;

end



N = 36;

results_groups = zeros(T-N,2);

for t = 1:T-N


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

    

    momentum = zeros(1,K);
    
    for i=1:K
    
       momentum(1,i) = sum(Ye(t+N-12:t+N-2,i)) * active(i);
    
    end


    momentum(momentum==0) = NaN;

    momentum1 = sort(momentum);
    
    low_bound = round(active_count * 0.1);

    upp_bound = round((active_count * 0.1) * 9);
    
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
    
    WML = results_groups(:,2)-results_groups(:,1);
	
    Winners = results_groups(:,2);

    Losers = results_groups(:,1);
    
    montly_return = mean(WML)

    stdev = sqrt(var(WML))
    
    t_stat = mean(WML) / sqrt(var(WML)/(T-N))


