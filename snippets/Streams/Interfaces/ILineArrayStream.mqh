// Line array stream v1.0
#include <Array/ILineArray.mqh>

interface ILineArrayStream
{
public:
   virtual void AddRef() = 0;
   virtual void Release() = 0;
   virtual int Size() = 0;

   virtual bool GetValue(const int period, ILineArray* &val) = 0;
};