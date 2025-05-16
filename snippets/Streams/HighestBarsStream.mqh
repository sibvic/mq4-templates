#include <Streams/AOnStream.mqh>
#include <Streams/SimplePriceStream.mqh>
#include <enums/PriceType.mqh>

// Highest bars stream v2.0

class HighestBarsStream : public AOnStream
{
   int _loopback;
public:
   HighestBarsStream(string symbol, ENUM_TIMEFRAMES timeframe, int loopback)
      :AOnStream(new SimplePriceStream(symbol, timeframe, PriceHigh))
   {
      _source.Release();
      _loopback = loopback;
   }
   HighestBarsStream(TIStream<double>* source, int loopback)
      :AOnStream(source)
   {
      _loopback = loopback;
   }

   bool GetValue(const int period, int &val)
   {
      double current;
      if (!_source.GetValue(period, current))
         return false;
      int index = 0;
      for (int i = 1; i < _loopback; ++i)
      {
         double value;
         if (!_source.GetValue(period + i, value))
            return false;
         if (current < value)
         {
            current = value;
            index = i;
         }
      }
      val = index;
      return true;
   }

   bool GetValue(const int period, double &val)
   {
      int value;
      if (!GetValue(period, value))
      {
         return false;
      }
      val = value;
      return true;
   }
};