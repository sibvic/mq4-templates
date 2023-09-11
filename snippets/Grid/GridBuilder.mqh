#include <Grid/ICellFactory.mqh>
#include <Grid/Grid.mqh>

// Grid builder v5.1

#ifndef GridBuilder_IMP
#define GridBuilder_IMP

class GridBuilder
{
   string _symbols[];
   int _symbolsCount;
   Grid *grid;
   int _originalX;
   int _originalY;
   bool _verticalMode;
   ICellFactory* _cellFactory[];
   ENUM_BASE_CORNER _corner;
   bool _showHistorical;
public:
   GridBuilder(int x, int y, bool verticalMode, ENUM_BASE_CORNER __corner, bool showHistorical)
   {
      _showHistorical = showHistorical;
      _corner = __corner;
      _verticalMode = verticalMode;
      _originalY = y;
      _originalX = x;
      grid = new Grid();
   }

   ~GridBuilder()
   {
      for (int i = 0; i < ArraySize(_cellFactory); ++i)
      {
         delete _cellFactory[i];
      }
      ArrayResize(_cellFactory, 0);
   }

   void AddCell(ICellFactory* cellFactory)
   {
      int size = ArraySize(_cellFactory);
      ArrayResize(_cellFactory, size + 1);
      _cellFactory[size] = cellFactory;
   }

   void SetSymbols(const string symbols)
   {
      StringSplit(symbols, ',', _symbols);
      _symbolsCount = ArraySize(_symbols);

      int cellFactorySize = ArraySize(_cellFactory);
      if (_verticalMode)
      {
         Row* row = grid.AddRow();
         row.Add(new EmptyCell());
         if (cellFactorySize > 1)
         {
            row = grid.AddRow();
            row.Add(new EmptyCell());
         }
         for (int i = 0; i < _symbolsCount; i++)
         {
            row = grid.AddRow();
            string id = IndicatorObjPrefix + _symbols[i] + "_Name";
            row.Add(new LabelCell(id, _symbols[i], _corner));
         }
      }
      else
      {
         //TODO: add support of multiple values
         Row* row = grid.AddRow();
         row.Add(new EmptyCell());
         for (int i = 0; i < _symbolsCount; i++)
         {
            string id = IndicatorObjPrefix + _symbols[i] + "_Name";
            row.Add(new LabelCell(id, _symbols[i], _corner));
         }
      }
   }

   void AddTimeframe(const string label, const ENUM_TIMEFRAMES timeframe)
   {
      int cellFactorySize = ArraySize(_cellFactory);
      if (_verticalMode)
      {
         int startIndex = 1;
         Row* header = grid.GetRow(0);
         header.Add(new LabelCell(IndicatorObjPrefix + label + "_h", label, _corner));
         if (cellFactorySize > 1)
         {
            ++startIndex;
            Row* subHeader = grid.GetRow(1);
            for (int i = 0; i < cellFactorySize; ++i)
            {
               if (i > 0)
               {
                  header.Add(new EmptyCell());
               }
               subHeader.Add(new LabelCell(IndicatorObjPrefix + label + "_sh" + IntegerToString(i), _cellFactory[i].GetHeader(), _corner));
            }
         }
         
         for (int i = 0; i < _symbolsCount; i++)
         {
            Row* row = grid.GetRow(startIndex + i);
            for (int ii = 0; ii < cellFactorySize; ++ii)
            {
               string id = IndicatorObjPrefix + _symbols[i] + "_" + label + IntegerToString(ii);
               row.Add(_cellFactory[ii].Create(id, 0, 0, _corner, _symbols[i], timeframe, _showHistorical));
            }
         }
      }
      else
      {
         //TODO: add support of multiple values
         Row* row = grid.AddRow();
         #ifndef EXCLUDE_PERIOD_HEADER
            row.Add(new LabelCell(IndicatorObjPrefix + label + "_Label", label, _corner));
         #endif
         for (int i = 0; i < _symbolsCount; i++)
         {
            string id = IndicatorObjPrefix + _symbols[i] + "_" + label;
            for (int ii = 0; ii < cellFactorySize; ++ii)
            {
               row.Add(_cellFactory[ii].Create(id, 0, 0, _corner, _symbols[i], timeframe, _showHistorical));
            }
         }
      }
   }

   Grid* Build()
   {
      return grid;
   }
};
#endif