module asr.line_drawer;

import std.math;
import asr.graphics_device;
import asr.vector;
import asr.color;

static class LineDrawer
{
    public static void drawLine(GraphicsDevice graphics, Vector2 from, Vector2 to, Color color)
    {
        drawLineBresenham(graphics, from.toPoint2(), to.toPoint2(), color);
    }

    private static void drawLineBresenham(GraphicsDevice graphics, Point2 from, Point2 to, Color color)
    {
        if (abs(to.y - from.y) < abs(to.x - from.x))
        {
            if (from.x > to.x)
            {
                drawLineBresenhamLow(graphics, to, from, color);
            }
            else
            {
                drawLineBresenhamLow(graphics, from, to, color);
            }
        }
        else
        {
            if (from.y > to.y)
            {
                drawLineBresenhamHigh(graphics, to, from, color);
            }
            else
            {
                drawLineBresenhamHigh(graphics, from, to, color);
            }
        }
    }

    private static void drawLineBresenhamLow(GraphicsDevice graphics, Point2 from, Point2 to, Color color)
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
            graphics.setPixel(x, y, color);
            if (d > 0)
            {
                y += yi;
                d -= 2 * delta.x;
            }
            d += 2 * delta.y;
        }
    }

    private static void drawLineBresenhamHigh(GraphicsDevice graphics, Point2 from, Point2 to, Color color)
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
            graphics.setPixel(x, y, color);
            if (d > 0)
            {
                x += xi;
                d -= 2 * delta.y;
            }
            d += 2 * delta.x;
        }
    }
}