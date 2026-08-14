Shader "leeveel/GrassAni"
{
  Properties
  {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Base (RGB) Alpha (A)", 2D) = "white" {}
    _OffsetPower ("摆动强度", Range(-2, 2)) = 0.87
    _XLoopSpeed ("左右摆动速度", Range(-2, 2)) = 1
    _YLoopSpeed ("前后摆动速度", Range(-2, 2)) = 1
    _UpDownLoopSpeed ("上下摆动速度", Range(-10, 10)) = 0
    _CutClip ("半透明裁剪阈值", Range(0, 1.01)) = 0
    _MinY ("MinY", float) = 1
    _Mask ("Mask", 2D) = "black" {}
    [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull Mode", float) = 2
  }
  SubShader
  {
    Tags
    { 
      "IGNOREPROJECTOR" = "true"
      "QUEUE" = "AlphaTest"
      "RenderType" = "TransparentCutout"
    }
    LOD 400
    Pass // ind: 1, name: 
    {
      Tags
      { 
        "IGNOREPROJECTOR" = "true"
        "QUEUE" = "AlphaTest"
        "RenderType" = "TransparentCutout"
      }
      LOD 400
      Cull Off
      // m_ProgramMask = 6
      CGPROGRAM
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4 _Time;
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_WorldToObject;
      //uniform float4x4 unity_MatrixVP;
      uniform float4 _MainTex_ST;
      uniform float _OffsetPower;
      uniform float _MinY;
      uniform float _XLoopSpeed;
      uniform float _YLoopSpeed;
      uniform float _UpDownLoopSpeed;
      uniform sampler2D _Mask;
      uniform float _CutClip;
      uniform float4 _Color;
      uniform sampler2D _MainTex;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      float4 u_xlat0;
      float4 u_xlat1;
      float u_xlat6;
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          u_xlat0.x = (_Time.y * _XLoopSpeed);
          u_xlat0.yz = (_Time.yy * float2(_UpDownLoopSpeed, _YLoopSpeed));
          u_xlat0.xyz = sin(u_xlat0.xyz);
          u_xlat0.xyz = (u_xlat0.xyz * float3(_OffsetPower, _OffsetPower, _OffsetPower));
          u_xlat1.xyz = (in_v.vertex.yyy * conv_mxt4x4_1(unity_ObjectToWorld).xyz);
          u_xlat1.xyz = ((conv_mxt4x4_0(unity_ObjectToWorld).xyz * in_v.vertex.xxx) + u_xlat1.xyz);
          u_xlat1.xyz = ((conv_mxt4x4_2(unity_ObjectToWorld).xyz * in_v.vertex.zzz) + u_xlat1.xyz);
          u_xlat6 = max(u_xlat1.y, _MinY);
          u_xlat6 = min(u_xlat6, 1000);
          u_xlat6 = (float(1) / u_xlat6);
          u_xlat0.xyz = (float3(u_xlat6, u_xlat6, u_xlat6) * u_xlat0.xyz);
          u_xlat6 = tex2Dlod(_Mask, float4(float3(in_v.texcoord.xy, 0), 1)).x;
          u_xlat0.xyz = ((u_xlat0.xyz * float3(u_xlat6, u_xlat6, u_xlat6)) + u_xlat1.xyz);
          u_xlat1.xyz = (u_xlat0.yyy * conv_mxt4x4_1(unity_WorldToObject).xyz);
          u_xlat0.xyw = ((conv_mxt4x4_0(unity_WorldToObject).xyz * u_xlat0.xxx) + u_xlat1.xyz);
          u_xlat0.xyz = ((conv_mxt4x4_2(unity_WorldToObject).xyz * u_xlat0.zzz) + u_xlat0.xyw);
          out_v.vertex = UnityObjectToClipPos(u_xlat0);
          out_v.color = in_v.color;
          out_v.texcoord.xy = TRANSFORM_TEX(in_v.texcoord.xy, _MainTex);
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float4 u_xlat0_d;
      float4 u_xlat16_0;
      int u_xlatb0;
      float u_xlat1_d;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat16_0 = tex2D(_MainTex, in_f.texcoord.xy);
          u_xlat1_d = ((_Color.w * u_xlat16_0.w) + (-_CutClip));
          u_xlat0_d = (u_xlat16_0 * _Color);
          out_f.color = u_xlat0_d;
          #ifdef UNITY_ADRENO_ES3
          u_xlatb0 = (u_xlat1_d<0);
          #else
          u_xlatb0 = (u_xlat1_d<0);
          #endif
          if(u_xlatb0)
          {
              discard;
          }
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
    Pass // ind: 2, name: 
    {
      Tags
      { 
        "IGNOREPROJECTOR" = "true"
        "QUEUE" = "AlphaTest"
        "RenderType" = "TransparentCutout"
        "RequireOption" = "SoftVegetation"
      }
      LOD 400
      ZWrite Off
      Cull Off
      Blend SrcAlpha OneMinusSrcAlpha
      // m_ProgramMask = 6
      CGPROGRAM
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4 _Time;
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_WorldToObject;
      //uniform float4x4 unity_MatrixVP;
      uniform float4 _MainTex_ST;
      uniform float _OffsetPower;
      uniform float _MinY;
      uniform float _XLoopSpeed;
      uniform float _YLoopSpeed;
      uniform float _UpDownLoopSpeed;
      uniform sampler2D _Mask;
      uniform float _CutClip;
      uniform float4 _Color;
      uniform sampler2D _MainTex;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      float4 u_xlat0;
      float4 u_xlat1;
      float u_xlat6;
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          u_xlat0.x = (_Time.y * _XLoopSpeed);
          u_xlat0.yz = (_Time.yy * float2(_UpDownLoopSpeed, _YLoopSpeed));
          u_xlat0.xyz = sin(u_xlat0.xyz);
          u_xlat0.xyz = (u_xlat0.xyz * float3(_OffsetPower, _OffsetPower, _OffsetPower));
          u_xlat1.xyz = (in_v.vertex.yyy * conv_mxt4x4_1(unity_ObjectToWorld).xyz);
          u_xlat1.xyz = ((conv_mxt4x4_0(unity_ObjectToWorld).xyz * in_v.vertex.xxx) + u_xlat1.xyz);
          u_xlat1.xyz = ((conv_mxt4x4_2(unity_ObjectToWorld).xyz * in_v.vertex.zzz) + u_xlat1.xyz);
          u_xlat6 = max(u_xlat1.y, _MinY);
          u_xlat6 = min(u_xlat6, 1000);
          u_xlat6 = (float(1) / u_xlat6);
          u_xlat0.xyz = (float3(u_xlat6, u_xlat6, u_xlat6) * u_xlat0.xyz);
          u_xlat6 = tex2Dlod(_Mask, float4(float3(in_v.texcoord.xy, 0), 1)).x;
          u_xlat0.xyz = ((u_xlat0.xyz * float3(u_xlat6, u_xlat6, u_xlat6)) + u_xlat1.xyz);
          u_xlat1.xyz = (u_xlat0.yyy * conv_mxt4x4_1(unity_WorldToObject).xyz);
          u_xlat0.xyw = ((conv_mxt4x4_0(unity_WorldToObject).xyz * u_xlat0.xxx) + u_xlat1.xyz);
          u_xlat0.xyz = ((conv_mxt4x4_2(unity_WorldToObject).xyz * u_xlat0.zzz) + u_xlat0.xyw);
          out_v.vertex = UnityObjectToClipPos(u_xlat0);
          out_v.color = in_v.color;
          out_v.texcoord.xy = TRANSFORM_TEX(in_v.texcoord.xy, _MainTex);
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float4 u_xlat0_d;
      float4 u_xlat16_0;
      int u_xlatb0;
      float u_xlat1_d;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat16_0 = tex2D(_MainTex, in_f.texcoord.xy);
          u_xlat1_d = ((_Color.w * u_xlat16_0.w) + (-_CutClip));
          u_xlat0_d = (u_xlat16_0 * _Color);
          out_f.color = u_xlat0_d;
          #ifdef UNITY_ADRENO_ES3
          u_xlatb0 = ((-u_xlat1_d)<0);
          #else
          u_xlatb0 = ((-u_xlat1_d)<0);
          #endif
          if(u_xlatb0)
          {
              discard;
          }
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  SubShader
  {
    Tags
    { 
      "IGNOREPROJECTOR" = "true"
      "QUEUE" = "AlphaTest"
      "RenderType" = "TransparentCutout"
    }
    LOD 200
    Pass // ind: 1, name: 
    {
      Tags
      { 
        "IGNOREPROJECTOR" = "true"
        "QUEUE" = "AlphaTest"
        "RenderType" = "TransparentCutout"
      }
      LOD 200
      Cull Off
      // m_ProgramMask = 6
      CGPROGRAM
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4 _Time;
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_WorldToObject;
      //uniform float4x4 unity_MatrixVP;
      uniform float4 _MainTex_ST;
      uniform float _OffsetPower;
      uniform float _MinY;
      uniform float _XLoopSpeed;
      uniform float _YLoopSpeed;
      uniform float _UpDownLoopSpeed;
      uniform sampler2D _Mask;
      uniform float _CutClip;
      uniform float4 _Color;
      uniform sampler2D _MainTex;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float4 color :COLOR0;
          float2 texcoord :TEXCOORD0;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      float4 u_xlat0;
      float4 u_xlat1;
      float u_xlat6;
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          u_xlat0.x = (_Time.y * _XLoopSpeed);
          u_xlat0.yz = (_Time.yy * float2(_UpDownLoopSpeed, _YLoopSpeed));
          u_xlat0.xyz = sin(u_xlat0.xyz);
          u_xlat0.xyz = (u_xlat0.xyz * float3(_OffsetPower, _OffsetPower, _OffsetPower));
          u_xlat1.xyz = (in_v.vertex.yyy * conv_mxt4x4_1(unity_ObjectToWorld).xyz);
          u_xlat1.xyz = ((conv_mxt4x4_0(unity_ObjectToWorld).xyz * in_v.vertex.xxx) + u_xlat1.xyz);
          u_xlat1.xyz = ((conv_mxt4x4_2(unity_ObjectToWorld).xyz * in_v.vertex.zzz) + u_xlat1.xyz);
          u_xlat6 = max(u_xlat1.y, _MinY);
          u_xlat6 = min(u_xlat6, 1000);
          u_xlat6 = (float(1) / u_xlat6);
          u_xlat0.xyz = (float3(u_xlat6, u_xlat6, u_xlat6) * u_xlat0.xyz);
          u_xlat6 = tex2Dlod(_Mask, float4(float3(in_v.texcoord.xy, 0), 1)).x;
          u_xlat0.xyz = ((u_xlat0.xyz * float3(u_xlat6, u_xlat6, u_xlat6)) + u_xlat1.xyz);
          u_xlat1.xyz = (u_xlat0.yyy * conv_mxt4x4_1(unity_WorldToObject).xyz);
          u_xlat0.xyw = ((conv_mxt4x4_0(unity_WorldToObject).xyz * u_xlat0.xxx) + u_xlat1.xyz);
          u_xlat0.xyz = ((conv_mxt4x4_2(unity_WorldToObject).xyz * u_xlat0.zzz) + u_xlat0.xyw);
          out_v.vertex = UnityObjectToClipPos(u_xlat0);
          out_v.color = in_v.color;
          out_v.texcoord.xy = TRANSFORM_TEX(in_v.texcoord.xy, _MainTex);
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float4 u_xlat0_d;
      float4 u_xlat16_0;
      int u_xlatb0;
      float u_xlat1_d;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat16_0 = tex2D(_MainTex, in_f.texcoord.xy);
          u_xlat1_d = ((_Color.w * u_xlat16_0.w) + (-_CutClip));
          u_xlat0_d = (u_xlat16_0 * _Color);
          out_f.color = u_xlat0_d;
          #ifdef UNITY_ADRENO_ES3
          u_xlatb0 = (u_xlat1_d<0);
          #else
          u_xlatb0 = (u_xlat1_d<0);
          #endif
          if(u_xlatb0)
          {
              discard;
          }
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack Off
}
