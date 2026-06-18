# FEDOMA Smart Home System

A smart home automation system designed for beneficiaries of the **Federation of Disability Organisations in Malawi (FEDOMA)** who live with mobility or hearing disabilities. The system automates doors, windows, curtains, and lights, and adds a smart doorbell and intrusion detection system, so that users can manage their home independently with reduced reliance on a carer.

This project was completed as my **Final Year Project (BSc (Hons) in Computing)**.

## Background

FEDOMA is a non-governmental organisation founded in 1999, formed by uniting 12 disability-focused organisations across Malawi, with a mission to enhance the welfare of people with disabilities and support their independence. Many of the people FEDOMA supports rely on someone else to physically assist them with everyday tasks and household chores. This project was developed in direct response to that need, following research visits and interviews with FEDOMA staff and beneficiaries, with the aim of giving users greater independence in managing their own home.

## How It's Controlled

Each home element supports a different level of automation, based directly on feedback gathered from FEDOMA beneficiaries during requirements gathering:

- **Doors** are controlled manually through the mobile app only. Automatic sensor-based opening was deliberately excluded, since the system is designed with wheelchair users in mind and an automatically moving door was judged too high a safety risk.
- **Windows, curtains, and lights** support both automatic control (triggered by sensor readings) and manual control through the mobile app, with settings configurable per room or per element.
- **Doorbell**: a visitor-operated doorbell button triggers an in-home ring, captures an image of the visitor, uploads it to the database, and sends an SMS notification so the user can see who's at the door without needing to move.
- **Intrusion detection**: sensors on windows trigger an in-home alarm and an SMS notification if a break-in is detected.
- **Reports**: the mobile app shows usage statistics (e.g. doorbell activity and intrusion events) pulled from the database. No sensitive personal data is collected, only aggregate statistics.

Voice control was considered during requirements gathering but intentionally left out of this version, since beneficiaries raised concerns that differing accents could cause misunderstandings; this is noted as a future improvement.

## Architecture

The system is split into two connected parts: a Flutter mobile application and an Arduino-based hardware prototype, both synced through a shared cloud database.

### Mobile Application
- **Framework:** Flutter (Dart) — chosen for cross-platform support across Android and iOS from a single codebase
- **Authentication:** Firebase Authentication (email-based signup, login, and verification)
- **Functionality:** room-by-room control of home elements, doorbell viewing (including visitor image), intrusion alerts, usage reports/statistics, and settings

### Hardware Prototype
- **Microcontrollers:** Arduino Uno, ESP32, ESP32-CAM (for doorbell image capture), and a DFRobot GSM module (for SMS notifications)
- **Language:** C++, via the Arduino IDE
- **Physical build:** a wooden miniature house (bedroom and living room) housing the sensors and actuators for doors, windows, curtains, lights, the doorbell, and intrusion detection
- **Sensors/actuators:** light intensity sensor, rain sensor, intrusion ("hit") sensor, buzzer for the in-home alarm, plus actuators for each automated element

### Database
- **Firebase Realtime Database (NoSQL)** — selected over MySQL for low-latency, key-value-based reads and writes, which suited a system where every home element needs to stay continuously in sync between the app and the hardware
- **Firebase Storage** — used for storing doorbell visitor images

### Notifications
Notifications are sent via **SMS through a GSM module**, rather than push notifications. This was a deliberate change made during development: push notifications would have required a stable internet connection at all times, but doorbell and intrusion alerts need to reach the user immediately and reliably, even over a weak or unavailable network connection. SMS does not depend on internet connectivity, making it a more dependable choice for this use case.

## Development Notes

A few of the more significant engineering challenges encountered and resolved during the build:

- **ESP32 instability under load**: frequent reads/writes to Firebase caused the ESP32 to repeatedly shut down due to limited processing capacity. This was resolved by batching all database syncing into a single JSON read and write per loop, with a 5-second delay between loop cycles.
- **Sensor pins failing once WiFi was active**: a subset of ESP32 pins stopped reading sensor data correctly as soon as the board connected to the internet, since those pins are used internally for the WiFi connection. This was resolved by remapping the affected sensors to other available pins.
- **Push notifications were dropped in favour of SMS** (see Notifications above), following repeated breakage caused by Flutter's frequently updated and, at the time, poorly documented push notification APIs.

## Future Improvements

As noted in the project's reflection, a few directions for future development were identified but not implemented in this version:

- Voice command integration, to reduce the need to physically reach for a phone when sensor control is switched off
- A shift from mains electricity to solar power, to reduce running costs and align with sustainable energy goals
- A backup battery system, so that the intrusion detection system in particular continues to function during a power outage

## Project Context

This project was completed as the Final Year Project for a BSc (Hons) in Computing, developed in consultation with FEDOMA staff and beneficiaries, demonstrating the end-to-end design and implementation of a multi-platform IoT system: requirements gathering, UML-based design, low- and mid-fidelity prototyping, hardware/software integration, and testing with real users.

## Author

**Mohammad Taha Nadwi**
GitHub: [@MohammadTahaNadwi](https://github.com/MohammadTahaNadwi)
