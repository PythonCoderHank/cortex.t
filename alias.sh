#!/bin/bash

# Change all variables accoriding to your wallet/hotkey names, open ports, and logging preference.

# Set global variables for miner
export MINER_WALLET_NAME="MINER WALLET HERE"
export MINER_NETWORK_NAME="local" # Can change this to finney if you don't have a local node set up
export MINER_BASE_PORT=9000 # Pick an available listening tcp port here
export LOGGING_LEVEL="info" # Other options are info and trace. Info is less logging and trace is more logging.

# Set global variables for validator
export VALI_NAME="default"
export VALI_HOTKEY="default"
export VALI_BASE_PORT=15000

function start_miner {
  local miner_number=$1
  local hotkey=$(printf "%02d" $miner_number) # This assumes the miner hotkeys are named 01 thorugh 09
  local port=$(($MINER_BASE_PORT + $miner_number))
  local cmd="pm2 start ./neurons/miner.py --interpreter python3 -- --netuid 18 --subtensor.network $MINER_NETWORK_NAME --wallet.name $MINER_WALLET_NAME --wallet.hotkey $hotkey --axon.port $port --logging.$LOGGING_LEVEL"

  echo "Executing command: $cmd"
  eval $cmd
}

function start_vali {
  local cmd="pm2 start ./neurons/validator.py --interpreter python3 -- --netuid 18 --subtensor.network $MINER_NETWORK_NAME --wallet.name $VALI_NAME --wallet.hotkey $VALI_HOTKEY --logging.$LOGGING_LEVEL"

  echo "Executing command: $cmd"
  eval $cmd
}

# Create aliases for start_miner1, start_miner2, ..., start_miner9
for i in {1..9}; do
  alias start_miner$i="start_miner $i"
done

alias start_vali="start_vali"