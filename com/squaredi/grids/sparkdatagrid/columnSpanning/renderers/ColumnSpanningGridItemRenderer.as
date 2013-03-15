package com.squaredi.grids.sparkdatagrid.columnSpanning.renderers
{
    import com.squaredi.grids.sparkdatagrid.columnSpanning.events.ColumnSpanningEvent;

    import flash.display.DisplayObjectContainer;
    import flash.geom.Rectangle;

    import mx.core.UIComponent;

    import spark.components.Group;
    import spark.components.gridClasses.GridItemRenderer;

    //http://squaredi.blogspot.com/2012/07/column-spanning-with-flex-spark.html
    public class ColumnSpanningGridItemRenderer extends GridItemRenderer
    {
        private var _spannableItemRendererAccessor:ISpannableGridItemRenderer
        [Bindable] protected var isExpanded:Boolean;

        public function ColumnSpanningGridItemRenderer()
        {
            super();
        }

        public function get spannableItemRendererAccessor():ISpannableGridItemRenderer
        {
            return _spannableItemRendererAccessor;
        }

        public function set spannableItemRendererAccessor(value:ISpannableGridItemRenderer):void
        {
            _spannableItemRendererAccessor = value;
        }


        override public function set data(value:Object):void
        {
            resetExpandedCell();
            super.data = value;

        }

        public override function set visible(value:Boolean):void
        {
            /*
             During freeItemRenderers within the GridLayout, renderers surprisingly aren't
             removed from the layer, instead their visibility if just toggled off.

             So there are no direct events that can be tracked with this (PropertyChanged seems silly)
             So we need to capture the set visible directly.
             */
            if (! value)
            {
                resetExpandedCell();
            }
            super.visible = value;


        }

        public override function discard(willBeRecycled:Boolean):void
        {
            super.discard(willBeRecycled);
            resetExpandedCell();
        }

        protected function getSpanData():Object
        {
            return data;
        }

        protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth,unscaledHeight);
            updateSizeToSpanColumns();
        }

        protected function updateSizeToSpanColumns():void
        {
            if (! isSpanningEnabled()) {return;}
            if (spannableItemRendererAccessor.doesDataSpanColumns(getSpanData()))
            {
                expandCell();
            }
            else
            {
                resetExpandedCell()
            }

			var hidden:Boolean = spannableItemRendererAccessor.isCurrentCellHiddenBeneathASpan(data,columnIndex)
			var shouldBeVisible:Boolean =  ! hidden && getElementThatSpans().visible;
			getElementThatSpans().visible = shouldBeVisible;

        }

        protected function expandCell():void
        {
            if (isSpanningEnabled())
            {
                var cellBounds:Rectangle = grid.getCellBounds(rowIndex,columnIndex);
                var additionalColumns:int = spannableItemRendererAccessor.getNumofSpannedColumns(getSpanData());
                var cellWidth:Number = determineExpandedCellWidth(columnIndex, additionalColumns);
                var elementThatSpans:UIComponent = getElementThatSpans();
                if (cellBounds)
                {
                    elementThatSpans.move(cellBounds.left, cellBounds.top);
                    elementThatSpans.setActualSize(cellWidth, cellBounds.height);
                }
                elementThatSpans.visible = this.visible
                moveSpanToHigherLayerInGridSkin()
                isExpanded = true;
                dispatchEvent(new ColumnSpanningEvent(ColumnSpanningEvent.CELL_SPANNING_EXPANDED, rowIndex, columnIndex))
            }
        }

        protected function resetExpandedCell():void
        {
            if (isExpanded)
            {
                if (isSpanningEnabled()) //only do stuff if we are attached
                {
                    var cellBounds:Rectangle = grid.getCellBounds(rowIndex,columnIndex);
                    var elementThatSpans:UIComponent = getElementThatSpans();
                    if (cellBounds) {elementThatSpans.setActualSize(cellBounds.width, cellBounds.height)}
                    else { elementThatSpans.setActualSize(0,0)}
                    elementThatSpans.move(0,0);
                    elementThatSpans.visible = false;
                }
                returnSpanToItemRendererLayer();
                isExpanded = false;
                dispatchEvent(new ColumnSpanningEvent(ColumnSpanningEvent.CELL_SPANNING_RESET, rowIndex, columnIndex))
            }


        }

        protected function getElementThatSpans():UIComponent
        {
            if (spannableItemRendererAccessor)
            {
                return spannableItemRendererAccessor.getElementThatSpans()
            }
            return null
        }

        protected function returnSpanToItemRendererLayer():void
        {
            this.addElement(getElementThatSpans());
        }

        protected function moveSpanToHigherLayerInGridSkin():void
        {
            var spanLayerName:String = spannableItemRendererAccessor.getSpanningRendererLayerNameInDataGridSkin();
            var topLayer:Group = getGridLayer(spanLayerName);
            if (topLayer)
            {
                topLayer.addElement(getElementThatSpans());

            }
        }

        protected function getGridLayer(layerName:String):Group
        {
            return Group(grid.getChildByName(layerName));
        }


        protected function isSpanningEnabled():Boolean
        {
            var isAttached:Boolean = grid != null;
            var hasSpanningInformation:Boolean = spannableItemRendererAccessor != null;
            return isAttached && hasSpanningInformation
        }

        protected function determineExpandedCellWidth(startColumnIndex:int, additionalColumns:int):Number
        {
            //Have to go +1 to get the starting pos of the column after the goal
            var finalColumnIdx:int = startColumnIndex + additionalColumns+1;
            var totalColumns:int = grid.columns.length;

            var targetXPosSpanEdge:Number
            var startX:Number = grid.getCellX(rowIndex,startColumnIndex);
            if (finalColumnIdx < totalColumns)
            {
                targetXPosSpanEdge = grid.getCellX(rowIndex,finalColumnIdx);
            }
            else
            {
                //We are outside the edge of the grid. Expand to the end
                targetXPosSpanEdge = grid.getLayoutBoundsWidth();
            }

            var targetWidth:Number = targetXPosSpanEdge - startX;

            return targetWidth;
        }
    }
}