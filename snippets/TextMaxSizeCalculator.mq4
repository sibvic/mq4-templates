// Text max size calculator v1.0

#ifndef TextMaxSizeCalculator_IMP
#define TextMaxSizeCalculator_IMP

class TextMaxSizeCalculator
{
    int _width;
    int _height;
public:
    TextMaxSizeCalculator()
    {
        _width = 0;
        _height = 0;
    }

    void AddText(const string text)
    {
        int width;
        int height;
        TextGetSize(text, width, height);
        if (_width < width)
        {
            _width = width;
        }
        if (_height < height)
        {
            _height = height;
        }
    }

    int GetWidth()
    {
        return _width;
    }
    int GetHeight()
    {
        return _height;
    }
};

#endif