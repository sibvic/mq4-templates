// Price outside band condition v1.1
#ifndef PriceOutsideBandCondition_IMP
#define PriceOutsideBandCondition_IMP
#include <ACondition.mq4>
class PriceOutsideBandCondition : public ACondition
{
   int _period;
   double _dev;
public:
   PriceOutsideBandCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int period, double dev)
      :ACondition(symbol, timeframe)
   {
      _period = period;
      _dev = dev;
   }

   bool IsPass(const int period)
   {
      double lowerValue = iBands(_symbol, _timeframe, _period, _dev, 0, PRICE_CLOSE, MODE_LOWER, period);
      double upperValue = iBands(_symbol, _timeframe, _period, _dev, 0, PRICE_CLOSE, MODE_UPPER, period);
      double close = iClose(_symbol, _timeframe, period);
      return lowerValue > close || upperValue < close;
   }
};
#endif