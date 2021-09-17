// Boilinger Band Standard Stream v1.0

#ifndef BoilingerBandStandardStream_IMP
#define BoilingerBandStandardStream_IMP

#include <AStream.mqh>

class BoilingerBandStandardStream : public AStream
{
   double _dev;
   int _length;
   int _stream;
public:
   BoilingerBandStandardStream(string symbol, ENUM_TIMEFRAMES timeframe, int length, double dev, int stream)
      :AStream(symbol, timeframe)
   {
      _dev = dev;
      _length = length;
      _stream = stream;
   }

   ~BoilingerBandStandardStream()
   {
   }

   virtual bool GetValue(const int period, double &val)
   {
      val = iBands(_symbol, _timeframe, _length, _dev, 0, PRICE_CLOSE, _stream, period);
      return true;
   }
};

#endif