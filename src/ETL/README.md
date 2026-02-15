# ETL (Extract, Transform, Load) - Data Processing Scripts

Python scripts for processing Nordic stock exchange data.

## Scripts

### Copenhagen Exchange
- `CopenhagenStockData.py` - Filter and process Copenhagen stock data, convert DKK to EUR
- `CopenhagenReturnsData.py` - Calculate monthly and weekly returns

### Helsinki Exchange
- `HelsinkiStockData.py` - Filter and process Helsinki stock data
- `HelsinkiReturnsData.py` - Calculate monthly and weekly returns

### Oslo Exchange
- `OsloStockData.py` - Filter and process Oslo stock data, convert NOK to EUR
- `OsloReturnsData.py` - Calculate monthly and weekly returns

### Stockholm Exchange
- `StockholmStockData.py` - Filter and process Stockholm stock data, convert SEK to EUR
- `StockholmReturnsData.py` - Calculate monthly and weekly returns

## Configuration

- `config.py` - Local configuration (not committed to git). Copy from `config.example.py` and update paths.
- `config.example.py` - Template configuration file for setting up local paths

## Usage

1. Update `config.py` with your local file paths
2. Run stock data scripts first:
   ```bash
   python HelsinkiStockData.py
   ```
3. Then run returns calculation scripts:
   ```bash
   python HelsinkiReturnsData.py
   ```

## Output

Processed data is saved to locations specified in `config.py` as Excel files.
