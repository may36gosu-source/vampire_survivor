Shader "magesbox/Erosion_Vertex_Move_Noise_Mask"
{
  Properties
  {
    [Enum(UnityEngine.Rendering.CullMode)] _Cullmode ("Cull Mode", float) = 0
    [Enum(Add,1,Alpha,5)] _Blend1 ("混合参数1", float) = 1
    [Enum(Add,1,Alpha,10)] _Blend2 ("混合参数2", float) = 1
    [Enum(Disable,0,LessEqual,4,GreaterEqual,7)] _ZTest ("ZTest", float) = 0
    [HDR] _Color ("Color", Color) = (0.5,0.5,0.5,1)
    _Texure ("Main Texure", 2D) = "white" {}
    _DistortTex ("DistortTex", 2D) = "block" {}
    _MainTexDistortParam ("扭曲主纹理:U速度, V速度, 强度", Vector) = (0,0,0.2,1)
    [HDR] _Color ("Color", Color) = (0.5,0.5,0.5,1)
    _Soft_Value ("Soft_Value", float) = 0
    _Erosion_Texure ("Erosion_Texure", 2D) = "white" {}
    _Mask ("Mask", 2D) = "white" {}
    _U_Move ("Mask_U_Move", float) = 0
    _V_Move ("Mask_V_Move", float) = 0
    _MaskTexDistortParam ("扭曲Mask:U速度, V速度, 强度", Vector) = (0,0,0.2,1)
    _Mask2 ("Mask2", 2D) = "white" {}
    _U2_Move ("Mask2_U_Move", float) = 0
    _V2_Move ("Mask2_V_Move", float) = 0
    _Mask2TexDistortParam ("扭曲Mask2:U速度, V速度, 强度", Vector) = (0,0,0.2,1)
    _Vertex_Move ("Vertex_Move", 2D) = "white" {}
    _Vertex_offset ("Vertex_offset", Vector) = (0,0,0,0)
    _Vertex_U_Move ("Vertex_U_Move", float) = 0
    _Vertex_V_Move ("Vertex_V_Move", float) = 0
    [HideInInspector] _Cutoff ("Alpha cutoff", Range(0, 1)) = 0.5
    _StencilComp ("Stencil Comparison", float) = 8
    _Stencil ("Stencil ID", float) = 0
    _StencilOp ("Stencil Operation", float) = 0
    _StencilWriteMask ("Stencil Write Mask", float) = 255
    _StencilReadMask ("Stencil Read Mask", float) = 255
    _ColorMask ("Color Mask", float) = 15
  }
  SubShader
  {
    Tags
    { 
      "IGNOREPROJECTOR" = "true"
      "QUEUE" = "Transparent"
      "RenderType" = "Transparent"
    }
    Pass // ind: 1, name: FORWARD
    {
      Name "FORWARD"
      Tags
      { 
        "IGNOREPROJECTOR" = "true"
        "LIGHTMODE" = "FORWARDBASE"
        "QUEUE" = "Transparent"
        "RenderType" = "Transparent"
        "SHADOWSUPPORT" = "true"
      }
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
      Blend Zero Zero
      // m_ProgramMask = 6
      CGPROGRAM
      #pragma multi_compile DIRECTIONAL
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      #define conv_mxt4x4_3(mat4x4) float4(mat4x4[0].w,mat4x4[1].w,mat4x4[2].w,mat4x4[3].w)
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4 _Time;
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_WorldToObject;
      //uniform float4x4 unity_MatrixVP;
      uniform float4 _Vertex_Move_ST;
      uniform float4 _Vertex_offset;
      uniform float _Vertex_U_Move;
      uniform float _Vertex_V_Move;
      uniform sampler2D _Vertex_Move;
      uniform float4 _Texure_ST;
      uniform float4 _DistortTex_ST;
      uniform float4 _MainTexDistortParam;
      uniform float4 _Color;
      uniform float4 _Erosion_Texure_ST;
      uniform float _Soft_Value;
      uniform float _U_Move;
      uniform float _V_Move;
      uniform float4 _MaskTexDistortParam;
      uniform float4 _Mask_ST;
      uniform float _U2_Move;
      uniform float _V2_Move;
      uniform float4 _Mask2TexDistortParam;
      uniform float4 _Mask2_ST;
      uniform sampler2D _DistortTex;
      uniform sampler2D _Texure;
      uniform sampler2D _Erosion_Texure;
      uniform sampler2D _Mask;
      uniform sampler2D _Mask2;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float3 normal :NORMAL0;
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 color :COLOR0;
      };
      
      struct OUT_Data_Vert
      {
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 texcoord2 :TEXCOORD2;
          float3 texcoord3 :TEXCOORD3;
          float4 color :COLOR0;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 color :COLOR0;
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
          u_xlat0.xy = ((float2(_Vertex_U_Move, _Vertex_V_Move) * _Time.yy) + in_v.texcoord.xy);
          u_xlat0.xy = TRANSFORM_TEX(u_xlat0.xy, _Vertex_Move);
          u_xlat0.xyz = tex2Dlod(_Vertex_Move, float4(float3(u_xlat0.xy, 0), 0)).xyz;
          u_xlat0.xyz = (u_xlat0.xyz * in_v.normal.xyz);
          u_xlat0.xyz = (u_xlat0.xyz * in_v.texcoord1.www);
          u_xlat0.xyz = ((u_xlat0.xyz * _Vertex_offset.xyz) + in_v.vertex.xyz);
          u_xlat1 = (u_xlat0.yyyy * conv_mxt4x4_1(unity_ObjectToWorld));
          u_xlat1 = ((conv_mxt4x4_0(unity_ObjectToWorld) * u_xlat0.xxxx) + u_xlat1);
          u_xlat0 = ((conv_mxt4x4_2(unity_ObjectToWorld) * u_xlat0.zzzz) + u_xlat1);
          u_xlat1 = (u_xlat0 + conv_mxt4x4_3(unity_ObjectToWorld));
          out_v.texcoord2 = ((conv_mxt4x4_3(unity_ObjectToWorld) * in_v.vertex.wwww) + u_xlat0);
          out_v.vertex = mul(unity_MatrixVP, u_xlat1);
          out_v.texcoord.xy = in_v.texcoord.xy;
          out_v.texcoord1 = in_v.texcoord1;
          u_xlat0.x = dot(in_v.normal.xyz, conv_mxt4x4_0(unity_WorldToObject).xyz);
          u_xlat0.y = dot(in_v.normal.xyz, conv_mxt4x4_1(unity_WorldToObject).xyz);
          u_xlat0.z = dot(in_v.normal.xyz, conv_mxt4x4_2(unity_WorldToObject).xyz);
          out_v.texcoord3.xyz = normalize(u_xlat0.xyz);
          out_v.color = in_v.color;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float3 u_xlat0_d;
      float4 u_xlat16_0;
      float4 u_xlat1_d;
      float4 u_xlat16_1;
      float2 u_xlat2;
      float4 u_xlat16_2;
      float3 u_xlat3;
      float3 u_xlat5;
      float2 u_xlat6_d;
      float u_xlat16_6;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = ((float2(_U_Move, _V_Move) * _Time.yy) + in_f.texcoord.xy);
          u_xlat0_d.xy = TRANSFORM_TEX(u_xlat0_d.xy, _Mask);
          u_xlat6_d.xy = TRANSFORM_TEX(in_f.texcoord.xy, _DistortTex);
          u_xlat1_d.xy = ((_Time.yy * _MaskTexDistortParam.xy) + u_xlat6_d.xy);
          u_xlat16_1.x = tex2D(_DistortTex, u_xlat1_d.xy).x;
          u_xlat0_d.xy = ((u_xlat16_1.xx * _MaskTexDistortParam.zz) + u_xlat0_d.xy);
          u_xlat16_1 = tex2D(_Mask, u_xlat0_d.xy);
          u_xlat0_d.xy = ((_Time.yy * _Mask2TexDistortParam.xy) + u_xlat6_d.xy);
          u_xlat6_d.xy = ((_Time.yy * _MainTexDistortParam.xy) + u_xlat6_d.xy);
          u_xlat16_6 = tex2D(_DistortTex, u_xlat6_d.xy).x;
          u_xlat16_0.x = tex2D(_DistortTex, u_xlat0_d.xy).x;
          u_xlat3.xz = ((float2(_U2_Move, _V2_Move) * _Time.yy) + in_f.texcoord.xy);
          u_xlat3.xz = TRANSFORM_TEX(u_xlat3.xz, _Mask2);
          u_xlat0_d.xy = ((u_xlat16_0.xx * _Mask2TexDistortParam.zz) + u_xlat3.xz);
          u_xlat16_2 = tex2D(_Mask2, u_xlat0_d.xy);
          u_xlat1_d = (u_xlat16_1 * u_xlat16_2);
          u_xlat0_d.xy = (in_f.texcoord.xy + in_f.texcoord1.xy);
          u_xlat0_d.xy = TRANSFORM_TEX(u_xlat0_d.xy, _Texure);
          u_xlat0_d.xy = ((float2(u_xlat16_6, u_xlat16_6) * _MainTexDistortParam.zz) + u_xlat0_d.xy);
          u_xlat16_0 = tex2D(_Texure, u_xlat0_d.xy);
          u_xlat0_d.xyz = (u_xlat16_0.xyz * _Color.xyz);
          u_xlat2.xy = TRANSFORM_TEX(in_f.texcoord.xy, _Erosion_Texure);
          u_xlat16_2.x = tex2D(_Erosion_Texure, u_xlat2.xy).x;
          u_xlat5.x = ((-_Soft_Value) + (-1.5));
          u_xlat5.x = ((in_f.texcoord1.z * u_xlat5.x) + _Soft_Value);
          u_xlat2.x = ((u_xlat16_2.x * _Soft_Value) + (-u_xlat5.x));
          #ifdef UNITY_ADRENO_ES3
          u_xlat2.x = min(max(u_xlat2.x, 0), 1);
          #else
          u_xlat2.x = clamp(u_xlat2.x, 0, 1);
          #endif
          u_xlat5.xyz = (u_xlat2.xxx * in_f.color.xyz);
          u_xlat0_d.xyz = (u_xlat0_d.xyz * u_xlat5.xyz);
          out_f.color.xyz = (u_xlat1_d.xyz * u_xlat0_d.xyz);
          u_xlat0_d.x = (in_f.color.w * _Color.w);
          u_xlat0_d.x = (u_xlat16_0.w * u_xlat0_d.x);
          u_xlat0_d.x = (u_xlat2.x * u_xlat0_d.x);
          out_f.color.w = (u_xlat0_d.x * u_xlat1_d.w);
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack "Diffuse"
}
