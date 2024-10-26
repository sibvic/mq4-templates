#include <Streams/AOnStream.mqh>
#include <Streams/Averages/SMAOnStream.mqh>
#include <Streams/TwoStreamDifferenceStream.mqh>
#include <Streams/AbsStream.mqh>
#include <Streams/SumOnStream.mqh>

// CCI on stream v1.0

class CCIOnStream : public AOnStream
{
   double _length;
   TwoStreamDifferenceStream* _diff;
   SumOnStream* _sum;
   double _mul;
public:
   CCIOnStream(IStream *source, const int length)
      :AOnStream(source)
   {
      _length = length;
      SmaOnStream* mov = new SmaOnStream(source, length);
      _mul = 0.015 / length;
      _diff = new TwoStreamDifferenceStream(source, mov);
      mov.Release();
      AbsStream* diffAbs = new AbsStream(_diff);
      _sum = new SumOnStream(diffAbs, length);
      diffAbs.Release();
   }

   ~CCIOnStream()
   {
      _diff.Release();
      _sum.Release();
   }

   bool GetValue(const int period, double &val)
   {
      double sum = 0;
      double diff = 0;
      if (!_sum.GetValue(period, sum) || !_diff.GetValue(period, diff))
      {
         return false;
      }
      sum *= _mul;
      val = diff / sum;
      return true;
   }
};