package com.squaredi.grids.sparkdatagrid.columnSpanning.events
{
    import flash.events.Event;

    public class ColumnSpanningEvent extends Event
    {
        public static const CELL_SPANNING_EXPANDED:String = "cellSpanningExpanded"
        public static const CELL_SPANNING_RESET:String = "cellSpanningReset"
        public var rowIndex:int;
        public var columnIndex:int;

        public function ColumnSpanningEvent(type:String,  rowIndex:int,  columnIndx:int):void
        {
            super(type,true,false )
            this.rowIndex = rowIndex;
            this.columnIndex = columnIndx;
        }


        override public function clone():Event
        {
            return new ColumnSpanningEvent(type,rowIndex, columnIndex);
        }
    }
}
