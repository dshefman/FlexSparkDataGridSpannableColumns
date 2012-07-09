package com.squaredi.grids.sparkdatagrid.renderers
{
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;

    import spark.components.DataGrid;
    import spark.components.Grid;

    import spark.components.Group;
	import spark.components.gridClasses.GridItemRenderer;
	
	public class ColumnSpanningGridItemRenderer extends GridItemRenderer
	{
		private var _spannableItemRendererAccessor:ISpannableGridItemRenderer
		protected var isExpanded:Boolean;
		
		public function ColumnSpanningGridItemRenderer()
		{
			super();
			//this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage);
		}

		/*private function removedFromStage(event:Event):void
		{
			resetExpandedCell();
		}*/
		
		public function get spannableItemRendererAccessor():ISpannableGridItemRenderer
		{
			return _spannableItemRendererAccessor;
		}
		
		public function set spannableItemRendererAccessor(value:ISpannableGridItemRenderer):void
		{
			_spannableItemRendererAccessor = value;
		}
		
		
		public override function set visible(value:Boolean):void
		{
			/*
			During freeItemRenderers within the GridLayout, renderers surprisingly aren't 
			removed from the layer, instead their visibility if just toggled off. 
			
			So there are no direct events that can be tracked with this (PropertyChanged seems silly)
			So we need to capture the set visible directly.
			
			We always need to reset. Prepare or updateDisplaylist should figure out how to show it again.
			*/
			resetExpandedCell();
			super.visible = value;
		}
		
		
		
		public override function prepare(hasBeenRecycled:Boolean):void
		{
			super.prepare(hasBeenRecycled);
			updateSizeToSpanColumns();
		}


		public override function discard(willBeRecycled:Boolean):void
		{
			super.discard(willBeRecycled);	
			resetExpandedCell();
		}
		
		
		protected override function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			/*
			There is some weirdness here. updateSizeToSpanColumns() needs to be in updateDisplayList
			as well as the prepare method. Otherwise it doesn't seem to catch 100% of the time
			
			Artifacts might be doubling of span layers, missing cells, or ignoring span all together
			*/
			updateSizeToSpanColumns();
		}
		
		protected function updateSizeToSpanColumns():void
		{
			if (! isSpanningEnabled())
            {
                return;
            }
			
			
			if (spannableItemRendererAccessor.doesDataSpanColumns(data))
			{
				expandCell();
			}
			else
			{
				resetExpandedCell()	
			}
			
			var hidden:Boolean = spannableItemRendererAccessor.isCurrentCellHiddenBeneathASpan(data,columnIndex)
			var shouldBeVisible:Boolean =  ! hidden && this.visible;
			getElementThatSpans().visible = shouldBeVisible;
			
		}
		
		protected function expandCell():void
		{
			if (isSpanningEnabled() && ! isExpanded)
			{
				var additionalColumns:int = spannableItemRendererAccessor.getNumofSpannedColumns(data);
				moveSpanToHigherLayerInGridSkin()
				
				var elementThatSpans:UIComponent = getElementThatSpans();
				var cellWidth:Number = determineExpandedCellWidth(columnIndex, additionalColumns);
				var cellBounds:Rectangle = grid.getCellBounds(rowIndex,columnIndex);
				elementThatSpans.move(cellBounds.left, cellBounds.top);
				elementThatSpans.setActualSize(cellWidth, cellBounds.height);
				
				isExpanded = true;
				
			}
		}
		
		protected function resetExpandedCell():void
		{
			returnSpanToItemRendererLayer();
			if (isSpanningEnabled())
			{
				var elementThatSpans:UIComponent = getElementThatSpans();
                var cellBounds:Rectangle = grid.getCellBounds(rowIndex,columnIndex);
				elementThatSpans.move(0, 0);
                if (cellBounds)
                {
				    elementThatSpans.setActualSize(cellBounds.width, cellBounds.height);
                }
			}
			isExpanded = false;	
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
			var element:UIComponent = getElementThatSpans();
			if (element)
			{
				this.addElement(element);
			}
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
			if (grid)
			{
				return Group(grid.getChildByName(layerName));
			}
			return null;
		}
		
		
		protected function isSpanningEnabled():Boolean
		{
			var isAttached:Boolean = grid != null;
			var hasSpanningInformation:Boolean = spannableItemRendererAccessor != null;
			var hasSpanLayerDefinedInSkin:Boolean = false;
			if (hasSpanningInformation)
			{
				var spanLayerName:String = spannableItemRendererAccessor.getSpanningRendererLayerNameInDataGridSkin();
				var topLayer:Group = getGridLayer(spanLayerName);
				
				hasSpanLayerDefinedInSkin = topLayer != null
				
			}
			
			return isAttached && hasSpanningInformation && hasSpanLayerDefinedInSkin
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