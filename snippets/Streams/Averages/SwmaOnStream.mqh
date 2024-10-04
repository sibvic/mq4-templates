#include <Streams/AOnStream.mqh>

#ifndef SwmaOnStream_IMPL
#define SwmaOnStream_IMPL

// EMA on stream v1.0

class SwmaOnStream : public AOnStream
{
public:
   SwmaOnStream(IStream *source)
      :AOnStream(source)
   {
   }

   bool GetValue(const int period, double &val)
   {
      int totalBars = _source.Size();
      if (period > totalBars - 4)
      {
         return false;
      }

      double x0;
      double x1;
      double x2;
      double x3;
      if (!_source.GetValue(period, x0) || !_source.GetValue(period + 1, x1) || !_source.GetValue(period + 2, x2) || !_source.GetValue(period + 3, x3))
      {
         return false;
      }
      val = x3 * 1 / 6 + x2 * 2 / 6 + x1 * 2 / 6 + x0 * 1 / 6;
      return true;
   }
};
#endif 