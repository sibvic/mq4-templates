#include <Grid/ACell.mqh>

// Empty cell v2.1

#ifndef EmptyCell_IMP
#define EmptyCell_IMP

class EmptyCell : public ACell
{
public:
   virtual void Draw(int x, int y) { }
   virtual void Measure(int& width, int& height)
   {
      width = 0;
      height = 0;
   }
   virtual void HandleButtonClicks() {}
};

#endif