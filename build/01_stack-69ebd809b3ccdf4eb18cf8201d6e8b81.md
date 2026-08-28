---
title: Stack
---

[Portal](https://github.com/ophelialabs/Platform/tree/main/fluent/cmd_cntr2) | [Interface](https://ophelialabs.github.io) | [NeurIPS](https://neurips.cc/)

---

## SciStream (The Pipe): High-Speed Data Streaming
[SciStream](https://scistream.readthedocs.io/) is an architecture and toolkit designed to handle the real-time movement of massive data from scientific instruments to remote supercomputers. Streams the high-bandwidth, raw neural spike data (the "firehose") directly from the NESD interface to a GPU-accelerated workstation. [1](https://dl.acm.org/doi/pdf/10.1145/3502181.3531475)
- **Purpose**: It enables high-speed (100Gbps+), memory-to-memory data streaming [11, 27].
    * **Real-Time Feed**: Acts as the high-speed "highway" for the 1 million+ neurons being recorded. It handles memory-to-memory streaming from the implanted NESD device to the dashboard with ultra-low latency (~4 microseconds), ensuring the Commander sees actions as they happen.
- **Key Function**: It bridges different security domains, allowing researchers to analyze data as it's being generated (e.g., from a telescope or light source) rather than waiting for days to transfer and process it later [11, 27].
- **Developers**: Lead by researchers from [Argonne National Laboratory](https://par.nsf.gov/servlets/purl/10380550) [27]. [1](https://sc20.supercomputing.org/proceedings/workshops/workshop_pages/pec240.html)

## syGlass (The Lens):
Volumetrically renders this massive stream in real-time. It allows the Commander or Physician to literally "walk through" the user's neural forest in a VR headset, seeing 3D activation patterns as they happen.
- Data Translation: SciStream delivers data in high-speed formats (like HDF5 or raw buffers). You would use the syGlass Python API to ingest these streams and convert them into volumetric blocks for the VR engine.
- Annotation Sync: Annotations made by the Physician inside syGlass (e.g., "Scar tissue forming here") are tagged and sent to the SciX-linked database, ensuring the user's "Digital Twin" is updated across the entire mission ecosystem.

## SciX (The Atlas): Research Discovery Platform
[SciX](https://scixplorer.org/) is an open digital library and discovery portal that expands upon the legendary Astrophysics Data System (ADS). Provides a semantic overlay. When a Physician clicks on a specific cluster of firing neurons in syGlass, SciX pulls up the relevant research papers, previous mapping sessions, or clinical warnings associated with that specific brain region.
- **Purpose**: It serves as a unified search platform for literature, datasets, and software [1, 13].
    * **Knowledge Layer**: Acts as the "library" that stores historical patient data, calibration models, and relevant clinical literature. It allows the Physician to cross-reference a user's current neural patterns with known research or previous successful configurations.
- **Coverage**: While ADS focused on astronomy and physics, SciX expands this to [Earth science, heliophysics, planetary science, and biological sciences]() [13, 23].
- **Key Features**: It uses semantic technologies and knowledge graphs to link papers directly to the underlying data products and code used to create them [16, 20].
- **Sponsor**: It is a [NASA-backed initiative](https://ui.adsabs.harvard.edu/blog/scix) developed by the Center for Astrophysics | Harvard & Smithsonian [13, 14].

### Integrated Workflow
Feature | SciStream | SciX
|:---------- | ---------- |:------------:|
Primary Goal | Efficiently move live experimental data. | Efficiently discover and link research.
Target Data | Raw streams from instruments (HPC). | Publications, datasets, and software.
Main Use Case | Real-time analysis and steering. | Literature reviews and cross-discipline research.

Integrating syGlass into a SciStream + SciX architecture provides the "Immersive Command Center" for the NESD dashboard. While SciStream moves the data and SciX provides the context, syGlass acts as the high-performance VR/AR visualization engine for the 1 million+ neurons.

- **Deployment**: SciStream handles the high-bandwidth "firehose" of data required by NESD's \(10^{6}\) neuron recording goal.
- **Monitoring**: The Commander uses a simplified interface to confirm the "Link" is active and responsive during a mission.
- **Analysis**: Simultaneously, the Physician uses SciX to pull "Digital Twin" models of the user's brain to verify that stimulation patterns (writing to \(10^{5}\) neurons) remain within safe therapeutic limits.

## Specific Dashboard Roles
| Feature | Commander View (Operational) | Physician View (Clinical)
|:---------- | ---------- |:------------:|
| Primary Goal | Mission readiness and intent execution. | Signal integrity and neurological health.
SciStream Role | Live Telemetry: Visualizes real-time "intent" signals (e.g., motor control for a drone or limb). | Signal Quality: Monitors raw electrode impedance and noise levels across thousands of channels.
SciX Role | Contextual Alerts: Flags if the user's "baseline" performance is dropping based on mission history. | Diagnostic Linking: Links current neural anomalies to known clinical research via the SciX Science Explorer.
Key Metrics | Signal Latency, Intent Accuracy, Battery Life. | Neural Plasticity, Electrode Degradation, Health Baselines.

### For the Commander: 
#### "Tactical Neural Map"
- syGlass Implementation: Uses a simplified, high-contrast 3D overlay. It visualizes "Intent Bubbles"—zones of the motor cortex lighting up before a physical action is taken.
- Synergy: If SciStream detects a lag in the neural-to-digital link, syGlass can highlight the "bottleneck" area in red within the Commander's field of view, allowing for an immediate tactical swap or mission abort.

#### "Augmented Intent"
- Sensory Injection: The Commander can "push" tactical data directly into the user’s sensory perception. For example, injecting a "thermal sense" or "spatial ping" into the user's parietal lobe, allowing them to "feel" an enemy's location without looking at a screen.
- Focus Steering: By manipulating the XR dashboard, the Commander can boost the user's visual processing or auditory gain during high-stress moments, effectively "tuning" the user's brain for the mission.

### For the Physician: 
#### "Precision Diagnostic Suite"
- syGlass Implementation: Enables "Virtual Micro-Slicing." The Physician can freeze a SciStream live-feed and use syGlass tools to measure the density of neural firing or track electrode degradation in 1:1 scale.
- Synergy: While inside the syGlass VR environment, the Physician can trigger SciX queries via voice command (e.g., "SciX: Show similar activation patterns in recent epilepsy studies"), with the results appearing as floating windows next to the live 3D brain model.

#### "Sensory Re-Calibration"
- Tactile Mapping: If a user has lost sensation in a limb, the Physician can use syGlass in XR to manually stimulate specific "dead" zones. By "tapping" a virtual neuron in the XR environment, they send a signal to the NESD to trigger a phantom touch for the user.
- Pain Suppression: The Physician can identify "pain circuits" (hyper-active clusters) and use an XR interface to "dim" those regions, sending inhibitory signals to provide immediate relief.
- SciX Integration: During manipulation, SciX provides real-time "Safety Envelopes." If the Physician tries to stimulate a region too intensely, SciX flags a clinical study or safety protocol as a HUD overlay in the XR headset.

## Technical Implementation via syGlass & SciStream
- Haptic Mirroring: Use the syGlass Python API to map XR controller coordinates to the 3D coordinates of the neural implant's electrode array.
- Latent Feedback (SciStream): To avoid "sensory lag" (which causes nausea or seizures), SciStream must maintain a sub-10ms round-trip latency between the XR "click" and the neural stimulation.
- Visual-Neural Sync: The XR environment (syGlass) ensures that the visual representation of the brain matches the physical stimulation site with micrometer precision, preventing "misfires" in sensitive brain regions.

## 1. The Nanosat Bridge (The Physical Link)
Modern Nanosats (3U to 12U CubeSats) act as Tactical Edge Nodes in orbit.
- The Hardware: The Nanosat carries a Q-NET-compatible laser terminal or a high-frequency Ka-band radio.
- The Link: The MEG-fiber interface (worn by the user) transmits data to a local ground terminal (running your K3s/Go/Envoy stack). This terminal "uplinks" the encrypted neural stream to the Nanosat.
- The Q-NET Extension: Some Nanosats now perform Space-to-Ground Quantum Key Distribution (QKD). The satellite beams entangled photons down to the ground terminal, providing the "Quantum Seed" for your TLS 1.3 tunnel even in areas without physical fiber.

## 2. CSDAP Integration (The Data Layer)
CSDAP is the NASA/DoD program that buys commercial satellite data (from companies like Planet, Spire, or BlackSky) for government use.
- Contextual Awareness: CSDAP provides high-resolution imagery and RF signals from the user's specific location.
- The Fusion: Your Go-based microservice in the cloud merges the "Neural Stream" (what the user is thinking/feeling) with "CSDAP Data" (what the satellites see around the user).
- Example: If the user’s neural interface detects a high-stress "threat" response, the system automatically pulls the latest CSDAP SAR (Synthetic Aperture Radar) imagery of the surrounding 5km to identify potential hazards.

## 3. Implementing the "Space-Aware" Pod
To make this work, your K3s Pods must be "Space-Aware":
Protocol Optimization: Standard TCP/IP fails over satellite due to high latency. Your Envoy Wrapper is configured to use QUIC (UDP-based) or SCPS (Space Communications Protocol Specifications) to keep the neural stream fluid.
- Intermittent Connectivity: The Go driver uses a "Store and Forward" buffer. If the Nanosat passes behind a mountain, the MEG-powered interface stores the neural data in a local Sidecar and bursts it to the satellite once the link is restored.

## 4. Identity & Access (Entra ID in Space)
- Cross-Domain Identity: Entra ID manages the permissions for the satellite uplink. The Nanosat verifies the user's Workload Identity before allowing the data to enter the "Space Segment" of the DoDIN.
- Stream Access: A commander at a HQ can view the "CSDAP + Neural" fusion dashboard. Think Neuralink with first person visual and subtitles. They authenticate via Entra ID MFA, and the Envoy Proxy decrypts the satellite-delivered stream in real-time.