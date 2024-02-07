// Stream returns falling flag. Similar to ta.falling in PineScript v1.0
#include <Streams/Abstract/ABoolStream.mqh>

class FallingStream : public ABoolStream
{
   IStream* _source;
   int _length;
public:
   FallingStream(IStream* source, int length)
   {
      _source = source;
      _source.AddRef();
      _length = length;
   }
   ~FallingStream()
   {
      _source.Release();
   }

   int Size()
   {
      return _source.Size();
   }

   bool GetValue(const int period, bool &val)
   {
      double current;
      if (!_source.GetValue(period, current))
      {
         return false;
      }
      double prev;
      if (!_source.GetValue(period + _length, prev))
      {
         return false;
      }
      val = prev > current;
      return true;
   }
};