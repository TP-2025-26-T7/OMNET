# RC Car 5G Network Simulation

This project simulates a 5G network scenario where a central controller communicates with multiple RC cars using OMNeT++ and the Simu5G framework.

## Project Overview

The simulation models a **Standalone 5G Network** where:
1.  A **Controller** (Server) sends telemetry requests (simulated as JSON files) to RC Cars.
2.  **RC Cars** (UEs) receive the requests and echo the data back to the controller.
3.  The communication happens over a simulated 5G New Radio (NR) link via a gNodeB.

## File Structure & Purpose

### 1. `RcCar5GNetwork.ned` (Network Topology)
Defines the physical and logical structure of the network.
*   **Modules**:
    *   `controller`: The server sending commands.
    *   `gnb`: The 5G Base Station (gNodeB).
    *   `car[numCars]`: The RC cars equipped with 5G connectivity (`NRUe`).
    *   `upf` / `coreUpf`: User Plane Functions handling 5G core routing.
    *   `binder`, `channelControl`: Simu5G helper modules for resource management and wireless channel modeling.
*   **Connections**: Defines the wired links from the Controller through the 5G Core to the gNodeB.

### 2. `omnetpp.ini` (Simulation Configuration)
The main configuration file controlling the simulation parameters.

**Key Configurations:**

*   **Traffic Generation (Simulating JSON):**
    *   The Controller uses `UdpBasicApp` to send packets.
    *   `*.controller.app[*].messageLength = 1024B`: Simulates a 1KB JSON file.
    *   `*.controller.app[*].sendInterval = 1s`: Sends data every second.
    *   `*.car[*].app[0].typename = "UdpEchoApp"`: Cars simply echo the received data back.

*   **Mobility:**
    *   Cars use `LinearMobility` to move at `10mps` (approx 36 km/h).
    *   `*.car[*].mobility.initialX/Y`: Sets starting positions.

*   **5G Settings:**
    *   `*.channelControl.carrierFrequency = 3.5GHz`: Operating frequency.
    *   `*.car[*].macCellId = 1`: Associates cars with the specific gNodeB.

### 3. `config.xml` (IP Configuration)
A helper file used by the `Ipv4NetworkConfigurator` to automatically assign IP addresses (e.g., `10.x.x.x`) to all devices in the network.

## How It Works

1.  **Initialization**: The simulation starts, placing 3 cars and 1 gNodeB on the canvas.
2.  **Connection**: Cars attach to the gNodeB signal.
3.  **Traffic Flow**:
    *   At `t=2s`, the Controller sends a 1024-byte UDP packet to Car 0.
    *   The packet travels: Controller -> Router -> UPF -> CoreUPF -> gNodeB -> (Wireless 5G) -> Car 0.
    *   Car 0 receives the packet and immediately sends it back (Echo).
4.  **Loop**: This repeats for all cars every second.

## How to Run

### Using the IDE (GUI)

1.  Open the project in the **OMNeT++ IDE**.
2.  Right-click `omnetpp.ini`.
3.  Select **Run As > OMNeT++ Simulation**.
4.  Click **Run** in the simulation window to visualize the packet flow.

### Using CLI (Headless Mode)

To run the simulation without the graphical interface (useful for servers or batch runs):

1.  Open your terminal/command prompt.
2.  Navigate to the project folder.
3.  Run the following command:
    ```bash
    opp_run -u Cmdenv -c General -n . omnetpp.ini
    ```
    *   `-u Cmdenv`: Selects the command-line interface (no GUI).
    *   `-c General`: Runs the configuration named "General".
    *   `-n .`: Sets the NED path to the current directory.

