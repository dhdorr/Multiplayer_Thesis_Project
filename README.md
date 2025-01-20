
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
Contrary to single-player games or LAN-based multiplayer games, online games must consider the potential maximum distance between any two connected computers and implement unique techniques to accommodate any networking anomalies that occur because of the internet. In a single-player or LAN-based environment, these updates would ideally update the simulation at a continuous, predictable, and instantaneous rate. However, latency is one of the main challenges of developing a multiplayer game, as it can contribute to inconsistencies between player views and give certain players an unfair advantage. The effect these issues have on the experience of an online game left unaddressed is that they lead to noticeable update delays, stuttering or inconsistent updates due to inconsistent delivery timing, and loss of updates. Furthermore, several published articles suggest that players begin to be negatively impacted by latency of just 150ms. Players of multiplayer online games expect their games to be just as responsive as offline games. Another contributing factor to latency is the distance of a connection. The client-server model could be more favorable to latency compensation because you can deploy servers to match the geographic location of all clients. 

## Latency Compensation Techniques (Assemble!)
### Client Prediction
Client-side prediction, or optimistic prediction, assumes that the authoritative server will accept the player’s input and immediately process said input on the client side. As long as the game world is deterministic (given a game state and a set of inputs, the result is completely predictable), we can accurately predict the future game state before the server has processed the inputs. This can be viewed as the client optimistically applying movement velocity to the player's character or starting some animation so that the player can see an immediate response to their input.
![client_prediction_1](https://github.com/user-attachments/assets/a658ffd4-fa56-4f35-b1c5-d54f722536da)

### Entity Interpolation
Entity interpolation is another client-side technique that aims to reduce the visual artifacts of network latency and packet loss. Entity interpolation does this simply by interpolating the state of each replicated entity from its current state to the latest received state over the delta time - or the time it takes to receive the next state. Quake 3 only uses interpolation for client-side state updates, even though interpolation can produce unrealistic results. The drawback of this technique is that every client sees a slightly different view of the simulation, but delay discrepancies of up to 100ms are generally not noticeable to players.

### Server Reconciliation
Server reconciliation, often used in parallel with optimistic prediction, is a multi-step algorithm involving resolving client input and the server response. Both Gambetta and No Bugs recognize that client-side prediction becomes unstable when many client inputs are requested before the server can respond. Because of this, the client must reconcile the response from the server in a way that does not jar the player. Server reconciliation is typically only applied to a client’s player character as it requires a steady stream of past inputs or positions to be stored in memory and simulated. First, the client caches all player inputs in memory and attaches a time stamp to each input. Then, when the authoritative server receives the input, it can mark the outgoing update with that time stamp. The server needs to keep track of the time stamp it responds to because the client will need it again. Lastly, when the client receives the server’s update and the associated time stamp that the server is responding to, the client will immediately accept and apply the server’s update of the player position, then look into its cached memory of inputs for that time stamp and re-simulate every input that has occurred from that time stamp till the current time. The figure below shows a communication diagram between a client and a server in which the client is using server reconciliation. In this diagram, the client sends requests (R1) to the server, and the server generates authoritative position updates (A1) in direct response to the request. Finally, when the client receives the authoritative position update, they must apply it and re-simulate each subsequent input request. No Bugs offers further reconciliation methods like using Bezier curves and splines to blend velocity between the server’s authoritative state and the client’s latest predicted state.
![server_reconciliation_1](https://github.com/user-attachments/assets/e6b5a1f9-c4de-402d-a2ec-e26ed9f7f945)

### Buffer on Receipt
Buffer on receipt is a term that encompasses any buffer that may be implemented on both the client and the server. It allows for received update packets to be stored in memory for some amount of time before the simulation processes them. The buffer accounts for jitter and intermittent packet loss by extending the window in which a packet is expected to arrive. It then delivers the packet to the simulation at a fixed rate, creating a consistent delta between updates. The figure below shows how a buffer on receipt can alleviate the issues of an unpredictable internet connection. Buffer on Receipt is a client-side construct that allows the client to store incoming server update packets to consume updates at a steady, unchanging rate. The main purpose of the buffer is to account for variable latency within the network since packets sent over the internet will not have predictable latency. Packets may get lost or arrive out of order when traveling through the internet. The Buffer on Receipt’s job is to give late packets a chance to arrive or generate update packets if none arrive. The effect of the buffer on receipt can be subtle for clients with consistent internet connections. However, the Buffer on Receipt is necessary for a quality gameplay experience for any client with poor or inconsistent internet connections. A steady stream of updates is important for the client because of the client-side Entity Interpolation. When updates come in sporadically, this affects the interpolation speeds of networked objects and leads to a perceptible inconsistent game feel. 
![buffer_diagram_3](https://github.com/user-attachments/assets/8e3cfa05-2a0e-4cb9-8fb8-bbde013ea42d)


### Dead Reckoning
Dead reckoning is a method of projection in which the system uses the last known velocity of an object to calculate its future position or trajectory. It is commonly employed in aeronautics for tracking and projecting flight paths, particularly when the data from an aircraft's black box may be intermittently interrupted due to severe weather conditions. Dead reckoning assumes that the object in motion will continue along its current trajectory, allowing it to project an estimated change in position until the next update is received. Additionally, online games can utilize dead reckoning to accurately estimate the velocity of entities within the game world between intermittent updates from the server. For example, predicting a simulated car's motion can be achieved by taking into account its previous trajectory states and the latency between updates.

### Taxonomy of Latency Compensation Techniques
I am unable to discuss every possible latency compensation technique. However, a paper from a team of researchers searched and categorized every article, paper, and conference talk about latency compensation and compiled their findings into this taxonomy of latency compensation techniques.
![taxonomy_for_latency_techniques](https://github.com/user-attachments/assets/588d03f5-fe09-4f5b-9738-eb293932d6a5)



## Communication Diagram
This figure is a communication diagram of this project that models the latency between the client and server and shows where latency compensation techniques may be applied to reduce the effects of latency.
![fancy_comm_diag_4](https://github.com/user-attachments/assets/7f72df44-5598-401b-98a2-0e11890b8e90)


## Database Schema
![Untitled](https://github.com/user-attachments/assets/0e89f7f9-d0cc-4c4b-bab2-023d665b5e85)
