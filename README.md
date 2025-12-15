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

1.  **Initialisation**: The simulation starts, placing 3 cars and 1 gNodeB on the canvas.
2.  **Connection**: Cars attach to the gNodeB signal.
3.  **Traffic Flow**:
    *   At `t=2s`, the Controller sends a 1024-byte UDP packet to Car 0.
    *   The packet travels: Controller -> Router -> UPF -> CoreUPF -> gNodeB -> (Wireless 5G) -> Car 0.
    *   Car 0 receives the packet and immediately sends it back (Echo).
4.  **Loop**: This repeats for all cars every second.

# How to Run and Set Up

# OMNeT++ on Windows via WSL2 

## 1) Install (or update) WSL2 on Windows

1. Open **PowerShell as Administrator**.

2. Install WSL + default Ubuntu:

   ```powershell
   wsl --install
   ```

3. Reboot when prompted.

4. Update and verify WSL:

   ```powershell
   wsl --update
   wsl --version
   wsl --list --verbose
   ```

---

## 3) Install OMNeT++ 

### Option A (Recommended on Windows): `opp_env.wsl` 

OMNeT++’s download page recommends `opp_env` and specifically provides an **`opp_env.wsl`** image for WSL, with a minimum WSL version requirement.

**Install `opp_env.wsl`:**

* Download `opp_env.wsl` and **double-click** it
* On first run, follow the prompts (option 2 with INET is best)
* On **other runs** to open the WSL use:

```powershell
wsl -d opp_env
```

---

## 3.1) Install the needed framework: Simu5G (and its dependencies)

Inside the `opp_env.wsl` distro:

```bash
mkdir -p ~/workspace/simu5g_ws
cd ~/workspace/simu5g_ws
opp_env init
opp_env install simu5g-1.3.0
```

* Note: Go make your self some coffe (wait time to download everything is about 45 minutes)

---

## 3.2) Start the IDE (GUI)

Once you are in the correct environment `opp_env`:

  ```bash
  omnetpp
  ```

---

## 4) Create a clean project structure (src + simulations) in the IDE

1. **File → New → OMNeT++ Project**
2. Input name (`tp7`) -> Next >
3. Select: **Clean project with src and simulation folders**
4. Next > (Skip C++ Project type, keep default)
5. Next > (Skip Select Configuration, keep default)
6. Finish

### 4.2) Add references and packages

Right-click the project -> Properties -> Project References -> Select: **inet** and **simu5g**

**Add**
NED file needs to be placed in a folder named `myrcproject` in `src` folder

---

## 5) Build the project (IDE workflow)

1. **Project → Build Project** (Or Build ALL)
2. If you get linker/include errors, re-check:

   * Project references to INET/Simu5G
   * Active build configuration (Debug/Release), especially if you mix binaries

---

## 6) Put files from GitHub into the IDE project

* Clone OMNET github repo into your **WSL Linux filesystem** (e.g., `~/workspace/...`), then import into the IDE.

Steps:

1. In WSL:

   ```bash
   cd ~/workspace
   git clone https://github.com/TP-2025-26-T7/OMNET.git
   ```
2. In OMNeT++ IDE:

   * **File → Import → General → Existing Projects into Workspace**
   * Select the cloned directory

---

## 7) Run the simulation (GUI)

1. Open `simulations/omnetpp.ini`
2. Right-click → **Run As → OMNeT++ Simulation**
3. Choose **Qtenv** if you want interactive GUI runs.

---

# Error handling

- NED file needs to be placed in a folder named "myrcproject"
- omnetpp.ini needs to have Network set as: `<projectname>.myrcprojectRcCar5GNetwork`
- Original project name in OMNET was `tp7`
- Other than that, its skill issue
