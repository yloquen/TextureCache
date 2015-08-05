package com.wiener.caching
{
	import com.wiener.datastruct.LinkedListNode;
	import com.wiener.datastruct.LinkedList;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ImageDecodingPolicy;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;

	import starling.textures.Texture;

	public class TextureCache
	{
		private var _cacheDic:Dictionary;

		// LRU (least recently used), a linked list used to remove the LRU resource
		private var _lruList:LinkedList;

		private var _maxCachedItems:int;

		private var _cacheHits:Number;
		private var _numRequests:Number;

		private var _loaderContext:LoaderContext;


		public function TextureCache()
		{
			_cacheHits = 0;
			_numRequests = 0;
			_maxCachedItems = 10;

			_loaderContext = new LoaderContext();
			_loaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;

			this._cacheDic = new Dictionary(true);
			this._lruList = new LinkedList();
		}


		public function getTexture(url:String, callback:Function, textureUser:Object):void
		{
			_numRequests++;

			var cacheData:CacheData = getCacheData(url);

			if (cacheData != null)
			{
				_cacheHits++;

				cacheData.addTextureUser(textureUser);

				if (cacheData.isLoaded)
				{
					callback(cacheData.texture);
					_lruList.moveToTail(cacheData.linkedListNode);
				}
				else
				{
					cacheData.addCallback(callback);
				}
			}
			else
			{
				loadUrl(url, callback, textureUser);
			}

			if (_numRequests == 100)
			{
				trace("Cache hit rate: " + _cacheHits/_numRequests);
				_cacheHits = 0;
				_numRequests = 0;
			}
		}


		private function loadUrl(url:String, callback:Function, textureUser:Object):void
		{
			var loader:Loader = new Loader();

			var cacheData:CacheData = new CacheData();
			cacheData.url = url;
			cacheData.addCallback(callback);
			cacheData.linkedListNode = new LinkedListNode();
			cacheData.loader = loader;
			cacheData.addTextureUser(textureUser);

			_cacheDic[url] = cacheData;
			_lruList.addToTail(cacheData.linkedListNode);

			loader.name = url;

			try
			{
				loader.load(new URLRequest(url), _loaderContext);
			}
			catch (e:Error)
			{
				processLoaderError(loader);
			}

			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIoError);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadingComplete);
			loader.contentLoaderInfo.addEventListener(Event.OPEN, onConnectionOpen);

		}

		private function onConnectionOpen(e:Event):void
		{
			var loaderInfo:LoaderInfo = e.currentTarget as LoaderInfo;
			var cacheData:CacheData = getCacheData(loaderInfo.loader.name);
			cacheData.connectionOpen = true;
		}


		private function onIoError(e:IOErrorEvent):void
		{
			var loaderInfo:LoaderInfo=e.target as LoaderInfo;
			var loader:Loader=loaderInfo.loader;

			processLoaderError(loader);
		}


		private function processLoaderError(loader:Loader):void
		{
			var url:String = loader.name;

			var cacheData:CacheData = getCacheData(url);
			var callbacks:Vector.<Function> = cacheData.getCallbacks();
			cacheData.loader = null;

			for each (var callback:Function in callbacks)
			{
				callback(null);
			}

	        clearItem(cacheData);
		}


		private function onLoadingComplete(e:Event):void
		{
			var loader:Loader = e.currentTarget.loader;

			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadingComplete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
			loader.contentLoaderInfo.removeEventListener(Event.OPEN, onConnectionOpen);

			var url:String = loader.contentLoaderInfo.url;

			var cacheData:CacheData = getCacheData(url);
			cacheData.isLoaded = true;
			cacheData.texture = Texture.fromBitmap(Bitmap(loader.content));
			cacheData.loader = null;
			var callbacks:Vector.<Function> = cacheData.getCallbacks();

			for each (var callback:Function in callbacks)
			{
				callback(cacheData.texture);
			}

			cacheData.clearCallbacks();

			if (_lruList.length > _maxCachedItems)
			{
				//clearAll();
			}

		}


		public function addCacheHandle(url:String, textureUser:Object):void
		{
			trace("Add cache handle : " + url);
			getCacheData(url).addTextureUser(textureUser);
		}


		public function releaseCacheHandle(url:String, callbackToClear:Function, textureUser:Object):void
		{
			trace("Release cache handle : " + url);
			getCacheData(url).removeTextureUser(callbackToClear, textureUser);
		}


		private function clearItem(cacheData:CacheData):void
		{
			if (cacheData.loader)
			{
				cacheData.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadingComplete);
				cacheData.loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIoError);
				cacheData.loader.contentLoaderInfo.removeEventListener(Event.OPEN, onConnectionOpen);

				if (cacheData.connectionOpen)
				{
					try
					{
						cacheData.loader.close();
					}
					catch (e:Error)
					{

					}
				}
			}

			finishClear(cacheData);
		}


		private function finishClear(cacheData:CacheData):void
		{
			if (cacheData.getTextureUsers().length > 0)
			{
				return;
			}

			if (cacheData.texture)
			{
				cacheData.texture.dispose();
			}

			delete this._cacheDic[cacheData.url];

			_lruList.remove(cacheData.linkedListNode);
		}


		public function clearAll():void
		{
			for each (var cacheData:CacheData in _cacheDic)
			{
				clearItem(cacheData);
			}
		}


		private function getCacheData(url:String):CacheData
		{
			return this._cacheDic[url] as CacheData;
		}



		public function get maxCachedItems():int
		{
			return _maxCachedItems;
		}


		public function set maxCachedItems(value:int):void
		{
			_maxCachedItems = value;
		}


	}


}