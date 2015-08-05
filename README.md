# TextureCache

Texture cache for Starling 

TextureCache.as - load texture from URL on cache miss or provide it immediately if loaded
LRU - least recently used list of resources disposing keeping all recently used textures in cache
Proxy class ImageLoader can be added to stage immediately , and image with the loaded texture is added inside as soon as the texture is loaded. 
