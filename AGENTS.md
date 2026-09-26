# AGENTS.md

## Project overview

MQL4/MetaTrader 4 template library designed to speed up development of typical
indicators and expert advisors (EAs). Maintained by Victor Tereschenko
(ProfitRobots), primarily to support the
[Trade Script Converter](https://convertor.profitrobots.com) and PineScript →
MQL4 conversions (the `snippets/PineScript` folder mirrors PineScript APIs).

Repository: https://github.com/sibvic/mq4-templates

## Repository layout

- `Templates/` — ready-to-use `.mq4` skeletons (indicators, dashboards, EAs).
  See `Templates/readme.md` for the catalog and usage instructions.
- `snippets/` — reusable `.mqh` include library used by the templates,
  organized by domain:
  - `Conditions/` — `ICondition` building blocks (see below). Most trading
    logic is expressed as conditions.
  - `Actions/` — `IAction` building blocks executed when conditions pass
    (open/close orders, trailing, breakeven, delete pendings, etc.).
  - `Streams/`, `Indicators/`, `IndicatorStreams.mqh` — data stream
    abstraction (price/indicator series, incl. "indicator over indicator").
  - `Arrays/`, `Logic/`, `Order/`, `MoneyManagement/`, `Grid/`,
    `ChartObjects/`, `Canvas/`, `enums/`, `PineScript/`, `Utils/` and various
    top-level helpers (`TradingController.mqh`, `OrderBuilder.mqh`,
    `MarketOrderBuilder.mqh`, `Signaler.mqh`, `InstrumentInfo.mqh`, ...).
- `snippets/readme.md` — per-snippet usage docs. Keep it updated when adding
  snippets.

## How the templates work

Templates are *not* compiled as-is. Workflow:

1. Copy a template from `Templates/` into the target `MQL4\Experts` or
   `MQL4\Indicators` folder.
2. Enable/disable features via the `#define` / `#ifdef` block at the top of
   the file (e.g. `STOP_LOSS_FEATURE`, `TAKE_PROFIT_FEATURE`,
   `POSITION_CAP_FEATURE`, `TRADING_TIME_FEATURE`, `MARTINGALE_FEATURE`,
   `ACT_ON_SWITCH_CONDITION`, `WITH_EXIT_LOGIC`). Commented-out defines
   produce plain (non-input) variables with fixed defaults instead of
   `input` parameters.
3. Fill in the trading logic at the `//TODO: implement` markers — usually by
   implementing `IsPass(const int period, const datetime date)` in
   condition classes or composing existing `ICondition` snippets.
4. Resolve `#include <...>` directives before compiling in MetaEditor, either by:
   - injecting snippet sources with [MQ4Inject](https://github.com/sibvic/MQ4Inject), or
   - copying `snippets/` content into `MQL4\Include` (see `copy_to_mt.bat`).

Advanced alerts (Telegram etc.) need
[mt-notifications-lib](https://github.com/sibvic/mt-notifications-lib) DLL.

## Key abstractions

### ICondition — the main building block

`snippets/Conditions/ICondition.mqh`:

```mql4
interface ICondition
{
   virtual void AddRef() = 0;
   virtual void Release() = 0;
   virtual bool IsPass(const int period, const datetime date) = 0;
   virtual string GetLogMessage(const int period, const datetime date) = 0;
};
```

- Entry/exit logic in EA templates is implemented as condition classes
  (`LongCondition`, `ShortCondition`, `ExitLongCondition`,
  `ExitShortCondition`) inherited from `ACondition`, each returning `bool`
  from `IsPass`.
- Conditions are composed with `AndCondition` / `OrCondition`, combined in
  `CreateLongCondition` / `CreateShortCondition` / `CreateLongFilterCondition`
  / `CreateShortFilterCondition` / `CreateExit*Condition` factory functions.
- `ActOnSwitchCondition` wraps a condition to fire once on the rising edge
  (enabled by `ACT_ON_SWITCH_CONDITION`); `DisabledCondition` /
  `NoCondition` are neutral placeholders.
- `condition.Add(child, false)` — the second arg controls ownership/release.
- There is a large library of ready conditions in `snippets/Conditions/`
  (ADX/DMI, Bollinger Bands, CCI, MACD, candle patterns, divergences,
  day/time filters, spread cap, position limits, profit hits, ...). Prefer
  reusing them over writing new logic.

### IAction — what to do when a condition passes

`snippets/Actions/IAction.mqh` + `ActionOnConditionLogic`. Registered via
`actions.AddActionOnCondition(action, condition)` in `CreateController`.
Ready actions: `OpenMarketOrderAction`, `CloseAllAction`, `CloseSideAction`,
`DeleteOrdersAction`, trailing/breakeven/partial-close actions, etc.

### AOrderAction / orderHandlers

`orderHandlers.AddOrderAction(...)` (in `CreateController`) runs an action
for every newly opened order; the new ticket is in `_currentTicket`. See
`Templates/EA_Base.md` for examples.

### Streams

`IStream`/stream classes (`snippets/Streams/`) provide timeseries-style data
(access by bar index) and `EntryStreamData` passed to entry conditions.

## Coding conventions

- MQL4 with `#property strict`; `.mqh` includes use `#ifndef X_DEF /
  #define X_DEF` include guards.
- Interfaces are prefixed `I` (`ICondition`, `IAction`, `IStream`), abstract
  bases `A` (`ACondition`, `AOrderAction`, `AAction`).
- Reference counting instead of `delete`: objects implementing `AddRef()`/
  `Release()` are passed around as `I*` pointers; call `Release()` after
  handing ownership to containers (`condition.Add(x, false)` already takes
  ownership, then the factory calls `x.Release()` — follow that pattern).
- Feature toggles: `#ifdef FEATURE` wraps `input` declarations with an
  `#else` branch declaring plain variables with the same names — keep both
  branches in sync when adding parameters.
- Templates/snippets carry a version comment (`// Name vX.Y`); bump it when
  editing.
- `input` parameters use `snake_case`; comments after `//` document the
  input label.
- Snippets reference each other via angle-bracket includes
  (`#include <Conditions/ACondition.mqh>`), assuming `snippets/` root is on
  the include path.
- No build system, tests, or CI — verification is compiling in MetaEditor 4.

## Related repositories

- MQ4Inject — include injector: https://github.com/sibvic/MQ4Inject
- fxlint — lint utility: https://github.com/sibvic/fxlint
- Sibling template packs: fxts2, pinescript, mq5, nt8 (same structure).
