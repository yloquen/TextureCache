package com.wiener.caching
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class ImageLoader extends Sprite
	{
		private var _width:Number;
		private var _height:Number;

		private var _image:Image;
		private var _url:String;

		private var _textureCache:TextureCache;


		public function ImageLoader(width:Number, height:Number, textureCache:TextureCache)
		{
			this._width = width;
			this._height = height;
			this._textureCache = textureCache;

			addEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}


		public function load(url:String):void
		{
			this._url = url;

			try
			{
				_textureCache.getTexture(this._url, onLoadSuccess, this);
			}
			catch (e:Error)
			{
				trace(e.getStackTrace());
			}
		}


		public function get image():Image
		{
			return _image;
		}


		private function onLoadSuccess(texture:Texture):void
		{
			if (texture != null)
			{
				_image = new Image(texture);

				_image.width = _width;
				_image.height = _height;

				addChild(_image);
			}
		}


		private function destroy(event:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);

			_textureCache.releaseCacheHandle(this._url, onLoadSuccess, this);
		}



	}


}
