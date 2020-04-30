// High/low stop loss stream v1.0

#ifndef HighLowStopLossProvider_IMP
#define HighLowStopLossProvider_IMP

class HighLowStopLossProvider : public IStopLossProvider
{
   int _bars;
   bool _isBuy;
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
public:
   HighLowStopLossProvider(int bars, bool isBuy, string symbol, ENUM_TIMEFRAMES timeframe)
   {
      _symbol = symbol;
      _timeframe = timeframe;
      _bars = bars;
      _isBuy = isBuy;
   }

   virtual double GetValue(const int period, double entryPrice)
   {
      if (_isBuy)
      {
         int lowestIndex = iLowest(_symbol, _timeframe, MODE_LOW, _bars, period);
         return iLow(_symbol, _timeframe, lowestIndex);
      }
      int highestIndex = iHighest(_symbol, _timeframe, MODE_HIGH, _bars, period);
      return iHigh(_symbol, _timeframe, highestIndex);
   }
};


#endif