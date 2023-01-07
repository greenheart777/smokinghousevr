// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Burned/Particles/HeatDistortParticle"
{
	Properties
	{
		_TextureSample0("Texture Sample 0", 2D) = "bump" {}
		_Distort("Distort", Range( 0 , 1)) = 0.7226186
		_BigDot("BigDot", 2D) = "white" {}
		_Tile("Tile", Vector) = (1,1,0,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		GrabPass{ }
		CGPROGRAM
		#pragma target 2.0
		#pragma surface surf Unlit alpha:fade keepalpha noshadow noambient novertexlights nolightmap  nodynlightmap nodirlightmap nofog 
		struct Input
		{
			float4 screenPos;
			float2 uv_texcoord;
			float4 vertexColor : COLOR;
		};

		uniform sampler2D _GrabTexture;
		uniform sampler2D _TextureSample0;
		uniform float2 _Tile;
		uniform float _Distort;
		uniform sampler2D _BigDot;
		uniform float4 _BigDot_ST;

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float3 tex2DNode3 = UnpackNormal( tex2D( _TextureSample0, ( i.uv_texcoord * _Tile ) ) );
			float2 appendResult17 = (float2(tex2DNode3.r , tex2DNode3.g));
			float3 appendResult18 = (float3(( appendResult17 * _Distort ) , tex2DNode3.b));
			float4 screenColor2 = tex2D( _GrabTexture, ( ase_screenPosNorm + float4( ( appendResult18 * i.vertexColor.a ) , 0.0 ) ).xy );
			o.Emission = screenColor2.rgb;
			float2 uv_BigDot = i.uv_texcoord * _BigDot_ST.xy + _BigDot_ST.zw;
			o.Alpha = ( tex2D( _BigDot, uv_BigDot ).r * i.vertexColor.a );
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
-1673;35;1666;980;2180.507;464.7885;1.768251;True;False
Node;AmplifyShaderEditor.TexCoordVertexDataNode;39;-2045.674,238.5836;Float;False;0;2;0;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.Vector2Node;41;-2028.065,408.322;Float;False;Property;_Tile;Tile;3;0;Create;True;0;0;False;0;1,1;2,2;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-1776.73,289.7524;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;3;-1486.601,272.1041;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;a27471c99ffb7d149943faa5d0b7fa27;a27471c99ffb7d149943faa5d0b7fa27;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;-1477.855,473.2809;Float;False;Property;_Distort;Distort;1;0;Create;True;0;0;False;0;0.7226186;0.005;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;-1080.877,260.4349;Float;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;36;-699.9456,377.7512;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;6;-884.9633,280.2606;Float;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;18;-605.6842,277.7198;Float;False;FLOAT3;4;0;FLOAT2;0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.VertexColorNode;35;-571.8626,644.7407;Float;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ScreenPosInputsNode;4;-268.1078,63.25719;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-290.0034,279.8531;Float;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SamplerNode;24;-690.4647,433.7272;Float;True;Property;_BigDot;BigDot;2;0;Create;True;0;0;False;0;4dc913430fb6d6c4d82675d47f4820f0;4dc913430fb6d6c4d82675d47f4820f0;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;5;62.58492,147.5185;Float;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;5.357479,456.8057;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenColorNode;2;275.6982,143.386;Float;False;Global;_GrabScreen0;Grab Screen 0;0;0;Create;True;0;0;False;0;Object;-1;False;False;1;0;FLOAT2;0,0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;20;602.3824,186.2076;Float;False;True;0;Float;ASEMaterialInspector;0;0;Unlit;Burned/Particles/HeatDistortParticle;False;False;False;False;True;True;True;True;True;True;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Transparent;0.5;True;False;0;False;Transparent;;Transparent;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;False;2;5;False;-1;10;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;42;0;39;0
WireConnection;42;1;41;0
WireConnection;3;1;42;0
WireConnection;17;0;3;1
WireConnection;17;1;3;2
WireConnection;36;0;3;3
WireConnection;6;0;17;0
WireConnection;6;1;7;0
WireConnection;18;0;6;0
WireConnection;18;2;36;0
WireConnection;38;0;18;0
WireConnection;38;1;35;4
WireConnection;5;0;4;0
WireConnection;5;1;38;0
WireConnection;34;0;24;1
WireConnection;34;1;35;4
WireConnection;2;0;5;0
WireConnection;20;2;2;0
WireConnection;20;9;34;0
ASEEND*/
//CHKSM=C5981A0B7F43618718F3428C535A064D2DB2109F