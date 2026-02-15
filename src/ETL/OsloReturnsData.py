import pandas as pd
from config import (
    OSLO_MONTHLY_PRICES_EUR, OSLO_MONTHLY_RETURNS,
    OSLO_WEEKLY_PRICES, OSLO_WEEKLY_RETURNS
)


def calculate_returns(prices_df, output_path):
    returns_df = prices_df.copy()
    
    for col in prices_df.columns:
        if col == 'date':
            continue
        returns_df[col] = prices_df[col].pct_change() * 100
    
    returns_df.to_excel(output_path, index=False)
    return returns_df


def calculate_monthly_returns():
    prices_df = pd.read_excel(OSLO_MONTHLY_PRICES_EUR)
    return calculate_returns(prices_df, OSLO_MONTHLY_RETURNS)


def calculate_weekly_returns():
    prices_df = pd.read_excel(OSLO_WEEKLY_PRICES)
    returns_df = pd.DataFrame(columns=prices_df.columns)
    returns_df['date'] = prices_df['date']
    
    for col in prices_df.columns:
        if col == 'date':
            continue
        returns_df[col] = prices_df[col].pct_change() * 100
    
    returns_df.to_excel(OSLO_WEEKLY_RETURNS, index=False)
    return returns_df


if __name__ == "__main__":
    print("Calculating monthly returns...")
    monthly = calculate_monthly_returns()
    print(f"Monthly returns: {monthly.shape}")
    
    print("Calculating weekly returns...")
    weekly = calculate_weekly_returns()
    print(f"Weekly returns: {weekly.shape}")
