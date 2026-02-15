import pandas as pd
from config import (
    COPENHAGEN_MV, COPENHAGEN_MV_EUR, COPENHAGEN_MONTHLY_PRICES, COPENHAGEN_MONTHLY_PRICES_EUR,
    COPENHAGEN_WEEKLY_PRICES, COPENHAGEN_FIRST_NORTH, COPENHAGEN_FINANCIALS, BANKS_DUPLICATES, EXCHANGE_RATES
)


def load_exclusion_lists():
    fn_df = pd.read_excel(COPENHAGEN_FIRST_NORTH)
    fn_list = set(x.upper() for x in fn_df['yhtiö'])
    fn_list = {x.split(' A/S')[0].split(' PLC')[0].split(' BTU')[0].split(', ')[0] for x in fn_list}
    
    fin_df = pd.read_excel(COPENHAGEN_FINANCIALS)
    fin_list = set(x.upper() for x in fin_df['yhtiö'])
    
    banks_df = pd.read_excel(BANKS_DUPLICATES)
    banks_list = set(x.upper() for x in banks_df['yhtiö'])
    
    return fn_list, fin_list, banks_list


def should_exclude_stock(col_name, fn_list, fin_list, banks_list):
    col_str = str(col_name).upper()
    
    if '#ERROR' in col_str or ' ETF ' in col_str:
        return True
    
    for stock in fn_list | fin_list | banks_list:
        if stock in col_str:
            return True
    
    return False


def convert_to_eur(df, currency_col='DKK/EUR'):
    for col in df.columns:
        if col in ('date', 'SEK/EUR', 'NOK/EUR', 'DKK/EUR'):
            continue
        df[col] = df[col] * df[currency_col]
    
    return df.drop(columns=['SEK/EUR', 'NOK/EUR', 'DKK/EUR'])


def filter_market_value_data():
    df = pd.read_excel(COPENHAGEN_MV)
    fn_list, fin_list, banks_list = load_exclusion_lists()
    
    cols_to_keep = [col for col in df.columns 
                    if not should_exclude_stock(col, fn_list, fin_list, banks_list) and 
                    df[col].nunique() > 20]
    
    df = df[[col for col in cols_to_keep if col == 'date' or df[col].max() >= 10]]
    
    rates = pd.read_excel(EXCHANGE_RATES)
    df = df.merge(rates, on='date')
    df = convert_to_eur(df)
    
    df.to_excel(COPENHAGEN_MV_EUR, index=False)
    return df


def remove_stale_prices(df, offset_indices):
    for j in range(1, len(df.columns)):
        for i in range(len(df) - max(offset_indices)):
            if pd.notna(df.iloc[i, j]):
                value = df.iloc[i, j]
                if all(value == df.iloc[i + offset, j] for offset in offset_indices if i + offset < len(df)) and \
                   value == df.iloc[-1, j]:
                    df.iloc[i+1:, j] = pd.NA
                    break
    
    return df


def process_monthly_prices():
    mv_df = pd.read_excel(COPENHAGEN_MV_EUR)
    company_list = [str(col).split(' - MARKET VALUE')[0] for col in mv_df.columns]
    
    df = pd.read_excel(COPENHAGEN_MONTHLY_PRICES)
    df = df[[col for col in df.columns if col in company_list]]
    df = remove_stale_prices(df, [1, 2, 3, 5])
    
    rates = pd.read_excel(EXCHANGE_RATES)
    df = df.merge(rates, on='date')
    df = convert_to_eur(df)
    
    df.to_excel(COPENHAGEN_MONTHLY_PRICES_EUR, index=False)
    
    prices_df = pd.read_excel(COPENHAGEN_MONTHLY_PRICES)
    prices_df = prices_df[[col for col in prices_df.columns if col in company_list]]
    prices_df = remove_stale_prices(prices_df, [1, 2, 3, 5])
    prices_df.to_excel(COPENHAGEN_MONTHLY_PRICES, index=False)
    
    return df


def process_weekly_prices():
    monthly_df = pd.read_excel(COPENHAGEN_MONTHLY_PRICES)
    company_list = monthly_df.columns.tolist()
    
    df = pd.read_excel(COPENHAGEN_WEEKLY_PRICES)
    df = df[[col for col in df.columns if col in company_list]]
    df = remove_stale_prices(df, [1, 2, 5, 8, 12, 16, 18, 21])
    
    df.to_excel(COPENHAGEN_WEEKLY_PRICES, index=False)
    return df


if __name__ == "__main__":
    print("Filtering market value data...")
    mv_data = filter_market_value_data()
    print(f"Market value: {mv_data.shape}")
    
    print("Processing monthly prices...")
    monthly = process_monthly_prices()
    print(f"Monthly prices: {monthly.shape}")
    
    print("Processing weekly prices...")
    weekly = process_weekly_prices()
    print(f"Weekly prices: {weekly.shape}")
