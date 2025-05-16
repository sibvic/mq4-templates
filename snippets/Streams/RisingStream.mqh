// Stream returns rising flag. Similar to ta.rising in PineScript v2.0
#include <Streams/Abstract/ABoolStream.mqh>

class RisingStream : public ABoolStream
{
   TIStream<double>* _source;
   int _length;
public:
   RisingStream(TIStream<double>* source, int length)
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