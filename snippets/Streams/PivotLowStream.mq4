// Pivot low stream v1.0

#include <AOnStream.mq4>

class PivotLowStream : public AOnStream
{
   int _leftBars;
   int _rightBars;
public:
   PivotLowStream(IStream *source, int leftBars, int rightBars)
      :AOnStream(source)
   {
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
      for (int i = 0; i < _rightBars; ++i)
      {
         double value;
         if (!_source.GetValue(period + i, value) || center > value)
         {
            return false;
         }
      }
      for (int i = 0; i < _leftBars; ++i)
      {
         double value;
         if (!_source.GetValue(period + i + _rightBars, value) || center > value)
         {
            return false;
         }
      }
      val = center;
      return true;
   }
};