// Stream returns rising flag. Similar to ta.rising in PineScript v1.0
#include <Streams/IStream.mqh>

class RisingStream
{
   IStream* _source;
   int _length;
   int _refs;
public:
   RisingStream(IStream* source, int length)
   {
      _source = source;
      _source.AddRef();
      _length = length;
      _refs = 1;
   }
   ~RisingStream()
   {
      _source.Release();
   }

   void AddRef()
   {
      _refs++;
   }

   void Release()
   {
      if (--_refs == 0)
      {
         delete &this;
      }
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