module asr.graphics_device;

import derelict.sdl2.sdl;
import std.algorithm;
import std.stdio;
import std.math;
import asr.color;
import asr.vector;
import asr.math;
import asr.buffer;
import asr.line_drawer;
import asr.texture;

public class GraphicsDevice
{
    private int _width;

    private int _height;

    private Color32Buffer _backBuffer;

    public this(int width, int height)
    {
        _width = width;
        _height = height;
        _backBuffer = new Color32Buffer(_width, _height);
    }

    @property
    public Color32Buffer backBuffer()
    {
        return _backBuffer;
    }

    public void clear(Color color)
    {
        auto color32 = color.toColor32();
        _backBuffer.clear(color32);
    }

    public void drawLine(Vector2 from, Vector2 to, Color color)
    {
        LineDrawer.drawLine(this, from, to, color);
    }

    public void drawTextureRaw(Texture texture)
    {
        auto xMax = min(texture.width, _backBuffer.width);
        auto yMax = min(texture.height, _backBuffer.height);
        for (int y = 0; y < yMax; y++)
        {
            for (int x = 0; x < xMax; x++)
            {
                auto color = texture.getPixel(x, y);
                _backBuffer.setPixel(x, y, color);
            }
        }
    }

    public void setPixel(Point2 position, Color color)
    {
        this.setPixel(position.x, position.y, color);
    }

    public void setPixel(int x, int y, const ref Color color)
    {
        auto color32 = color.toColor32();
        _backBuffer.setPixel(x, y, color32);
    }
}
