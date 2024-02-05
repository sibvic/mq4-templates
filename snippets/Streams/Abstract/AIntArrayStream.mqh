// Abstract implementation for IIntArrayStream v1.0

#ifndef IIntArrayStream_IMPL
#define IIntArrayStream_IMPL

#include <Streams/Interfaces/IIntArrayStream.mqh>

class AIntArrayStream : public IIntArrayStream
{
   int _refs;   
public:
   AIntArrayStream()
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
