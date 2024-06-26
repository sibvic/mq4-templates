// Stream returns rising flag. Similar to ta.rising in PineScript v1.1
#include <Streams/Abstract/ABoolStream.mqh>

class RisingStream : public ABoolStream
{
   IStream* _source;
   int _length;
public:
   RisingStream(IStream* source, int length)
   {
      _source = source;
      _source.AddRef();
      _length = length;
   }
   ~RisingStream()
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
      val = prev < current;
      return true;
   }
};