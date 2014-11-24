#include <a_samp>
#include <streamer>

new objects[8];
public OnFilterScriptInit()
{
	objects[0] = CreateDynamicObject(8148,2514.8999000,-2595.6001000,15.3000000,0.0000000,0.0000000,0.0000000); //
	objects[1] = CreateDynamicObject(8148,2374.5000000,-2574.7000000,15.6000000,0.0000000,0.0000000,180.0000000); //
	objects[2] = CreateDynamicObject(8042,2514.8999000,-2504.3999000,18.1000000,0.0000000,0.0000000,15.0000000); //
	objects[3] = CreateDynamicObject(8209,2465.8999000,-2494.0000000,15.7000000,0.0000000,0.0000000,180.0000000); //
	objects[4] = CreateDynamicObject(8209,2424.0000000,-2494.0000000,15.7000000,0.0000000,0.0000000,179.9950000); //
	objects[5] = CreateDynamicObject(8209,2425.7000000,-2680.3000000,14.7000000,0.0000000,0.0000000,359.9950000); //
	objects[6] = CreateDynamicObject(3749,2376.1001000,-2663.8999000,18.4000000,0.0000000,0.0000000,90.0000000); //
	objects[7] = CreateDynamicObject(8209,2376.3000000,-2674.8000000,-29.3000000,0.0000000,90.0000000,267.7450000); //
	return 1;
}

public OnFilterScriptExit()
{
	for(new i = 0; i < 8; i++) {
	    DestroyDynamicObject(objects[i]);
	}
	return 1;
}
