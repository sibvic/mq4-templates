// String stream v1.0

#ifndef StringStream_IMPL
#define StringStream_IMPL

#include <Streams/Abstract/AStringStream.mqh>

class StringStream : public AStringStream
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
   string _stream[];
public:
   StringStream(const string symbol, const ENUM_TIMEFRAMES timeframe)
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

   void SetValue(const int period, string value)
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

   virtual bool GetValue(const int period, string &val)
   {
      int size = iBars(_Symbol, _Period);
      int oldPos = size - period - 1;
      if (oldPos - 1 >= size)
      {
         return false;  
      }
      EnsureStreamHasProperSize(size);
      if (_stream[oldPos] == NULL)
      {
         return false;
      }
      val = _stream[oldPos];
      return true;
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