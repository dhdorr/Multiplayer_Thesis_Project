
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
4. [The Game](#the-game)
   - [Description](#description)
   - [Home Screen](#home-screen)
   - [Character Select](#character-select)
   - [Lobby](#lobby)
   - [Gameplay](#gameplay)
6. [Communication Diagram](#communication-diagram)
7. [Database Schema](#database-schema)


 ## Overview
Multiplayer online games are a flavor of interactive distributed systems in which many disparately connected computers work together to maintain a consensus on a rapidly updating simulation. Looking beyond gameplay loops and graphical fidelity, multiplayer online games have unique challenges they must overcome to be viewed favorably by players, predominantly how the game handles latency. From the player's perspective, latency would be defined as “the time it takes for the player’s input to be shown on screen.” However, from a computer networking perspective, latency is “the time it takes for a packet of data to be sent over the network from one computer to another.” This project will discuss the implications of latency in interactive distributed systems such as multiplayer online games. Furthermore, I will discuss implementing several latency compensation techniques and demonstrate their effectiveness in several different genres of multiplayer online games. The impact of each latency compensation technique is directly related to the pace of the gameplay loop and can range from immensely impactful to not noticeable at all.

## Why Latency Compensation is important
Contrary to single-player games or LAN-based multiplayer games, online games must consider the potential maximum distance between any two connected computers and implement unique techniques to accommodate any networking anomalies that occur because of the internet. In a single-player or LAN-based environment, these updates would ideally update the simulation at a continuous, predictable, and instantaneous rate. However, latency is one of the main challenges of developing a multiplayer game, as it can contribute to inconsistencies between player views and give certain players an unfair advantage. The effect these issues have on the experience of an online game left unaddressed is that they lead to noticeable update delays, stuttering or inconsistent updates due to inconsistent delivery timing, and loss of updates. Furthermore, several published articles suggest that players begin to be negatively impacted by latency of just 150ms. Players of multiplayer online games expect their games to be just as responsive as offline games. Another contributing factor to latency is the distance of a connection. The client-server model could be more favorable to latency compensation because you can deploy servers to match the geographic location of all clients. 

## Latency Compensation Techniques (Assemble!)

Latency compensation is an incredibly vast and complex topic. As such, I cannot cover everything in this project. Instead, I will only cover the latency compensation techniques that I was able to implement in this project.

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

## The Game!
### Description
This project is designed as a multiplayer third-person action game. The game features an arena-style map in a three-dimensional play space. The game's mechanics are simple: players move about in a three-dimensional space and attempt to dodge a dangerous projectile. If the projectile hits a player, they will be eliminated. However, players can also reflect the projectile by standing in the projectile’s path and pressing the ‘reflect’ button. If the reflection succeeds, the projectile will rebound in the direction the reflecting player is facing and increase in speed. From a game design perspective, this mechanic encourages players to take risks to eliminate other players. But, from a networking perspective, this time-sensitive object interaction will test the effects of latency compensation techniques on the player’s view of the projectile. 

### Home Screen
Players will be greeted with the start menu shown below when starting the client game application. On this screen, they can set their username, which will be visible to all other players in the match. They may also select which character skin they want to use and enter the server IP address they wish to connect to. This allows the player to define their identity before requesting a connection with the server. When the Connect to Server button is pressed, the client will send a connection request packet to the server. The connection request packet includes the player’s username, selected skin, IP address, and port number. With this information, the server can create its own instance of the player that will be replicated to other connected players. Once complete, the server will send a connection response to the player, passing them a unique player_id, which will be used to authenticate their packets. When the client receives the server’s connection response, the client state will transition to the Lobby state, where they will wait for other players to connect to the server.

![main_menu_1](https://github.com/user-attachments/assets/1fd78ab8-e777-42fe-8071-9fe3469ece6e)


### Character Select
In the skin selection screen, players may choose between 10 different character skins: bard, cyborg_ninja, druid, king, queen, rogue, samurai, sorcerer, witch, and wizard. Each skin is a purely cosmetic choice that does not impact gameplay. Each character is a three-dimensional model with animations for idling, running, and reflecting projectiles. The shared animation of each skin was made possible by using Godot’s Animation Library feature. The Animation Library feature allows me to create a single animated skeleton that can be shared across many different meshes (skins). Since each mesh shares the same base model, they can easily use the same skeleton without issues such as clipping or malformed deformation weights.

![skin_menu_1](https://github.com/user-attachments/assets/99b5dcae-499f-41f8-92d8-245242049f5a)


### Lobby
Once the player connects to the server, they are immediately loaded into a game world arena. They are initially greeted with a lobby screen displaying all the currently connected players. This is the client’s Lobby state. In the lobby, each connected player gets their nameplate in the lobby interface that displays their chosen username and whether they are ready. The server has a Lobby state of its own. In the server’s Lobby state, it continuously listens for new connection requests from new clients to add to the lobby and sends out lobby updates to each client connected to the lobby. The server will not start the game until the lobby is full and all connected players are ready. In this case, the lobby size is set to four players, so the game will begin when all four players check the ready box to signify that they are ready. When the ready check box is clicked, the server will be updated that that player is ready, and in turn, the server will update the rest of the lobby that that player has ‘readied up.’ When the other clients receive this lobby update, they will update the nameplate of the ready player to have the ready check box checked off, and the square next to it will be bright green. With this, all clients should easily be able to tell who in the lobby is ready for the match. When all players have ‘readied up,’ the server will transition to the Running Game state. Upon transitioning into this state, the server will send a final lobby update to each client, prompting each one to transition into the client’s Playing Game state.

![lobby_view_1](https://github.com/user-attachments/assets/97344039-dc87-4ce6-88c4-c00b0a3c4151)


### Gameplay
Finally, when the players' lobby is full, and each player signifies that they are ready, the server will initiate a countdown to begin the match. This countdown aims to transition each client out of the Lobby state and alert them to the start of the match. At this point, each player’s client program will send input packets to the server, and the server will dispatch world updates. Clients will send the server their input packets every frame, which is 16.6667 milliseconds. Even if no input is made on the client’s controller, a packet will still be sent to the server, as doing nothing is still an important input to replicate to all other clients. The server, on the other hand, is designed to buffer inputs for ten frames. This means that all client inputs are stored in a buffer until the ten-frame time limit expires. At this time, every buffered input will be simulated simultaneously in a single frame. This ten-frame buffer is essential for managing the server's output bandwidth. Another benefit is that input packets are given ample time to arrive before the next world state gets simulated. The drawback to using a large buffer is that it adds more time to the RTT of a client’s input, so it must be balanced accordingly.
The red ball in the middle is a dangerous projectile called the Bomb-ball. If a player collides with it, they will be eliminated. The Bomb-ball is controlled solely by the server and is in constant motion from the start of the game. The Bomb-ball can bounce off the arena's walls or be reflected by the players. To reflect the Bomb-ball, a player must stand in its path, face it, and time pressing the reflect action command just before it collides with the player. The window of reflection is short, but if a player successfully reflects the ball, the player will gain temporary immunity, and the ball will increase its speed, becoming more dangerous to all players. Lastly, when the Bomb-ball collides with a player, that player is eliminated.  When a player is eliminated, their character explodes into a swarm of particles, and they no longer have control over a character. However, an eliminated player will still receive world state updates from the server, so they may continue to watch the match until all other players have been eliminated.

![gameplay_1](https://github.com/user-attachments/assets/02995044-1d30-4ac9-a91f-69627e501077)


## Communication Diagram
This figure is a communication diagram of this project that models the latency between the client and server and shows where latency compensation techniques may be applied to reduce the effects of latency.

![fancy_comm_diag_4](https://github.com/user-attachments/assets/7f72df44-5598-401b-98a2-0e11890b8e90)


## Database Schema
This is the database schema for this project. This project utilizes a SQLite database that runs on the server. The relationship between players and the matches they play can be easily navigated; you can even record every action a player makes and every update the server sends out. These records are essential for creating a replay system for other players to spectate or rewatch a match. Every 10 frames, the server dumps all of the buffered player inputs into the database, which may easily surpass 10,000 tuples in a single play session.

![Untitled](https://github.com/user-attachments/assets/0e89f7f9-d0cc-4c4b-bab2-023d665b5e85)
