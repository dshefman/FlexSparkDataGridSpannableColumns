package com.squaredi.examples.grids.columnspanning.exampleLoading
{
    [Bindable]
    public class LoadingNameVO
    {
        public var name:String;
        public var pm:String;
        public var team:String;
        public var lastUpdated:Date = new Date();
        public var weeks:Object = {}

        public function isLoading():Boolean
        {
            return weeks.wk1 == null
        }
    }
}
