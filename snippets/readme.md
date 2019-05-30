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

    void OnCalculate()
    {
        if (!tradingTime.IsTradingTime(Time[period]))
        {
            Print("Outside of trading time");
            return 0;
        }
    }