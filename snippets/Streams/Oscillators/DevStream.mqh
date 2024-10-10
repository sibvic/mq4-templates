#include <Streams/AOnStream.mqh>
#include <Streams/Averages/SmaOnStream.mqh>

// Measure of difference between the series and it's SMA stream 
// v1.0

class DevStream : public AOnStream
{
   SmaOnStream* sma;
public:
   DevStream (IStream *source, const int length)
      :AOnStream(source)
   {
      sma = new SmaOnStream(source, length);
   }

   ~DevStream ()
   {
      sma.Release();
   }

   bool GetValue(const int period, double &val)
   {
      double src;
      double smaValue;
      if (!_source.GetValue(period, src) || !sma.GetValue(period, smaValue))
      {
         return false;
      }
      val = src - smaValue;
      return true;
   }
};