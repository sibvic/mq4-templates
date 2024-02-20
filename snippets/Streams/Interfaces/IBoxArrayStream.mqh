// Box array stream v1.0
#include <Array/IBoxArray.mqh>

interface IBoxArrayStream
{
public:
   virtual void AddRef() = 0;
   virtual void Release() = 0;
   virtual int Size() = 0;

   virtual bool GetValue(const int period, IBoxArray* &val) = 0;
};