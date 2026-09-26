# Templates

Templates are skeletons for typical MT4 indicators and expert advisors. They
are **not** meant to be compiled as-is — treat each one as a starting point.

## How to use a template

1. **Pick a template** from the list below and copy it into your terminal's
   `MQL4\Experts` (for EAs) or `MQL4\Indicators` folder.
2. **Enable/disable features** via the `#define` block at the top of the file
   (e.g. `STOP_LOSS_FEATURE`, `TAKE_PROFIT_FEATURE`, `POSITION_CAP_FEATURE`,
   `TRADING_TIME_FEATURE`, `MARTINGALE_FEATURE`, `ACT_ON_SWITCH_CONDITION`,
   `WITH_EXIT_LOGIC`). Each feature wraps its `input` parameters in `#ifdef`;
   disabled features fall back to fixed default variables, so the code stays
   compilable either way.
3. **Insert your trading logic** at the `//TODO: implement` markers. In EAs
   this means implementing `IsPass(period, date)` in the condition classes
   (`LongCondition`, `ShortCondition`, `ExitLongCondition`,
   `ExitShortCondition`) or composing ready-made `ICondition` building blocks
   from `snippets/Conditions/` inside the `Create*Condition` factory
   functions (combine them with `AndCondition`/`OrCondition`, run actions on
   them via `actions.AddActionOnCondition`). In indicator templates the
   markers are inside the `OnCalculate` loop.
4. **Resolve the `#include` directives** before compiling in MetaEditor:
   - inject the snippet sources into the file with
     [MQ4Inject](https://github.com/sibvic/MQ4Inject), or
   - copy the content of `snippets/` into `MQL4\Include`
     (`copy_to_mt.bat` does this with robocopy).
5. Compile in MetaEditor 4 and test on a demo account.

See [EA_Base.md](./EA_Base.md) for extending EAs with custom order actions
(`AOrderAction`/`orderHandlers`) and condition-triggered actions
(`IAction`/`actions`).

## Template catalog

### EA_Base

EA template. Parameters of this EA described
[here](https://github.com/sibvic/mq4-templates/wiki/EA_Base-template-parameters).
You can find the description of the internals [here](./EA_Base.md)

Features:

- Can trade multiple symbols.

### EA_on_trade

EA that reacts to other trades (e.g. opens a hedge order when a monitored
order appears). Logic is implemented via `ICondition`/`IAction` pairs.

### EA_conditions_display

Indicator that renders EA entry/exit conditions as a colored heatmap —
useful for debugging condition logic visually.

### EA_highly_adaptable

EA template where each signal/event is mapped to a configurable
`CustomActionType` input (buy/sell/limit/stop/close/alert), so the strategy
behavior is re-wired from parameters.

### indicator_base

Template of the indicator/oscillator base.

### arrows_base

Template of the indicator/oscillator with arrows to draw. Supports multiple
display types (arrows, candles coloring, lines, text), live/on-bar-close
signal modes and consecutive-signal filtering.

### arrows_base_divergence

`arrows_base` variant pre-wired for divergence signals.

### candles_overlay

Two candle streams. Used to color the candles.

### dashboard

Dashboard/scanner template. You need to implement `IsPass` for the
`UpCondition` and `DownCondition`.

### dashboard_text

Dashboard/scanner template. Shows text in the cells. You need to implement
`TextValueCell`.

### currency

Template for a forex currency (like USD). Used to calculate some value based
on several pairs for a single currency.

### currency_all

Multi-currency variant of `currency` — computes the same metric for all
major currencies at once.

### heatmap

Heatmap.
