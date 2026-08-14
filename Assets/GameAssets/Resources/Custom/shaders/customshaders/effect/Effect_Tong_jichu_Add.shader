Shader "Effect/Tong_jichu_Add"
{
  Properties
  {
    _Color ("Color", Color) = (1,1,1,1)
    [MaterialToggle] _Color_Alpha_X ("Color_Alpha_X", float) = 0
    [MaterialToggle] _Vertex_Color ("Vertex_Color", float) = 0
    _Tex ("Tex", 2D) = "white" {}
    _Tex_U ("Tex_U", float) = 0
    [MaterialToggle] _Tex_U_X ("Tex_U_X", float) = 0
    _Tex_V ("Tex_V", float) = 0
    [MaterialToggle] _Tex_V_Y ("Tex_V_Y", float) = 0
    _Tex_Ang ("Tex_Ang", Range(0, 360)) = 0
    [MaterialToggle] _Tex_Rotate ("Tex_Rotate----------------------------------------------", float) = 0
    _Tex_Rotate_speed ("Tex_Rotate_speed--------------------------------------", float) = 0
    _Tex_Mask ("Tex_Mask", 2D) = "white" {}
    [MaterialToggle] _World_Mask ("World_Mask", float) = 0
    [MaterialToggle] _World_Mask_View ("World_Mask_View", float) = 0.5
    _Tex_Mask_U ("Tex_Mask_U", float) = 0
    [MaterialToggle] _Tex_Mask_U_Z ("Tex_Mask_U_Z", float) = 0
    _Tex_Mask_V ("Tex_Mask_V", float) = 0
    [MaterialToggle] _Tex_Mask_V_W ("Tex_Mask_V_W", float) = 0
    _Tex_Mask_Ang ("Tex_Mask_Ang", Range(0, 360)) = 0
    [MaterialToggle] _Tex_Mask_Rotate ("Tex_Mask_Rotate----------------------------------------------", float) = 0
    _Tex_Mask_Rotate_speed ("Tex_Mask_Rotate_speed--------------------------------------", float) = 0
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
      #define conv_mxt4x4_0(mat4x4) float4(mat4x4[0].x,mat4x4[1].x,mat4x4[2].x,mat4x4[3].x)
      #define conv_mxt4x4_1(mat4x4) float4(mat4x4[0].y,mat4x4[1].y,mat4x4[2].y,mat4x4[3].y)
      #define conv_mxt4x4_2(mat4x4) float4(mat4x4[0].z,mat4x4[1].z,mat4x4[2].z,mat4x4[3].z)
      #define conv_mxt4x4_3(mat4x4) float4(mat4x4[0].w,mat4x4[1].w,mat4x4[2].w,mat4x4[3].w)
      
      
      #define CODE_BLOCK_VERTEX
      //uniform float4x4 unity_ObjectToWorld;
      //uniform float4x4 unity_MatrixVP;
      //uniform float4 _Time;
      //uniform float4x4 unity_MatrixV;
      uniform float4 _Tex_ST;
      uniform float4 _Color;
      uniform float4 _Tex_Mask_ST;
      uniform float _Tex_Mask_Ang;
      uniform float _Tex_Ang;
      uniform float _Tex_U;
      uniform float _Tex_V;
      uniform float _Tex_Mask_U;
      uniform float _Tex_Mask_V;
      uniform float _Vertex_Color;
      uniform float _World_Mask;
      uniform float _World_Mask_View;
      uniform float _Tex_Mask_Rotate_speed;
      uniform float _Tex_Mask_Rotate;
      uniform float _Tex_Rotate_speed;
      uniform float _Tex_Rotate;
      uniform float _Tex_U_X;
      uniform float _Tex_V_Y;
      uniform float _Tex_Mask_U_Z;
      uniform float _Tex_Mask_V_W;
      uniform float _Color_Alpha_X;
      uniform sampler2D _Tex;
      uniform sampler2D _Tex_Mask;
      struct appdata_t
      {
          float4 vertex :POSITION0;
          float2 texcoord :TEXCOORD0;
          float4 texcoord1 :TEXCOORD1;
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
          u_xlat0 = (in_v.vertex.yyyy * conv_mxt4x4_1(unity_ObjectToWorld));
          u_xlat0 = ((conv_mxt4x4_0(unity_ObjectToWorld) * in_v.vertex.xxxx) + u_xlat0);
          u_xlat0 = ((conv_mxt4x4_2(unity_ObjectToWorld) * in_v.vertex.zzzz) + u_xlat0);
          u_xlat1 = (u_xlat0 + conv_mxt4x4_3(unity_ObjectToWorld));
          out_v.texcoord2 = ((conv_mxt4x4_3(unity_ObjectToWorld) * in_v.vertex.wwww) + u_xlat0);
          out_v.vertex = mul(unity_MatrixVP, u_xlat1);
          out_v.texcoord.xy = in_v.texcoord.xy;
          out_v.texcoord1 = in_v.texcoord1;
          out_v.color = in_v.color;
          return out_v;
      }
      
      #define CODE_BLOCK_FRAGMENT
      float3 u_xlat0_d;
      float3 u_xlat1_d;
      float4 u_xlat16_1;
      float2 u_xlat2;
      float3 u_xlat3;
      float3 u_xlat4;
      float2 u_xlat5;
      float2 u_xlat8;
      float u_xlat12;
      float u_xlat13;
      OUT_Data_Frag frag(v2f in_f)
      {
          OUT_Data_Frag out_f;
          u_xlat0_d.xy = (in_f.texcoord2.yy * conv_mxt4x4_1(unity_MatrixV).xy);
          u_xlat0_d.xy = ((conv_mxt4x4_0(unity_MatrixV).xy * in_f.texcoord2.xx) + u_xlat0_d.xy);
          u_xlat0_d.xy = ((conv_mxt4x4_2(unity_MatrixV).xy * in_f.texcoord2.zz) + u_xlat0_d.xy);
          u_xlat8.xy = (_Time.yy * float2(_Tex_Mask_U, _Tex_Mask_V));
          u_xlat1_d.xy = (((-_Time.yy) * float2(_Tex_Mask_U, _Tex_Mask_V)) + in_f.texcoord1.zw);
          u_xlat8.x = ((_Tex_Mask_U_Z * u_xlat1_d.x) + u_xlat8.x);
          u_xlat8.y = ((_Tex_Mask_V_W * u_xlat1_d.y) + u_xlat8.y);
          u_xlat0_d.xy = (u_xlat0_d.xy + u_xlat8.xy);
          u_xlat1_d.xy = (u_xlat0_d.xy + float2(0.5, 0.5));
          u_xlat0_d.x = (u_xlat8.x + in_f.texcoord2.x);
          u_xlat2.xy = (u_xlat8.xy + in_f.texcoord.xy);
          u_xlat0_d.z = (u_xlat8.y + in_f.texcoord2.y);
          u_xlat0_d.xy = (u_xlat0_d.xz + float2(0.5, 0.5));
          u_xlat8.xy = ((-u_xlat0_d.xy) + u_xlat1_d.xy);
          u_xlat0_d.xy = ((float2(float2(_World_Mask_View, _World_Mask_View)) * u_xlat8.xy) + u_xlat0_d.xy);
          u_xlat0_d.xy = ((-u_xlat2.xy) + u_xlat0_d.xy);
          u_xlat0_d.xy = ((float2(float2(_World_Mask, _World_Mask)) * u_xlat0_d.xy) + u_xlat2.xy);
          u_xlat0_d.xy = (u_xlat0_d.xy + float2(-0.5, (-0.5)));
          u_xlat8.xy = float2((float2(_Tex_Ang, _Tex_Mask_Ang) * float2(0.0174532942, 0.0174532942)));
          u_xlat1_d.x = ((_Time.y * _Tex_Mask_Rotate_speed) + (-u_xlat8.y));
          u_xlat12 = ((_Tex_Mask_Rotate * u_xlat1_d.x) + u_xlat8.y);
          u_xlat1_d.x = sin(u_xlat12);
          u_xlat2.x = cos(u_xlat12);
          u_xlat3.z = u_xlat1_d.x;
          u_xlat3.y = u_xlat2.x;
          u_xlat3.x = (-u_xlat1_d.x);
          u_xlat1_d.y = dot(u_xlat0_d.xy, u_xlat3.xy);
          u_xlat1_d.x = dot(u_xlat0_d.xy, u_xlat3.yz);
          u_xlat0_d.xy = (u_xlat1_d.xy + float2(0.5, 0.5));
          u_xlat0_d.xy = TRANSFORM_TEX(u_xlat0_d.xy, _Tex_Mask);
          u_xlat16_1 = tex2D(_Tex_Mask, u_xlat0_d.xy);
          u_xlat0_d.x = dot(u_xlat16_1.xyz, float3(0.300000012, 0.589999974, 0.109999999));
          u_xlat0_d.x = (u_xlat16_1.w * u_xlat0_d.x);
          u_xlat4.x = ((_Time.y * _Tex_Rotate_speed) + (-u_xlat8.x));
          u_xlat4.x = ((_Tex_Rotate * u_xlat4.x) + u_xlat8.x);
          u_xlat1_d.x = sin(u_xlat4.x);
          u_xlat2.x = cos(u_xlat4.x);
          u_xlat3.z = u_xlat1_d.x;
          u_xlat4.xy = (_Time.yy * float2(_Tex_U, _Tex_V));
          u_xlat5.xy = (((-float2(_Tex_U, _Tex_V)) * _Time.yy) + in_f.texcoord1.xy);
          u_xlat4.xy = ((float2(_Tex_U_X, _Tex_V_Y) * u_xlat5.xy) + u_xlat4.xy);
          u_xlat4.xy = (u_xlat4.xy + in_f.texcoord.xy);
          u_xlat4.xy = (u_xlat4.xy + float2(-0.5, (-0.5)));
          u_xlat3.y = u_xlat2.x;
          u_xlat3.x = (-u_xlat1_d.x);
          u_xlat1_d.y = dot(u_xlat4.xy, u_xlat3.xy);
          u_xlat1_d.x = dot(u_xlat4.xy, u_xlat3.yz);
          u_xlat4.xy = (u_xlat1_d.xy + float2(0.5, 0.5));
          u_xlat4.xy = TRANSFORM_TEX(u_xlat4.xy, _Tex);
          u_xlat16_1 = tex2D(_Tex, u_xlat4.xy);
          u_xlat4.xyz = (u_xlat16_1.xyz * _Color.xyz);
          u_xlat4.xyz = (u_xlat16_1.www * u_xlat4.xyz);
          u_xlat4.xyz = (u_xlat4.xyz * _Color.www);
          u_xlat1_d.xyz = (u_xlat0_d.xxx * u_xlat4.xyz);
          u_xlat1_d.xyz = (u_xlat1_d.xyz * in_f.color.xyz);
          u_xlat1_d.xyz = (u_xlat1_d.xyz * in_f.color.www);
          u_xlat13 = (in_f.texcoord1.x + (-in_f.color.w));
          u_xlat13 = ((_Color_Alpha_X * u_xlat13) + in_f.color.w);
          u_xlat1_d.xyz = (float3(u_xlat13, u_xlat13, u_xlat13) * u_xlat1_d.xyz);
          u_xlat0_d.xyz = ((u_xlat4.xyz * u_xlat0_d.xxx) + (-u_xlat1_d.xyz));
          out_f.color.xyz = ((float3(_Vertex_Color, _Vertex_Color, _Vertex_Color) * u_xlat0_d.xyz) + u_xlat1_d.xyz);
          out_f.color.w = 1;
          return out_f;
      }
      
      
      ENDCG
      
    } // end phase
  }
  FallBack Off
}
