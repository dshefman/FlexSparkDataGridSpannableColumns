/**
 * User: Drew
 * Date: 7/9/12
 */
package com.squaredi.examples.grids.columnspanning
{
    [Bindable]
    public class CellDataVO
    {
       public var colSpan:int = 0;
       public var columnIndex:int =0
       public var label:String;



        public function CellDataVO( colSpan:int, label:String)
        {
            this.colSpan = colSpan;
            this.label = label;
        }


        public function toString():String
        {
            return label
        }
    }
}
