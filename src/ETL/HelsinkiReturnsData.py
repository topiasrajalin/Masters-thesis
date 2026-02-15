import pandas as pd
from config import HELSINKI_MONTHLY_PRICES, HELSINKI_MONTHLY_RETURNS, HELSINKI_WEEKLY_PRICES, HELSINKI_WEEKLY_RETURNS


def calculate_returns(prices_df, output_path):
    returns_df = prices_df.copy()
    
    for col in prices_df.columns:
        if col == 'date':
            continue
        returns_df[col] = prices_df[col].pct_change() * 100
    
    returns_df.to_excel(output_path, index=False)
    return returns_df


def calculate_monthly_returns():
    prices_df = pd.read_excel(HELSINKI_MONTHLY_PRICES)
    return calculate_returns(prices_df, HELSINKI_MONTHLY_RETURNS)


def calculate_weekly_returns():
    prices_df = pd.read_excel(HELSINKI_WEEKLY_PRICES)
    return calculate_returns(prices_df, HELSINKI_WEEKLY_RETURNS)


if __name__ == "__main__":
    monthly_returns = calculate_monthly_returns()
    print(f"Monthly returns: {monthly_returns.shape}")
    
    weekly_returns = calculate_weekly_returns()
    print(f"Weekly returns: {weekly_returns.shape}")
