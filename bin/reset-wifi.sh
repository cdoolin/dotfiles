#!/bin/bash

sudo modprobe -r ath11k_pci ath11k mhi_pci_generic
sudo modprobe ath11k_pci
sudo systemctl restart NetworkManager

