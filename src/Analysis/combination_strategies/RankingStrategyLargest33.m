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
    
    uppMV_bound = round((active_count * 0.33333333) * 2);
    
    size_upp = activemv_sorted(uppMV_bound);
    
    for i = 1:K
    
        if active_mv(i) > size_upp
            
            active_large(i) = 1;
            
        else
            
            active_large(i) = 0;
    
        end
        
    end

    active_count2 = sum(active_large);



    % Low vola sort

    ranks = zeros(1,K);

    for i = 1:K
        
        ranks(1,i) = i;

    end

    low_vola = zeros(1,K);
    
    for i=1:K
    
       low_vola(i) = Vola(t,i) * active_large(i);
    
    end

    low_vola(low_vola==0) = NaN;

    low_vola1 = sort(low_vola);

    ranked_sorted_low_vola = zeros(2,K);

    for i = 1:sum(active_large)

        ranked_sorted_low_vola(1,i) = ranks(1,i);
        ranked_sorted_low_vola(2,i) = low_vola1(1,i);

    end

    ranked_sorted_low_vola(ranked_sorted_low_vola==0) = NaN;

    company_ranks = zeros(3,K);


    for i = 1:K

        if isnan(low_vola(1,i))

        else
            for j = 1:K

                if low_vola(1,i) == ranked_sorted_low_vola(2,j)
                    company_ranks(1,i) = ranked_sorted_low_vola(1,j);
                    break
                end 
        
            end

        end

    end


    % Momentum sort
    
    momentum = zeros(1,K);
    
    for i=1:K
    
       momentum(i) = sum(Ye(t+N-12:t+N-2,i)) * active_large(i);
    
    end


    momentum(momentum==0) = NaN;
    
    momentum1 = sort(momentum, 'descend');
    momentum1 = momentum1(~isnan(momentum1));
    
    ranked_sorted_momentum = zeros(2,K);

    for i = 1:sum(active_large)

        ranked_sorted_momentum(1,i) = ranks(1,i);
        ranked_sorted_momentum(2,i) = momentum1(1,i);

    end

    ranked_sorted_momentum(ranked_sorted_momentum==0) = NaN;

    for i = 1:K

        if isnan(momentum(1,i))

        else
            for j = 1:K

                if momentum(1,i) == ranked_sorted_momentum(2,j)
                    company_ranks(2,i) = ranked_sorted_momentum(1,j);
                    break
                end 
        
            end

        end

    end

    company_ranks(3,:) = (company_ranks(1,:) + company_ranks(2,:)) / 2;



    company_total_ranks = company_ranks(3,:);

    company_total_ranks(company_total_ranks==0) = NaN;

    sorted_ranks = sort(company_total_ranks);

    low_rank_bound = round(sum(active_large)*0.33333);

    low_rank = sorted_ranks(low_rank_bound);

    high_rank_bound = round((sum(active_large)*0.33333) * 2);

    high_rank = sorted_ranks(high_rank_bound);

    
    company_ranks(company_ranks==0) = NaN;

    long_group = zeros(1,K);

    for i = 1:K

        if company_ranks(3,i) <= low_rank

            long_group(1,i) = 1;
        else

            long_group(1,i) = 0;

        end

    end


    short_group = zeros(1,K);

    for i = 1:K

        if company_ranks(3,i) > high_rank

            short_group(1,i) = 1;
        else

            short_group(1,i) = 0;

        end

    end



    Ya = Ye;
    Ya(isnan(Ya))=0;
    

    portfolio_long = (long_group*Ya(N+t,:)')/sum(long_group);
    
    portfolio_short = (short_group*Ya(N+t,:)')/sum(short_group);
        
    results_groups(t,1) = portfolio_long;
    
    results_groups(t,2) = portfolio_short;
     
end
    
    rank_portfolio = results_groups(:,1); % - results_groups(:,2);

    montly_return = mean(rank_portfolio)

    stdev = sqrt(var(rank_portfolio))
    
    t_stat = mean(rank_portfolio) / sqrt(var(rank_portfolio)/(T-N))