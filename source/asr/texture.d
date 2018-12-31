module asr.texture;

import std.string;
import std.stdio;
import asr.color;
import asr.buffer;
import derelict.sdl2.sdl;
import derelict.sdl2.image;

class Texture
{
    private Color32Buffer _content;

    public this(int width, int height)
    {
        _content = new Color32Buffer(width, height);
    }

    @property
    public int width() const
    {
        return _content.width;
    }

    @property
    public int height() const
    {
        return _content.height;
    }

    public Color32 getPixel(int x, int y) const
    in
    {
        assert(x >= 0 && x < this.width);
        assert(y >= 0 && y < this.height);
    }
    do
    {
        return _content.getPixel(x, y);
    }

    public static Texture loadFromFile(string path)
    {
        auto surface = IMG_Load(toStringz(path));
        if (surface == null)
        {
            writefln("Unable to load image from file: %s. SDL_image Error: %s", path, fromStringz(IMG_GetError()));
            return null;
        }
        scope(exit) SDL_FreeSurface(surface);

        auto image = SDL_ConvertSurfaceFormat(surface, SDL_PIXELFORMAT_RGBA8888, 0);
        if (image == null)
        {
            writefln("Unable to convert image from file: %s. SDL_image Error: %s", path, fromStringz(IMG_GetError()));
            return null;
        }
        scope(exit) SDL_FreeSurface(image);

        auto texture = new Texture(image.w, image.h);
        auto buffer = texture._content;

        SDL_LockSurface(image);
        auto pixels = cast(uint*)image.pixels;
        for (int y = 0; y < buffer.height; y++)
        {
            for (int x = 0; x < buffer.width; x++)
            {
                auto pixel = pixels[y * surface.w + x];
                buffer.setPixel(x, y, Color32(pixel));
            }
        }
        SDL_UnlockSurface(image);

        return texture;
    }
}