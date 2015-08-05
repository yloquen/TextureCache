package com.wiener.caching
{
	import com.wiener.datastruct.LinkedListNode;

	import flash.display.Loader;

	import starling.textures.Texture;


	public class CacheData
	{
		public var linkedListNode:LinkedListNode;
		public var isLoaded:Boolean;
		public var texture:Texture;
		public var url:String;
		public var loader:Loader;
		public var connectionOpen:Boolean;

		private var _callbacks:Vector.<Function>;
		private var _textureUsers:Vector.<Object>;




		public function CacheData()
		{
			_callbacks  = new Vector.<Function>();
			_textureUsers = new Vector.<Object>();
		}


		public function addCallback(callback:Function):void
		{
			_callbacks.push(callback);
		}


		public function addTextureUser(textureUser:Object):void
		{
			_textureUsers.push(textureUser)
		}


		public function removeTextureUser(callback:Function, textureUser:Object):void
		{
			this._callbacks.splice(_callbacks.indexOf(callback), 1);
			this._textureUsers.splice(_textureUsers.indexOf(textureUser), 1);
		}


		public function getCallbacks():Vector.<Function>
		{
			return _callbacks;
		}


		public function clearCallbacks():void
		{
			_callbacks = new Vector.<Function>();
		}


		public function getTextureUsers():Vector.<Object>
		{
			return _textureUsers;
		}


	}


}
