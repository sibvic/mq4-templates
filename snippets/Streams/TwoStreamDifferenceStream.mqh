#include <Streams/AStreamBase.mqh>

// Difference between two streams v1.0

class TwoStreamDifferenceStream : public AStreamBase
{
   IStream* _first;
   IStream* _second;
public:
   TwoStreamDifferenceStream(IStream* first, IStream* second)
      :AStreamBase()
   {
      _first = first;
      _first.AddRef();
      _second = second;
      _second.AddRef();
   }
   ~TwoStreamDifferenceStream()
   {
      _first.Release();
      _second.Release();
   }

   virtual int Size()
   {
      return _first.Size();
   }

   bool GetValue(const int period, double &val)
   {
      double first;
      double second;
      if (!_first.GetValue(period, first) || !_second.GetValue(period, second))
      {
         return false;
      }
      val = first - second;
      return true;
   }
};