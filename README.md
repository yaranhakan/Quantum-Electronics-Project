# Quantum Electronics Final Project

Quantifying Photon Statistics of a Pulsed LASER

## Project Description

The goal of this project is to quantify photon statistics of a pulsed LASER using data obtained from time-stamped photodetections of single photon detectors (APDs). The data was obtained from the experiment using a pulsed LASER which generates light pulses of temporal width 10 ns every 100 ns. The pulses were attenuated using neutral density filter and coupled into a 1X4 fiber-based beam splitter. The output of each end of the fiber was connected to APDs which are "ON-OFF" type detectors.

The unsynchronized data from the time tagger is provided in the file `10ns_1E6_10SEC_Formatted.txt`. The data is divided into teams, and each team is assigned a different time range to work with. Each team further splits the data into two halves and divides the first half into time bins of size Trep.

## Data Processing

The following steps were taken to process the data:

1. The time bin to which each photon belongs was determined based on the time stamp of the photodetection.
2. If two photons have the same time bin and the relative delay is less than the pulse width, then they must be coming from the same pulse.
3. The time delay of each time photodetection was calculated.
4. The data for each team was synchronized using the method discussed in class. The value of Trep was determined such that the delay Vs bin should be a horizontal line with a finite width.
5. The synchronized data for each team was saved as `Data-TeamX-Synchronized.txt`, where X is the team number.
6. The number of bins which are empty, one photon, two photons, and three photons was counted for the synchronized data.
7. The histogram of the probabilities was plotted.

## File Structure

The following files are included in the project:

- `10ns_1E6_10SEC_Formatted.txt`: The unsynchronized data from the time tagger.
- `Data-TeamX-Synchronized.txt`: The synchronized data for each team.
- `README.md`: This file.


## Credits

This project was completed by O. Hakan Yaran as part of Quantum Electronics course at Syracuse University with the supervision of Professor Pankaj Jha. The data processed in this project was gathered from Professor Jha's experiment at Quantum Lab in Syracuse University. This project is a replication of the paper "Photon statistics characterization of a single-photon source" by R. Alléaume. The code was written by O. Hakan Yaran.
