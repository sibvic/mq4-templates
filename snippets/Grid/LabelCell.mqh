#include <Grid/ACell.mqh>

// Label cell v3.0

#ifndef LabelCell_IMP
#define LabelCell_IMP

class LabelCell : public ACell
{
   string _id;
   string _text; 
   ENUM_BASE_CORNER _corner;
public:
   LabelCell(const string id, const string text, ENUM_BASE_CORNER corner) 
   { 
      _corner = corner;
      _id = id; 
      _text = text; 
   }

   virtual void Measure(int& width, int& height)
   {
      Measure(_text, "Arial", font_size, width, height);
   }

   virtual void Draw(int x, int y) 
   { 
      ObjectMakeLabel(_id, x, y, _text, Labels_Color, _corner, WindowNumber, "Arial", font_size); 
   }

   virtual void HandleButtonClicks()
   {
      
   }
};

#endif