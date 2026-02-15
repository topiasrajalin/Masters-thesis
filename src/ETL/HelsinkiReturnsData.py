import pandas as pd
from config import MONTHLY_PRICES, MONTHLY_RETURNS, WEEKLY_PRICES, WEEKLY_RETURNS


def calculate_returns(prices_df, output_path):
    returns_df = prices_df.copy()
    
    for col in prices_df.columns:
        if col == 'date':
            continue
        returns_df[col] = prices_df[col].pct_change() * 100
    
    returns_df.to_excel(output_path, index=False)
    return returns_df


def calculate_monthly_returns():
    prices_df = pd.read_excel(MONTHLY_PRICES)
    return calculate_returns(prices_df, MONTHLY_RETURNS)


def calculate_weekly_returns():
    prices_df = pd.read_excel(WEEKLY_PRICES)
    return calculate_returns(prices_df, WEEKLY_RETURNS)


if __name__ == "__main__":
    monthly_returns = calculate_monthly_returns()
    print(f"Monthly returns: {monthly_returns.shape}")
    
    weekly_returns = calculate_weekly_returns()
    print(f"Weekly returns: {weekly_returns.shape}")
