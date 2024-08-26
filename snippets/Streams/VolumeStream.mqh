#include <Streams/Abstract/AIntStream.mqh>

// Volume stream v1.0

#ifndef VolumeStream_IMP
#define VolumeStream_IMP

class VolumeStream : public AIntStream
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
public:
   VolumeStream(const string symbol, ENUM_TIMEFRAMES timeframe)
   {
      _symbol = symbol;
      _timeframe = timeframe;
   }
   ~VolumeStream()
   {
   }

   bool GetValue(const int period, int &val)
   {
      if (iBars(_symbol, _timeframe) <= period)
      {
         return false;
      }
      val = iVolume(_symbol, _timeframe, period);
      return true;
   }
   
   int Size()
   {
      return iBars(_symbol, _timeframe);
   }
   
};
#endif