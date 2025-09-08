// Float array stream v1.0
#include <Array/ITArray.mqh>

interface IIntArrayStream
{
public:
   virtual void AddRef() = 0;
   virtual void Release() = 0;
   virtual int Size() = 0;

   virtual bool GetValue(const int period, ITArray<int>* &val) = 0;
};