// Line array interface v1.0
#include <Objects/Line.mqh>

class ILineArray
{
public:
   virtual void Unshift(Line* value) = 0;
   virtual int Size() = 0;
   virtual void Push(Line* value) = 0;
   virtual Line* Pop() = 0;
   virtual Line* Get(int index) = 0;
   virtual ILineArray* Slice(int from, int to) = 0;
   virtual ILineArray* Clear() = 0;
   virtual Line* Shift() = 0;
};