// Empty cell v1.1

#include <ICell.mq4>

#ifndef EmptyCell_IMP
#define EmptyCell_IMP

class EmptyCell : public ICell
{
public:
   virtual void Draw() { }
   virtual void HandleButtonClicks() {}
};

#endif