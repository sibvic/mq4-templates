#ifndef LabelArray_IMPL
#define LabelArray_IMPL
// Label array v1.0
#include <PineScript/Array/CustomTypeArray.mqh>
#include <Objects/LabelsCollection.mqh>

class LabelArray : public CustomTypeArray<Label*>
{
public:
   LabelArray(int size, Label* defaultValue) : CustomTypeArray(size, defaultValue)
   {
   }

protected:
   virtual void DeleteItem(Label* item)
   {
      LabelsCollection::Delete(item);
   }
};
#endif