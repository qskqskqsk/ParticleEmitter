//--------------------------------------------------------------------------------------
// Copyright (c) XU, Tianchen. All rights reserved.
//--------------------------------------------------------------------------------------

#include "SharedConst.h"

//--------------------------------------------------------------------------------------
// Struct
//--------------------------------------------------------------------------------------
struct Particle
{
	float3 Pos;
	float3 Velocity;
	float LifeTime;
};

static float4 g_boundary = { BOUNDARY };

//--------------------------------------------------------------------------------------
// Transform from simulation space to grid space
//--------------------------------------------------------------------------------------
int3 SimulationToGridSpace(float3 v)
{
	const float halfGridSize = GRID_SIZE * 0.5;
	v = (v - g_boundary.xyz) / g_boundary.w; // [-1, 1]

	return v * halfGridSize + halfGridSize;
}

//--------------------------------------------------------------------------------------
// Transform from world space to simulation space
//--------------------------------------------------------------------------------------
float3 WorldToSimulationSpace(float3 v)
{
	return v * 0.1;
}

//--------------------------------------------------------------------------------------
// Transform from simulation space to world space
//--------------------------------------------------------------------------------------
float3 SimulationToWorldSpace(float3 v)
{
	return v / 0.1;
}

//--------------------------------------------------------------------------------------
// Out of grid boundary
//--------------------------------------------------------------------------------------
bool IsOutOfGrid(int3 pos)
{
	return any(pos < 0.0) || any(pos >= GRID_SIZE);
}

//--------------------------------------------------------------------------------------
// Hash to linear index
//--------------------------------------------------------------------------------------
uint GridGetCellIndex(int3 pos)
{
	return dot(pos, int3(1, GRID_SIZE, GRID_SIZE * GRID_SIZE));
}

//--------------------------------------------------------------------------------------
// Hash to linear index
//--------------------------------------------------------------------------------------
uint GridGetCellIndexWithPosition(float3 pos)
{
	int3 gPos = SimulationToGridSpace(pos);
	//gPos = clamp(gPos, 0.0, GRID_SIZE - 0.0001);

	return IsOutOfGrid(gPos) ? GRID_SIZE * GRID_SIZE * GRID_SIZE : GridGetCellIndex(gPos);
}
