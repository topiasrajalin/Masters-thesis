T = 285;


Ye = zeros(T,K);

for i=1:K

    Ye(:,i) = Y(:,i)-rf;

end





T = 285;

N = 36;

K = 1645;

low_vola_results_groups = zeros(T-N,2);
momentum_results_groups = zeros(T-N,2);

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

    low_vola = zeros(1,K);
    
    for i=1:K
    
       low_vola(i) = Vola(t,i) * active(i);
    
    end

    low_vola(low_vola==0) = NaN;

    low_vola1 = sort(low_vola);
    
    low_vola_bound = round(active_count * 0.33);

    high_vola_bound = round((active_count * 0.33) * 2);
    
    low_vola_low = low_vola1(low_vola_bound);
    
    low_vola_upp = low_vola1(high_vola_bound);
    
    low_vola_group1 = zeros(1,K);
    
    for i = 1:K
    
        if low_vola(i) <= low_vola_low
            
            low_vola_group1(i) = 1;
            
        else
            
            low_vola_group1(i) = 0;
    
        end
        
    end
    
    
    low_vola_group2 = zeros(1,K);
    
    for i = 1:K
    
        if low_vola(i) > low_vola_upp
         
            low_vola_group2(i) = 1;
        
        else
            
            low_vola_group2(i) = 0;
    
        end
    
    end
    
    Ya = Ye;
    Ya(isnan(Ya))=0;
    

    low_vola_portfolio_1 = (low_vola_group1*Ya(N+t,:)')/sum(low_vola_group1);
    
    low_vola_portfolio_2 = (low_vola_group2*Ya(N+t,:)')/sum(low_vola_group2);
        
    low_vola_results_groups(t,1) = low_vola_portfolio_1;
    
    low_vola_results_groups(t,2) = low_vola_portfolio_2;



    momentum = zeros(1,K);
    
    for i=1:K
    
       momentum(i) = sum(Ye(t+N-12:t+N-2,i)) * active(i);
    
    end


    momentum(momentum==0) = NaN;

    momentum1 = sort(momentum);
    
    momentum_low_bound = round(active_count * 0.33);

    momentum_upp_bound = round((active_count * 0.33) * 2);
    
    momentum_low = momentum1(momentum_low_bound);
    
    momentum_upp = momentum1(momentum_upp_bound);
    
    momentum_group1 = zeros(1,K);
    
    for i = 1:K
    
        if momentum(i) <= momentum_low
            
            momentum_group1(i) = 1;
            
        else
            
            momentum_group1(i) = 0;
    
        end
        
    end
    
    
    momentum_group2 = zeros(1,K);
    
    for i = 1:K
    
        if momentum(i) > momentum_upp
         
            momentum_group2(i) = 1;
        
        else
            
            momentum_group2(i) = 0;
    
        end
    
    end
    
    Ya2 = Ye;
    Ya2(isnan(Ya2))=0;
        
    momentum_portfolio_1 = (momentum_group1*Ya2(N+t,:)')/sum(momentum_group1);
    
    momentum_portfolio_2 = (momentum_group2*Ya2(N+t,:)')/sum(momentum_group2);
        
    momentum_results_groups(t,1) = momentum_portfolio_1;
    
    momentum_results_groups(t,2) = momentum_portfolio_2;
     
end

momentum_long_short =  momentum_results_groups(:,2)-momentum_results_groups(:,1);

momentum_winners = momentum_results_groups(:,2);

momentum_losers = momentum_results_groups(:,1);

low_vola = low_vola_results_groups(:,1);

high_vola = low_vola_results_groups(:,2);

vola_long_short = low_vola_results_groups(:,1) - low_vola_results_groups(:,2);


combined_portfolio_5050 = zeros(T-N,1);

for j = 1:T-N
    
    combined_portfolio_5050(j,1) = (momentum_winners(j,1) + low_vola(j,1)) / 2;


end


montly_return = mean(combined_portfolio_5050)

stdev = sqrt(var(combined_portfolio_5050))
    
t_stat = mean(combined_portfolio_5050) / sqrt(var(combined_portfolio_5050)/(T-N))