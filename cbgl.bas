' CBGL - OpenGL graphics library for CoolBasic
' by Tapio Vierros 2008

#Include Once "fbpng/fbpng.bi"
#Include Once "fbpng/png_image.bi" 
#Include Once "fbgfx.bi" 
#Include Once "GL/glfw.bi"
#Include Once "GL/glext.bi" 
#Include Once "crt.bi"
#Include Once "windows.bi"
#Include Once "cbgl.bi"
'#Include Once "def.bi"

#Macro getParam(datatype)
	Function getParam##datatype(p As Byte Ptr, ByVal id As Integer) As datatype
		Dim ret As datatype
		memcpy(@ret,@p[(id-1)*4],4)
		Return ret
	End Function
#EndMacro

getParam(Integer)
getParam(UInteger)
getParam(Single)


'Open "test.txt" For Output As #1
'Print #1, w,h,depth,flags
'Close #1


Const TEX_MASKED = &h1
Const TEX_MIPMAP = &h2
Const TEX_NOFILTER = &h4
Const TEX_HASALPHA = &h8

'------------------------------------------------------------------------
'' Create texture creates textures from BLOAD buffer
Private Function CreateTexture( ByVal buffer As Any Ptr, ByVal flags As Integer = 0 ) As UInteger
	Dim p As UInteger Ptr
	Dim As Integer w, h, x, y
	Dim As UInteger col
	Dim tex As UInteger
	Dim As GLenum Format, minfilter, magfilter
	Dim As FB.PUT_HEADER Ptr header = buffer
	Function = 0
 
    If header->Type = FB.PUT_HEADER_NEW Then
		w = header->Width
		h = header->height
    Else
		w = header->old.width
		h = header->old.height
    End If

	ReDim dat(0 To (w * h) - 1) As UInteger
	p = @dat(0)
	glGenTextures 1, @tex
	glBindTexture GL_TEXTURE_2D, tex
'Open "log.txt" For Output As #1
	For y = h-1 To 0 Step -1
		For x = 0 To w-1
			col = Point(x, y, buffer)
			'' Swap R and B so we can use the GL_RGBA texture format
			col = RGB(col And &hFF, _
				(col Shr 8) And &hFF, _
				(col Shr 16) And &hFF)
			'If( (flags And TEX_MASKED) And (col = &hFF00FF) ) Then
			'Print #1,col
			If ( (flags And TEX_MASKED) And ((col And &h00FFFFFF) = 0) ) Then
				*p = 0
			Else
				*p = col Or &hFF000000
			End If
			p += 1
		Next x
	Next y
'Close #1
	If (flags And (TEX_MASKED Or TEX_HASALPHA)) Then Format = GL_RGBA Else Format = GL_RGB
	If (flags And TEX_NOFILTER) Then magfilter = GL_NEAREST Else magfilter = GL_LINEAR
	If( flags And TEX_MIPMAP) Then
		gluBuild2DMipmaps GL_TEXTURE_2D, Format, w, h, GL_RGBA, GL_UNSIGNED_BYTE, @dat(0)
		If (flags And TEX_NOFILTER) Then minfilter = GL_LINEAR_MIPMAP_NEAREST Else minfilter = GL_LINEAR_MIPMAP_LINEAR
	Else
		glTexImage2D GL_TEXTURE_2D, 0, Format, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, @dat(0)
		minfilter = magfilter
	End If
	glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, minfilter
	glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, magfilter
	Function = tex
End Function



'':::::
Sub UtilThread(param As Any Ptr)
	Do
		If InKey = Chr(255)+ "k" Then End
		Sleep 200,1
	Loop
End Sub


'':::::
Sub cbglInit Cdecl (params As UByte Ptr) Export
    scrW = getParamInteger(params, 1)
    scrH = getParamInteger(params, 2)
    Var flags = getParamInteger(params, 3)

	Dim As HWND WindowHandle
	WindowHandle = FindWindow(0, "CB Window")
	ShowWindow(WindowHandle, SW_HIDE)

	ScreenRes scrw, scrh, 32, , fb.GFX_OPENGL Or (flags And 1) 
	If (ScreenPtr = 0) Then ScreenRes scrw, scrh, 16, , fb.GFX_OPENGL Or flags Or fb.GFX_ALPHA_PRIMITIVES 

 	glViewport 0, 0, scrw, scrh 
	glMatrixMode GL_PROJECTION 
	glLoadIdentity 
	gluOrtho2D 0,scrw,scrh,0 
	glMatrixMode GL_MODELVIEW 
	glLoadIdentity 

	glShadeModel GL_SMOOTH 
	'glDisable GL_DEPTH_TEST
	glDisable GL_LIGHTING
	'glDepthMask GL_FALSE
	'glEnable GL_TEXTURE_RECTANGLE_ARB 
	glClearColor 0.0, 0.0, 0.0, 1.0 
	glClear GL_COLOR_BUFFER_BIT 
	glColor4f 1.0, 1.0, 1.0, 1.0
	
	'If glfwExtensionSupported("GL_ARB_texture_rectangle") = 0 Then beep
	'glEnable GL_LINE_SMOOTH
	glBlendFunc GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA
	glEnable GL_BLEND
	
	cbglBuildFont
	
	Dim As Integer mx,my,mb
	GetMouse(mx,my,,mb)
	Sleep 200
	WindowTitle "CBGL App"
	ThreadCreate(@UtilThread)
	'hDC = GetDC( hWnd )
End Sub

Sub cbglInit3d Cdecl (params As UByte Ptr) Export
	scrW = getParamInteger(params, 1)
    scrH = getParamInteger(params, 2)
    Var flags = getParamInteger(params, 3)

	Dim As HWND WindowHandle
	WindowHandle = FindWindow(0, "CB Window")
	ShowWindow(WindowHandle, SW_HIDE)

	ScreenRes scrw, scrh, 32, , fb.GFX_OPENGL Or (flags And 1) 
	If (ScreenPtr = 0) Then ScreenRes scrw, scrh, 16, , fb.GFX_OPENGL Or flags

	'' ReSizeGLScene
	glViewport 0, 0, scrW, scrH                    '' Reset The Current Viewport
	glMatrixMode GL_PROJECTION                     '' Select The Projection Matrix
	glLoadIdentity                                 '' Reset The Projection Matrix
	gluPerspective 45.0, CSng(scrW)/CSng(scrH), 0.1, 100.0   '' Calculate The Aspect Ratio Of The Window
	glMatrixMode GL_MODELVIEW                      '' Select The Modelview Matrix
	glLoadIdentity                                 '' Reset The Modelview Matrix
	
	'' All Setup For OpenGL Goes Here
	glShadeModel GL_SMOOTH                         '' Enable Smooth Shading
	glClearColor 0.0, 0.0, 0.0, 0.5                '' Black Background
	glClearDepth 1.0                               '' Depth Buffer Setup
	glEnable GL_DEPTH_TEST                         '' Enables Depth Testing
	glDepthFunc GL_LEQUAL                          '' The Type Of Depth Testing To Do
	glHint GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST    '' Really Nice Perspective Calculations
	
	cbglBuildFont
	
	Dim As Integer mx,my,mb
	GetMouse(mx,my,,mb)
	Sleep 200
	WindowTitle "CBGL App"
	ThreadCreate(@UtilThread)
End Sub


Sub cbglTerminate Cdecl (params As UByte Ptr) Export
	Dim As HWND WindowHandle
	WindowHandle = FindWindow(0, "CB Window")
	ShowWindow(WindowHandle, SW_SHOW)
	Screen 0
End Sub

'':::::
Sub cbglSetWindow Cdecl (params As UByte Ptr) Export
	Var stlen = getParamInteger(params,1)
	Dim wtitle As String = ""
	For i As Integer = 0 To stlen-1
		wtitle += Chr(params[4+i])
	Next i
	WindowTitle(wtitle)
End Sub


''::::: 
Sub cbglFlip Cdecl () Export
	Flip
End Sub 


''::::: 
Sub cbglCls Cdecl () Export
	glClear GL_COLOR_BUFFER_BIT
End Sub


''::::: 
Sub cbglColor Cdecl (params As UByte Ptr) Export
	Var r = getParamInteger(params,1)
	Var g = getParamInteger(params,2)
	Var b = getParamInteger(params,3)
	Var a = getParamInteger(params,4)
	glColor4ub r,g,b,a
End Sub


''::::: GRAPHICS PRIMITIVES :::::''



''::::: 
Sub cbglDot Cdecl (params As UByte Ptr) Export
	Var x = getParamInteger(params, 1)
	Var y = getParamInteger(params, 2) 
	glLoadIdentity
	glBegin GL_POINTS 
		glVertex2f x, y 
	glEnd	
End Sub 

''::::: 
Sub cbglLine Cdecl (params As UByte Ptr) Export
	Var x1 = getParamInteger(params, 1)
	Var y1 = getParamInteger(params, 2)
	Var x2 = getParamInteger(params, 3)
	Var y2 = getParamInteger(params, 4) 
    
	glLoadIdentity
	glBegin GL_LINES 
		glVertex2f x1, y1 
		glVertex2f x2, y2 
	glEnd   
	glBegin GL_POINTS 
		glVertex2f x2, y2 
	glEnd 
End Sub 


''::::: 
Sub cbglBox Cdecl (params As UByte Ptr) Export
	Var x1 = getParamInteger(params, 1)
	Var y1 = getParamInteger(params, 2)
	Var x2 = getParamInteger(params, 3)
	Var y2 = getParamInteger(params, 4)
	Var boxfull = getParamInteger(params, 5) 
    
	glLoadIdentity
	If boxfull <> 0 Then
		glBegin GL_QUADS 
			glVertex2f x1, y1 
			glVertex2f x1, y2 
			glVertex2f x2, y2 
			glVertex2f x2, y1 
		glEnd 
	Else
		glBegin GL_LINE_STRIP 
			glVertex2f x1, y1 
			glVertex2f x1, y2 
			glVertex2f x2, y2 
			glVertex2f x2, y1 
			glVertex2f x1, y1 
		glEnd 
	EndIf
End Sub 

'::::: 
Sub cbglCircle Cdecl (params As UByte Ptr) Export
	Var x = getParamInteger(params, 1)
	Var y = getParamInteger(params, 2)
	Var r = getParamInteger(params, 3)
	Var filled = getParamInteger(params, 4) 
	glLoadIdentity
	glTranslatef x, y, 0
	Var quad = gluNewQuadric()
	If filled <> 0 Then filled = r-1
    gluDisk quad, filled, r, 60, 1
    gluDeleteQuadric quad
End Sub 


''::::: 
Sub cbglEllipse Cdecl (params As UByte Ptr) Export
   	Var x = getParamInteger(params, 1)
	Var y = getParamInteger(params, 2)
	Var a = getParamInteger(params, 3)
	Var b = getParamInteger(params, 4)
	Var filled = getParamInteger(params, 5) 
	
	If filled <> 0 Then glBegin GL_TRIANGLE_FAN: glVertex2f x, y Else glBegin GL_LINE_STRIP 
    
    glLoadIdentity
	Var points = Sqr(a) * Sqr(b) / PI 
	Var increment = (2.0 * PI) / CSng(points) 
	Var angle = 0
	For i As Integer = 0 To points 
		glVertex2f x + (Cos(angle) * a), y + (Sin(angle) * b) 
		angle += increment 
	Next   
	glEnd 
End Sub 




''::::: IMAGES :::::''


'':::::
Sub cbglLoadImage Cdecl (params As UByte Ptr) Export
	If textureCount >= textureArraySize Then textureArraySize += 10: ReDim Preserve textures(1 To textureArraySize)
	textureCount += 1
	Var flags = getParamInteger(params,1)
	Var stlen = getParamInteger(params,2)
	Dim filename As String = ""
	For i As Integer = 0 To stlen-1
		filename += Chr(params[8+i])
	Next i
	'Dim img As Any Ptr = ImageCreate(w,h)
	'If BLoad(filename, img) <> 0 Then Beep 
	'textures(textureCount) = CreateTexture(img,TEX_MASKED)
	
	Dim As Any Ptr img
	img = png_load(filename, PNG_TARGET_FBNEW)
	If img = NULL Then Beep: End
	
	'glGenTextures 1, @textures(textureCount).id
	'glBindTexture GL_TEXTURE_2D, textures(textureCount).id
	Dim As Integer w,h
	png_dimensions(filename,w,h)
	textures(textureCount).w = w
	textures(textureCount).h = h
	'glTexImage2D GL_TEXTURE_2D, 0, GL_RGB, w, h, 0, GL_RGBA, GL_UNSIGNED_BYTE, img
	'glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR
	'glTexParameteri GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR
	
	'Dim img As Any Ptr = ImageCreate(w,h)
	'If BLoad("font.bmp", img) <> 0 Then Beep 

	
	textures(textureCount).id = CreateTexture(img, flags Or TEX_MASKED)
    memcpy(params,@textureCount,4) 'return texture handle
End Sub


'':::::
Sub cbglDrawImage Cdecl (params As UByte Ptr) Export
	Var id = getParamInteger(params, 1)
	Var x  = getParamInteger(params, 2)
	Var y  = getParamInteger(params, 3)
	Var rot = getParamSingle(params, 4)
	Var scale = getParamSingle(params, 5)
	Var alpha = getParamInteger(params, 6)
	Dim As Integer tw = textures(id).w, th = textures(id).h
	
	glLoadIdentity
	glTranslatef x, y, 0
	glTranslatef tw\2, th\2, 0
	glScalef scale,scale,1
	glRotatef rot, 0,0,1
	glTranslatef -tw\2, -th\2, 0
	
	glPushAttrib GL_ENABLE_BIT
	glEnable GL_TEXTURE_2D
	glBindTexture GL_TEXTURE_2D, textures(id).id
	glColor4ub 255, 255, 255, alpha
	glBegin GL_QUADS
		glTexCoord2f(0 , 1 )
		glVertex2i  (0 , 0 )
		glTexCoord2f(1 , 1 )
		glVertex2i  (tw, 0 )
		glTexCoord2f(1 , 0 )
		glVertex2i  (tw, th)
		glTexCoord2f(0 , 0 )
		glVertex2i  (0, th )
	glEnd
	glPopAttrib
End Sub


Sub cbglImageWidth Cdecl (params As UByte Ptr) Export
	Var id = getParamInteger(params, 1)
	memcpy(params,@textures(id).w,4)
End Sub

Sub cbglImageHeight Cdecl (params As UByte Ptr) Export
	Var id = getParamInteger(params, 1)
	memcpy(params,@textures(id).h,4)
End Sub

   


''::::: TEXT :::::''



Sub cbglText Cdecl (params As UByte Ptr) Export
	Var x = getParamInteger(params,1)
	Var y = getParamInteger(params,2)
	Var f = getParamInteger(params,3)
	Var size = getParamSingle(params,4)
	Var stlen = getParamInteger(params,5)
	Dim txt As String = ""
	For i As Integer = 0 To stlen-1
		txt += Chr(params[20+i])
	Next i
	
	glPushAttrib GL_ENABLE_BIT
	glEnable GL_TEXTURE_2D
	'glEnable GL_ALPHA_TEST
	'glAlphaFunc GL_NOTEQUAL, 0
	'glBlendFunc GL_SRC_ALPHA,GL_DST_ALPHA
	glBindTexture GL_TEXTURE_2D, f			                        '' Select Our Font Texture
	glDisable GL_DEPTH_TEST                                         '' Disables Depth Testing
	glMatrixMode GL_PROJECTION                                      '' Select The Projection Matrix
	glPushMatrix                                                    '' Store The Projection Matrix
		glLoadIdentity                                              '' Reset The Projection Matrix
		glOrtho 0, scrW, scrH, 0,-1, 1                              '' Set Up An Ortho Screen
		glMatrixMode GL_MODELVIEW                                   '' Select The Modelview Matrix
		glPushMatrix                                                '' Store The Modelview Matrix
			glLoadIdentity                                          '' Reset The Modelview Matrix
			glTranslatef x, y, 0                                    '' Position The Text (0,0 - Bottom Left)
			glScalef size, size, 0
			glListBase fbase-32
			glCallLists stlen, GL_UNSIGNED_BYTE, StrPtr(txt)     				'' Write The Text To The Screen
			glMatrixMode GL_PROJECTION                              '' Select The Projection Matrix
		glPopMatrix                                                 '' Restore The Old Projection Matrix
		glMatrixMode GL_MODELVIEW                                   '' Select The Modelview Matrix
	glPopMatrix                                                     '' Restore The Old Projection Matrix
	glPopAttrib
End Sub


Sub cbglBuildFont()'Cdecl (params As UByte Ptr) Export
	'Dim As UInteger fonttex = getParamInteger(params, 1)
	Dim loop1 As Integer
	Dim cx As Double                             '' Holds Our X Character Coord
	Dim cy As Double                             '' Holds Our Y Character Coord

	fbase = glGenLists(256)                      '' Creating 256 Display Lists
	'glBindTexture GL_TEXTURE_2D, fonttex	     '' Select Our Font Texture
	For loop1 = 0 To 255                         '' Loop Through All 256 Lists

		cx = (loop1 Mod 16)/16.0                 '' X Position Of Current Character
		cy = Int(loop1\16)/16.0                     '' Y Position Of Current Character

		glNewList fbase+loop1, GL_COMPILE        '' Start Building A List
		glBegin GL_QUADS                         '' Use A Quad For Each Character
			glTexCoord2f cx, 1.0-cy-0.0625         '' Texture Coord (Bottom Left)
			glVertex2i 0, 16                     '' Vertex Coord (Bottom Left)
			glTexCoord2f cx+0.0625, 1.0-cy-0.0625'' Texture Coord (Bottom Right)
			glVertex2i 16, 16                    '' Vertex Coord (Bottom Right)
			glTexCoord2f cx+0.0625, 1.0-cy		 '' Texture Coord (Top Right)
			glVertex2i 16, 0                     '' Vertex Coord (Top Right)
			glTexCoord2f cx, 1.0-cy		         '' Texture Coord (Top Left)
			glVertex2i 0, 0                      '' Vertex Coord (Top Left)
		glEnd                                    '' Done Building Our Quad (Character)
		glTranslated 14, 0, 0                    '' Move To The Right Of The Character
		glEndList                                '' Done Building The Display List
	Next loop1
End Sub

''::::: INPUT :::::''


Sub cbglKeyDown Cdecl (params As UByte Ptr) Export
	Var scancode = getParamInteger(params, 1)
	If MultiKey(scancode) Then params[0] = 1 Else params[0] = 0
End Sub


Sub cbglMouseX Cdecl (params As UByte Ptr) Export
	Dim As Integer mx,my
	GetMouse mx,my
	memcpy(params,@mx,4) 'return the coordinate
End Sub


Sub cbglMouseY Cdecl (params As UByte Ptr) Export
	Dim As Integer mx,my
	GetMouse mx,my
	memcpy(params,@my,4) 'return the coordinate	
End Sub


Sub cbglMouseZ Cdecl (params As UByte Ptr) Export
	Dim As Integer mx,my,mw
	GetMouse mx,my,mw
	memcpy(params,@mw,4) 'return the wheel rotation
End Sub


Sub cbglMouseDown Cdecl (params As UByte Ptr) Export
	Dim As Integer mx,my,mb
	GetMouse mx,my,,mb
	If params[0] = 1 AndAlso (mb And 1) Then params[0] = 1: Return
	If params[0] = 2 AndAlso (mb And 2) Then params[0] = 1: Return
	If params[0] = 3 AndAlso (mb And 4) Then params[0] = 1: Return
	params[0] = 0
End Sub



Sub cbgl0 Cdecl (params As UByte Ptr) Export
	Var cmd = params[0]
	Select Case As Const cmd
		Case cb_glloadidentity	: glLoadIdentity: Return
		Case cb_glpushmatrix 	: glPushMatrix: Return
		Case cb_glpopmatrix 	: glPopMatrix: Return
		Case cb_glend 			: glEnd: Return
		Case cb_glendlist 		: glEndList: Return
	End Select
	MessageBox NULL, !"Unsupported command " +Str(cmd)+ "!", "CBGL Error", MB_ICONERROR 'ASTERISK
End Sub

Sub cbgl1i Cdecl (params As UByte Ptr) Export
	Var par1 = getParamInteger(params,1)
	Var cmd = params[4]
	Select Case As Const cmd
		Case cb_glenable		: glEnable par1: Return
		Case cb_gldisable		: glDisable par1: Return
		Case cb_glbegin			: glBegin par1: Return
		Case cb_glclear			: glClear par1: Return
		Case cb_glcalllist		: glCallList par1: Return
		Case cb_glshademodel	: glShadeModel par1: Return
		Case cb_glDepthMask		: glDepthMask par1: Return
		Case cb_glMatrixMode	: glMatrixMode par1: Return
		Case cb_glpushattrib	: glPushAttrib par1: Return
		Case cb_gldepthfunc		: glDepthFunc par1: Return
		Case cb_glcullface		: glCullFace par1: Return
		'Case cb_gldepthfunc"	: glDepthFunc par1: Return
	End Select	
	MessageBox NULL, !"Unsupported command " +Str(cmd)+ "!", "CBGL Error", MB_ICONERROR 'ASTERISK
End Sub

Sub cbgl2i Cdecl (params As UByte Ptr) Export
	Var par1 = getParamInteger(params,1)
	Var par2 = getParamInteger(params,2)
	Var cmd = params[8]
	Select Case As Const cmd
		Case cb_glvertex		: glVertex2i par1,par2: Return
		Case cb_glbindtexture	: glBindTexture par1, par2: Return
		Case cb_glRasterPos		: glRasterPos2i par1, par2: Return
		Case cb_glblendfunc		: glBlendFunc par1,par2: Return
		Case cb_glhint 			: glHint par1,par2: Return
		Case cb_glnewlist		: glNewList par1,par2: Return
		Case cb_glfog			: glFogi par1,par2: Return
		Case cb_gllightmodel	: glLightModeli par1,par2: Return
			
	End Select
	MessageBox NULL, !"Unsupported command " +Str(cmd)+ "!", "CBGL Error", MB_ICONERROR 'ASTERISK
End Sub

Sub cbgl3i Cdecl (params As UByte Ptr) Export
	Var par1 = getParamInteger(params,1)
	Var par2 = getParamInteger(params,2)
	Var par3 = getParamInteger(params,3)
	Var cmd = params[12]
	Select Case As Const cmd
		Case cb_glvertex		: glVertex3i par1,par2,par3: Return
		Case cb_gltexparameter	: glTexParameteri par1,par2,par3: Return
		Case cb_glcolor			: glColor3i par1,par2,par3: Return
		Case cb_glnormal		: glNormal3i par1,par2,par3: Return
		Case cb_gllight			: glLighti par1,par2,par3: Return
		'Case cb_glnormal3i": glNormal3i par1,par2,par3: Return
			
	End Select
	MessageBox NULL, !"Unsupported command " +Str(cmd)+ "!", "CBGL Error", MB_ICONERROR 'ASTERISK
End Sub

Sub cbgl4i Cdecl (params As UByte Ptr) Export
	Var par1 = getParamInteger(params,1)
	Var par2 = getParamInteger(params,2)
	Var par3 = getParamInteger(params,3)
	Var par4 = getParamInteger(params,4)
	Var cmd = params[16]
	Select Case As Const cmd
		Case cb_glcolor			: glColor4i par1,par2,par3,par4: Return
		Case cb_glviewport		: glViewport par1,par2,par3,par4: Return
	End Select
	MessageBox NULL, !"Unsupported command " +Str(cmd)+ "!", "CBGL Error", MB_ICONERROR 'ASTERISK
End Sub


Sub cbgl1f Cdecl (params As UByte Ptr) Export
	Var par1 = getParamSingle(params,1)
	Var cmd = params[4]
	Select Case As Const cmd
		Case cb_glcleardepth	: glClearDepth par1: Return
		Case cb_gllinewidth		: glLineWidth par1: Return
		Case cb_glpointsize		: glPointSize par1: Return
			
	End Select	
	MessageBox NULL, !"Unsupported command " +Str(cmd)+ "!", "CBGL Error", MB_ICONERROR 'ASTERISK
End Sub


Sub cbgl2f Cdecl (params As UByte Ptr) Export
	Var par1 = getParamSingle(params,1)
	Var par2 = getParamSingle(params,2)
	Var cmd = params[8]
	Select Case As Const cmd
		Case cb_gltexcoord		: glTexCoord2f par1,par2: Return
		Case cb_glvertex		: glVertex2f par1,par2: Return
		Case cb_glRasterPos		: glRasterPos2f par1, par2: Return
		Case cb_glfog			: glFogf CInt(par1),par2: Return
		Case cb_gllightmodel	: glLightModelf CInt(par1),par2: Return
		'Case cb_glvertex2		: glVertex2f par1,par2: Return
	End Select
	MessageBox NULL, !"Unsupported command " +Str(cmd)+ "!", "CBGL Error", MB_ICONERROR 'ASTERISK
End Sub


Sub cbgl3f Cdecl (params As UByte Ptr) Export
	Var par1 = getParamSingle(params,1)
	Var par2 = getParamSingle(params,2)
	Var par3 = getParamSingle(params,3)
	Var cmd = params[12]
	Select Case As Const cmd
		Case cb_glvertex		: glVertex3f par1,par2,par3: Return
		Case cb_gltranslate		: glTranslatef par1,par2,par3: Return
		Case cb_glnormal		: glNormal3f par1,par2,par3: Return
		Case cb_glscale			: glScalef par1,par2,par3: Return
		Case cb_glcolor			: glColor3f par1,par2,par3: Return
		Case cb_gllight			: glLightf CInt(par1),CInt(par2),par3: Return
	End Select
	MessageBox NULL, !"Unsupported command " +Str(cmd)+ "!", "CBGL Error", MB_ICONERROR 'ASTERISK
End Sub


Sub cbgl4f Cdecl (params As UByte Ptr) Export
	Var par1 = getParamSingle(params,1)
	Var par2 = getParamSingle(params,2)
	Var par3 = getParamSingle(params,3)
	Var par4 = getParamSingle(params,4)
	Var cmd = params[16]
	Select Case As Const cmd
		Case cb_glrotate		: glRotatef par1,par2,par3,par4: Return
		Case cb_glcolor			: glColor4f par1,par2,par3,par4: Return
		Case cb_glclearcolor	: glClearColor par1,par2,par3,par4: Return
		Case cb_gluperspective	: gluPerspective par1,par2,par3,par4: Return
		Case cb_gluortho2d		: gluOrtho2D par1,par2,par3,par4: Return
		'Case cb_glcolor4f		: glColor4f par1,par2,par3,par4: Return
	End Select
	MessageBox NULL, !"Unsupported command " +Str(cmd)+ "!", "CBGL Error", MB_ICONERROR 'ASTERISK
End Sub









Sub cbglText2 Cdecl (params As UByte Ptr) Export
	Var x = getParamInteger(params,1)
	Var y = getParamInteger(params,2)
	Var stlen = getParamInteger(params,3)
	Dim txt As String = ""
	For i As Integer = 0 To stlen-1
		txt += Chr(params[12+i])
	Next i
	
	
	glPushAttrib GL_ENABLE_BIT
	'glEnable GL_TEXTURE_2D
	'glBindTexture GL_TEXTURE_2D, f			                        '' Select Our Font Texture
	glDisable GL_DEPTH_TEST                                         '' Disables Depth Testing
	glMatrixMode GL_PROJECTION                                      '' Select The Projection Matrix
	glPushMatrix                                                    '' Store The Projection Matrix
		glLoadIdentity                                              '' Reset The Projection Matrix
		glOrtho 0, scrW, scrH, 0,-1, 1                              '' Set Up An Ortho Screen
		glMatrixMode GL_MODELVIEW                                   '' Select The Modelview Matrix
		glPushMatrix                                                '' Store The Modelview Matrix
			glLoadIdentity                                          '' Reset The Modelview Matrix
			glTranslatef x, y, 0                                    '' Position The Text (0,0 - Bottom Left)
			glListBase fbase-32
			glCallLists stlen, GL_BYTE, StrPtr(txt)     				'' Write The Text To The Screen
			glMatrixMode GL_PROJECTION                              '' Select The Projection Matrix
		glPopMatrix                                                 '' Restore The Old Projection Matrix
		glMatrixMode GL_MODELVIEW                                   '' Select The Modelview Matrix
	glPopMatrix                                                     '' Restore The Old Projection Matrix
	glPopAttrib
	
	Return 
	
	glMatrixMode GL_PROJECTION
	glLoadIdentity
	gluPerspective 45, CSng(scrW) / CSng(scrH), 0.1, 100
	glMatrixMode GL_MODELVIEW
	glLoadIdentity
	'glTranslatef(0.0,0.0,-3.0)
	
	glRasterPos2i x, y
	glPushAttrib GL_LIST_BIT
		glListBase Fbase-32 
		glCallLists Len(txt), GL_UNSIGNED_BYTE , StrPtr(txt) 
	glPopAttrib 
	
    glMatrixMode GL_PROJECTION
	glLoadIdentity 
	gluOrtho2D 0,scrW,scrH,0
	glMatrixMode GL_MODELVIEW
End Sub


Sub cbglLoadFont Cdecl (params As UByte Ptr) Export
	Var font_height = getParamInteger(params,1)
	Var font_weight = getParamInteger(params,2)
	Var stlen = getParamInteger(params,3)
	Dim txt As String = ""
	For i As Integer = 0 To stlen-1
		txt += Chr(params[12+i])
	Next i
	Fbase = glGenLists(96)
	font = CreateFont(-font_height,_ 	'Height
				0,_ 					'Width
				0,_						'Angle of escapement
				0,_						'Base-line orientation angle
				font_weight,_ 			'Font weight
				FALSE,_					'Italics
				FALSE,_					'Underline
				FALSE,_ 				'Strikethrough
				ANSI_CHARSET,_      	'Character ser identifier         
				OUT_TT_PRECIS,_			'Output precision
				CLIP_DEFAULT_PRECIS,_	'Clipping precision
				ANTIALIASED_QUALITY,_	'Output quality         
				FF_DONTCARE Or DEFAULT_PITCH,_ 'Pitch and family    
				txt)					'Typeface name 
	oldfont = SelectObject(hDC, font)
	wglUseFontBitmaps(hDC, 32, 96, Fbase)
	SelectObject(hDC, oldfont)
	DeleteObject(font)
End Sub   
