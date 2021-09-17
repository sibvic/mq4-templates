// Stochastic stream v1.0

#include <AStream.mqh>

#ifndef StochasticStream_IMP
#define StochasticStream_IMP

class StochasticStream : public AStream
{
   int _kPeriod;
   int _dPeriod;
   int _slowingPeriod;
   int _stream;
public:
   StochasticStream(const string symbol, ENUM_TIMEFRAMES timeframe, int kPeriod, int dPeriod, int slowingPeriod, int stream)
      :AStream(symbol, timeframe)
   {
      _kPeriod = kPeriod;
      _dPeriod = dPeriod;
      _slowingPeriod = slowingPeriod;
      _stream = stream;
   }

   ~StochasticStream()
   {
   }

   bool GetValue(const int period, double &val)
   {
      val = iStochastic(_symbol, _timeframe, _kPeriod, _dPeriod, _slowingPeriod, MODE_SMA, 0, _stream, period);
      return true;
   }
};
#endif