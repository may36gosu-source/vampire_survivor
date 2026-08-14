Shader "leeveel/FxAllInOne"
{
  Properties
  {
    [Header(Render)] [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend ("SrcBlend", float) = 1
    [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend ("DstBlend", float) = 0
    [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull Mode", float) = 2
    [Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", float) = 0
    [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", float) = 0
    [Header(Base)] [HDR] _TintColor ("主颜色", Color) = (1,1,1,1)
    _MainTex ("主纹理", 2D) = "black" {}
    _Main_Speed_Intensity_Rotate ("流动(XY) 强度(Z) 旋转(W)", Vector) = (0,0,1,0)
    [KeywordEnum(Repeat, Clamp)] _WarpMode ("Wrap Mode", float) = 0
    [Header(Mask)] [Toggle] _MaskToggle1 ("开关", float) = 0
    _MaskTex1 ("遮罩纹理1(R)", 2D) = "white" {}
    _Mask_Speed1 ("流动1(XY)", Vector) = (0,0,0,0)
    [Toggle] _MaskToggle2 ("开关", float) = 0
    _MaskTex2 ("遮罩纹理2(R)", 2D) = "white" {}
    _Mask_Speed2 ("流动2(XY)", Vector) = (0,0,0,0)
    [Toggle] _MaskToggle3 ("开关", float) = 0
    _MaskTex3 ("遮罩纹理3(R)", 2D) = "white" {}
    _Mask_Speed3 ("流动3(XY)", Vector) = (0,0,0,0)
    [Header(Dissolve)] [Toggle] _DissolveToggle ("开关", float) = 0
    _DissolveTex ("溶解纹理(R)", 2D) = "white" {}
    _Dissolve_Speed ("流动(XY)", Vector) = (0,0,0,0)
    _Cutoff ("溶解度(smoothstep)", Range(0, 1)) = 0.5
    [Toggle] _DissolveCurveToggle ("自定义曲线开关(打开时接管溶解度)", float) = 0
    [NoScaleOffset] _DissolveRampTex ("溶解Ramp", 2D) = "white" {}
    [Header(Distortion)] [MaterialToggle(DISTORTIONENABLE)] _DistortionToggle ("Enabled", float) = 0
    _DistortionTex ("扰动纹理(R)", 2D) = "white" {}
    _Distort_Speed ("流动(XY)", Vector) = (0,0,0,0)
    _DistortionPower ("强度", Range(0, 1)) = 0.5
    [Header(Rim)] [Toggle] _RimToggle ("开关", float) = 0
    [Toggle] _Invert ("Invert", float) = 0
    _RimColor ("Rim Color", Color) = (1,0.65,0,1)
    _Rim_Scale_Power ("Fade(X) Power(Y)", Vector) = (1,1,0,0)
  }
  SubShader
  {
    Tags
    { 
      "QUEUE" = "Transparent"
      "RenderType" = "Transparent"
    }
    Pass // ind: 1, name: 
    {
      Tags
      { 
        "QUEUE" = "Transparent"
        "RenderType" = "Transparent"
      }
      ZWrite Off
      Cull Off
      Stencil
      { 
        Ref 0
        ReadMask 255
        WriteMask 255
        Pass Keep
        Fail Keep
        ZFail Keep
        PassFront Keep
        FailFront Keep
        ZFailFront Keep
        PassBack Keep
        FailBack Keep
        ZFailBack Keep
      } 
      Blend Zero Zero
      // m_ProgramMask = 6
      CGPROGRAM
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4 _Time;
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_MatrixVP;
      uniform float4 _MainTex_ST;
      uniform float4 _Main_Speed_Intensity_Rotate;
      uniform float4 _TintColor;
      uniform sampler2D _MainTex;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float4 color :COLOR0;
          float4 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Vert
      {
          float4 color :COLOR0;
          float4 texcoord :TEXCOORD0;
          float4 texcoord7 :TEXCOORD7;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float4 color :COLOR0;
          float4 texcoord :TEXCOORD0;
      };
      
      struct OUT_Data_Frag
      {
          float4 color :SV_Target0;
      };
      
      float4 u_xlat0;
      float4 u_xlat1;
      OUT_Data_Vert vert(appdata_t in_v)
      {
          OUT_Data_Vert out_v;
          out_v.vertex = UnityObjectToClipPos(in_v.vertex);
          out_v.color = in_v.color;
          u_xlat0.xy = TRANSFORM_TEX(in_v.texcoord.xy, _MainTex);
          out_v.texcoord.xy = ((_Main_Speed_Intensity_Rotate.xy * _Time.yy) + u_xlat0.xy);
          out_v.texcoord.zw = float2(0, 0);
          out_v.texcoord7 = float4(0, 0, 0, 0);
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float4 u_xlat0_d;
      float4 u_xlat16_0;
      float2 u_xlat1_d;
      float u_xlat2;
      float3 u_xlat3;
      float u_xlat8;
      int u_xlatb8;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = ((in_f.texcoord.xy * float2(2, 2)) + float2(-1, (-1)));
          u_xlat1_d.x = sin(_Main_Speed_Intensity_Rotate.w);
          u_xlat2 = cos(_Main_Speed_Intensity_Rotate.w);
          u_xlat3.z = u_xlat1_d.x;
          u_xlat3.y = u_xlat2;
          u_xlat3.x = (-u_xlat1_d.x);
          u_xlat1_d.y = dot(u_xlat3.xy, u_xlat0_d.xy);
          u_xlat1_d.x = dot(u_xlat3.yz, u_xlat0_d.xy);
          u_xlat0_d.xy = ((u_xlat1_d.xy * float2(0.5, 0.5)) + float2(0.5, 0.5));
          u_xlat0_d.xy = (u_xlat0_d.xy + (-in_f.texcoord.xy));
          #ifdef UNITY_ADRENO_ES3
          u_xlatb8 = (_Main_Speed_Intensity_Rotate.w!=0);
          #else
          u_xlatb8 = (_Main_Speed_Intensity_Rotate.w!=0);
          #endif
          u_xlat8 = (u_xlatb8)?(1):(float(0));
          u_xlat0_d.xy = ((float2(u_xlat8, u_xlat8) * u_xlat0_d.xy) + in_f.texcoord.xy);
          u_xlat16_0 = tex2D(_MainTex, u_xlat0_d.xy);
          u_xlat16_0 = (u_xlat16_0 * _TintColor);
          u_xlat0_d = (u_xlat16_0 * _Main_Speed_Intensity_Rotate.zzzz);
          u_xlat0_d = (u_xlat0_d * in_f.color);
          out_f.color = u_xlat0_d;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack Off
}
