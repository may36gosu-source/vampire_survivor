/*
Author:gzg
Date:2019-08-20
Desc:这个Shader是用来生成阴影并且与StencilShadowReceiver是同时使用,
    本Shader还有两个参数_LightDir向量(光的方向)和_World2Receiver矩阵(世界到投影的面板的转换矩阵),需要通过程序代码设置.
*/
Shader "Ares/SpecialEffect/StencilShadowCaster"
{
	Properties
	{
		_LightDir("灯光方向",Vector) = (-0.4, -0.8, -0.5, 0.0)
		_ShadowColor ("阴影颜色", Color) = (0,0,0,1)  
		_ReceiverDir("接受阴影的面板方向",Vector) = (1,0,0,0)     
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue"="Transparent"}
		LOD 100
		UsePass "Gonbest/Function/StencilShadowHelper/SHADOWCASTER&PLANEDIR"
	}
}
