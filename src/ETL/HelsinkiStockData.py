import pandas as pd
from config import (
    STOCKS_MV, FIRST_NORTH, FINANCIALS, BANKS_DUPLICATES,
    MONTHLY_PRICES, WEEKLY_PRICES, OUTPUT_MV, OUTPUT_MONTHLY, OUTPUT_WEEKLY
)


def load_exclusion_lists():
    fn_df = pd.read_excel(FIRST_NORTH)
    fn_list = set(x.upper() for x in fn_df['yhtiö'])
    
    fin_df = pd.read_excel(FINANCIALS)
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


def filter_market_value_data():
    df = pd.read_excel(STOCKS_MV)
    fn_list, fin_list, banks_list = load_exclusion_lists()
    
    cols_to_keep = [col for col in df.columns 
                    if not should_exclude_stock(col, fn_list, fin_list, banks_list) and 
                    df[col].nunique() > 20]
    
    df = df[[col for col in cols_to_keep if col == 'date' or df[col].max() >= 10]]
    df.to_excel(OUTPUT_MV, index=False)
    
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
    mv_df = pd.read_excel(OUTPUT_MV)
    company_list = [str(col).split(' - MARKET VALUE')[0] for col in mv_df.columns]
    
    df = pd.read_excel(MONTHLY_PRICES)
    df = df[[col for col in df.columns if col in company_list]]
    df = remove_stale_prices(df, [1, 2, 3, 5])
    
    df.to_excel(OUTPUT_MONTHLY, index=False)
    return df


def process_weekly_prices():
    monthly_df = pd.read_excel(OUTPUT_MONTHLY)
    company_list = monthly_df.columns.tolist()
    
    df = pd.read_excel(WEEKLY_PRICES)
    df = df[[col for col in df.columns if col in company_list]]
    df = remove_stale_prices(df, [1, 2, 5, 8, 12, 16, 18, 21])
    
    df.to_excel(OUTPUT_WEEKLY, index=False)
    return df


if __name__ == "__main__":
    mv_data = filter_market_value_data()
    print(f"Market value: {mv_data.shape}")
    
    monthly = process_monthly_prices()
    print(f"Monthly prices: {monthly.shape}")
    
    weekly = process_weekly_prices()
    print(f"Weekly prices: {weekly.shape}")
