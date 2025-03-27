// Label array interface v1.0
#include <Objects/Label.mqh>
#include <PineScript/Array/ITArray.mqh>

class ILabelArray : public ITArray<Label*>
{
public:
   virtual ILabelArray* Slice(int from, int to) = 0;
   virtual ILabelArray* Clear() = 0;
};