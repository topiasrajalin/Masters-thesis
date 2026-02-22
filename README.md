# Nordic Stock Exchange Analysis - Master's Thesis

Comprehensive analysis of investment strategies across Nordic stock exchanges (Copenhagen, Helsinki, Oslo, Stockholm) using Python data processing and MATLAB financial analysis.

## Publications

- **Master's Thesis**: [Combining idiosyncratic volatility and momentum - Evidence from the Nordic stock markets](https://osuva.uwasa.fi/server/api/core/bitstreams/c4d64a78-d1c1-43d9-9f83-442f08f9dfad/content)
- **Published Article**: [Combining low-volatility and momentum: recent evidence from the Nordic equities](https://doi.org/10.1080/00036846.2024.2337806)

## Project Structure

```
Masters-thesis/
├── src/
│   ├── ETL/                    # Data processing scripts (Python)
│   │   ├── HelsinkiStockData.py
│   │   ├── HelsinkiReturnsData.py
│   │   ├── CopenhagenStockData.py
│   │   ├── CopenhagenReturnsData.py
│   │   ├── OsloStockData.py
│   │   ├── OsloReturnsData.py
│   │   ├── StockholmStockData.py
│   │   ├── StockholmReturnsData.py
│   │   ├── config.example.py
│   │   └── config.py (local, not committed)
│   │
│   └── Analysis/               # Analysis scripts (MATLAB)
│       ├── momentum/
│       ├── volatility/
│       ├── strategies/
│       ├── combination/
│       ├── bootstrap/
│       ├── factor/
│       └── ranking/
│
├── data/
│   ├── raw/                    # Source data (not committed)
│   └── processed/              # Processed data outputs
│
├── results/                    # Analysis results (not committed)
│   ├── tables/
│   └── figures/
│
├── docs/                       # Documentation
│   └── notebooks/              # Archived Jupyter notebooks
│
├── tests/                      # Unit and integration tests
├── requirements.txt            # Python dependencies
└── README.md

```

## Quick Start

### 1. Setup Python Environment

```bash
# Create virtual environment (optional but recommended)
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### 2. Configure Data Paths

```bash
# Copy example config
cp src/ETL/config.example.py src/ETL/config.py

# Edit config.py with your actual file paths
# Example paths to add:
# - HELSINKI_STOCK_DATA = "C:/path/to/helsinki_stocks.xlsx"
# - COPENHAGEN_STOCK_DATA = "C:/path/to/copenhagen_stocks.xlsx"
# - etc.
```

### 3. Run ETL Pipeline

```bash
# Process stock data and calculate returns for each exchange
cd src/ETL

python HelsinkiStockData.py
python HelsinkiReturnsData.py

python CopenhagenStockData.py
python CopenhagenReturnsData.py

python OsloStockData.py
python OsloReturnsData.py

python StockholmStockData.py
python StockholmReturnsData.py
```

### 4. Run Analysis Scripts

```bash
# Run MATLAB analysis scripts
cd src/Analysis
matlab < momentum/Momentum.m
```

## Directory Descriptions

- **[src/ETL/](src/ETL/)** - Python data extraction, transformation, and loading scripts for Nordic exchanges
- **[src/Analysis/](src/Analysis/)** - MATLAB financial analysis and strategy implementation scripts
- **[data/](data/)** - Raw and processed data storage (not version controlled)
- **[results/](results/)** - Analysis output tables and figures (not version controlled)
- **[docs/](docs/)** - Project documentation and archived development notebooks
- **[tests/](tests/)** - Unit tests for validation

## Key Features

- **Multi-exchange support**: Copenhagen, Helsinki, Oslo, Stockholm
- **Currency normalization**: Automatic DKK/NOK/SEK to EUR conversion
- **Centralized configuration**: Single config file for all data paths
- **Strategy analysis**: Multiple investment strategy implementations
- **Statistical rigor**: Bootstrap t-statistics and factor control analysis

## Requirements

- **Python 3.7+** with pandas, numpy, scipy, matplotlib, openpyxl
- **MATLAB 2020a+** with Statistics and Machine Learning Toolbox

## Notes

- Raw data files and processed outputs are git-ignored for privacy and size
- Config file (`src/ETL/config.py`) is git-ignored; use `config.example.py` as template
- Archived Jupyter notebooks are in `docs/notebooks/` for reference only

## For More Information

See the README files in each subdirectory for detailed documentation.