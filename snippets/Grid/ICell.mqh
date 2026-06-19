// Interface for a cell v2.0

#ifndef ICell_IMP
#define ICell_IMP

class ICell
{
public:
   virtual void Draw(int x, int y) = 0;
   virtual void HandleButtonClicks() = 0;
   virtual void Measure(int& width, int& height) = 0;
   virtual bool IsMergeSkipped() { return false; }
   virtual int GetMergeTillColumn() { return -1; }
   virtual int GetMergeTillRow() { return -1; }
   virtual void SetMergeSkip(bool /*skip*/) { }
   virtual void SetMergeSpan(int /*tillColumn*/, int /*tillRow*/) { }
   virtual void ClearMergeSpan() { }
   virtual void SetDrawWidth(int /*width*/) { }
   virtual void SetDrawHeight(int /*height*/) { }
   virtual int GetDrawWidth() { return 0; }
   virtual int GetDrawHeight() { return 0; }
};

#endif