package
{
	import com.greensock.TweenMax;
	import com.wiener.caching.ImageLoader;
	import com.wiener.caching.TextureCache;

	import starling.display.Sprite;
	import starling.events.Event;

	public class TextureCacheTest extends Sprite
	{
		public var imgIdRange:Number = 10;

		private var _textureCache:TextureCache;


		public function TextureCacheTest()
		{
			_textureCache = new TextureCache();

			TweenMax.to(this, 10, {imgIdRange:200, yoyo:true, repeat:-1});

			addEventListener(Event.ENTER_FRAME, onEnterFrame);

			TweenMax.delayedCall(5, clearEvent);
			TweenMax.delayedCall(10, stop);
		}


		private function clearEvent():void
		{
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}


		private function stop():void
		{
			_textureCache.clearAll();
		}


		private function onEnterFrame(event:Event):void
		{
			var imagesToLoad:int = 2 + Math.random()*4;

			//for (var imgIdx:int=0; imgIdx < imagesToLoad; imgIdx++)
			{
				var i:ImageLoader = new ImageLoader(100, 100, _textureCache);
				addChild(i);
				i.x = Math.random()*400;
				i.y = Math.random()*400;

				if (Math.random() < .05)
				{
					var url:String = "http://www.grajyyvatar.com/avatar/" + Math.round(Math.random()*imgIdRange) + "?d=wavatar&s=500";
				}
				else
				{
					url = "http://www.gravatar.com/avatar/" + Math.round(Math.random()*imgIdRange) + "?d=wavatar&s=500";
				}

				i.load(url);
				var delay:Number = 1+Math.random();
				TweenMax.delayedCall(delay, removeImage, [i]);
			}
		}


		private function removeImage (...args)
		{
			var i:ImageLoader = args[0] as ImageLoader;
			removeChild(i);
		}


	}


}