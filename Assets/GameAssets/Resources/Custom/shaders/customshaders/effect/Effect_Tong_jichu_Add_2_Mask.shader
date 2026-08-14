Shader "Effect/Tong_jichu_Add_2_Mask"
{
  Properties
  {
    _Color ("Color", Color) = (1,1,1,1)
    _Tex ("Tex", 2D) = "white" {}
    _Tex_U ("Tex_U", float) = 0
    [MaterialToggle] _Tex_U_X ("Tex_U_X", float) = 0
    _Tex_V ("Tex_V", float) = 0
    [MaterialToggle] _Tex_V_Y ("Tex_V_Y", float) = 0
    _Tex_Ang ("Tex_Ang", Range(0, 360)) = 0
    [MaterialToggle] _Tex_Rotate ("Tex_Rotate--------------------------------------", float) = 0
    _Tex_Rotate_speed ("Tex_Rotate_speed--------------------------------------", float) = 0
    _Tex_Mask ("Tex_Mask", 2D) = "white" {}
    _Tex_Mask_U ("Tex_Mask_U", float) = 0
    [MaterialToggle] _Tex_Mask_U_Z ("Tex_Mask_U_Z", float) = 0
    _Tex_Mask_V ("Tex_Mask_V", float) = 0
    [MaterialToggle] _Tex_Mask_V_W ("Tex_Mask_V_W", float) = 0
    _Tex_Mssk_Ang ("Tex_Mssk_Ang", Range(0, 360)) = 0
    [MaterialToggle] _Tex_Mask_Rotate ("Tex_Mask_Rotate--------------------------------------", float) = 0
    _Tex_Mask_Rotate_speed ("Tex_Mask_Rotate_speed--------------------------------------", float) = 0
    _Tex_Mask_2 ("Tex_Mask_2", 2D) = "white" {}
    _Tex_Mask_2_U ("Tex_Mask_2_U", float) = 0
    [MaterialToggle] _Tex_Mask_2_U_X2 ("Tex_Mask_2_U_X2", float) = 0
    _Tex_Mask_2_V ("Tex_Mask_2_V", float) = 0
    [MaterialToggle] _Tex_Mask_2_V_Y2 ("Tex_Mask_2_V_Y2", float) = 0
    _Tex_Mask_2_Ang ("Tex_Mask_2_Ang", Range(0, 360)) = 0
    [MaterialToggle] _Tex_Mask_2_Rotate ("Tex_Mask_2_Rotate--------------------------------------", float) = 0
    _Tex_Mask_2_Rotate_speed ("Tex_Mask_2_Rotate_speed--------------------------------------", float) = 0
    _Tex_UVadd ("Tex_UVadd", 2D) = "white" {}
    _Tex_UVadd_Intensity ("Tex_UVadd_Intensity", float) = 0
    [MaterialToggle] _Tex_UVAdd_ ("Tex_UVAdd_", float) = 0
    [MaterialToggle] _XY ("XY", float) = 0
    _Tex_UVadd_U ("Tex_UVadd_U", float) = 0
    [MaterialToggle] _Tex_UVadd_U_Z2 ("Tex_UVadd_U_Z2", float) = 0
    _Tex_UVadd_V ("Tex_UVadd_V", float) = 0
    [MaterialToggle] _Tex_UVadd_V_W2 ("Tex_UVadd_V_W2", float) = 0
    _Tex_UVadd_Ang ("Tex_UVadd_Ang", Range(0, 360)) = 0
    [MaterialToggle] _Tex_UVadd_Rotate ("Tex_UVadd_Rotate--------------------------------------", float) = 0
    _Tex_UVadd_Rotate_speed ("Tex_UVadd_Rotate_speed--------------------------------------", float) = 0
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
      }
      ZWrite Off
      Cull Off
      Blend One One
      ColorMask RGB
      // m_ProgramMask = 6
      CGPROGRAM
      //#pragma target 4.0
      
      #pragma vertex vert
      #pragma fragment frag
      
      #include "UnityCG.cginc"
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_MatrixVP;
      //uniform float4 _Time;
      uniform float4 _Tex_ST;
      uniform float4 _Color;
      uniform float4 _Tex_Mask_ST;
      uniform float _Tex_Mssk_Ang;
      uniform float _Tex_Ang;
      uniform float _Tex_Mask_2_Ang;
      uniform float4 _Tex_Mask_2_ST;
      uniform float _Tex_U;
      uniform float _Tex_V;
      uniform float _Tex_Mask_U;
      uniform float _Tex_Mask_V;
      uniform float _Tex_Mask_2_U;
      uniform float _Tex_Mask_2_V;
      uniform float4 _Tex_UVadd_ST;
      uniform float _Tex_UVadd_Intensity;
      uniform float _Tex_UVadd_U;
      uniform float _Tex_UVadd_V;
      uniform float _Tex_UVadd_Ang;
      uniform float _Tex_UVAdd_;
      uniform float _XY;
      uniform float _Tex_Rotate;
      uniform float _Tex_Rotate_speed;
      uniform float _Tex_Mask_Rotate_speed;
      uniform float _Tex_Mask_Rotate;
      uniform float _Tex_Mask_2_Rotate;
      uniform float _Tex_Mask_2_Rotate_speed;
      uniform float _Tex_UVadd_Rotate_speed;
      uniform float _Tex_UVadd_Rotate;
      uniform float _Tex_Mask_2_V_Y2;
      uniform float _Tex_Mask_2_U_X2;
      uniform float _Tex_Mask_V_W;
      uniform float _Tex_Mask_U_Z;
      uniform float _Tex_V_Y;
      uniform float _Tex_U_X;
      uniform float _Tex_UVadd_V_W2;
      uniform float _Tex_UVadd_U_Z2;
      uniform sampler2D _Tex_UVadd;
      uniform sampler2D _Tex;
      uniform sampler2D _Tex_Mask;
      uniform sampler2D _Tex_Mask_2;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 texcoord2 :TEXCOORD2;
          float4 color :COLOR0;
      };
      
      struct OUT_Data_Vert
      {
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
          float4 texcoord2 :TEXCOORD2;
          float4 color :COLOR0;
          float4 vertex :SV_POSITION;
      };
      
      struct v2f
      {
          float2 texcoord :TEXCOORD0;
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
          out_v.vertex = UnityObjectToClipPos(in_v.vertex);
          out_v.texcoord.xy = in_v.texcoord.xy;
          out_v.texcoord1 = in_v.texcoord1;
          out_v.texcoord2 = in_v.texcoord2;
          out_v.color = in_v.color;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float4 u_xlat0_d;
      float4 u_xlat16_0;
      float4 u_xlat1_d;
      float4 u_xlat16_1;
      float4 u_xlat2;
      float3 u_xlat3;
      float3 u_xlat4;
      float u_xlat5;
      float3 u_xlat6;
      float3 u_xlat7;
      float2 u_xlat8;
      float2 u_xlat9;
      float2 u_xlat14;
      float2 u_xlat15;
      float u_xlat21;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = (_Time.yy * float2(_Tex_UVadd_U, _Tex_UVadd_V));
          u_xlat14.xy = (((-float2(_Tex_UVadd_U, _Tex_UVadd_V)) * _Time.yy) + in_f.texcoord2.zw);
          u_xlat0_d.x = ((_Tex_UVadd_U_Z2 * u_xlat14.x) + u_xlat0_d.x);
          u_xlat0_d.y = ((_Tex_UVadd_V_W2 * u_xlat14.y) + u_xlat0_d.y);
          u_xlat1_d.xy = (u_xlat0_d.xy + in_f.texcoord.xy);
          u_xlat0_d.xy = (u_xlat1_d.xy + float2(-0.5, (-0.5)));
          u_xlat14.x = (_Tex_UVadd_Ang * 0.0174532942);
          u_xlat21 = ((_Time.y * _Tex_UVadd_Rotate_speed) + (-u_xlat14.x));
          u_xlat14.x = ((_Tex_UVadd_Rotate * u_xlat21) + u_xlat14.x);
          u_xlat1_d.x = sin(u_xlat14.x);
          u_xlat2.x = cos(u_xlat14.x);
          u_xlat3.z = u_xlat1_d.x;
          u_xlat3.y = u_xlat2.x;
          u_xlat3.x = (-u_xlat1_d.x);
          u_xlat1_d.y = dot(u_xlat0_d.xy, u_xlat3.xy);
          u_xlat1_d.x = dot(u_xlat0_d.xy, u_xlat3.yz);
          u_xlat0_d.xy = (u_xlat1_d.xy + float2(0.5, 0.5));
          u_xlat14.x = ((-u_xlat0_d.x) + u_xlat0_d.y);
          u_xlat14.x = ((_XY * u_xlat14.x) + u_xlat0_d.x);
          u_xlat14.xy = ((-u_xlat0_d.xy) + u_xlat14.xx);
          u_xlat0_d.xy = ((float2(_Tex_UVAdd_, _Tex_UVAdd_) * u_xlat14.xy) + u_xlat0_d.xy);
          u_xlat0_d.xy = TRANSFORM_TEX(u_xlat0_d.xy, _Tex_UVadd);
          u_xlat16_0 = tex2D(_Tex_UVadd, u_xlat0_d.xy);
          u_xlat0_d.x = dot(u_xlat16_0.xyz, float3(0.300000012, 0.589999974, 0.109999999));
          u_xlat0_d.x = (u_xlat16_0.w * u_xlat0_d.x);
          u_xlat1_d = (_Time.yyyy * float4(_Tex_U, _Tex_V, _Tex_Mask_U, _Tex_Mask_V));
          u_xlat2 = (((-float4(_Tex_U, _Tex_V, _Tex_Mask_U, _Tex_Mask_V)) * _Time.yyyy) + in_f.texcoord1);
          u_xlat7.xyz = ((float3(_Tex_U_X, _Tex_V_Y, _Tex_Mask_U_Z) * u_xlat2.xyz) + u_xlat1_d.xyz);
          u_xlat1_d.x = ((_Tex_Mask_V_W * u_xlat2.w) + u_xlat1_d.w);
          u_xlat1_d.w = (u_xlat1_d.x + in_f.texcoord.y);
          u_xlat1_d.xyz = (u_xlat7.xyz + in_f.texcoord.xyx);
          u_xlat7.xy = (u_xlat1_d.xy + float2(-0.5, (-0.5)));
          u_xlat1_d.xy = (u_xlat1_d.zw + float2(-0.5, (-0.5)));
          u_xlat2.xyz = float3((float3(_Tex_Ang, _Tex_Mssk_Ang, _Tex_Mask_2_Ang) * float3(0.0174532942, 0.0174532942, 0.0174532942)));
          u_xlat15.xy = ((_Time.yy * float2(_Tex_Rotate_speed, _Tex_Mask_Rotate_speed)) + (-u_xlat2.xy));
          u_xlat21 = ((_Tex_Rotate * u_xlat15.x) + u_xlat2.x);
          u_xlat15.x = ((_Tex_Mask_Rotate * u_xlat15.y) + u_xlat2.y);
          u_xlat2.x = sin(u_xlat15.x);
          u_xlat3.x = cos(u_xlat15.x);
          u_xlat4.x = sin(u_xlat21);
          u_xlat5 = cos(u_xlat21);
          u_xlat6.z = u_xlat4.x;
          u_xlat6.y = u_xlat5;
          u_xlat6.x = (-u_xlat4.x);
          u_xlat4.y = dot(u_xlat7.xy, u_xlat6.xy);
          u_xlat4.x = dot(u_xlat7.xy, u_xlat6.yz);
          u_xlat7.xy = (u_xlat4.xy + float2(0.5, 0.5));
          u_xlat0_d.xy = ((u_xlat0_d.xx * float2(_Tex_UVadd_Intensity, _Tex_UVadd_Intensity)) + u_xlat7.xy);
          u_xlat0_d.xy = TRANSFORM_TEX(u_xlat0_d.xy, _Tex);
          u_xlat16_0 = tex2D(_Tex, u_xlat0_d.xy);
          u_xlat0_d = (u_xlat16_0 * _Color);
          u_xlat4.z = u_xlat2.x;
          u_xlat4.y = u_xlat3.x;
          u_xlat4.x = (-u_xlat2.x);
          u_xlat2.y = dot(u_xlat1_d.xy, u_xlat4.xy);
          u_xlat2.x = dot(u_xlat1_d.xy, u_xlat4.yz);
          u_xlat1_d.xy = (u_xlat2.xy + float2(0.5, 0.5));
          u_xlat1_d.xy = TRANSFORM_TEX(u_xlat1_d.xy, _Tex_Mask);
          u_xlat16_1 = tex2D(_Tex_Mask, u_xlat1_d.xy);
          u_xlat1_d.x = dot(u_xlat16_1.xyz, float3(0.300000012, 0.589999974, 0.109999999));
          u_xlat1_d.x = (u_xlat16_1.w * u_xlat1_d.x);
          u_xlat0_d.w = (u_xlat0_d.w * u_xlat1_d.x);
          u_xlat0_d = (u_xlat0_d * in_f.color);
          u_xlat1_d.x = ((_Time.y * _Tex_Mask_2_Rotate_speed) + (-u_xlat2.z));
          u_xlat1_d.x = ((_Tex_Mask_2_Rotate * u_xlat1_d.x) + u_xlat2.z);
          u_xlat2.x = cos(u_xlat1_d.x);
          u_xlat1_d.x = sin(u_xlat1_d.x);
          u_xlat3.z = u_xlat1_d.x;
          u_xlat8.xy = (_Time.yy * float2(_Tex_Mask_2_U, _Tex_Mask_2_V));
          u_xlat9.xy = (((-_Time.yy) * float2(_Tex_Mask_2_U, _Tex_Mask_2_V)) + in_f.texcoord2.xy);
          u_xlat8.xy = ((float2(_Tex_Mask_2_U_X2, _Tex_Mask_2_V_Y2) * u_xlat9.xy) + u_xlat8.xy);
          u_xlat8.xy = (u_xlat8.xy + in_f.texcoord.xy);
          u_xlat8.xy = (u_xlat8.xy + float2(-0.5, (-0.5)));
          u_xlat3.y = u_xlat2.x;
          u_xlat3.x = (-u_xlat1_d.x);
          u_xlat2.y = dot(u_xlat8.xy, u_xlat3.xy);
          u_xlat2.x = dot(u_xlat8.xy, u_xlat3.yz);
          u_xlat1_d.xy = (u_xlat2.xy + float2(0.5, 0.5));
          u_xlat1_d.xy = TRANSFORM_TEX(u_xlat1_d.xy, _Tex_Mask_2);
          u_xlat16_1 = tex2D(_Tex_Mask_2, u_xlat1_d.xy);
          u_xlat1_d.x = dot(u_xlat16_1.xyz, float3(0.300000012, 0.589999974, 0.109999999));
          u_xlat1_d.x = (u_xlat16_1.w * u_xlat1_d.x);
          u_xlat21 = (u_xlat0_d.w * u_xlat1_d.x);
          out_f.color.xyz = (float3(u_xlat21, u_xlat21, u_xlat21) * u_xlat0_d.xyz);
          out_f.color.w = 1;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack Off
}
