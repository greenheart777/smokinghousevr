Description
   Burning Shader is a shader that will help you in creating your game. Also there are particle systems, lighting, script and models to display the shader environment.
   The models were taken from a free asset Viking Village by UNITY TECHNOLOGIES from unity asset store for demonstration purpose.
   ***ATTENTION*** To get a visual similar to the previews you need to download Post Processing Stack by UNITY TECHNOLOGIES. It's free. And use PostProcessBehaviour script with the file, which can be found in the folder PostProcess on a camera.***ATTENTION*** 
   The shader was created using Amplify Shader Editor(1.6.4).


Shader Property
   * CoalMask - use special texture, it contains noises and masks, in folder "Assets/Textures/Special"
   * WoodAlbedo - use your albedo texture of wood
   * WoodNormal - use your normal texture of wood
   * CoalNormal - use special normal texture, in folder "Assets/Textures/Special"
   * CoalColor - hot coal color, this is HDR
   * CinderPower - control how much space will take all cinder
   * CinderSidePower - control how much space will take side cinder
   * CinderLow - control how much space will take cinder in the lower parts of the object
   * AshesPower - control how much space will take ashes
   * UVTiling - uv scale of coal
   * DetailWoodAlbedo - additional texture for your albedo to improve the visuals of the material


Supported Platforms
   All platforms 


Unity Versions 
   Unity 2017.4.19f1 and higher


Versions of burning shader
   * sh_coal
   * sh_coal_localcoord
   * sh_coal_mask
   * sh_coal_mask_localcoord
   * sh_coal_mask_met
   * sh_coal_mask_met_localcoord
   * sh_coal_met
   * sh_coal_met_localcoord
   * sh_coal_nodetailalbedo
   * sh_coal_nodetailalbedo_localcoord
   * sh_coal_nodetailalbedo_met
   * sh_coal_nodetailalbedo_met_localcoord
   * sh_coal_nodetailalbedo_notriplanar_met
   * sh_coal_nodetailalbedo_notriplanar_met_localcoord
   * sh_coal_notriplanar
   * sh_coal_notriplanar_localcoord
   * sh_coal_notriplanar_met
   * sh_coal_notriplanar_met_localcoord
   * sh_coal_notriplanar_nodetailalbedo
   * sh_coal_notriplanar_nodetailalbedo_localcoord

   Where
      * _met - shaders use metallic map instead of specular color
      * _localcoord - calculating the position of coal in local space instead of world
      * _mask - alfa mask if the object should burn through
      * _nodetailalbedo - lightens the shader
      * _notriplanar - lightens the shader


Feedback (suggestions, questions, reports or errors)
   SomeOneWhoCaresFeedBack@gmail.com


My social networks
   https://www.artstation.com/vrdsgsegs
   https://twitter.com/iOneWhoCares
   