// VWMA on stream v1.2

#include <Streams/AOnStream.mqh>
#include <Streams/Interfaces/IIntStream.mqh>

#ifndef VwmaOnStream_IMP
#define VwmaOnStream_IMP

class VwmaOnStream : public AOnStream
{
   int _length;
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
public:
   VwmaOnStream(string symbol, ENUM_TIMEFRAMES timeframe, IStream *source, const int length)
      :AOnStream(source)
   {
      _symbol = symbol;
      _timeframe = timeframe;
      _length = length;
   }

   bool GetValue(const int period, double &val)
   {
      int totalBars = iBars(_symbol, _timeframe);
      if (period > totalBars - _length)
         return false;
      double price;
      if (!_source.GetValue(period, price))
         return false;

      long sumw = iVolume(_symbol, _timeframe, period);
      double sum = sumw * price;
      for (int k = 1; k < _length; k++)
      {
         long weight = Volume[period + k];
         sumw += weight;
         if (!_source.GetValue(period + k, price))
            return false;
         sum += weight * price;  
      }
      val = sum / sumw;
      return true;
   }
};

class VwmaWithVolumeStreamOnStream : public AOnStream
{
   int _length;
   IIntStream* _volume;
public:
   VwmaWithVolumeStreamOnStream(IStream *source, IIntStream* volume, const int length)
      :AOnStream(source)
   {
      _volume = volume;
      _volume.AddRef();
      _length = length;
   }
   
   ~VwmaWithVolumeStreamOnStream()
   {
      _volume.Release();
   }

   bool GetValue(const int period, double &val)
   {
      int totalBars = _volume.Size();
      if (period > totalBars - _length)
         return false;
      double price;
      if (!_source.GetValue(period, price))
         return false;

      int sumw;
      if (!_volume.GetValue(period, sumw))
      {
         return false;
      }
      double sum = sumw * price;
      for (int k = 1; k < _length; k++)
      {
         int weight;
         if (!_volume.GetValue(period + k, weight))
         {
            return false;
         }
         sumw += weight;
         if (!_source.GetValue(period + k, price))
            return false;
         sum += weight * price;  
      }
      val = sum / sumw;
      return true;
   }
};

class VwmaOnStreamFactory
{
public:
   static IStream* Create(string symbol, ENUM_TIMEFRAMES timeframe, IStream *source, const int length)
   {
      return new VwmaOnStream(symbol, timeframe, source, length);
   }
   
   static IStream* Create(IStream *source, IIntStream *volume, const int length)
   {
      return new VwmaWithVolumeStreamOnStream(source, volume, length);
   }
};

#endif