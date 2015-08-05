package
{
	import com.greensock.TweenMax;
	import com.wiener.caching.ImageLoader;
	import com.wiener.caching.TextureCache;

	import starling.display.Quad;

	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class TextureCacheTest extends Sprite
	{
		public var imgIdRange:Number = 40;

		private var _textureCache:TextureCache;


		public function TextureCacheTest()
		{
			if (stage)
			{
				start(null);
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, start);
			}

			_textureCache = new TextureCache();


		}

		private function start(event:Event):void
		{
			//test1();
			test2();
		}


		private function test2():void
		{
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
		}


		private function onTouch(event:TouchEvent):void
		{
			var t:Touch = event.getTouch(stage);
			if (t && t.phase == TouchPhase.ENDED)
			{
				removeChildren(0,-1,true);

				for (var i:int=0; i<5; i++)
				{
					for (var j:int=0; j<5; j++)
					{
						var img:ImageLoader = new ImageLoader(90, 90, _textureCache);
						addChild(img);
						img.x = i*100;
						img.y = j*100;
						img.load("http://www.gravatar.com/avatar/" + Math.round(Math.random()*imgIdRange) + "?d=wavatar&s=90");
					}
				}
			}
		}





		private function test1():void
		{
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