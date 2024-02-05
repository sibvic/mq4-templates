// Float array stream v1.0
#include <Array/IIntArray.mqh>

interface IIntArrayStream
{
public:
   virtual void AddRef() = 0;
   virtual void Release() = 0;
   virtual int Size() = 0;

   virtual bool GetValue(const int period, IIntArray* &val) = 0;
};