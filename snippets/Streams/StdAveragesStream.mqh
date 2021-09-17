// Standard averages stream v1.0

#ifndef StdAveragesStream_IMP
#define StdAveragesStream_IMP

#include <IStream.mqh>
class StdAveragesStream : public AStream
{
   int _period;
   int _shift;
   ENUM_MA_METHOD _method;
   ENUM_APPLIED_PRICE _price;
public:
   StdAveragesStream(const string symbol, const ENUM_TIMEFRAMES timeframe, 
                     int period, int shift, ENUM_MA_METHOD method, ENUM_APPLIED_PRICE price)
      :AStream(symbol, timeframe)
   {
      _period = price;
      _shift = shift;
      _method = method;
      _price = price;
   }

   virtual bool GetValue(const int period, double &val)
   {
      val = iMA(_symbol, _timeframe, _period, _shift, _method, _price, period);
      return true;
   }
};
#endif