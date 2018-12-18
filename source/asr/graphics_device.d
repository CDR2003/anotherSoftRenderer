module asr.graphics_device;

import derelict.sdl2.sdl;
import std.stdio;
import std.math;
import asr.color;
import asr.vector;
import asr.math;

public class GraphicsDevice
{
    private SDL_Renderer* _renderer;

    public this(SDL_Renderer* renderer)
    {
        _renderer = renderer;
    }

    public void clear(Color color)
    {
        auto color32 = color.toColor32();
        SDL_SetRenderDrawColor(_renderer, color32.r, color32.g, color32.b, color32.a);
        SDL_RenderClear(_renderer);
    }

    public void drawLine(Vector2 from, Vector2 to, Color color)
    {
        this.drawLineBresenham(from.toPoint2(), to.toPoint2(), color);
    }

    private void drawLineBresenham(Point2 from, Point2 to, Color color)
    {
        if (abs(to.y - from.y) < abs(to.x - from.x))
        {
            if (from.x > to.x)
            {
                this.drawLineBresenhamLow(to, from, color);
            }
            else
            {
                this.drawLineBresenhamLow(from, to, color);
            }
        }
        else
        {
            if (from.y > to.y)
            {
                this.drawLineBresenhamHigh(to, from, color);
            }
            else
            {
                this.drawLineBresenhamHigh(from, to, color);
            }
        }
    }

    private void drawLineBresenhamLow(Point2 from, Point2 to, Color color)
    {
        auto delta = to - from;
        auto yi = 1;
        if (delta.y < 0)
        {
            yi = -1;
            delta.y = -delta.y;
        }

        auto d = 2 * delta.y - delta.x;
        auto y = from.y;
        for (int x = from.x; x <= to.x; x++)
        {
            this.setPixel(x, y, color);
            if (d > 0)
            {
                y += yi;
                d -= 2 * delta.x;
            }
            d += 2 * delta.y;
        }
    }

    private void drawLineBresenhamHigh(Point2 from, Point2 to, Color color)
    {
        auto delta = to - from;
        auto xi = 1;
        if (delta.x < 0)
        {
            xi = -1;
            delta.x = -delta.x;
        }

        auto d = 2 * delta.x - delta.y;
        auto x = from.x;
        for (int y = from.y; y <= to.y; y++)
        {
            this.setPixel(x, y, color);
            if (d > 0)
            {
                x += xi;
                d -= 2 * delta.y;
            }
            d += 2 * delta.x;
        }
    }

    private void setPixel(Point2 position, Color color)
    {
        this.setPixel(position.x, position.y, color);
    }

    private void setPixel(int x, int y, const ref Color color)
    {
        auto color32 = color.toColor32();
        SDL_SetRenderDrawColor(_renderer, color32.r, color32.g, color32.b, color32.a);
        SDL_RenderDrawPoint(_renderer, x, y);
    }
}
