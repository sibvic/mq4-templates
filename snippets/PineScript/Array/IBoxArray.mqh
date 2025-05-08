// Box array interface v1.1
#include <PineScript/Objects/Box.mqh>
#include <PineScript/Array/ITArray.mqh>

class IBoxArray : public ITArray<Box*>
{
public:
   virtual IBoxArray* Slice(int from, int to) = 0;
   virtual IBoxArray* Clear() = 0;
};