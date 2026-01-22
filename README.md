# Minimal Emulation Echo Example

This is a **minimal working echo program** that connects the OMNeT++ simulation to a real network interface.
**Note:** This is currently a simplified version because we were not able to make the more elaborate 5G version work yet.

## Overview

This project uses `ExtLowerEthernetInterface` to bridge the simulation with the host system. It includes:
1.  **Host1**: A simulated host running `UdpEchoApp`.
2.  **Ext Interface**: A network interface bound to a real device (e.g., `veth-sim`).
3.  **RealTimeScheduler**: The simulation runs in real time to allow interaction with external traffic.

## File Structure & Purpose

### 1. `RcCar5GNetwork.ned`
Defines the `ExtPingNet` network which contains:
*   `host1`: A StandardHost.
*   `configurator`: Configures the IP addresses.

### 2. `omnetpp.ini` (Simulation Configuration)
*   **Network**: `ExtPingNet`
*   **Scheduler**: `inet::RealTimeScheduler` (Required for emulation)
*   **Interface**: `ExtLowerEthernetInterface` bound to `veth-sim`.
*   **App**: `UdpEchoApp` on port 9999.

### 3. `config.xml`
Assigns the IP address (`10.255.0.2`) to the emulated interface.

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
