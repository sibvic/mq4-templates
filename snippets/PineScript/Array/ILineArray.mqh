// Line array interface v1.2
#include <PineScript/Objects/Line.mqh>
#include <PineScript/Array/ITArray.mqh>

class ILineArray : public ITArray<Line*>
{
public:
   virtual ILineArray* Slice(int from, int to) = 0;
   virtual ILineArray* Clear() = 0;
};