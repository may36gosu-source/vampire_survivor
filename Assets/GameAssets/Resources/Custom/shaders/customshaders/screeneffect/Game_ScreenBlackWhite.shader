Shader "Game/ScreenBlackWhite"
{
  Properties
  {
    _Lerp ("灰度", Range(0, 1)) = 1
    _Flip ("黑白翻转", Range(0, 1)) = 0
    _Power ("强度", Range(0, 1)) = 0
    _Center ("中心点", Vector) = (0.5,0.5,0,0)
    _LineNoiseTex ("速度线纹理", 2D) = "black" {}
    _SpeedMaskThreshold ("速度线阈值", Vector) = (0.3,1,0,0)
    _SpeedMaskSpeed ("速度", Vector) = (1,0,0,0)
    _SpeedLineColor ("速度线颜色", Color) = (1,1,1,1)
    _SpaceCenter ("中心挖空", Vector) = (0,1,0,0)
    _BlackColor ("黑色替换", Color) = (0,0,0,1)
    _WhiteColor ("白色替换", Color) = (1,1,1,1)
    [Toggle(_RGB_SPLIT_)] rgbSplit ("rgb分离", float) = 0
  }
  SubShader
  {
    Tags
    { 
      "IGNOREPROJECTOR" = "true"
      "QUEUE" = "Transparent+200"
      "RenderType" = "Transparent"
    }
    Pass // ind: 1, name: 
    {
      Tags
      { 
      }
      ZClip Off
      ZWrite Off
      Cull Off
      Stencil
      { 
        Ref 0
        ReadMask 0
        WriteMask 0
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
      // m_ProgramMask = 0
      
    } // end phase
    Pass // ind: 2, name: 
    {
      Tags
      { 
        "IGNOREPROJECTOR" = "true"
        "QUEUE" = "Transparent+200"
        "RenderType" = "Transparent"
      }
      ZTest Always
      ZWrite Off
      Cull Off
      // m_ProgramMask = 6
      CGPROGRAM
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4 _ProjectionParams;
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_MatrixVP;
      //uniform float4 _Time;
      uniform float _Lerp;
      uniform float _Flip;
      uniform float _Power;
      uniform float4 _LineNoiseTex_ST;
      uniform float2 _SpeedMaskThreshold;
      uniform float2 _SpeedMaskSpeed;
      uniform float2 _Center;
      uniform float2 _SpaceCenter;
      uniform float4 _SpeedLineColor;
      uniform float3 _BlackColor;
      uniform float3 _WhiteColor;
      uniform sampler2D _LineNoiseTex;
      uniform sampler2D _GrabTexture;
      struct appdata_t
      {
          float4 vertex :POSITION0;
      };
      
      struct OUT_Data_Vert
      {
          float4 texcoord :TEXCOORD0;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
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
          u_xlat0 = UnityObjectToClipPos(in_v.vertex);
          u_xlat1.x = (u_xlat0.y * _ProjectionParams.x);
          u_xlat1.w = (u_xlat1.x * 0.5);
          u_xlat1.xz = (u_xlat0.xw * float2(0.5, 0.5));
          out_v.texcoord.xy = (u_xlat1.zz + u_xlat1.xw);
          out_v.texcoord.zw = u_xlat0.zw;
          out_v.vertex = u_xlat0;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float4 u_xlat0_d;
      float2 u_xlat1_d;
      float4 u_xlat16_1;
      float3 u_xlat2;
      float u_xlat3;
      float2 u_xlat4;
      int u_xlatb4;
      float3 u_xlat5;
      int u_xlatb5;
      float2 u_xlat6;
      float u_xlat7;
      float u_xlat9;
      int u_xlatb9;
      int u_xlatb10;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = (in_f.texcoord.xy / in_f.texcoord.ww);
          u_xlat6.xy = (u_xlat0_d.xy + (-_Center.xy));
          u_xlat1_d.x = max(abs(u_xlat6.x), abs(u_xlat6.y));
          u_xlat1_d.x = (float(1) / u_xlat1_d.x);
          u_xlat4.x = min(abs(u_xlat6.x), abs(u_xlat6.y));
          u_xlat1_d.x = (u_xlat1_d.x * u_xlat4.x);
          u_xlat4.x = (u_xlat1_d.x * u_xlat1_d.x);
          u_xlat7 = ((u_xlat4.x * 0.0208350997) + (-0.0851330012));
          u_xlat7 = ((u_xlat4.x * u_xlat7) + 0.180141002);
          u_xlat7 = ((u_xlat4.x * u_xlat7) + (-0.330299497));
          u_xlat4.x = ((u_xlat4.x * u_xlat7) + 0.999866009);
          u_xlat7 = (u_xlat4.x * u_xlat1_d.x);
          u_xlat7 = ((u_xlat7 * (-2)) + 1.57079637);
          #ifdef UNITY_ADRENO_ES3
          u_xlatb10 = (abs(u_xlat6.x)<abs(u_xlat6.y));
          #else
          u_xlatb10 = (abs(u_xlat6.x)<abs(u_xlat6.y));
          #endif
          u_xlat7 = (u_xlatb10)?(u_xlat7):(float(0));
          u_xlat1_d.x = ((u_xlat1_d.x * u_xlat4.x) + u_xlat7);
          #ifdef UNITY_ADRENO_ES3
          u_xlatb4 = (u_xlat6.x<(-u_xlat6.x));
          #else
          u_xlatb4 = (u_xlat6.x<(-u_xlat6.x));
          #endif
          u_xlat4.x = (u_xlatb4)?((-3.14159274)):(float(0));
          u_xlat1_d.x = (u_xlat4.x + u_xlat1_d.x);
          u_xlat4.x = min(u_xlat6.x, u_xlat6.y);
          #ifdef UNITY_ADRENO_ES3
          u_xlatb4 = (u_xlat4.x<(-u_xlat4.x));
          #else
          u_xlatb4 = (u_xlat4.x<(-u_xlat4.x));
          #endif
          u_xlat7 = max(u_xlat6.x, u_xlat6.y);
          u_xlat6.x = length(u_xlat6.xy);
          #ifdef UNITY_ADRENO_ES3
          u_xlatb9 = (u_xlat7>=(-u_xlat7));
          #else
          u_xlatb9 = (u_xlat7>=(-u_xlat7));
          #endif
          u_xlatb9 = (u_xlatb9 && u_xlatb4);
          u_xlat9 = (u_xlatb9)?((-u_xlat1_d.x)):(u_xlat1_d.x);
          u_xlat9 = ((u_xlat9 * 0.159154952) + 0.5);
          u_xlat1_d.x = frac(_Time.x);
          u_xlat2.y = ((u_xlat1_d.x * _SpeedMaskSpeed.xxxy.w) + u_xlat9);
          u_xlat9 = (u_xlat6.x + u_xlat6.x);
          u_xlat6.x = ((u_xlat6.x * 2) + (-_SpaceCenter.xxxy.z));
          u_xlat2.x = (((-u_xlat1_d.x) * _SpeedMaskSpeed.xxxy.z) + u_xlat9);
          u_xlat1_d.xy = TRANSFORM_TEX(u_xlat2.xy, _LineNoiseTex);
          u_xlat16_1.xy = tex2D(_LineNoiseTex, u_xlat1_d.xy).xw;
          u_xlat9 = (u_xlat16_1.y * u_xlat16_1.x);
          u_xlat1_d.x = ((-_SpaceCenter.xxxy.z) + _SpaceCenter.xxxy.w);
          u_xlat1_d.x = (float(1) / u_xlat1_d.x);
          u_xlat6.x = (u_xlat6.x * u_xlat1_d.x);
          #ifdef UNITY_ADRENO_ES3
          u_xlat6.x = min(max(u_xlat6.x, 0), 1);
          #else
          u_xlat6.x = clamp(u_xlat6.x, 0, 1);
          #endif
          u_xlat1_d.x = ((u_xlat6.x * (-2)) + 3);
          u_xlat6.x = (u_xlat6.x * u_xlat6.x);
          u_xlat6.x = (u_xlat6.x * u_xlat1_d.x);
          u_xlat1_d.x = (u_xlat6.x * u_xlat9);
          u_xlat6.x = ((u_xlat9 * u_xlat6.x) + (-_SpeedMaskThreshold.x));
          u_xlat9 = ((u_xlat1_d.x * 2) + (-1));
          u_xlat4.xy = (float2(u_xlat9, u_xlat9) * u_xlat0_d.xy);
          u_xlat1_d.xy = (u_xlat1_d.xx * u_xlat4.xy);
          u_xlat0_d.xy = ((u_xlat1_d.xy * float2(0.0500000007, 0.0500000007)) + u_xlat0_d.xy);
          u_xlat16_1 = tex2D(_GrabTexture, u_xlat0_d.xy);
          u_xlat0_d.xyw = ((u_xlat16_1.xyz * float3(-2, (-2), (-2))) + float3(1, 1, 1));
          u_xlat0_d.xyw = ((float3(float3(_Flip, _Flip, _Flip)) * u_xlat0_d.xyw) + u_xlat16_1.xyz);
          u_xlat2.x = dot(u_xlat0_d.xyw, float3(0.298999995, 0.587000012, 0.114));
          #ifdef UNITY_ADRENO_ES3
          u_xlatb5 = (u_xlat2.x>=0.5);
          #else
          u_xlatb5 = (u_xlat2.x>=0.5);
          #endif
          u_xlat5.x = (u_xlatb5)?(1):(float(0));
          u_xlat5.x = ((-u_xlat2.x) + u_xlat5.x);
          u_xlat2.x = ((_Power * u_xlat5.x) + u_xlat2.x);
          u_xlat5.xyz = ((-_BlackColor.xyz) + _WhiteColor.xyz);
          u_xlat2.xyz = ((u_xlat2.xxx * u_xlat5.xyz) + _BlackColor.xyz);
          u_xlat2.xyz = ((-u_xlat0_d.xyw) + u_xlat2.xyz);
          u_xlat16_1.xyz = ((float3(_Lerp, _Lerp, _Lerp) * u_xlat2.xyz) + u_xlat0_d.xyw);
          u_xlat0_d.x = ((-_SpeedMaskThreshold.x) + _SpeedMaskThreshold.y);
          u_xlat0_d.x = (float(1) / u_xlat0_d.x);
          u_xlat0_d.x = (u_xlat0_d.x * u_xlat6.x);
          #ifdef UNITY_ADRENO_ES3
          u_xlat0_d.x = min(max(u_xlat0_d.x, 0), 1);
          #else
          u_xlat0_d.x = clamp(u_xlat0_d.x, 0, 1);
          #endif
          u_xlat3 = ((u_xlat0_d.x * (-2)) + 3);
          u_xlat0_d.x = (u_xlat0_d.x * u_xlat0_d.x);
          u_xlat0_d.x = (u_xlat0_d.x * u_xlat3);
          u_xlat0_d = ((u_xlat0_d.xxxx * _SpeedLineColor) + u_xlat16_1);
          out_f.color = u_xlat0_d;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack Off
}
