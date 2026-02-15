import os

DATA_DIR = r"/path/to/your/data/directory"

MONTHLY_PRICES = os.path.join(DATA_DIR, "HelsinkiMainListStocksPmontly.xlsx")
MONTHLY_RETURNS = os.path.join(DATA_DIR, "HelsinkiMainListStocksMontlyReturns.xlsx")
WEEKLY_PRICES = os.path.join(DATA_DIR, "HelsinkiMainListStocksPweekly.xlsx")
WEEKLY_RETURNS = os.path.join(DATA_DIR, "HelsinkiMainListStocksWeeklyReturns.xlsx")

STOCKS_MV = os.path.join(DATA_DIR, "HelsinkiStocksMV.xlsx")
FIRST_NORTH = os.path.join(DATA_DIR, "HelsinkiFirstNorth.xlsx")
FINANCIALS = os.path.join(DATA_DIR, "HelsinkiFinancials.xlsx")
BANKS_DUPLICATES = os.path.join(DATA_DIR, "BanksDoublesOther.xlsx")

OUTPUT_MV = os.path.join(DATA_DIR, "HelsinkiMainListStocksMV.xlsx")
OUTPUT_MONTHLY = os.path.join(DATA_DIR, "HelsinkiMainListStocksPmontly.xlsx")
OUTPUT_WEEKLY = os.path.join(DATA_DIR, "HelsinkiMainListStocksPweekly.xlsx")
