// Float array stream v1.0

#ifndef FloatArrayStream_IMPL
#define FloatArrayStream_IMPL

#include <Streams/Abstract/AFloatArrayStream.mqh>

class FloatArrayStream : public AFloatArrayStream
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
   IFloatArray* _stream[];
public:
   FloatArrayStream(const string symbol, const ENUM_TIMEFRAMES timeframe)
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

   void SetValue(const int period, IFloatArray* value)
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

   bool GetValue(const int period, IFloatArray* &val)
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