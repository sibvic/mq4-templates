// Pivot high stream v1.2

#include <Streams/AOnStream.mqh>
#include <Streams/SimplePriceStream.mqh>
#include <enums/PriceType.mqh>

class PivotHighStream : public AOnStream
{
   int _leftBars;
   int _rightBars;
public:
   PivotHighStream(IStream *source, int leftBars, int rightBars)
      :AOnStream(source)
   {
      _leftBars = leftBars;
      _rightBars = rightBars;
   }

   PivotHighStream(string symbol, ENUM_TIMEFRAMES timeframe, int leftBars, int rightBars)
      :AOnStream(NULL)
   {
      _source = new SimplePriceStream(symbol, timeframe, PriceHigh);
      _leftBars = leftBars;
      _rightBars = rightBars;
   }

   bool GetValue(const int period, double &val)
   {
      double center;
      if (!_source.GetValue(period + _rightBars, center))
      {
         return false;
      }
      double value;
      for (int i = 0; i < _rightBars; ++i)
      {
         if (!_source.GetValue(period + i, value) || center < value)
         {
            return false;
         }
      }
      for (int ii = 0; ii < _leftBars; ++ii)
      {
         if (!_source.GetValue(period + ii + _rightBars, value) || center < value)
         {
            return false;
         }
      }
      val = center;
      return true;
   }
};