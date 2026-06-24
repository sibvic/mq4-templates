// Percent rank v2.0

#ifndef PercentRank_IMP
#define PercentRank_IMP

#include <Streams/AOnStream.mqh>

class PercentRank : public AOnStream
{
   int length;
public:
   PercentRank(TIStream<double> *stream, int length)
      :AOnStream(stream)
   {
      this.length = length;
   }

   bool GetValue(const int period, double &val)
   {
      int totalBars = Size();
      if (totalBars == 0)
      {
         return false;
      }

      double target;
      if (!_source.GetValue(period, target))
      {
         return false;
      }

      int count = 0;
      for (int i = 1; i < length; ++i)
      {
         double current;
         if (!_source.GetValue(period + i, current))
         {
            return false;
         }
         if (current != EMPTY_VALUE && target >= current)
         {
            count++;
         }
      }
      val = (count * 100.0) / length;
      return true;
   }
};

#endif
