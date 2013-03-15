/**
 * User: Drew
 * Date: 7/9/12
 */
package com.squaredi.examples.grids.columnspanning.example1
{
    [Bindable]
    public class RowDataVO
    {
        public var name:CellDataVO;
        public var address:CellDataVO;
        public var city:CellDataVO
        public var st:CellDataVO;
        public var zip:CellDataVO;

        public function spanName(span:int):void
        {
            name.colSpan = span;
        }

        public function spanCity(span:int):void
        {
            city.colSpan = span;
        }
    }
}
