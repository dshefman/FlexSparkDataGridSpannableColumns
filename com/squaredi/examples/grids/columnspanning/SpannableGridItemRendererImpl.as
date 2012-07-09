package com.squaredi.examples.grids.columnspanning
{
    import com.squaredi.grids.sparkdatagrid.renderers.ISpannableGridItemRenderer;

    import mx.core.UIComponent;

    import spark.components.gridClasses.GridColumn;

    public class SpannableGridItemRendererImpl implements ISpannableGridItemRenderer
	{
		private var _renderer:ExampleSpanningCellRenderer
		private var spanningElementHardReference:UIComponent;
		public function SpannableGridItemRendererImpl(renderer:ExampleSpanningCellRenderer)
		{
			_renderer = renderer;
			spanningElementHardReference = _renderer.rowRenderer;
		}
		
		public function getElementThatSpans():UIComponent
		{
			return spanningElementHardReference;
		}
		
		public function getSpanningRendererLayerNameInDataGridSkin():String
		{
			return "rendererOverlayLayer";
		}
		
		public function getNumofSpannedColumns(data:Object):int
		{
			var convertedData:Object = convertRawDataToSpannableData(data);
			if (convertedData && convertedData is CellDataVO)
			{
				var cell:CellDataVO = CellDataVO(convertedData);
                var colSpans:int = cell.colSpan
				return colSpans;
			}
			return 0;
		}
		
		public function doesDataSpanColumns(data:Object):Boolean
		{
            var numOfSpannedColumns:int =  getNumofSpannedColumns(data)
            var rtn:Boolean = numOfSpannedColumns > 0
			return rtn;
		}
		
		public function isCurrentCellHiddenBeneathASpan(data:Object, columnIndex:int):Boolean
		{
			var convertedData:Object = convertRawDataToSpannableData(data);
            /*
            Assume that if the label is empty, it is hidden
             */
			if (convertedData is CellDataVO)
			{

                var dataFieldValue:String = CellDataVO(convertedData).label
                var hasValidData:Boolean = dataFieldValue != null && dataFieldValue != ""
				return  ! hasValidData
			}
			return false;
		}

		
		private function isGridEditable():Boolean
		{
			if (_renderer.grid)
			{
				return _renderer.grid.dataGrid.editable
			}
			return false;
		}

		public function convertRawDataToSpannableData(data:Object):Object
		{
			if (data is CellDataVO) {return data};
            if (data is RowDataVO)
            {
                var col:GridColumn = GridColumn(_renderer.column);
                var dataField:String = col.dataField;
                var rtn:CellDataVO = CellDataVO(data[dataField]);
                return rtn;
            }
			return null;
		}
	}
}