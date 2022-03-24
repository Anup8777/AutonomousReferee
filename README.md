<div id="top"></div>
<!--
README to be edited according to the need.
-->

# Autonomous Referee System Project - MSD2021

## Table of Content
1. [About The Project](#about-the-project)
2. [Feasibility Studies](#feasibility-studies)
3. [System Architecture](#system-architecture)
4. [Implementation and Validation](#implementation-and-validation)
5. [How to get a flying start?](#how-to-get-a-flying-start)
6. [Team](#team)

<!-- ABOUT THE PROJECT -->
## About The Project

The goal of the project is to develop an autonomous referee system for soccer robots which can satisfy the following goal:

*"The final goal is to have a 5 minute long 2 against 2 robot soccer game, using the Tech United turtles, refereed by the system described above, which receives a positive recommendation by an experienced human referee. By positive recommendation we mean that the human referee acknowledges that the provided refereeing system, for that 5 minute long game, refereed the match well."*

The full description of the project can be found under docs/[autoref_2122 comments RD.pdf](https://github.com/Anup8777/AutonomousReferee/blob/main/docs/autoref_2122%20comments%20RD.pdf "autoref_2122 comments RD.pdf")


<!-- Feasibility Analysis -->
## Feasibility Studies
In order to develop the autonomous referee system different technologies have been taken into considerastion as follow:
- Using simulation
- Using Drone + Camera
- Using surveillance cameras to record the match
- Using TURTLE (Tech United soccer robots)

For each of the above technology a feasibility study document has been prepared which can be found in: docs/[FeasibilityAnalysis](https://github.com/Anup8777/AutonomousReferee/tree/main/docs/FeasibilityAnalysis "FeasibilityAnalysis")

![image](https://user-images.githubusercontent.com/20322579/159932182-10ca3719-1516-491d-8192-d3656c5a316b.png)

Then each technology has been evaluated by PUGH matrix by each of the team members and it is decided to use TURTLEs as the main technology to develop the AutoRef system.

<!-- System Architecture -->
## System Architecture

The **Architecture Description** dcoument can be found in the following folder: docs/[Architecture](https://github.com/Anup8777/AutonomousReferee/tree/main/docs/Architecture "Architecture")

The Architecture Description document covers the following topic:
- Introduction
- Stakeholders and Concerns
- Environment Analysis
- Models and Views

<!-- Implementation -->
## Implementation and Validation

The developed code in MATLAB for the Task 1 and Task 2 can be found in the following folder in GitHub repository: AutonomousReferee/[src](https://github.com/Anup8777/AutonomousReferee/tree/main/src "src")
 
For example, the developed codes can be used to detect the violation in the follwoing two scenarios.
 
### Task1: Ball Out of Play
Determine if the ball is in or out of pitch (BOOP).  

https://user-images.githubusercontent.com/20322579/159901992-aee37024-05e3-4a03-b4ae-37d4e773a160.mp4

### Task2: Determine if the ball has rolled freely for > 0.5 m after kick

https://user-images.githubusercontent.com/20322579/159902028-0035ea5f-ba2e-4644-b3eb-ce7a2c7c0c54.mp4

<!-- How to get a flying start -->
## How to get a flying start?

- It is recommended to not start from the scratch.
- It is highly recommended to get in touch with the Tech United team and use the Tech United repository in case of using TURTLES. <br />
  Some of the people that you can get in touch with:<br />
  Tech United Website: https://www.techunited.nl/en/<br />
  Tech United (Techunited@tue.nl)<br />
  René van de Molengraft (M.J.G.v.d.Molengraft@tue.nl)<br />
  Ruben Beumer (r.m.beumer@tue.nl) <br />
- In the Tech United repository there are tools that may be useful for the development of the AutoRef system<br />
  **Greenfield**<br />
  **Simulator**<br />
  **Refbox**<br />
- Ask for permission for using the security cameras.
  You may contact with Ömür Arslan (o.arslan@tue.nl) to ask for the permission.
- Get in touch with MSD2021.
- Get in touch with Matthias Briegel
  Matthias is the person who has previously worked on developing AutoRef system and he may share some interesting ideas for the development of the AutoRef system. (matthias_briegel@hotmail.com)

<!-- Team -->
## Team

This project has been carried out by the Mechatronic Systems Design (MSD) 2021 at Eindhoven University of Technology (TU/e) for the 1st in-house project in Block II of the program. The team members are as follow:

Anup Padaki - System Architect (a.v.padaki@tue.nl)<br />
Cevahir Karagoz - Design Engineer (c.karagoz@tue.nl)<br />
Guilherme Pagatini - Project Manager (g.pagatini@tue.nl)<br />
Kian Azami - Design Engineer (k.azami@tue.nl)<br />
Marzhan Baubekova - Team Leader (m.baubekova@tue.nl)<br />
Meghna Mohamed - Design Engineer (m.mohamed@tue.nl)<br />
Shubo Zhang - Desgin Engineer (s.zhang6@tue.nl)<br />
Yuri Hudak - Design Engineer (y.f.hudak@tue.nl)<br />

MSD2021 AutoRef Project Link: https://github.com/Anup8777/AutonomousReferee

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- LICENSE -->
## License

Distributed under the MIT License. See `LICENSE.txt` for more information.

<p align="right">(<a href="#top">back to top</a>)</p>
