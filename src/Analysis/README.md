# Financial Analysis - MATLAB Scripts

MATLAB scripts for analyzing Nordic stock exchange data and implementing investment strategies.

## Directory Structure

### `momentum/`
- `Momentum.m` - Basic momentum strategy implementation
- `MomentumLargest33.m` - Momentum strategy applied to largest 33 stocks

### `volatility/`
- `LowVolatility.m` - Low volatility strategy implementation
- `LowVolatilityLargest33.m` - Low volatility strategy applied to largest 33 stocks

### `strategies/`
- `5050Strategy.m` - Equal-weight 50/50 strategy
- `5050Strategy Largest33.m` - 50/50 strategy applied to largest 33 stocks

### `combination/`
- `CombinationMomentumThenVolaLargest33.m` - Combined momentum then volatility strategy
- `CombinationVolaThenMomentumLargest33.m` - Combined volatility then momentum strategy

### `bootstrap/`
- `BlocksBootstrappingReturnTstats.m` - Bootstrap methodology for t-statistic calculations on returns

### `factor/`
- `FactorControllingStandardTstats.m` - Factor control analysis with standard t-statistics

### `ranking/`
- `RankingStrategyLargest33.m` - Stock ranking strategy for largest 33 companies

## Usage

Run MATLAB scripts from MATLAB command line or IDE. Each script processes data from the directories specified and outputs analysis results.

## Requirements

- MATLAB (version 2020a or later recommended)
- Statistics and Machine Learning Toolbox (for bootstrap and statistical functions)
