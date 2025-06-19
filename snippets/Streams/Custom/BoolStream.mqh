// Custom boolean stream v2.0

#ifndef BoolStream_IMPL
#define BoolStream_IMPL

#include <Streams/Abstract/TAStream.mqh>

class BoolStream : public TAStream<int>
{
   string _symbol;
   ENUM_TIMEFRAMES _timeframe;
   bool _stream[];
   int _emptyValue;
public:
   BoolStream(const string symbol, const ENUM_TIMEFRAMES timeframe, int emptyValue = -1)
   {
      _emptyValue = emptyValue;
      _symbol = symbol;
      _timeframe = timeframe;
   }
   void Init()
   {
      ArrayInitialize(_stream, _emptyValue);
   }

   virtual int Size()
   {
      return iBars(_symbol, _timeframe);
   }

   void SetValue(const int period, bool value)
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

   bool GetValue(const int period, bool &val)
   {
      int totalBars = Size();
      int index = totalBars - period - 1;
      if (index < 0 || totalBars <= index)
      {
         return false;
      }
      EnsureStreamHasProperSize(totalBars);
      
      val = _stream[index];
      return _stream[index] != _emptyValue;
   }
   
   bool GetValue(const int period, int &val)
   {
      int totalBars = Size();
      int index = totalBars - period - 1;
      if (index < 0 || totalBars <= index)
      {
         return false;
      }
      EnsureStreamHasProperSize(totalBars);
      
      val = _stream[index];
      return _stream[index] != _emptyValue;
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
            _stream[i] = _emptyValue;
         }
      }
   }
};
#endif