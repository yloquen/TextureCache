package com.wiener.datastruct
{
	public class LinkedList
	{
		private var _head:LinkedListNode;
		private var _tail:LinkedListNode;
		private var _length:int;


		public function LinkedList()
		{
			this._head = null;
			this._tail = null;
			this._length = 0;
		}


		public function get length():int
		{
			return this._length;
		}


		public function addToTail(node:LinkedListNode):void
		{
			if (_head == null)
			{
				_head = _tail = node;
			}
			else
			{
				_tail.next = node;
				node.prev = _tail;
				_tail = node;
			}

			node.owner = this;
			this._length++;
		}


		public function remove(node:LinkedListNode):void
		{
			if (node.owner == this)
			{
				if (node.next)
				{
					if (node.prev)
					{
						node.next.prev = node.prev;
						node.prev.next = node.next;
					}
					else
					{
						node.next.prev = null;
						_head = node.next;
					}
				}
				else
				{
					if (node.prev)
					{
						node.prev.next = null;
						_tail = node.prev;
					}
					else
					{
						_head = _tail = null;
					}
				}

				node.owner = null;
				node.prev = null;
				node.next = null;

				_length--;
			}
		}


		public function removeFirst():LinkedListNode
		{
			var returnNode:LinkedListNode;

			if (this._head)
			{
				returnNode = this._head;
				remove(this._head);
			}

			return returnNode;
		}


		public function get head():LinkedListNode
		{
			return _head;
		}


		public function set head(value:LinkedListNode):void
		{
			_head = value;
		}


		public function get tail():LinkedListNode
		{
			return _tail;
		}


		public function set tail(value:LinkedListNode):void
		{
			_tail = value;
		}


		public function moveToTail(linkedListNode:LinkedListNode):void
		{
			remove(linkedListNode);
			addToTail(linkedListNode);
		}


	}


}
