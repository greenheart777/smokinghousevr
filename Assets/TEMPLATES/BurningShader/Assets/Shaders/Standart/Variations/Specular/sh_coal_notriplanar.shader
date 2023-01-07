// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Burned/Coal_NoTriplanar"
{
	Properties
	{
		_CoalMasks("CoalMasks", 2D) = "white" {}
		_WoodAlbedo("WoodAlbedo", 2D) = "white" {}
		_WoodNormal("WoodNormal", 2D) = "bump" {}
		_CoalNormal("CoalNormal", 2D) = "bump" {}
		[HDR]_CoalColor("CoalColor", Color) = (0,0,0,0)
		_CinderPower("CinderPower", Range( 0 , 3)) = 2
		_CinderSidePower("CinderSidePower", Range( 0 , 3)) = 1.55
		_CinderLow("CinderLow", Range( 0 , 3)) = 0.18
		_AshesPower("AshesPower", Float) = 3.6
		_UVTiling("UVTiling", Vector) = (1,1,0,0)
		_DetailWoodAlbedo("DetailWoodAlbedo", 2D) = "white" {}
		_Specular("Specular", Color) = (0,0,0,0)
		_WoodSm("WoodSm", Float) = 0
		_DetailWoodNormal("DetailWoodNormal", 2D) = "bump" {}
		_WoodOcclusion_AOR("WoodOcclusion_AO(R)", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGINCLUDE
		#include "UnityStandardUtils.cginc"
		#include "UnityShaderVariables.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
			float3 worldPos;
		};

		uniform sampler2D _DetailWoodNormal;
		uniform sampler2D _WoodNormal;
		uniform float4 _WoodNormal_ST;
		uniform sampler2D _CoalNormal;
		uniform float2 _UVTiling;
		uniform sampler2D _CoalMasks;
		uniform float4 _CoalMasks_ST;
		uniform float StartBurning;
		uniform sampler2D _WoodAlbedo;
		uniform float4 _WoodAlbedo_ST;
		uniform sampler2D _DetailWoodAlbedo;
		uniform float4 _DetailWoodAlbedo_ST;
		uniform float _AshesPower;
		uniform float _CinderSidePower;
		uniform float _CinderLow;
		uniform float _CinderPower;
		uniform float StopBurning;
		uniform float4 _CoalColor;
		uniform float4 _Specular;
		uniform float _WoodSm;
		uniform sampler2D _WoodOcclusion_AOR;
		uniform float4 _WoodOcclusion_AOR_ST;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float2 uv_WoodNormal = i.uv_texcoord * _WoodNormal_ST.xy + _WoodNormal_ST.zw;
			float2 temp_output_45_0 = ( i.uv_texcoord * _UVTiling );
			float2 uv_CoalMasks = i.uv_texcoord * _CoalMasks_ST.xy + _CoalMasks_ST.zw;
			float clampResult43 = clamp( ( 1.0 - pow( tex2D( _CoalMasks, uv_CoalMasks ).b , (0.0 + (StartBurning - 0.0) * (2.0 - 0.0) / (1.0 - 0.0)) ) ) , 0.0 , 1.0 );
			float3 lerpResult93 = lerp( BlendNormals( UnpackNormal( tex2D( _DetailWoodNormal, ( i.uv_texcoord * 5.0 ) ) ) , UnpackNormal( tex2D( _WoodNormal, uv_WoodNormal ) ) ) , UnpackNormal( tex2D( _CoalNormal, temp_output_45_0 ) ) , clampResult43);
			o.Normal = lerpResult93;
			float2 uv_WoodAlbedo = i.uv_texcoord * _WoodAlbedo_ST.xy + _WoodAlbedo_ST.zw;
			float4 tex2DNode10 = tex2D( _WoodAlbedo, uv_WoodAlbedo );
			float2 uv_DetailWoodAlbedo = i.uv_texcoord * _DetailWoodAlbedo_ST.xy + _DetailWoodAlbedo_ST.zw;
			float temp_output_9_0_g1 = tex2DNode10.r;
			float temp_output_18_0_g1 = ( 1.0 - temp_output_9_0_g1 );
			float3 appendResult16_g1 = (float3(temp_output_18_0_g1 , temp_output_18_0_g1 , temp_output_18_0_g1));
			float FirePower224 = StartBurning;
			float4 tex2DNode24 = tex2D( _CoalMasks, temp_output_45_0 );
			float CoalColor205 = tex2DNode24.r;
			float3 temp_cast_2 = (CoalColor205).xxx;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_vertexNormal = mul( unity_WorldToObject, float4( ase_worldNormal, 0 ) );
			float4 transform117 = mul(unity_ObjectToWorld,float4( ase_vertexNormal , 0.0 ));
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform152 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float2 temp_cast_5 = (tex2D( _CoalMasks, ( ( i.uv_texcoord * float2( 0.5,0.5 ) ) + ( float2( 0.005,0.01 ) * _Time.y ) ) ).b).xx;
			float2 lerpResult175 = lerp( i.uv_texcoord , temp_cast_5 , 0.01);
			float4 tex2DNode29 = tex2D( _CoalMasks, lerpResult175 );
			float clampResult180 = clamp( ( CoalColor205 * _CinderLow * tex2DNode29.g ) , 0.0 , 1.0 );
			float clampResult155 = clamp( ( max( transform117.y , 0.0 ) + ( max( transform152.y , 0.0 ) * _CinderSidePower ) + clampResult180 ) , 0.0 , 1.0 );
			float temp_output_91_0 = ( clampResult155 * _CinderPower * 100.0 * pow( tex2DNode29.g , (6.0 + (StopBurning - 0.0) * (-10.0 - 6.0) / (1.0 - 0.0)) ) );
			float clampResult192 = clamp( ( pow( CoalColor205 , _AshesPower ) * (0.0 + (temp_output_91_0 - 0.9) * (1.0 - 0.0) / (1.0 - 0.9)) * FirePower224 ) , 0.0 , 1.0 );
			float3 lerpResult306 = lerp( ( ( tex2DNode10.rgb * ( ( ( tex2D( _DetailWoodAlbedo, uv_DetailWoodAlbedo ).rgb * (unity_ColorSpaceDouble).rgb ) * temp_output_9_0_g1 ) + appendResult16_g1 ) ) * (0.77 + (FirePower224 - 0.0) * (0.0 - 0.77) / (1.0 - 0.0)) ) , temp_cast_2 , clampResult192);
			o.Albedo = lerpResult306;
			float2 temp_cast_6 = (( tex2D( _CoalMasks, ( i.uv_texcoord * 2.0 ) ).g * 0.5 )).xx;
			float2 panner21 = ( 1.0 * _Time.y * float2( 0.15,0 ) + temp_cast_6);
			float clampResult217 = clamp( ( tex2D( _CoalMasks, panner21 ).g * 4.0 * CoalColor205 ) , 0.0 , 1.0 );
			float4 lerpResult12 = lerp( float4( 0,0,0,0 ) , ( CoalColor205 * _CoalColor * clampResult217 ) , clampResult43);
			float clampResult49 = clamp( temp_output_91_0 , 0.0 , 1.0 );
			float temp_output_123_0 = ( 1.0 - clampResult49 );
			float4 lerpResult87 = lerp( float4( 0,0,0,0 ) , lerpResult12 , ( FirePower224 * temp_output_123_0 ));
			o.Emission = lerpResult87.rgb;
			float4 temp_cast_8 = (0.0).xxxx;
			float4 lerpResult270 = lerp( _Specular , temp_cast_8 , FirePower224);
			o.Specular = lerpResult270.rgb;
			float CoalSmAo207 = tex2DNode24.a;
			float lerpResult228 = lerp( _WoodSm , CoalSmAo207 , FirePower224);
			o.Smoothness = lerpResult228;
			float2 uv_WoodOcclusion_AOR = i.uv_texcoord * _WoodOcclusion_AOR_ST.xy + _WoodOcclusion_AOR_ST.zw;
			float CoalNoise2206 = tex2DNode24.b;
			float lerpResult238 = lerp( tex2D( _WoodOcclusion_AOR, uv_WoodOcclusion_AOR ).r , ( temp_output_123_0 * ( 1.0 - ( CoalNoise2206 + clampResult180 ) ) ) , FirePower224);
			o.Occlusion = lerpResult238;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf StandardSpecular keepalpha fullforwardshadows nodynlightmap 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				SurfaceOutputStandardSpecular o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandardSpecular, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
25;7;1666;986;3806.109;-70.06288;1.029431;True;False
Node;AmplifyShaderEditor.TexCoordVertexDataNode;169;-4492.737,1297.04;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;170;-4469.048,1757.396;Float;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;168;-4481.465,1602.799;Float;False;Constant;_Vector1;Vector 1;24;0;Create;True;0;0;False;0;0.005,0.01;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.Vector2Node;167;-4478.03,1448.17;Float;False;Constant;_Vector0;Vector 0;24;0;Create;True;0;0;False;0;0.5,0.5;0.5,0.5;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;171;-4220.305,1607.928;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;236;-2970.067,-460.4288;Float;False;Property;_UVTiling;UVTiling;13;0;Create;True;0;0;False;0;1,1;1,1;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexCoordVertexDataNode;44;-3012.046,-586.5157;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;-4233.979,1431.352;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;45;-2636.472,-477.3878;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;173;-4017.446,1525.468;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;174;-3824.649,1497.726;Float;True;Property;_TextureSample5;Texture Sample 5;4;0;Create;True;0;0;False;0;None;2d479324bd85dcd4facb271ae1f53661;True;0;False;white;Auto;False;Instance;33;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;309;-3674.199,1387.955;Float;False;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;24;-2369.598,-739.6808;Float;True;Property;_TextureSample1;Texture Sample 1;4;0;Create;True;0;0;False;0;2d479324bd85dcd4facb271ae1f53661;2d479324bd85dcd4facb271ae1f53661;True;0;False;white;Auto;False;Instance;33;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;176;-3759.415,1708.024;Float;False;Constant;_CinderNoiseUVScale;CinderNoiseUVScale;10;0;Create;True;0;0;False;0;0.01;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;149;-3258.145,792.7192;Float;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;205;-1898.996,-896.9099;Float;False;CoalColor;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;175;-3423.016,1476.735;Float;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;152;-2989.173,792.129;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;178;-3005.34,1289.125;Float;False;Property;_CinderLow;CinderLow;11;0;Create;True;0;0;False;0;0.18;1.96;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;16;-3556.256,188.3745;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;17;-3594.913,309.7477;Float;False;Constant;_CoalNoiseEmissionUvScale;CoalNoiseEmissionUvScale;4;0;Create;True;0;0;False;0;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.NormalVertexDataNode;109;-3005.712,623.7775;Float;False;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;208;-2918.182,1202.111;Float;False;205;CoalColor;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;29;-3149.637,1446.938;Float;True;Property;_TextureSample2;Texture Sample 2;4;0;Create;True;0;0;False;0;2d479324bd85dcd4facb271ae1f53661;2d479324bd85dcd4facb271ae1f53661;True;0;False;white;Auto;False;Instance;33;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;182;-2621.456,1207.176;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;15;-3215.866,189.0645;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;157;-2777.392,969.3057;Float;False;Property;_CinderSidePower;CinderSidePower;10;0;Create;True;0;0;False;0;1.55;0.15;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMaxOpNode;153;-2699.257,838.8573;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;117;-2717.279,623.5734;Float;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;22;-2965.419,161.6456;Float;True;Property;_TextureSample0;Texture Sample 0;4;0;Create;True;0;0;False;0;2d479324bd85dcd4facb271ae1f53661;2d479324bd85dcd4facb271ae1f53661;True;0;False;white;Auto;False;Instance;33;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMaxOpNode;115;-2425.665,669.0167;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-2899.988,371.2204;Float;False;Constant;_CoalNoiseScale;CoalNoiseScale;8;0;Create;True;0;0;False;0;0.5;0.58;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;28;-3239.084,1718.399;Float;False;Global;StopBurning;StopBurning;10;0;Create;True;0;0;False;0;0.5;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;158;-2439.293,838.381;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;180;-2355.073,1091.586;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;20;-2563.081,212.026;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;19;-2571.373,327.421;Float;False;Constant;_CoalNoiseUVPanner;CoalNoiseUVPanner;9;0;Create;True;0;0;False;0;0.15,0;0.15,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleAddOpNode;154;-2126.322,815.8316;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;235;-2878.849,1722.457;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;6;False;4;FLOAT;-10;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;155;-1851.104,816.3149;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;234;-1917.082,1000.55;Float;False;Constant;_Const;Const;16;0;Create;True;0;0;False;0;100;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;218;-2498.403,-106.1524;Float;False;Global;StartBurning;StartBurning;20;0;Create;True;0;0;False;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;96;-1974.856,928.1199;Float;False;Property;_CinderPower;CinderPower;9;0;Create;True;0;0;False;0;2;0.32;0;3;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;21;-2276.1,213.651;Float;False;3;0;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;114;-2569.023,1496.635;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;261;-1554.599,-824.3876;Float;False;Constant;_DetailNormalUVScale;DetailNormalUVScale;22;0;Create;True;0;0;False;0;5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;224;-2107.247,36.00164;Float;False;FirePower;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;206;-1773.581,-730.0219;Float;False;CoalNoise2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;100;-1869.718,381.0922;Float;False;Constant;_CoalNoisePower;CoalNoisePower;11;0;Create;True;0;0;False;0;4;2.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;196;-1075.165,408.9827;Float;False;Property;_AshesPower;AshesPower;12;0;Create;True;0;0;False;0;3.6;3.64;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;91;-1512.314,812.6141;Float;False;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;9;-1962.441,184.8739;Float;True;Property;_rew;rew;4;0;Create;True;0;0;False;0;2d479324bd85dcd4facb271ae1f53661;2d479324bd85dcd4facb271ae1f53661;True;0;False;white;Auto;False;Instance;33;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;33;-1909.745,-306.4492;Float;True;Property;_CoalMasks;CoalMasks;4;0;Create;True;0;0;False;0;2d479324bd85dcd4facb271ae1f53661;2d479324bd85dcd4facb271ae1f53661;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureCoordinatesNode;262;-1610.021,-957.8255;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;209;-1083.838,314.1763;Float;False;205;CoalColor;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;219;-1808.443,-99.40897;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;212;-1857.122,467.502;Float;False;205;CoalColor;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;263;-1274.601,-957.6114;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PowerNode;39;-1526.234,-231.0297;Float;False;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;195;-843.6543,319.1586;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;99;-1577.161,236.636;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;210;-579.4558,967.8086;Float;False;206;CoalNoise2;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;225;-858.2903,658.899;Float;False;224;FirePower;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;193;-848.0005,456.4837;Float;False;5;0;FLOAT;0;False;1;FLOAT;0.9;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;10;-176.3099,-605.78;Float;True;Property;_WoodAlbedo;WoodAlbedo;5;0;Create;True;0;0;False;0;None;518249a30c8ae754ba6ace7438dae717;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;255;-175.9869,-414.8418;Float;True;Property;_DetailWoodAlbedo;DetailWoodAlbedo;14;0;Create;True;0;0;False;0;a0fff3e053e70494ba9c91d152aeffa0;69c23a9535a4c2143bdfda7b563b993a;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;181;-313.5259,1066.087;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;256;-1060.625,-985.342;Float;True;Property;_DetailWoodNormal;DetailWoodNormal;17;0;Create;True;0;0;False;0;017469a3ea9ca3e4ea89e14f79a6e221;017469a3ea9ca3e4ea89e14f79a6e221;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;48;-1456.608,57.06815;Float;False;Property;_CoalColor;CoalColor;8;1;[HDR];Create;True;0;0;False;0;0,0,0,0;7.906699,2.607969,1.366079,0;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;194;-586.1567,434.5233;Float;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;226;164.445,-268.4608;Float;False;224;FirePower;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;11;-1170.334,-735.5777;Float;True;Property;_WoodNormal;WoodNormal;6;0;Create;True;0;0;False;0;None;f56e8c73d755f2347b44412fc6ad9b0f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;40;-1275.999,-230.1744;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;213;-1394.893,-29.75921;Float;False;205;CoalColor;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;217;-1348.136,238.1261;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;49;-1194.961,812.6927;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;223;393.3511,-262.9322;Float;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.77;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendNormalsNode;268;-683.7023,-585.7533;Float;False;0;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ClampOpNode;192;-374.9484,434.8003;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;147;-108.6176,967.7993;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1039.703,144.65;Float;False;3;3;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;207;-1694.144,-649.9088;Float;False;CoalSmAo;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;43;-1042.258,-230.2259;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;123;-865.5482,812.6558;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;229;-103.169,548.7671;Float;False;224;FirePower;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;13;-1168.178,-510.9188;Float;True;Property;_CoalNormal;CoalNormal;7;0;Create;True;0;0;False;0;None;f91c76d43b07b034ba951400ad8c3133;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;244;264.5541,-431.269;Float;False;Detail Albedo;0;;1;29e5a290b15a7884983e27c8f1afaa8c;0;3;12;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;9;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;267;-62.15375,384.0183;Float;False;Property;_WoodSm;WoodSm;16;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;85;637.2621,-285.8051;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;127;110.5585,817.6112;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;214;392.6927,-93.52663;Float;False;205;CoalColor;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;271;223.6533,363.2494;Float;False;Constant;_SpecConst;SpecConst;21;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;12;-713.0228,123.4314;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;239;-204.4312,622.5336;Float;True;Property;_WoodOcclusion_AOR;WoodOcclusion_AO(R);18;0;Create;True;0;0;False;0;None;8cba82c5350f91d46ad8e6539ff3c81f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;93;-371.2772,-269.4022;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.GetLocalVarNode;211;-102.7998,464.2261;Float;False;207;CoalSmAo;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;257;210.7187,189.9626;Float;False;Property;_Specular;Specular;15;0;Create;True;0;0;False;0;0,0,0,0;0.2735849,0.2232556,0.2232556,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WireNode;308;258.2728,86.37714;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;220;-597.1912,663.3303;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;272;429.8735,519.4047;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;228;224.5099,445.2271;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;270;597.643,194.9285;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;238;484.9165,651.384;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;273;173.746,-15.51492;Float;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;306;832.7005,-149.9887;Float;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;253;-1836.276,-815.239;Float;False;CoalNoise1;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;87;-362.1723,101.7751;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1072.725,78.11623;Float;False;True;2;Float;ASEMaterialInspector;0;0;StandardSpecular;Burned/Coal_NoTriplanar;False;False;False;False;False;False;False;True;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;171;0;168;0
WireConnection;171;1;170;0
WireConnection;172;0;169;0
WireConnection;172;1;167;0
WireConnection;45;0;44;0
WireConnection;45;1;236;0
WireConnection;173;0;172;0
WireConnection;173;1;171;0
WireConnection;174;1;173;0
WireConnection;309;0;169;0
WireConnection;24;1;45;0
WireConnection;205;0;24;1
WireConnection;175;0;309;0
WireConnection;175;1;174;3
WireConnection;175;2;176;0
WireConnection;152;0;149;0
WireConnection;29;1;175;0
WireConnection;182;0;208;0
WireConnection;182;1;178;0
WireConnection;182;2;29;2
WireConnection;15;0;16;0
WireConnection;15;1;17;0
WireConnection;153;0;152;2
WireConnection;117;0;109;0
WireConnection;22;1;15;0
WireConnection;115;0;117;2
WireConnection;158;0;153;0
WireConnection;158;1;157;0
WireConnection;180;0;182;0
WireConnection;20;0;22;2
WireConnection;20;1;18;0
WireConnection;154;0;115;0
WireConnection;154;1;158;0
WireConnection;154;2;180;0
WireConnection;235;0;28;0
WireConnection;155;0;154;0
WireConnection;21;0;20;0
WireConnection;21;2;19;0
WireConnection;114;0;29;2
WireConnection;114;1;235;0
WireConnection;224;0;218;0
WireConnection;206;0;24;3
WireConnection;91;0;155;0
WireConnection;91;1;96;0
WireConnection;91;2;234;0
WireConnection;91;3;114;0
WireConnection;9;1;21;0
WireConnection;219;0;218;0
WireConnection;263;0;262;0
WireConnection;263;1;261;0
WireConnection;39;0;33;3
WireConnection;39;1;219;0
WireConnection;195;0;209;0
WireConnection;195;1;196;0
WireConnection;99;0;9;2
WireConnection;99;1;100;0
WireConnection;99;2;212;0
WireConnection;193;0;91;0
WireConnection;181;0;210;0
WireConnection;181;1;180;0
WireConnection;256;1;263;0
WireConnection;194;0;195;0
WireConnection;194;1;193;0
WireConnection;194;2;225;0
WireConnection;40;0;39;0
WireConnection;217;0;99;0
WireConnection;49;0;91;0
WireConnection;223;0;226;0
WireConnection;268;0;256;0
WireConnection;268;1;11;0
WireConnection;192;0;194;0
WireConnection;147;0;181;0
WireConnection;47;0;213;0
WireConnection;47;1;48;0
WireConnection;47;2;217;0
WireConnection;207;0;24;4
WireConnection;43;0;40;0
WireConnection;123;0;49;0
WireConnection;13;1;45;0
WireConnection;244;12;10;0
WireConnection;244;11;255;0
WireConnection;244;9;10;1
WireConnection;85;0;244;0
WireConnection;85;1;223;0
WireConnection;127;0;123;0
WireConnection;127;1;147;0
WireConnection;12;1;47;0
WireConnection;12;2;43;0
WireConnection;93;0;268;0
WireConnection;93;1;13;0
WireConnection;93;2;43;0
WireConnection;308;0;192;0
WireConnection;220;0;225;0
WireConnection;220;1;123;0
WireConnection;272;0;229;0
WireConnection;228;0;267;0
WireConnection;228;1;211;0
WireConnection;228;2;229;0
WireConnection;270;0;257;0
WireConnection;270;1;271;0
WireConnection;270;2;272;0
WireConnection;238;0;239;1
WireConnection;238;1;127;0
WireConnection;238;2;229;0
WireConnection;273;0;93;0
WireConnection;306;0;85;0
WireConnection;306;1;214;0
WireConnection;306;2;308;0
WireConnection;253;0;24;2
WireConnection;87;1;12;0
WireConnection;87;2;220;0
WireConnection;0;0;306;0
WireConnection;0;1;273;0
WireConnection;0;2;87;0
WireConnection;0;3;270;0
WireConnection;0;4;228;0
WireConnection;0;5;238;0
ASEEND*/
//CHKSM=497F354ACD834EC497109D4B7DBEFA130FE3184F