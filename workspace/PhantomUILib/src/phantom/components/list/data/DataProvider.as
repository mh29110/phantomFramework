package phantom.components.list.data
{
    import flash.events.EventDispatcher;
    
    import phantom.components.list.events.DataChangeEvent;
    import phantom.components.list.events.DataChangeType;
    
    [Event(name="preDataChange", type="fl.events.DataChangeEvent")]
    [Event(name="dataChange", type="fl.events.DataChangeEvent")]
    
    /**
     * DataProvider 类提供一些方法和属性，这些方法和属性允许您查询和修改任何基于列表的组件中的数据。
     * 数据提供程序 是用作数据源的项目的线性集合，例如，一个数组。数据提供程序中的每个项目都是包含一个或多个数据字段的对象或 XML 对象。通过使用 DataProvider.getItemAt() 方法，可以按索引访问数据提供程序中包含的项目。
     *
     * @langversion 3.0
     * @playerversion Flash 9.0.28.0 
     * @playerversion AIR 1.0     * @productversion Flash CS3
     */
    public class DataProvider extends EventDispatcher 
    {
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        private var _data:Array;
        
        /**
         * 通过将列表、XML 实例或数据对象数组作为数据源，创建一个新的 DataProvider 对象。
         * 
         * @param data  (default = null) — 用于创建 DataProvider 的数据。
         * 
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function DataProvider(value:Object=null) 
        {			
            if (value == null) 
            {
                _data = [];
            } 
            else 
            {
                _data = getDataFromObject(value);
            }
        }
        
        /**
         * 数据提供程序包含的项目数。
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function get dataLen():uint 
        {
            return _data.length;
        }
        
        /**
         * 使指定索引处的项目失效。 项目在更改以后会失效；DataProvider 会自动重绘失效的项目。
         *
         * @param index 要使之失效的项目的索引。
         *
         * @throws RangeError 指定的索引小于 0 或大于等于数据提供程序的长度。
         *
         * @see #invalidate()
         * @see #invalidateItem()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function invalidateItemAt(index:int):void 
        {
            checkIndex(index,_data.length-1)
            dispatchChangeEvent(DataChangeType.INVALIDATE,[_data[index]],index,index);
        }
        
        /**
         * 使指定的项目失效。 项目在更改以后会失效；DataProvider 会自动重绘失效的项目。
         *
         * @param item 要使之失效的项目。
         *
         * @see #invalidate()
         * @see #invalidateItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function invalidateItem(item:Object):void 
        {
            var index:int = getItemIndex(item);
            if (index == -1) 
            { 
                return; 
            }
            invalidateItemAt(index);
        }
        
        /**
         * 使 DataProvider 包含的所有数据项失效，并调度 DataChangeEvent.INVALIDATE_ALL 事件。 项目在更改以后会失效；DataProvider 会自动重绘失效的项目。 
         *
         * @see #invalidateItem()
         * @see #invalidateItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function invalidate():void 
        {
            dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, DataChangeType.INVALIDATE_ALL, _data.concat(), 0, _data.length));
        }
        
        
        /**
         * 将新项目添加到数据提供程序的指定索引处。如果指定的索引超过数据提供程序的长度，则忽略该索引。
         *
         * @param item 包含要添加的项目数据的对象。
         * @param index  要在其位置添加项目的索引。
         *
         * @throws RangeError 指定的索引小于 0 或大于等于数据提供程序的长度。
         *
         * @see #addItem()
         * @see #addItems()
         * @see #addItemsAt()
         * @see #getItemAt()
         * @see #removeItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function addItemAt(item:Object,index:uint):void {
            checkIndex(index,_data.length);
            dispatchPreChangeEvent(DataChangeType.ADD,[item],index,index);
            _data.splice(index,0,item);
            dispatchChangeEvent(DataChangeType.ADD,[item],index,index);
        }
        
        /**
         * 将项目追加到数据提供程序的结尾。
         *
         * @param item 要追加到当前数据提供程序的结尾的项目。
         * 
         * @see #addItemAt()
         * @see #addItems()
         * @see #addItemsAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function addItem(item:Object):void 
        {
            dispatchPreChangeEvent(DataChangeType.ADD,[item],_data.length-1,_data.length-1);
            _data.push(item);
            dispatchChangeEvent(DataChangeType.ADD,[item],_data.length-1,_data.length-1);
        }
        
        /**
         * 向数据提供程序的指定索引处添加若干项目，并调度 DataChangeType.ADD 事件。
         *
         * @param items 要添加到数据提供程序的项目。
         * @param index 要在其位置插入项目的索引。
         * 
         * @throws RangeError 指定的索引小于 0 或大于等于数据提供程序的长度。
         *
         * @see #addItem()
         * @see #addItemAt()
         * @see #addItems()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function addItemsAt(items:Object,index:uint):void 
        {
            checkIndex(index,_data.length);
            var arr:Array = getDataFromObject(items);
            dispatchPreChangeEvent(DataChangeType.ADD,arr,index,index+arr.length-1);			
            _data.splice.apply(_data, [index,0].concat(arr));
            dispatchChangeEvent(DataChangeType.ADD,arr,index,index+arr.length-1);
        }
        
        /**
         * 向 DataProvider 的末尾追加多个项目，并调度 DataChangeType.ADD 事件。 按照指定项目的顺序添加项目。
         *
         * @param items 要追加到数据提供程序的项目。
         *
         * @see #addItem()
         * @see #addItemAt()
         * @see #addItemsAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function addItems(items:Object):void 
        {
            addItemsAt(items,_data.length);
        }
        
        /**
         * 将参数列表中的多个项目与当前DataProvider中的项目进行连接并创建新的DataProvide。如果不传递任何参数，则返回的原始对象的副本（浅表克隆）。
         * 
         * @param items 零个或更多的要添加到数据的项目。
         *
         * @see #addItems()
         * @see #merge()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function concat(...items):DataProvider 
        {
            var newConcatData:DataProvider = clone();
            if(items)
            {
                newConcatData.addItems(items);
            }
            return newConcatData;
        }
        
        /**
         * 将指定数据追加到数据提供程序包含的数据，并删除任何重复的项目。此方法调度 DataChangeType.ADD 事件。
         *
         * @param data 要合并到数据提供程序的数据。
         *
         * @see #concat()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function merge(newData:Object):void {
            var arr:Array = getDataFromObject(newData);
            var l:uint = arr.length;
            var startLength:uint = _data.length;
            
            dispatchPreChangeEvent(DataChangeType.ADD,_data.slice(startLength,_data.length),startLength,this._data.length-1);
            
            for (var i:uint=0; i<l; i++) 
            {
                var item:Object = arr[i];
                if (getItemIndex(item) == -1) 
                {
                    _data.push(item);
                }
            }
            if (_data.length > startLength) 
            {
                dispatchChangeEvent(DataChangeType.ADD,_data.slice(startLength,_data.length),startLength,this._data.length-1);
            } 
            else 
            {
                dispatchChangeEvent(DataChangeType.ADD,[],-1,-1);
            }
        }
        
        /**
         * 返回指定索引处的项目。
         *
         * @param index 要返回的项目的位置。
         *
         * @return 指定索引处的项目。
         *
         * @throws RangeError 指定的索引小于 0 或大于等于数据提供程序的长度。
         *
         * @see #getItemIndex()
         * @see #removeItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function getItemAt(index:uint):Object 
        {
            checkIndex(index,_data.length-1);
            return _data[index];
        }
        
        /**
         * 返回指定项目的索引。
         *
         * @param item 要查找的项目。
         *
         * @return 指定项目的索引；如果没有找到指定项目，则为 -1。
         *
         * @see #getItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function getItemIndex(item:Object):int 
        {
            return _data.indexOf(item);
        }
        
        /**
         * 删除指定索引处的项目，并调度 DataChangeType.REMOVE 事件。
         *
         * @param index 要删除的项目的索引。
         *
         * @return 被删除的项目。
         *
         * @throws RangeError 指定的索引小于 0 或大于等于数据提供程序的长度。
         *
         * @see #removeAll()
         * @see #removeItem()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function removeItemAt(index:uint):Object 
        {
            checkIndex(index,_data.length-1);
            dispatchPreChangeEvent(DataChangeType.REMOVE, _data.slice(index,index+1), index, index);
            var arr:Array = _data.splice(index,1);
            dispatchChangeEvent(DataChangeType.REMOVE,arr,index,index);
            return arr[0];
        }
        
        /**
         * 从数据提供程序中删除指定项目，并调度 DataChangeType.REMOVE 事件。
         *
         * @param item 要删除的项目。
         *
         * @return 被删除的项目。
         *
         * @see #removeAll()
         * @see #removeItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function removeItem(item:Object):Object {
            var index:int = getItemIndex(item);
            if (index != -1) 
            {
                return removeItemAt(index);
            }
            return null;
        }
        
        /**
         * 从数据提供程序中删除所有项目，并调度 DataChangeType.REMOVE_ALL 事件。
         *
         * @see #removeItem()
         * @see #removeItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function removeAll():void 
        {
            var arr:Array = _data.concat();
            
            dispatchPreChangeEvent(DataChangeType.REMOVE_ALL,arr,0,arr.length);
            _data = [];
            dispatchChangeEvent(DataChangeType.REMOVE_ALL,arr,0,arr.length);
        }
        
        /**
         * 用新项目替换现有项目，并调度 DataChangeType.REPLACE 事件。
         *
         * @param oldItem 要替换的项目。
         *
         * @param newItem 替换项目。
         *
         * @return 被替换的项目。
         *
         * @throws RangeError 无法在数据提供程序中找到项目。
         *
         * @see #replaceItemAt()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function replaceItem(newItem:Object,oldItem:Object):Object 
        {
            var index:int = getItemIndex(oldItem);
            if (index != -1) 
            {
                return replaceItemAt(newItem,index);
            }
            return null;
        }
        
        /**
         * 替换指定索引处的项目，并调度 DataChangeType.REPLACE 事件。
         *
         * @param newItem 替换项目。
         * @param index 要替换的项目的索引。
         *
         * @return 被替换的项目。
         * 
         * @throws RangeError 指定的索引小于 0 或大于等于数据提供程序的长度。
         *
         * @see #replaceItem()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function replaceItemAt(newItem:Object,index:uint):Object {
            checkIndex(index,_data.length-1);
            var arr:Array = [_data[index]];
            dispatchPreChangeEvent(DataChangeType.REPLACE,arr,index,index);
            _data[index] = newItem;
            dispatchChangeEvent(DataChangeType.REPLACE,arr,index,index);
            return arr[0];
        }
        
        /**
         * 对数据提供程序包含的项目进行排序，并调度 DataChangeType.SORT 事件。
         *
         * @param sortArg 用于排序的参数。
         *
         * @return 返回值取决于方法是否接收任何参数。 有关详细信息，请参阅 Array.sort() 方法。当 sortOption 属性设置为 Array.UNIQUESORT 时，该方法返回 0。
         *
         * @see #sortOn()
         * @see Array#sort() Array.sort()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function sort(...sortArgs:Array):* 
        {
            dispatchPreChangeEvent(DataChangeType.SORT,_data.concat(),0,_data.length-1);
            var returnValue:Array = _data.sort.apply(_data,sortArgs);
            dispatchChangeEvent(DataChangeType.SORT,_data.concat(),0,_data.length-1);
            return returnValue;
        }
        
        /**
         * 按指定字段对数据提供程序包含的项目进行排序，并调度 DataChangeType.SORT 事件。指定字段可以是字符串或字符串值数组，这些字符串值指定要按优先顺序对其进行排序的多个字段。
         *
         * @param fieldName 要按其进行排序的项目字段。该值可以是字符串或字符串值数组。
         *
         * @param options  (default = null) — 用于排序的选项。
         *
         * @return — 返回值取决于方法是否接收任何参数。 有关详细信息，请参阅 Array.sortOn() 方法。如果 sortOption 属性设置为 Array.UNIQUESORT，则该方法返回 0。 
         *
         * @see #sort()
         * @see Array#sortOn() Array.sortOn()
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function sortOn(fieldName:Object,options:Object=null):* 
        {
            dispatchPreChangeEvent(DataChangeType.SORT,_data.concat(),0,_data.length-1);
            var returnValue:Array = _data.sortOn(fieldName,options);
            dispatchChangeEvent(DataChangeType.SORT,_data.concat(),0,_data.length-1);
            return returnValue;
        }
        
        /**
         * 创建当前 DataProvider 对象的副本。
         *
         * @return 该 DataProvider 对象的新实例。
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function clone():DataProvider 
        {
            return new DataProvider(_data);
        }
        
        /**
         * 创建数据提供程序包含的数据的 Array 对象表示形式。
         *
         * @return 数据提供程序包含的数据的 Array 对象表示形式。
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        public function toArray():Array 
        {
            return _data.concat();
        }
        
        /**
         * 创建数据提供程序包含的数据的字符串表示形式。
         *
         * @return 数据提供程序包含的数据的字符串表示形式。
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         * @playerversion AIR 1.0         * @productversion Flash CS3
         */
        override public function toString():String 
        {
            return "DataProvider ["+_data.join(" , ")+"]";
        }
        
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        private function getDataFromObject(obj:Object):Array 
        {
            var retArr:Array;
            if (obj.hasOwnProperty("length")) 
            {
                var len:int = obj["length"];
                retArr = [];
                // convert to object array.
                for (var i:uint = 0; i <len; i++) 
                {
                    retArr.push(obj[i]);
                }
                return retArr;
                
            } 
            else if (obj is DataProvider) 
            {
                return obj.toArray();
            } 
            else if (obj is XML) 
            {
                retArr = [];
                var xml:XML = obj as XML;
                var nodes:XMLList = xml.*;
                var nodeObj:Object;
                for each (var node:XML in nodes) 
                {
                    nodeObj = {};
                    var attrs:XMLList = node.attributes();
                    for each (var attr:XML in attrs) 
                    {
                        nodeObj[attr.localName()] = attr.toString();
                    }
                    var propNodes:XMLList = node.*;
                    for each (var propNode:XML in propNodes) 
                    {
                        if (propNode.hasSimpleContent()) 
                        {
                            nodeObj[propNode.localName()] = propNode.toString();
                        }
                    }
                    retArr.push(nodeObj);
                }
                return retArr;
            }
            else 
            {
                throw new TypeError("Error: Type Coercion failed: cannot convert "+obj+" to Array or DataProvider.");
                return null;
            }
        }
        
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        private function checkIndex(index:int,maximum:int):void 
        {
            if (index > maximum || index < 0) 
            {
                throw new RangeError("DataProvider index ("+index+") is not in acceptable range (0 - "+maximum+")");
            }
        }
        
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        private function dispatchChangeEvent(evtType:String,items:Array,startIndex:int,endIndex:int):void 
        {
            dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,evtType,items,startIndex,endIndex));
        }
        
        /**
         * @private (protected)
         *
         * @langversion 3.0
         * @playerversion Flash 9.0.28.0
         */
        private function dispatchPreChangeEvent(evtType:String, items:Array, startIndex:int, endIndex:int):void 
        {
            dispatchEvent(new DataChangeEvent(DataChangeEvent.PRE_DATA_CHANGE, evtType, items, startIndex, endIndex));
        }
    }
    
}