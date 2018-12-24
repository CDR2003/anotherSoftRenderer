module asr.buffer;

import asr.color;

public class BufferT(T)
{
    private T[][] _pixels;

    private int _width;

    private int _height;

    public this(int width, int height)
    {
        _width = width;
        _height = height;
        _pixels = new T[][](_height, _width);
    }

    @property
    public int width()
    {
        return _width;
    }

    @property
    public int height()
    {
        return _height;
    }

    public void clear(T value)
    {
        for (int y = 0; y < _height; y++)
        {
            _pixels[y][] = value;
        }
    }

    public T getPixel(int x, int y)
    in
    {
        assert(x >= 0 && x < _width);
        assert(y >= 0 && y < _height);
    }
    do
    {
        return _pixels[y][x];
    }

    public void setPixel(int x, int y, T value)
    in
    {
        assert(x >= 0 && x < _width);
        assert(y >= 0 && y < _height);
    }
    do
    {
        _pixels[y][x] = value;
    }
}


alias ColorBuffer = BufferT!Color;
alias Color32Buffer = BufferT!Color32;
alias UByteBuffer = BufferT!ubyte;
