#include <Streams/AStreamBase.mqh>
// Custom stream with a size of a parent stream v2.0

class CustomStreamOnStream : public AStreamBase
{
   TIStream<double>* _source;
   double _stream[];
public:
   CustomStreamOnStream(TIStream<double>* stream)
   {
      _source = stream;
      _source.AddRef();
   }
   ~CustomStreamOnStream()
   {
      _source.Release();
   }

   void Init()
   {
      ArrayInitialize(_stream, EMPTY_VALUE);
   }

   virtual int Size()
   {
      return _source.Size();
   }

   void SetValue(const int period, double value)
   {
      int totalBars = Size();
      EnsureStreamHasProperSize(totalBars);
      _stream[period] = value;
   }

   bool GetValue(const int period, double &val)
   {
      int totalBars = Size();
      EnsureStreamHasProperSize(totalBars);
      val = _stream[period];
      return _stream[period] != EMPTY_VALUE;
   }
private:
   void EnsureStreamHasProperSize(int size)
   {
      if (ArrayRange(_stream, 0) != size) 
      {
         ArrayResize(_stream, size);
      }
   }
};
