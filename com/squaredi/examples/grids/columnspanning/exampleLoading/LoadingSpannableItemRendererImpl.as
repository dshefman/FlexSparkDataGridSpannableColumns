package com.squaredi.examples.grids.columnspanning.exampleLoading
{
    import com.squaredi.grids.sparkdatagrid.columnSpanning.renderers.ISpannableGridItemRenderer;

    import mx.core.IUIComponent;

    import mx.core.UIComponent;

    import spark.components.BorderContainer;

    public class LoadingSpannableItemRendererImpl implements ISpannableGridItemRenderer
    {
        public var  spanningElement:UIComponent
        public function LoadingSpannableItemRendererImpl(loadingLabel:UIComponent)
        {
            this.spanningElement = loadingLabel
        }

        public function getElementThatSpans():UIComponent
        {
            return spanningElement;
        }

        public function getSpanningRendererLayerNameInDataGridSkin():String
        {
            return "rendererOverlayLayer";
        }

        public function getNumofSpannedColumns(data:Object):int
        {
            return 7;
        }

        public function doesDataSpanColumns(data:Object):Boolean
        {
           return data != null && (data is LoadingNameVO) && LoadingNameVO(data).isLoading() == true
        }

        public function isCurrentCellHiddenBeneathASpan(data:Object, columnIndex:int):Boolean
        {
            return columnIndex > 3 && columnIndex <=10;
        }
    }
}
