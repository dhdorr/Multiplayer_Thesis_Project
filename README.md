
# Multiplayer_Thesis_Project
 Grad School Thesis for Multiplayer Netcode Latency Compensation Techniques Fall 2024
 
# Table of Contents

1. [Overview](#overview)
2. [Why Latency Compensation is Important](#why-latency-compensation-is-important)
3. [Latency Compensation Techniques](#latency-compensation-techniques)
   - [Client Prediction](#client-prediction)
   - [Entity Interpolation](#entity-interpolation)
   - [Server Reconciliation](#server-reconciliation)
   - [Buffer on Receipt](#buffer-on-receipt)
   - [Dead Reckoning](#dead-reckoning)
   - [Taxonomy of Latency Compensation Techniques](#taxonomy-of-latency-compensation-techniques)
4. [Communication Diagram](#communication-diagram)
5. [Database Schema](#database-schema)


 ## Overview
Multiplayer online games are a flavor of interactive distributed systems in which many disparately connected computers work together to maintain a consensus on a rapidly updating simulation. Looking beyond gameplay loops and graphical fidelity, multiplayer online games have unique challenges they must overcome to be viewed favorably by players, predominantly how the game handles latency. From the player's perspective, latency would be defined as “the time it takes for the player’s input to be shown on screen.” However, from a computer networking perspective, latency is “the time it takes for a packet of data to be sent over the network from one computer to another.” This project will discuss the implications of latency in interactive distributed systems such as multiplayer online games. Furthermore, I will discuss implementing several latency compensation techniques and demonstrate their effectiveness in several different genres of multiplayer online games. The impact of each latency compensation technique is directly related to the pace of the gameplay loop and can range from immensely impactful to not noticeable at all.

## Why Latency Compensation is important
Contrary to single-player games or LAN-based multiplayer games, online games must consider the potential maximum distance between any two connected computers and implement unique techniques to accommodate any networking anomalies that occur because of the internet. In a single-player or LAN-based environment, these updates would ideally update the simulation at a continuous, predictable, and instantaneous rate. However, latency is one of the main challenges of developing a multiplayer game, as it can contribute to inconsistencies between player views and give certain players an unfair advantage. The effect these issues have on the experience of an online game left unaddressed is that they lead to noticeable update delays, stuttering or inconsistent updates due to inconsistent delivery timing, and loss of updates. Furthermore, several published articles suggest that players begin to be negatively impacted by latency of just 150ms. Players of multiplayer online games expect their games to be just as responsive as offline games. Another contributing factor to latency is the distance of a connection. The client-server model could potentially be more favorable to latency compensation because you can deploy servers to match the geographic location of all clients. 

## Latency Compensation Techniques (Assemble!)
### Client Prediction
Client-side prediction, or optimistic prediction, assumes that the authoritative server will accept the player’s input and immediately process said input on the client side. As long as the game world is deterministic (given a game state and a set of inputs, the result is completely predictable), we can accurately predict the future game state before the server has processed the inputs. This can be viewed as the client optimistically applying movement velocity to the player's character or starting some animation so that the player can see an immediate response to their input.
![client_prediction_1](https://github.com/user-attachments/assets/a658ffd4-fa56-4f35-b1c5-d54f722536da)

### Entity Interpolation
asdf

### Server Reconciliation
asdf

### Buffer on Receipt
asdf

### Dead Reckoning
asdf

### Taxonomy of Latency Compensation Techniques
I am unable to discuss every possible latency compensation technique. However, a paper from a team of researchers searched and categorized every article, paper, and conference talk about latency compensation and compiled their findings into this taxonomy (family tree) of latency compensation techniques.
<img width="796" alt="taxonomy_for_latency_techniques" src="https://github.com/user-attachments/assets/b658907e-0402-41e3-941a-446c29b3ff31" />


## Communication Diagram
This figure is a communication diagram designed by No Bugs that models the latency between the client and server and shows where latency compensation techniques may be applied to reduce the effects of latency.
![fancy_comm_diag_4](https://github.com/user-attachments/assets/7f72df44-5598-401b-98a2-0e11890b8e90)


## Database Schema
![Untitled](https://github.com/user-attachments/assets/0e89f7f9-d0cc-4c4b-bab2-023d665b5e85)
