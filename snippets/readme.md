# Snippets

## TradingTime

Checks whether date/time in the specified time interval.

Usage:

    input string start_time = "000000"; // Start time in hhmmss format
    input string stop_time = "000000"; // Stop time in hhmmss format
    
    TradingTime* tradingTime;
    void OnInit()
    {
        tradingTime = new TradingTime();
        string error;
        if (!tradingTime.Init(start_time, stop_time, error))
        {
            Print(error);
            delete tradingTime;
            tradingTime = NULL;
            return INIT_FAILED;
        }
    }

    void OnDeinit()
    {
        delete tradingTime;
        tradingTime = NULL;
    }

    void OnTick()
    {
        if (!tradingTime.IsTradingTime(Time[period]))
        {
            Print("Outside of trading time");
            return 0;
        }
    }

## AccountStatistics

Shows account statistics on the chart: date, balance, equity, profit, leverage, spread, range and price.

Usage:

    #include <InstrumentInfo.mq4>
    #include <OrdersIterator.mq4>
    AccountStatistics* stats;
    void OnInit()
    {
        stats = new AccountStatistics("EA Name");
    }

    void OnDeinit()
    {
        delete stats;
        stats = NULL;
    }

    void OnTick()
    {
        stats.Update();
    }

## MarketOrderBuilder

Builds and executes market order

Usage:

    MarketOrderBuilder *orderBuilder = new MarketOrderBuilder();
    string error;
    int order = orderBuilder
        .SetSide(BuySide)
        .SetInstrument("EURUSD")
        .SetAmount(0.1)
        .SetSlippage(3)
        .SetMagicNumber(42)
        .SetStopLoss(1.15)
        .SetTakeProfit(1.20)
        .SetComment("Test")
        .Execute(error);
    delete orderBuilder;

## Breakeven

Moves stop loss to the specified point when the selected level of profit will be reached.

Usage:

    input StopLimitType breakeven_type = StopLimitDoNotUse; // Trigger type for the breakeven
    input double breakeven_value = 10; // Trigger for the breakeven
    input double breakeven_level = 0; // Breakeven target
    IBreakevenLogic* breakeven;

    int OnInit()
    {
        if (breakeven_type == StopLimitDoNotUse)
            breakeven = new DisabledBreakevenLogic();
        else
            breakeven = new BreakevenLogic(breakeven_type, breakeven_value, breakeven_level, NULL);
    }

    void OnDeinit()
    {
        delete breakeven;
        breakeven = NULL;
    }

    void OnTick()
    {
        breakeven.DoLogic(0);

        if (NeedOpenPosition())
        {
            int ticket = OpenPosition();
            breakeven.CreateBreakeven(ticket, 0);
        }
    }

## IndicatorStreams

Set of indicator stream. Used to calculate indicator over another indicator.

## Averages

Set of averages.

## Signaler

Shows alerts.

## CloseOnOpposite

Close on oppisite logic.

## Condition

Condition classes.

## CustomExitLogic

Custom exit logic.

## EntryStrategy

Entry strategy.

## InstrumentInfo

Provides information about an instrument/symbol/ticker.

## Linq

Linq-like interface for processing data.

## MandatoryClosing

Closes all trades and deletes all orders on time.

## AlertSignal

Draws an arrow on the chart and sends alert.

Usage:

    AlertSignal* signal;
    void OnInit()
    {
        PriceStream* highStream = new PriceStream(_Symbol, (ENUM_TIMEFRAMES)_Period, PriceHigh);
        signal = new AlertSignal(new AlertCondition(), highStream);
        highStream.Release();
        int id = 0;
        id = signal.RegisterStreams(id, "Alert thrown", 217);
    }

    void OnDeinit()
    {
        delete signal;
        signal = NULL;
    }

    void OnTick()
    {
        //...
        for (int pos = limit; pos >= 0; --pos)
        {
            signal.Update();
        }
    }

## Stream

Base streams.

## OrdersIterator

Iterates through orders.

## ClosedOrdersIterator

Iterates through closed orders.

### GetTicket

Get ticket id of the current order.

### Reset

Reset indicator, so it could be iterated again using Next().

## TradingCalculator

Trade calculator.

### GetBreakevenPrice

Get breakeven price for the trades.

## TradingCommands

Common trading commands.

### MoveSLTP

Moves stop loss and take profit.

### MoveSL

Moves stop loss.

## Order

Order entity.

## TrailingController

Controller for trailing.

Usage:

    TrailingLogic* trailingController = NULL;
    Signaler* signaler = NULL;

    int init()
    {
        trailingController = new TrailingLogic(trailing_type, trailing_step, 0, trailing_start, timeframe, signaler);
    }

    int start()
    {
        trailingController.DoLogic();
        
        int order = 0;
        trailingController.Create(order, distance_to_stop_in_pips);
    }

## MoneyManagement

Money management.

## TradingController

Trading controller.

## TradingTimeConditions

Enters into a position on trading time start and exits on trading time end.

## PositionCap

Limit number of opened trades

## OrderBuilder

Creates an order.

## MartingaleStrategy

Martingale strategy.

## VisibilityCotroller

Used for show/hide indicator data button.

Usage:
        
    extern int button_x = 20;
    extern int button_y = 30;

    VisibilityCotroller _visibility;

    int init() 
    {
        //...
        _visibility.Init("CloseButton", "My indicator", "Show/Hide", button_x, button_y);
        return (0);
    }

    int start()
    {
        _visibility.HandleButtonClicks();
        if (!_visibility.IsVisible())
        {
            Clean();
            return 0;
        }
        int limit = Bars - 2;
        if (IndicatorCounted() > 2 && !_visibility.IsRecalcNeeded()) 
            limit = Bars - IndicatorCounted() - 1;
        _visibility.ResetRecalc();
        //calc data
    }

    void OnChartEvent(const int id,
                    const long &lparam,
                    const double &dparam,
                    const string &sparam)
    {
        if (_visibility.HandleButtonClicks())
            start();
    }

## TradingMonitor

Trading monitor