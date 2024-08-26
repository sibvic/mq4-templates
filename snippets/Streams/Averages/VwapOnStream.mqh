// Vwap on stream v1.0

#include <Streams/AOnStream.mqh>
#include <Streams/interfaces/IIntStream.mqh>
#include <Streams/interfaces/IDateTimeStream.mqh>
#include <Streams/VolumeStream.mqh>
#include <Streams/DateTimeStream.mqh>

#ifndef VwapOnStream_IMP
#define VwapOnStream_IMP

class VwapOnStream : public AOnStream
{
   IIntStream* _volume;
   IDateTimeStream* _dates;
public:
   VwapOnStream(IStream *source, IIntStream* volume, IDateTimeStream* dates)
      :AOnStream(source)
   {
      _volume = volume;
      _volume.AddRef();
      _dates = dates;
      _dates.AddRef();
   }
   
   ~VwapOnStream()
   {
      _volume.Release();
      _dates.Release();
   }

   bool GetValue(const int period, double &val)
   {
      int totalBars = _volume.Size();
      if (period > totalBars)
         return false;
         
      double sum1 = 0;
      double sum2 = 0;
      datetime startDate;
      if (!_dates.GetValue(period, startDate))
      {
         val = EMPTY_VALUE;
         return false;
      }
      int startDay = TimeDay(startDate);
      for (int i = period; i < Size(); ++i)
      {
         datetime current;
         if (!_dates.GetValue(i, current))
         {
            val = EMPTY_VALUE;
            return false;
         }
         int currentDay = TimeDay(current);
         if (currentDay != startDate)
         {
            break;
         }
         double value;
         if (!_source.GetValue(i, value))
         {
            val = EMPTY_VALUE;
            return false;
         }
         int volume;
         if (!_volume.GetValue(i, volume))
         {
            val = EMPTY_VALUE;
            return false;
         }
         sum1 += value * volume;
         sum2 += volume;
      }
      val = sum2 != 0 ? sum1 / sum2 : 0;
      return true;
   }
};

class VwapOnStreamFactory
{
public:
   static IStream* Create(const string symbol, ENUM_TIMEFRAMES timeframe, IStream *source)
   {
      VolumeStream* volume = new VolumeStream(symbol, timeframe);
      DateTimeStream* dates = new DateTimeStream(symbol, timeframe);
      VwapOnStream* stream = new VwapOnStream(source, volume, dates);
      volume.Release();
      dates.Release();
      return stream;
   }
   
   static IStream* Create(IStream *source, IIntStream* volume, IDateTimeStream* dates)
   {
      return new VwapOnStream(source, volume, dates);
   }
};

#endif