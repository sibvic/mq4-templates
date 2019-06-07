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