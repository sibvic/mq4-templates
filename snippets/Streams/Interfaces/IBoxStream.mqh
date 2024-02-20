// Box array stream v1.0
#include <Objects/Box.mqh>

interface IBoxStream
{
public:
   virtual void AddRef() = 0;
   virtual void Release() = 0;
   virtual int Size() = 0;

   virtual bool GetValue(const int period, Box* &val) = 0;
};