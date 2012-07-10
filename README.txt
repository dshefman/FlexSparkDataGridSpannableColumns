Taken from Blog:

http://squaredi.blogspot.com/2012/07/column-spanning-with-flex-spark.html

And here are the key steps:

1) Setup a new Skin with an added GridLayer (in this case called "rendererOverlayLayer") as the last entry
ColumnSpanningSparkDatagridSkin.mxml 
2) Create your custom cell renderer, extending ColumnSpanningGridItemRenderer.as
3) Create your custom spannableItemRendererAccessor, implement ISpannableGridItemRenderer. 
These methods are used by ColumnSpanningGridItemRenderer to determine and relayer the span based on the data that comes in 
4) Attach your spannableItemRendererAccessor to the cellRenderer within preInitialize. (Note, if you attach it during creationComplete, you will need to force an update before it takes effect.) 



How it works:
The ColumnSpanningGridItemRenderer does all of the heavy lifting. It checks to see if the data has spanning enabled. If it does, then it reparents the itemrenderer to the rendererOverlayLayer within the skin and resizes it to fit the cell bounds defined. If it doesn't it reparents the itemrenderer back to the original rendererLayer and resizes back to the original size. 
There is a tricky part within the code, as I discovered, renderers are not added / removed from stage, but instead their visibility is toggled.


*** Tight Coupling Warning ****
Within the ISpannableGridItemRenderer, I expect that you will need implicit knowledge of the data / datatype coming in. Please remember that the data that is fed in is the rowData, and you will likely need to convert to to cellData to figure out individual spans. This could be through separate helper / utility classes. 

My example is a little extreme, as it is unlikely each cell would be comprised of its own value object. But it was easiest for this post. 

Anyways, this is purpose of the "convertRawDataToSpannableData()" method.  
Then once you have your cellData, you will need to determine if it spans via "doesDataSpanColumns()" which is probably related to "getNumofSpannedColumns()" 

That's the easy part. The hard part is determining that the following cells are hidden beneath the span. To make this a little easier, if there is some condition within the cell data that indicates that they are hidden, it isn't too bad (null / empty values/ constants). Otherwise, you might have to do some preprocessing of the data to compare expected column indices to actual column  indices  and base your conditionals on that. 