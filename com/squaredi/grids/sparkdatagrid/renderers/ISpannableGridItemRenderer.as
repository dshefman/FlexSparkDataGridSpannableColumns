package com.squaredi.grids.sparkdatagrid.renderers
{
	import mx.core.UIComponent;

	public interface ISpannableGridItemRenderer
	{
		function getElementThatSpans():UIComponent
		function getSpanningRendererLayerNameInDataGridSkin():String
		function getNumofSpannedColumns(data:Object):int
		function doesDataSpanColumns(data:Object):Boolean
		function isCurrentCellHiddenBeneathASpan(data:Object,columnIndex:int):Boolean
	}
}