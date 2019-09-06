// Band cross over condition v1.1
#ifndef BandCrossOverCondition_IMP
#define BandCrossOverCondition_IMP
#include <ABaseCondition.mq4>
class BandCrossOverCondition : public ABaseCondition
{
   int _period;
   double _dev;
public:
   BandCrossOverCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int period, double dev)
      :ABaseCondition(symbol, timeframe)
   {
      _period = period;
      _dev = dev;
   }

   bool IsPass(const int period)
   {
      double lowerValue0 = iBands(_symbol, _timeframe, _period, _dev, 0, PRICE_CLOSE, MODE_LOWER, period);
      double lowerValue1 = iBands(_symbol, _timeframe, _period, _dev, 0, PRICE_CLOSE, MODE_LOWER, period + 1);
      double close0 = iClose(_symbol, _timeframe, period);
      double close1 = iClose(_symbol, _timeframe, period + 1);
      return lowerValue0 < close0 && lowerValue1 >= close1;
   }
};
#endif