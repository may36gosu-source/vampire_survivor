Shader "Ares/Entity/Hair_Show_Old"
{
	Properties
    {
        _Color ("Main Color", Color) = (1, 1, 1, 1)		
        _ColorMultiplier("Color Multipler",range(0,2)) = 1
        _Cutoff ("Alpha cutoff", Range(0,1)) = 0.3
        _MainTex("Base (RGB)", 2D) = "white" {}
        _MaskTex ("Mask", 2D) = "white" {}	
        _BumpScale("Normal Map Scale",Range(0,2)) = 1  			//发现比率				
        _BumpMap("Normal Map",2D) = "black"{}							
        _SpecularPower1("Specular Power 1",Range(0,100)) = 1			
        _SpecularColor1("Specular Color 1", Color) = (0.5,0.5,0.5,1)
        _SpecularShift1 ("Specular Shift 1 ", Range(-1.0, 1.0)) = 1		
        _SpecularPower2 ("Specular Power 2", Range(0, 100)) = 10		
        _SpecularColor2("Specular Color 2", Color) = (0.5,0.5,0.5,1)
        _SpecularShift2 ("Specular Shift 2 ", Range(-1.0, 1.0)) = 1		
        _MainLightPos("Main Light Pos",Vector) = (0,0,0,1)
		_MainLightColor("Main Light Color",Color) = (1,1,1,1)
        _OA("OA",Range(0,1)) = 0.5
		_ISUI("(> 0.5) is ui",float) = 0
        _BloomTex ("BloomTex", 2D) = "black" {}
		_BloomFactor("BloomFactor", float) = 0
        
    }

	SubShader
	{
        Tags { "RenderType" = "Opaque" "Queue" = "Transparent"}
		UsePass "Gonbest/PBR/HairPBRHelper/WRITE&Z&A"
        UsePass "Gonbest/PBR/HairPBRHelper/WRITE&RGB&BASE"
        UsePass "Gonbest/PBR/HairPBRHelper/WRITE&BLEND&BACK"
        UsePass "Gonbest/PBR/HairPBRHelper/WRITE&BLEND&FRONT"		
	}	
	
	Fallback "Gonbest/FallBack/FBNothing"
}
