#ifndef BarsSinceStreamV2_IMPL
#define BarsSinceStreamV2_IMPL

#include <Streams/Abstract/AIntStream.mqh>
#include <Streams/Interfaces/IBoolStream.mqh>

// Counts number of bars since last condition.
// v1.01

class BarsSinceStreamV2 : public AIntStream
{
   IBoolStream* _condition;
   int _bars[];
public:
   BarsSinceStreamV2(IBoolStream* condition)
   {
      _condition = condition;
      _condition.AddRef();
   }

   ~BarsSinceStreamV2()
   {
      _condition.Release();
   }

   int Size()
   {
      return _condition.Size();
   }

   virtual bool GetValue(const int period, int &val)
   {
      int size = Size();
      if (period >= size)
      {
         return false;
      }
      if (ArraySize(_bars) < size)
      {
         ArrayResize(_bars, size);
      }
      int index = size - period - 1;
      if (_bars[index] == 0)
      {
         FillHistory(period);
      }
      val = _bars[index];
      return true;
   }
private:
   void FillHistory(int period)
   {
      int size = Size();
      for (int periodIndex = period; periodIndex < size; ++periodIndex)
      {
         int index = size - periodIndex - 1;
         bool val;
         if (!_condition.GetValue(periodIndex, val) || !val)
         {
            if (_bars[index] == 0)
            {
               continue;
            }
         }
         else
         {
            _bars[index] = 0;
         }
         for (int ii = index + 1; ii <= size - period - 1; ++ii)
         {
            _bars[ii] = _bars[ii - 1] + 1;
         }
         return;
      }
   }
};
#endif