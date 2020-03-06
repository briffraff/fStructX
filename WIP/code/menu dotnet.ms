global form
  try(form.close()) catch()
  (
  	 form = dotnetobject "MaxCustomControls.Maxform"
  	form.ShowIcon = form.ShowInTaskbar = form.MaximizeBox = form.MinimizeBox = off
  	form.StartPosition = form.StartPosition.Manual
  	form.Text = "Owner Draw Menu Item"
  	form.Bounds = dotnetobject "System.Drawing.Rectangle" 500 300 200 100
 
  	fn onDrawItem s e = 
  	(
  		g = e.Graphics
  		g.PixelOffsetMode = g.PixelOffsetMode.HighQuality
  		g.SmoothingMode = g.SmoothingMode.HighQuality
 
  		case of
  		(
  			(dotnet.compareEnums e.State e.State.Selected):
  			(
  				back = (dotnetclass "System.Drawing.Brushes").LightSalmon
  				fore = (dotnetclass "System.Drawing.Brushes").Black
  			)
  			default:
  			(
  				back = (dotnetclass "System.Drawing.Brushes").Salmon
  				fore = (dotnetclass "System.Drawing.Brushes").Black
  			)
  		)
  		g.FillRectangle back e.Bounds
  		g.DrawString s.Text (dotnetobject "System.Drawing.Font" e.Font e.Font.Style.Bold) fore 16 10
  	)
  	fn onMeasureItem s e = 
  	(
  		e.ItemHeight = 40
  		e.ItemWidth = 100
  	)
 
  	cm = dotNetObject "ContextMenu"
 
  	item = cm.menuitems.Add "Geometry"
  	item.OwnerDraw = on
  	item.Enabled = off
  	dotnet.addeventhandler item "DrawItem" onDrawItem
  	dotnet.addeventhandler item "MeasureItem" onMeasureItem		
 
  	fn onItemClick s e = (format "click: %\n" s.Text)
 
  	item = cm.menuitems.Add "Sphere"
  	dotnet.addeventhandler item "Click" onItemClick		
  	item = cm.menuitems.Add "Cone"		
  	dotnet.addeventhandler item "Click" onItemClick	
 
  	form.ContextMenu = cm
  	form.Showmodeless() 
  )