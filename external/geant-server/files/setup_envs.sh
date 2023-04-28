

#!/bin/bash
currentpath=$PWD

# Envs

# ROOT
echo "setup root..."
source /physics/root/build/bin/thisroot.sh

# geant4
echo "setup geant..."

cd /physics/geant/build

geant4_envbindir=$(pwd)
#-----------------------------------------------------------------------
# Setup Geant4 binary and library paths...
#
export PATH="$geant4_envbindir":${PATH}
export LD_LIBRARY_PATH="`cd $geant4_envbindir/BuildProducts/li* > /dev/null ; pwd`":${LD_LIBRARY_PATH}


# - Datasets
export G4NEUTRONHPDATA="`cd $geant4_envbindir/data/G4NDL4.6 > /dev/null ; pwd`"
export G4LEDATA="`cd $geant4_envbindir/data/G4EMLOW8.0 > /dev/null ; pwd`"
export G4LEVELGAMMADATA="`cd $geant4_envbindir/data/PhotonEvaporation5.7 > /dev/null ; pwd`"
export G4RADIOACTIVEDATA="`cd $geant4_envbindir/data/RadioactiveDecay5.6 > /dev/null ; pwd`"
export G4PARTICLEXSDATA="`cd $geant4_envbindir/data/G4PARTICLEXS4.0 > /dev/null ; pwd`"
export G4PIIDATA="`cd $geant4_envbindir/data/G4PII1.3 > /dev/null ; pwd`"
export G4REALSURFACEDATA="`cd $geant4_envbindir/data/RealSurface2.2 > /dev/null ; pwd`"
export G4SAIDXSDATA="`cd $geant4_envbindir/data/G4SAIDDATA2.0 > /dev/null ; pwd`"
export G4ABLADATA="`cd $geant4_envbindir/data/G4ABLA3.1 > /dev/null ; pwd`"
export G4INCLDATA="`cd $geant4_envbindir/data/G4INCL1.0 > /dev/null ; pwd`"
export G4ENSDFSTATEDATA="`cd $geant4_envbindir/data/G4ENSDFSTATE2.3 > /dev/null ; pwd`"





# pythia
echo "setup pythia..."
export PYTHIA8_INCLUDE=/physics/pythia8/include
export PYTHIA8_LIBRARIES=/physics/pythia8/lib
export PYTHONPATH=$PYTHONPATH:/physics/pythia8/lib

#fastjet
echo "setup fastjet..."
export FASTJET_INCLUDE=/physics/fastjet-3.3.3/include
export FASTJET_LIBRARIES=/usr/local/lib

#hepmc
echo "setup hepmc..."
export HEPMC_INCLUDE=/physics/hepmc/hepmc3/include/
export HEPMC_LIBRARIES=/usr/local/lib
#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$HEPMC_LIBRARIES
export PYTHONPATH=$PYTHONPATH:/physics/hepmc/build/python/3.10.7

# preload libs (fix)
export LD_PRELOAD=''
for file in /physics/geant/build/BuildProducts/lib/*.so
do
  echo $file
  export LD_PRELOAD=$file:$LD_PRELOAD
done


cd $currentpath
