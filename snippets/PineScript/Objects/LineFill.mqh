// Linefill object
// v1.1

#ifndef LineFill_IMPL
#define LineFill_IMPL

class LineFill
{
   int _refs;
public:
   LineFill()
   {
      _refs = 1;
   }
   void AddRef()
   {
      _refs++;
   }
   int Release()
   {
      int refs = --_refs;
      if (refs == 0)
      {
         delete &this;
      }
      return refs;
   }
   static void Delete(LineFill* linefill)
   {
   }
};
#endif
