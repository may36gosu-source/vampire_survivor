Shader "Ares/Particle/AlphaMask" {
	Properties {
		_Color ("Tint Color", Color) = (0.5,0.5,0.5,0.5)	
		_MainTex("Particle Texture (A = Transparency)", 2D) = "white"{}
		_MaskTex ("Masked Texture", 2D) = "gray" {}
		_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_UseClip("UseClip",float) = 0
		_ClipRect("ClipRect",Vector)= (-50000,-50000,50000,50000)
		_BloomTex ("BloomTex", 2D) = "(0.5,0.5,0.5,0.5)" {}
		_BloomFactor("BloomFactor", float) = 0
	}
	// ---- Fragment program cards
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"  "GonbestBloomType"="BloomMask"}
		Blend SrcAlpha OneMinusSrcAlpha,Zero OneMinusSrcAlpha		
		ColorMask RGB
		Cull Off Lighting Off ZWrite Off		
		Pass {
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_particles
			
			#include "UnityCG.cginc"
			
			struct appdata_t {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				half2 texcoord : TEXCOORD0;
				half2 texcoord1 : TEXCOORD1;
			};

			struct v2f {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				half2 texcoord : TEXCOORD0;			
				half2 texcoord1 : TEXCOORD1;	
				#ifdef SOFTPARTICLES_ON
				float4 projPos : TEXCOORD2;				
				#endif
			};
			
			uniform fixed4 _Color;
			uniform sampler2D _MainTex;
			uniform float4 _MainTex_ST;
			uniform sampler2D _MaskTex;
			uniform float4 _MaskTex_ST;
			uniform float _InvFade;
			
			uniform sampler2D _CameraDepthTexture;
			
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				#ifdef SOFTPARTICLES_ON
				o.projPos = ComputeScreenPos (o.vertex);
				COMPUTE_EYEDEPTH(o.projPos.z);
				#endif
				o.color = v.color;
				o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
				o.texcoord1 = TRANSFORM_TEX(v.texcoord1,_MaskTex);
				return o;
			}			
			
			fixed4 frag (v2f i) : COLOR
			{
				#ifdef SOFTPARTICLES_ON
				float sceneZ = LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos))));
				float partZ = i.projPos.z;
				float fade = saturate (_InvFade * (sceneZ-partZ));
				i.color.a *= fade;
				#endif
				
				//return 2.0f * i.color * _Color * tex2D(_MainTex, i.texcoord);
				fixed4 col = 2.0f * i.color * _Color * tex2D(_MainTex, i.texcoord);
				col.a *= tex2D(_MaskTex, i.texcoord1).r;
				return col;
			}
			ENDCG 
		}
	} 	
	Fallback "Gonbest/FallBack/FBNothing"
}
