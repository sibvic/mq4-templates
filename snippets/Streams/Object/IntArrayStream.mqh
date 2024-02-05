// Integer array stream v1.0

#ifndef IntArrayStream_IMPL
#define IntArrayStream_IMPL

#include <Streams/Abstract/AIntArrayStream.mqh>

class IntArrayStream : public AIntArrayStream
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
   IIntArray* _stream[];
public:
   IntArrayStream(const string symbol, const ENUM_TIMEFRAMES timeframe)
   {
      _symbol = symbol;
      _timeframe = timeframe;
   }
   void Init()
   {
      for (int i = 0; i < ArraySize(_stream); ++i)
      {
         _stream[i] = NULL;
      }
   }

   virtual int Size()
   {
      return iBars(_symbol, _timeframe);
   }

   void SetValue(const int period, IIntArray* value)
   {
      int totalBars = Size();
      int index = totalBars - period - 1;
      if (index < 0 || totalBars <= index)
      {
         return;
      }
      EnsureStreamHasProperSize(totalBars);
      _stream[index] = value;
   }

   bool GetValue(const int period, IIntArray* &val)
   {
      int totalBars = Size();
      int index = totalBars - period - 1;
      if (index < 0 || totalBars <= index)
      {
         return false;
      }
      EnsureStreamHasProperSize(totalBars);
      
      val = _stream[index];
      return _stream[index] != NULL;
   }
private:
   void EnsureStreamHasProperSize(int size)
   {
      int currentSize = ArrayRange(_stream, 0);
      if (currentSize != size) 
      {
         ArrayResize(_stream, size);
         for (int i = currentSize; i < size; ++i)
         {
            _stream[i] = NULL;
         }
      }
   }
};
#endif