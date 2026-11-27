#include <Streams/AStreamBase.mqh>
#include <Streams/HighestHighStream.mqh>
#include <Streams/LowestLowStream.mqh>

// Stochastics on stream v2.1
// 100 * (source - lowest(low, length)) / (highest(high, length) - lowest(low, length))
// A flat range or a missing value returns no value.

class StochOnStream : public AStreamBase
{
   TIStream<double>* _closeStream;
   HighestHighStream* _highest;
   LowestLowStream* _lowest;
   int _period;
public:
   StochOnStream(TIStream<double>* closeStream, TIStream<double>* highStream, TIStream<double>* lowStream, int period)
      :AStreamBase()
   {
      _period = period;
      _closeStream = closeStream;
      _closeStream.AddRef();
      _highest = new HighestHighStream(highStream, period);
      _lowest = new LowestLowStream(lowStream, period);
   }

   ~StochOnStream()
   {
      _closeStream.Release();
      _highest.Release();
      _lowest.Release();
   }
   
   virtual int Size()
   {
      return _closeStream.Size();
   }
   
   virtual bool GetValue(const int period, double &val)
   {
      double close;
      if (!_closeStream.GetValue(period, close))
      {
         return false;
      }
      double lowest;
      if (!_lowest.GetValue(period, lowest))
      {
         return false;
      }
      double highest;
      if (!_highest.GetValue(period, highest))
      {
         return false;
      }
      if (close == EMPTY_VALUE || highest == EMPTY_VALUE || lowest == EMPTY_VALUE)
      {
         return false;
      }
      double diff = highest - lowest;
      if (diff == 0)
      {
         return false;
      }
      val = 100 * (close - lowest) / diff;
      return true;
   }
};
