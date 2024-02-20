// Abstract implementation for IBoxArrayStream v1.0

#ifndef ABoxArrayStream_IMPL
#define ABoxArrayStream_IMPL

#include <Streams/Interfaces/IBoxArrayStream.mqh>

class ABoxArrayStream : public IBoxArrayStream
{
   int _refs;   
public:
   ABoxArrayStream()
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
