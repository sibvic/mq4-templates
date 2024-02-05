// Float array stream v1.0
#include <Array/IFloatArray.mqh>

interface IFloatArrayStream
{
public:
   virtual void AddRef() = 0;
   virtual void Release() = 0;
   virtual int Size() = 0;

   virtual bool GetValue(const int period, IFloatArray* &val) = 0;
};