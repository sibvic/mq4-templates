// Abstrace candle condition v1.0

#ifndef ACandleCondition_IMP
#define ACandleCondition_IMP

class ACandleCondition : public ACondition
{
public:
   ACandleCondition(string symbol, ENUM_TIMEFRAMES timeframe)
      :ACondition(symbol, timeframe)
   {

   }
protected:
   bool IsBullish(const int period, const datetime date)
   {
      return iClose(_symbol, _timeframe, period) >= iOpen(_symbol, _timeframe, period);
   }

   bool IsBearish(const int period, const datetime date)
   {
      return iClose(_symbol, _timeframe, period) < iOpen(_symbol, _timeframe, period);
   }

   double UpperWick(const int period, const datetime date)
   {
      return (iHigh(_symbol, _timeframe, period) - MathMax(iClose(_symbol, _timeframe, period), iOpen(_symbol, _timeframe, period))) / _instrument.GetPipSize();
   }

   double LowerWick(const int period, const datetime date)
   {
      return (MathMin(iClose(_symbol, _timeframe, period), iOpen(_symbol, _timeframe, period)) - iLow(_symbol, _timeframe, period)) / _instrument.GetPipSize();
   }

   double Body(const int period, const datetime date)
   {
      return MathAbs(iClose(_symbol, _timeframe, period) - iOpen(_symbol, _timeframe, period)) / _instrument.GetPipSize();
   }

   double Size(const int period, const datetime date)
   {
      return (iHigh(_symbol, _timeframe, period) - iLow(_symbol, _timeframe, period)) / _instrument.GetPipSize();
   }
};

#endif