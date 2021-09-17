// Range stream on stream v1.0

#include <AStreamBase.mqh>
#include <IBarStream.mqh>

#ifndef RangeStreamOnStream_IMP
#define RangeStreamOnStream_IMP

class RangeStreamOnStream : public AStreamBase
{
   IBarStream* _stream;
public:
   RangeStreamOnStream(IBarStream* stream)
   {
      _stream = stream;
      _stream.AddRef();
   }

   ~RangeStreamOnStream()
   {
      _stream.Release();
   }
   
   virtual bool GetValue(const int period, double &val)
   {
      double high, low;
      if (!_stream.GetHighLow(period, high, low))
         return false;
      val = high - low;
      return true;
   }
};

#endif