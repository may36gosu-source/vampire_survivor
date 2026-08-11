Shader "FXMaker/Mask Additive Tint" {
Properties {
 _TintColor ("Tint Color", Color) = (0.500000,0.500000,0.500000,0.500000)
 _MainTex ("Particle Texture", 2D) = "white" { }
 _Mask ("Mask", 2D) = "white" { }
}
SubShader { 
 Tags { "QUEUE"="Transparent" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" }
 Pass {
  Tags { "QUEUE"="Transparent" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" }
  ZWrite Off
  Cull Off
  Blend SrcAlpha One
  ColorMask RGB
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 2.0
#include "UnityCG.cginc"

// uniforms
float4 _MainTex_ST;
float4 _Mask_ST;

// vertex shader input data
struct appdata {
  float3 pos : POSITION;
  half4 color : COLOR;
  float3 uv0 : TEXCOORD0;
};

// vertex-to-fragment interpolators
struct v2f {
  fixed4 color : COLOR0;
  float2 uv0 : TEXCOORD0;
  float2 uv1 : TEXCOORD1;
  float2 uv2 : TEXCOORD2;
  float4 pos : SV_POSITION;
};

// vertex shader
v2f vert (appdata IN) {
  v2f o;
  half4 color = IN.color;
  float3 eyePos = mul (UNITY_MATRIX_MV, float4(IN.pos,1)).xyz;
  half3 viewDir = 0.0;
  o.color = saturate(color);
  // compute texture coordinates
  o.uv0 = IN.uv0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
  o.uv1 = IN.uv0.xy * _Mask_ST.xy + _Mask_ST.zw;
  o.uv2 = IN.uv0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
  // transform position
  o.pos = UnityObjectToClipPos(IN.pos);
  return o;
}

// textures
sampler2D _MainTex;
sampler2D _Mask;
fixed4 _TintColor;

// fragment shader
fixed4 frag (v2f IN) : SV_Target {
  fixed4 col;
  fixed4 tex, tmp0, tmp1, tmp2;
  // SetTexture #0
  tex = tex2D (_MainTex, IN.uv0.xy);
  col = _TintColor * IN.color;
  // SetTexture #1
  tex = tex2D (_Mask, IN.uv1.xy);
  col = tex * col;
  // SetTexture #2
  tex = tex2D (_MainTex, IN.uv2.xy);
  col = tex * col;
  col *= 2;
  return col;
}

// texenvs
//! TexEnv0: 01020103 01020103 [_MainTex] [_TintColor]
//! TexEnv1: 01010100 01010100 [_Mask]
//! TexEnv2: 02010100 02010100 [_MainTex]
ENDCG
 }
}
SubShader { 
 Tags { "QUEUE"="Transparent" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" }
 Pass {
  Tags { "QUEUE"="Transparent" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" }
  ZWrite Off
  Cull Off
  Blend SrcAlpha One
  ColorMask RGB
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma target 2.0
#include "UnityCG.cginc"

// uniforms
float4 _Mask_ST;
float4 _MainTex_ST;

// vertex shader input data
struct appdata {
  float3 pos : POSITION;
  half4 color : COLOR;
  float3 uv0 : TEXCOORD0;
};

// vertex-to-fragment interpolators
struct v2f {
  fixed4 color : COLOR0;
  float2 uv0 : TEXCOORD0;
  float2 uv1 : TEXCOORD1;
  float4 pos : SV_POSITION;
};

// vertex shader
v2f vert (appdata IN) {
  v2f o;
  half4 color = IN.color;
  float3 eyePos = mul (UNITY_MATRIX_MV, float4(IN.pos,1)).xyz;
  half3 viewDir = 0.0;
  o.color = saturate(color);
  // compute texture coordinates
  o.uv0 = IN.uv0.xy * _Mask_ST.xy + _Mask_ST.zw;
  o.uv1 = IN.uv0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
  // transform position
  o.pos = UnityObjectToClipPos(IN.pos);
  return o;
}

// textures
sampler2D _Mask;
sampler2D _MainTex;

// fragment shader
fixed4 frag (v2f IN) : SV_Target {
  fixed4 col;
  fixed4 tex, tmp0, tmp1, tmp2;
  // SetTexture #0
  tex = tex2D (_Mask, IN.uv0.xy);
  col = tex * IN.color;
  // SetTexture #1
  tex = tex2D (_MainTex, IN.uv1.xy);
  col = tex * col;
  return col;
}

// texenvs
//! TexEnv0: 01010103 01010103 [_Mask]
//! TexEnv1: 01010100 01010100 [_MainTex]
ENDCG
 }
}
}