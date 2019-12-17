// Band cross under v1.1
#ifndef BandCrossUnderCondition_IMP
#define BandCrossUnderCondition_IMP

#include <ACondition.mq4>

class BandCrossUnderCondition : public ACondition
{
   int _period;
   double _dev;
public:
   BandCrossUnderCondition(const string symbol, ENUM_TIMEFRAMES timeframe, int period, double dev)
      :ACondition(symbol, timeframe)
   {

   }

   bool IsPass(const int period)
   {
      double upperValue0 = iBands(_symbol, _timeframe, _period, _dev, 0, PRICE_CLOSE, MODE_UPPER, period);
      double upperValue1 = iBands(_symbol, _timeframe, _period, _dev, 0, PRICE_CLOSE, MODE_UPPER, period + 1);
      double close0 = iClose(_symbol, _timeframe, period);
      double close1 = iClose(_symbol, _timeframe, period + 1);
      return upperValue0 > close0 && upperValue1 <= close1;
   }
};
#endif