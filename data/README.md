# Data Directory

## Structure

### `raw/`
Original unprocessed data files from Nordic stock exchanges.

**Note:** This directory is not committed to git. Add your source Excel files here:
- Copenhagen Exchange stock prices and returns
- Helsinki Exchange stock prices and returns
- Oslo Exchange stock prices and returns
- Stockholm Exchange stock prices and returns

### `processed/`
Output from ETL (Extract, Transform, Load) scripts. Contains cleaned and processed data ready for analysis.

Files generated here are not committed to git. These are temporary outputs from running `src/ETL/*.py` scripts.

## Setup

1. Obtain stock price data from Nordic exchanges
2. Place raw data files in `data/raw/`
3. Update `src/ETL/config.py` with file paths
4. Run ETL scripts to generate processed data in `data/processed/`

## File Naming Convention

Raw files should follow this naming pattern:
- `{Exchange}_StockData.xlsx` - Price and market value data
- `{Exchange}_ReturnsData.xlsx` - Pre-calculated returns
- Exclusion lists as needed (e.g., `{Exchange}_Exclusions.xlsx`)
