' CBGL - OpenGL graphics library for CoolBasic
' by Tapio Vierros 2008


#Ifndef __cbgl_bi__ 
#define __cbgl_bi__ 


#Ifndef TRUE
 #define TRUE -1
 #define FALSE 0
#EndIf


Const PI = 3.1415926535

#Define cb_glAccum 1
#Define cb_glActiveTexture 2
#Define cb_glAlphaFunc 3
#Define cb_glAreTexturesResident 4
#Define cb_glArrayElement 5
#Define cb_glAttachShader 6
#Define cb_glBegin 7
#Define cb_glBeginQuery 8
#Define cb_glBindAttribLocation 9
#Define cb_glBindBuffer 10
#Define cb_glBindTexture 11
#Define cb_glBitmap 12
#Define cb_glBlendColor 13
#Define cb_glBlendEquation 14
#Define cb_glBlendEquationSeparate 15
#Define cb_glBlendFunc 16
#Define cb_glBlendFuncSeparate 17
#Define cb_glBufferData 18
#Define cb_glBufferSubData 19
#Define cb_glCallList 20
#Define cb_glCallLists 21
#Define cb_glClear 22
#Define cb_glClearAccum 23
#Define cb_glClearColor 24
#Define cb_glClearDepth 25
#Define cb_glClearIndex 26
#Define cb_glClearStencil 27
#Define cb_glClientActiveTexture 28
#Define cb_glClipPlane 29
#Define cb_glColor 30
#Define cb_glColorMask 31
#Define cb_glColorMaterial 32
#Define cb_glColorPointer 33
#Define cb_glColorSubTable 34
#Define cb_glColorTable 35
#Define cb_glColorTableParameter 36
#Define cb_glCompileShader 37
#Define cb_glCompressedTexImage1D 38
#Define cb_glCompressedTexImage2D 39
#Define cb_glCompressedTexImage3D 40
#Define cb_glCompressedTexSubImage1D 41
#Define cb_glCompressedTexSubImage2D 42
#Define cb_glCompressedTexSubImage3D 43
#Define cb_glConvolutionFilter1D 44
#Define cb_glConvolutionFilter2D 45
#Define cb_glConvolutionParameter 46
#Define cb_glCopyColorSubTable 47
#Define cb_glCopyColorTable 48
#Define cb_glCopyConvolutionFilter1D 49
#Define cb_glCopyConvolutionFilter2D 50
#Define cb_glCopyPixels 51
#Define cb_glCopyTexImage1D 52
#Define cb_glCopyTexImage2D 53
#Define cb_glCopyTexSubImage1D 54
#Define cb_glCopyTexSubImage2D 55
#Define cb_glCopyTexSubImage3D 56
#Define cb_glCreateProgram 57
#Define cb_glCreateShader 58
#Define cb_glCullFace 59
#Define cb_glDeleteBuffers 60
#Define cb_glDeleteLists 61
#Define cb_glDeleteProgram 62
#Define cb_glDeleteQueries 63
#Define cb_glDeleteShader 64
#Define cb_glDeleteTextures 65
#Define cb_glDepthFunc 66
#Define cb_glDepthMask 67
#Define cb_glDepthRange 68
#Define cb_glDetachShader 69
#Define cb_glDisable 70
#Define cb_glDisableClientState 71
#Define cb_glDisableVertexAttribArray 72
#Define cb_glDrawArrays 73
#Define cb_glDrawBuffer 74
#Define cb_glDrawBuffers 75
#Define cb_glDrawElements 76
#Define cb_glDrawPixels 77
#Define cb_glDrawRangeElements 78
#Define cb_glEdgeFlag 79
#Define cb_glEdgeFlagPointer 80
#Define cb_glEnable 81
#Define cb_glEnableClientState 82
#Define cb_glEnableVertexAttribArray 83
#Define cb_glEnd 84
#Define cb_glEndList 85
#Define cb_glEndQuery 86
#Define cb_glEvalCoord 87
#Define cb_glEvalMesh 88
#Define cb_glEvalPoint 89
#Define cb_glFeedbackBuffer 90
#Define cb_glFinish 91
#Define cb_glFlush 92
#Define cb_glFog 93
#Define cb_glFogCoord 94
#Define cb_glFogCoordPointer 95
#Define cb_glFrontFace 96
#Define cb_glFrustum 97
#Define cb_glGenBuffers 98
#Define cb_glGenLists 99
#Define cb_glGenQueries 100
#Define cb_glGenTextures 101
#Define cb_glHint 102
#Define cb_glHistogram 103
#Define cb_glIndex 104
#Define cb_glIndexMask 105
#Define cb_glIndexPointer 106
#Define cb_glInitNames 107
#Define cb_glInterleavedArrays 108
#Define cb_glIsBuffer 109
#Define cb_glIsEnabled 110
#Define cb_glIsList 111
#Define cb_glIsProgram 112
#Define cb_glIsQuery 113
#Define cb_glIsShader 114
#Define cb_glIsTexture 115
#Define cb_glLight 116
#Define cb_glLightModel 117
#Define cb_glLineStipple 118
#Define cb_glLineWidth 119
#Define cb_glLinkProgram 120
#Define cb_glListBase 121
#Define cb_glLoadIdentity 122
#Define cb_glLoadMatrix 123
#Define cb_glLoadName 124
#Define cb_glLoadTransposeMatrix 125
#Define cb_glLogicOp 126
#Define cb_glMap1 127
#Define cb_glMap2 128
#Define cb_glMapBuffer 129
#Define cb_glMapGrid 130
#Define cb_glMaterial 131
#Define cb_glMatrixMode 132
#Define cb_glMinmax 133
#Define cb_glMultiDrawArrays 134
#Define cb_glMultiDrawElements 135
#Define cb_glMultiTexCoord 136
#Define cb_glMultMatrix 137
#Define cb_glMultTransposeMatrix 138
#Define cb_glNewList 139
#Define cb_glNormal 140
#Define cb_glNormalPointer 141
#Define cb_glOrtho 142
#Define cb_glPassThrough 143
#Define cb_glPixelMap 144
#Define cb_glPixelStore 145
#Define cb_glPixelTransfer 146
#Define cb_glPixelZoom 147
#Define cb_glPointParameter 148
#Define cb_glPointSize 149
#Define cb_glPolygonMode 150
#Define cb_glPolygonOffset 151
#Define cb_glPolygonStipple 152
#Define cb_glPopAttrib 153
#Define cb_glPopClientAttrib 154
#Define cb_glPopMatrix 155
#Define cb_glPopName 156
#Define cb_glPrioritizeTextures 157
#Define cb_glPushAttrib 158
#Define cb_glPushClientAttrib 159
#Define cb_glPushMatrix 160
#Define cb_glPushName 161
#Define cb_glRasterPos 162
#Define cb_glReadBuffer 163
#Define cb_glReadPixels 164
#Define cb_glRect 165
#Define cb_glRenderMode 166
#Define cb_glResetHistogram 167
#Define cb_glResetMinmax 168
#Define cb_glRotate 169
#Define cb_glSampleCoverage 170
#Define cb_glScale 171
#Define cb_glScissor 172
#Define cb_glSecondaryColor 173
#Define cb_glSecondaryColorPointer 174
#Define cb_glSelectBuffer 175
#Define cb_glSeparableFilter2D 176
#Define cb_glShadeModel 177
#Define cb_glShaderSource 178
#Define cb_glStencilFunc 179
#Define cb_glStencilFuncSeparate 180
#Define cb_glStencilMask 181
#Define cb_glStencilMaskSeparate 182
#Define cb_glStencilOp 183
#Define cb_glStencilOpSeparate 184
#Define cb_glTexCoord 185
#Define cb_glTexCoordPointer 186
#Define cb_glTexEnv 187
#Define cb_glTexGen 188
#Define cb_glTexImage1D 189
#Define cb_glTexImage2D 190
#Define cb_glTexImage3D 191
#Define cb_glTexParameter 192
#Define cb_glTexSubImage1D 193
#Define cb_glTexSubImage2D 194
#Define cb_glTexSubImage3D 195
#Define cb_glTranslate 196
#Define cb_gluBeginCurve 197
#Define cb_gluBeginPolygon 198
#Define cb_gluBeginSurface 199
#Define cb_gluBeginTrim 200
#Define cb_gluBuild1DMipmapLevels 201
#Define cb_gluBuild1DMipmaps 202
#Define cb_gluBuild2DMipmapLevels 203
#Define cb_gluBuild2DMipmaps 204
#Define cb_gluBuild3DMipmapLevels 205
#Define cb_gluBuild3DMipmaps 206
#Define cb_gluCheckExtension 207
#Define cb_gluCylinder 208
#Define cb_gluDeleteNurbsRenderer 209
#Define cb_gluDeleteQuadric 210
#Define cb_gluDeleteTess 211
#Define cb_gluDisk 212
#Define cb_gluEndCurve 213
#Define cb_gluEndPolygon 214
#Define cb_gluEndSurface 215
#Define cb_gluEndTrim 216
#Define cb_gluErrorString 217
#Define cb_gluGetNurbsProperty 218
#Define cb_gluGetString 219
#Define cb_gluGetTessProperty 220
#Define cb_gluLoadSamplingMatrices 221
#Define cb_gluLookAt 222
#Define cb_gluNewNurbsRenderer 223
#Define cb_gluNewQuadric 224
#Define cb_gluNewTess 225
#Define cb_gluNextContour 226
#Define cb_glUniform 227
#Define cb_glUnmapBuffer 228
#Define cb_gluNurbsCallback 229
#Define cb_gluNurbsCallbackData 230
#Define cb_gluNurbsCallbackDataEXT 231
#Define cb_gluNurbsCurve 232
#Define cb_gluNurbsProperty 233
#Define cb_gluNurbsSurface 234
#Define cb_gluOrtho2D 235
#Define cb_gluPartialDisk 236
#Define cb_gluPerspective 237
#Define cb_gluPickMatrix 238
#Define cb_gluProject 239
#Define cb_gluPwlCurve 240
#Define cb_gluQuadricCallback 241
#Define cb_gluQuadricDrawStyle 242
#Define cb_gluQuadricNormals 243
#Define cb_gluQuadricOrientation 244
#Define cb_gluQuadricTexture 245
#Define cb_gluScaleImage 246
#Define cb_glUseProgram 247
#Define cb_gluSphere 248
#Define cb_glValidateProgram 249
#Define cb_glVertex 250
#Define cb_glVertexAttrib 251
#Define cb_glVertexAttribPointer 252
#Define cb_glVertexPointer 253
#Define cb_glViewport 254
#Define cb_glWindowPos 255

Declare Sub cbglBuildFont ()

Extern "C"

Declare Sub cbglInit Lib "cbgl" (params As UByte Ptr)

Declare Sub cbglInit3d Lib "cbgl" (params As UByte Ptr)

Declare Sub cbglTerminate Lib "cbgl" (params As UByte Ptr)

Declare Sub cbglSetWindow Lib "cbgl" (params As UByte Ptr)

Declare Sub cbglFlip Lib "cbgl" () 

Declare Sub cbglCls Lib "cbgl" () 

Declare Sub cbglColor Lib "cbgl" (params As UByte Ptr)

Declare Sub cbglDot Lib "cbgl" (params As UByte Ptr)

Declare Sub cbglLine Lib "cbgl" (params As UByte Ptr)

Declare Sub cbglBox Lib "cbgl" (params As UByte Ptr)

Declare Sub cbglCircle Lib "cbgl" (params As UByte Ptr)

Declare Sub cbglEllipse Lib "cbgl" (params As UByte Ptr)


Declare Sub cbglLoadImage Lib "cbgl" (params As UByte Ptr)

Declare Sub cbglDrawImage Lib "cbgl" (params As UByte Ptr)

Declare Sub cbglImageWidth Lib "cbgl" (params As UByte Ptr)

Declare Sub cbglImageHeight Lib "cbgl" (params As UByte Ptr)


Declare Sub cbglLoadFont Cdecl (params As UByte Ptr)

Declare Sub cbglText Cdecl (params As UByte Ptr)

Declare Sub cbglText2 Cdecl (params As UByte Ptr)

'Declare Sub cbglBuildFont Cdecl (params As UByte Ptr)


Declare Sub cbglKeyDown Lib "cbgl" (params As UByte Ptr)

Declare Sub cbglMouseDown Lib "cbgl" (params As UByte Ptr)

Declare Sub cbglMouseX Lib "cbgl" (params As UByte Ptr)

Declare Sub cbglMouseY Lib "cbgl" (params As UByte Ptr)

Declare Sub cbglMouseZ Lib "cbgl" (params As UByte Ptr)


Declare Sub cbgl0 Lib "cbgl" (params As UByte Ptr)

Declare Sub cbgl1i Lib "cbgl" (params As UByte Ptr)

Declare Sub cbgl2i Lib "cbgl" (params As UByte Ptr)

Declare Sub cbgl3i Lib "cbgl" (params As UByte Ptr)

Declare Sub cbgl4i Lib "cbgl" (params As UByte Ptr)

Declare Sub cbgl1f Lib "cbgl" (params As UByte Ptr)

Declare Sub cbgl2f Lib "cbgl" (params As UByte Ptr)

Declare Sub cbgl3f Lib "cbgl" (params As UByte Ptr)

Declare Sub cbgl4f Lib "cbgl" (params As UByte Ptr)

'Declare Sub cbgl Lib "cbgl" (params As UByte Ptr)

End Extern


Dim Shared cur_color As UInteger

Type tex_type
	id As UInteger
	w As Integer
	h As Integer
End Type

Dim Shared textureCount As Integer
Dim Shared textureArraySize As Integer = 10
ReDim Shared textures(1 To textureArraySize) As tex_type'UInteger

Dim Shared As Integer scrW, scrH
   
   Dim Shared As Uinteger Fbase
   Dim Shared As HFONT font   
   Dim Shared As HFONT oldfont     
   Dim Shared As HDC hDC
   Dim Shared As HWND hWnd
   hDC = GetDC( hWnd )


#EndIf