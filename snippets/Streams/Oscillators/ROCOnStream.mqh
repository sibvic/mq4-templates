#include <Streams/AOnStream.mqh>

// Rate of change stream v1.0

class ROCOnStream : public AOnStream
{
   double _length;
public:
   ROCOnStream(IStream *source, const int length)
      :AOnStream(source)
   {
      _length = length;
   }

   ~ROCOnStream()
   {
   }

   bool GetValue(const int period, double &val)
   {
      double pr;
      if (!_source.GetValue(period + _length, pr) || pr == 0)
      {
         return false;
      }
      double currPrice;
      if (!_source.GetValue(period, currPrice))
      {
         return false;
      }
      val = (currPrice / pr - 1) * 100;
      return true;
   }
};