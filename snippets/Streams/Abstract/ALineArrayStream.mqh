// Abstract implementation for ILineArrayStream v1.0

#ifndef ALineArrayStream_IMPL
#define ALineArrayStream_IMPL

#include <Streams/Interfaces/ILineArrayStream.mqh>

class ALineArrayStream : public ILineArrayStream
{
   int _refs;   
public:
   ALineArrayStream()
   {
      _refs = 1;
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
};

#endif
