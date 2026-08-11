Shader "Ares/UI/SimpleTexture_AlphaBlend_Stencil"
{
    Properties
    {
        _Color ("Tint Color", Color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "black" {}
        _ModelScale("Model Scale",Vector) = (1,1,1,1)
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "Queue" = "Transparent"}
        LOD 100
        CGINCLUDE
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;               
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float4 _ModelScale;

            v2f vert (appdata v)
            {
                v2f o;
                v.vertex.xyz *= _ModelScale.xyz;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv) * _Color;               
                return col;
            }            
        ENDCG
        
        Pass
        {
            Name "BASEBLEND"
            Blend SrcAlpha OneMinusSrcAlpha,Zero OneMinusSrcAlpha				
			Cull Back
			ZWrite Off
            Stencil
            {
                Ref 0
                Comp Equal
                Pass IncrSat
                ZFail Keep
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag          
            ENDCG
        }
    }
}
