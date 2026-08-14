Shader "Effect/GlitchSplit"
{
  Properties
  {
    [Enum(Off, 0, On, 1)] _ZWrite ("ZWrite", float) = 0
    [Enum(UnityEngine.Rendering.CompareFunction)] _ZTest ("ZTest", float) = 8
    [Enum(UnityEngine.Rendering.CullMode)] _Cull ("Cull Mode", float) = 0
    _mask ("mask", 2D) = "white" {}
    _Base_alpha ("Base_alpha", Range(0, 3)) = 1
    _scale ("scale", Range(0, 1)) = 0.1
    _shift ("shift", Range(0, 1)) = 1
    [Toggle(_CUSTOM1_X_CONTROL_SHIFT_ON)] _custom1_x_control_shift ("custom1_x_control_shift", float) = 0
    [NoScaleOffset] _mask2 ("mask2", 2D) = "white" {}
    _noise_mask_uv ("noise_mask_uv", Vector) = (1,1,0,0)
    _X_speed ("X_speed", Range(-1, 1)) = 1
    _Y_speed ("Y_speed", Range(-1, 1)) = 0
    _speed ("speed", Range(0, 4)) = 1
    [Toggle(_CUSTOM1_ZW_MOVE_UV_ON)] _custom1_zw_move_uv ("custom1_zw_move_uv", float) = 0
    [HideInInspector] _texcoord ("", 2D) = "white" {}
  }
  SubShader
  {
    Tags
    { 
      "IGNOREPROJECTOR" = "true"
      "PreviewType" = "Plane"
      "QUEUE" = "Transparent"
      "RenderType" = "Transparent"
    }
    LOD 100
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
    Pass // ind: 2, name: Unlit
    {
      Name "Unlit"
      Tags
      { 
        "IGNOREPROJECTOR" = "true"
        "LIGHTMODE" = "FORWARDBASE"
        "PreviewType" = "Plane"
        "QUEUE" = "Transparent"
        "RenderType" = "Transparent"
      }
      LOD 100
      ZWrite Off
      Cull Off
      Blend SrcAlpha OneMinusSrcAlpha
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
      uniform float _shift;
      uniform float _speed;
      uniform float _X_speed;
      uniform float _Y_speed;
      uniform float4 _noise_mask_uv;
      uniform float _scale;
      uniform float4 _mask_ST;
      uniform float _Base_alpha;
      uniform sampler2D _mask2;
      uniform sampler2D _GrabTexture;
      uniform sampler2D _mask;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float4 color :COLOR0;
          float4 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
      };
      
      struct OUT_Data_Vert
      {
          float4 texcoord1 :TEXCOORD1;
          float4 texcoord2 :TEXCOORD2;
          float4 texcoord3 :TEXCOORD3;
          float4 color :COLOR0;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float4 texcoord1 :TEXCOORD1;
          float4 texcoord2 :TEXCOORD2;
          float4 color :COLOR0;
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
          out_v.vertex = u_xlat0;
          u_xlat0.y = (u_xlat0.y * _ProjectionParams.x);
          u_xlat1.xzw = (u_xlat0.xwy * float3(0.5, 0.5, 0.5));
          out_v.texcoord1.zw = u_xlat0.zw;
          out_v.texcoord1.xy = (u_xlat1.zz + u_xlat1.xw);
          out_v.texcoord2 = in_v.texcoord;
          out_v.texcoord3 = in_v.texcoord1;
          out_v.color = in_v.color;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float2 u_xlat0_d;
      float4 u_xlat16_0;
      float3 u_xlat1_d;
      float u_xlat16_1;
      float2 u_xlat2;
      float2 u_xlat7;
      float u_xlat10;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = TRANSFORM_TEX(in_f.texcoord2.xy, _mask);
          u_xlat16_0.x = tex2D(_mask, u_xlat0_d.xy).x;
          u_xlat0_d.x = (u_xlat16_0.x * _Base_alpha);
          u_xlat16_0.w = (u_xlat0_d.x * in_f.color.w);
          #ifdef UNITY_ADRENO_ES3
          u_xlat16_0.w = min(max(u_xlat16_0.w, 0), 1);
          #else
          u_xlat16_0.w = clamp(u_xlat16_0.w, 0, 1);
          #endif
          u_xlat1_d.x = dot(float2(_X_speed, _Y_speed), float2(_X_speed, _Y_speed));
          u_xlat1_d.x = rsqrt(u_xlat1_d.x);
          u_xlat1_d.xy = (u_xlat1_d.xx * float2(_X_speed, _Y_speed));
          u_xlat7.x = (_Time.y * _speed);
          u_xlat2.xy = ((in_f.texcoord2.xy * _noise_mask_uv.xy) + _noise_mask_uv.zw);
          u_xlat1_d.xy = ((u_xlat7.xx * u_xlat1_d.xy) + u_xlat2.xy);
          u_xlat16_1 = tex2D(_mask2, u_xlat1_d.xy).x;
          u_xlat1_d.x = (u_xlat16_1 * _shift);
          u_xlat1_d.x = (u_xlat1_d.x * _scale);
          u_xlat1_d.z = (-u_xlat1_d.x);
          u_xlat10 = (in_f.texcoord1.w * 0.5);
          u_xlat2.x = (((-in_f.texcoord1.w) * 0.5) + in_f.texcoord1.y);
          u_xlat2.y = ((u_xlat2.x * _ProjectionParams.x) + u_xlat10);
          u_xlat2.x = in_f.texcoord1.x;
          u_xlat2.xy = (u_xlat2.xy / in_f.texcoord1.ww);
          u_xlat1_d.y = 0;
          u_xlat7.xy = (u_xlat1_d.zy + u_xlat2.xy);
          u_xlat1_d.xy = (u_xlat1_d.xy + u_xlat2.xy);
          u_xlat16_0.y = tex2D(_GrabTexture, u_xlat2.xy).y;
          u_xlat16_0.x = tex2D(_GrabTexture, u_xlat1_d.xy).x;
          u_xlat16_0.z = tex2D(_GrabTexture, u_xlat7.xy).z;
          out_f.color = u_xlat16_0;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack Off
}
