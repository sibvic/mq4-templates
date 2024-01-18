#include <Streams/AOnStream.mqh>
#include <Streams/SimplePriceStream.mqh>
#include <enums/PriceType.mqh>

// Lowest low stream v1.4

class LowestLowStream : public AOnStream
{
   int _loopback;
public:
   LowestLowStream(string symbol, ENUM_TIMEFRAMES timeframe, int loopback)
      :AOnStream(new SimplePriceStream(symbol, timeframe, PriceLow))
   {
      _source.Release();
   }
   LowestLowStream(IStream* source, int loopback)
      :AOnStream(source)
   {
      _loopback = loopback;
   }

   static bool GetValue(const int period, double &val, IStream* source, int loopback)
   {
      if (!source.GetValue(period, val))
         return false;

      for (int i = 1; i < loopback; ++i)
      {
         double value;
         if (!source.GetValue(period + i, value))
            return false;
         val = MathMin(val, value);
      }
      return true;
   }

   bool GetValue(const int period, double &val)
   {
      return LowestLowStream::GetValue(period, val, _source, _loopback);
   }
};