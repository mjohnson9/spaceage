#!/bin/sh

# Base directory
echo "-- Creating content directory"
mkdir -p workshop-content

# LICENSE
echo "-- Copying license..."
cp -auv LICENSE.md workshop-content/LICENSE

# Maps
echo "-- Copying maps..."
mkdir -p workshop-content/maps
cp -auv content/maps/*.bsp workshop-content/maps/

# Materials
echo "-- Copying materials..."
mkdir -p workshop-content/materials
cp -rauv content/materials/. workshop-content/materials/

# Models
echo "-- Copying models..."
mkdir -p workshop-content/models
cp -rauv content/models/. workshop-content/models/

# Particles
echo "-- Copying particles..."
mkdir -p workshop-content/particles
cp -rauv content/particles/. workshop-content/particles/

# Sound
echo "-- Copying sounds..."
mkdir -p workshop-content/sound
cp -rauv content/sound/. workshop-content/sound/

# Remove Git files
echo "-- Removing Git leftovers"
find workshop-content -iname '.git*' -delete
